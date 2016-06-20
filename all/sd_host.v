//`include "../code/ffd.v"
//`include "../code/pad.v"
//`include "../code/counter.v"
//`include "../code/parallelToSerial.v"
//`include "../code/serialToParallel.v"
//`include "../code/serialtoparallelwrapper.v"
//`include "../code/paralleltoserialwrapper.v"
//`include "../code/cmd_phys_controller.v"
//`include "../code/cmd_phys.v"
//`include "../code/cmd_controller.v"
//`include "../code/dat_phys_controller.v"
//`include "../code/dat_phys.v"
//`include "../code/dat_controller.v"
//`include "../code/fifo2.v"
//`include "../code/definitions_registers.v"
//`include "../code/registers.v"
//`include "../code/wishbone_slave5.v"
//`include "../code/fifo_wrapper.v"

module sd_host (
	input wire clock,
	input wire sd_clock,
	input wire wb_clock,
	input wire reset,


	//Inputs from Wishbone Master
	input wire 		we_i, //write_enable 
	input wire [4:0]	adr_i, 
	input wire 		strobe, // Strobe
	input wire [127:0] wb_data_i,
	
	//Outputs to Wishbone Master
	output wire [127:0]	wb_data_o,
	output wire 			ack_o,
	output wire			error_o,




	inout wire PIN_DAT,
	inout wire PIN_CMD

);
wire [127:0]	q_tx_out;
wire [127:0]  	fifo_bus_o;
wire [127:0]  	wb_data_bus_o;
wire [127:0]  	data_rx_in;
wire [3:0]   	fifo_status;
wire [3:0]   	blocks_host_phys;
wire [127:0] 	response;
wire [135:0] 	response_phys_control;
wire [39:0]		command;
wire [127:0] 	reg_bus_o;
wire [4:0] 		adr_o;
wire [127:0] 	host_data_i;
wire [127:0] 	host_data_o;
wire [127:0]	data_i;
wire [11:0]		block_size;
wire [15:0]		block_count;
wire [31:0]		argument;
wire [15:0]		transfer_mode;
wire [15:0]		present_state;
wire [15:0]		timeout_control;
wire [2:0]		software_reset;
wire [15:0]		error_interrupt_status_o;
wire [127:0] 	wb_data_bus_i ;
assign wb_data_bus_i = (reg_read_en == 1'b1)? reg_bus_o : (rx_read_en == 1'b1)? fifo_bus_o : 128'b0;
	

dat_controller datc(
	.clock(clock),
	.reset(reset),
	.writeRead(1'b1),
	.newDat(new_data),
	.blockCount(4'd2),
	.multipleData(1'b1),
	.serial_ready(sr_phys_host),
	.complete(complete_phys_host),
	.ack_in(ack_phys_host),
	.fifo_okay(1'b1),
	.transfer_complete(data_complete), //wishbone
	.strobe_out(strobe_host_phys),
	.ack_out(ack_host_phys),
	.blocks(blocks_host_phys),
	.multiple(multiple_host_phys),
	.writereadphys(wr_host_phys)


);


dat_phys dat(
	.sd_clock(sd_clock),
	.reset(reset),
	.strobe_in(strobe_host_phys),
	.ack_in(ack_host_phys),
	.idle_in(1'b0),
	.TIMEOUT_REG(16'd100),
	.blocks(blocks_host_phys),
	.writeRead(wr_host_phys),
	.multiple(multiple_host_phys),
	.dat_pin(PIN_DAT),
	.dataFROMFIFO(q_tx_out[31:0]),//del fifo tx-----------------q_tx_out
	.dataToFIFO(data_rx_in[31:0]),//del fifo rx-----------------data_rx_in
	.read_enable(rx_write_en),//fifo rx -------------------rx_write_en
	.write_enable(tx_read_en),//fifo tx------------------tx_read_en
	.serial_ready(sr_phys_host),
	.complete(complete_phys_host),
	.ack_out(ack_phys_host)
);

cmd_phys physical(
	.sd_clock(sd_clock),
	.reset(reset),
	.strobe_in( strobe_controller_phys),
	.ack_in(ack_controller_phys),
	.idle_in(1'b0),
	.cmd_to_send(command),
	.cmd_pin(PIN_CMD),
	.ack_out(ack_phys_to_controller),
	.strobe_out(strobe_phys_controller),
	.response(response_phys_control)
);

cmd_controller host_cmd(
	.clock(clock),
	.reset(reset),
	.new_command(new_command),
	.cmd_argument(32'b0),
	.cmd_index(6'd7),
	.TIMEOUT_ENABLE(1'b0),
	.ack_in(ack_phys_to_controller),
	.strobe_in(strobe_phys_controller),
	.cmd_in(response_phys_control),
	.TIMEOUT(1'b0),
	.strobe_out(strobe_controller_phys),
	.ack_out(ack_controller_phys),
	.cmd_out(command),
	.command_complete(complete_cmd),
	.response(response) //wishbone cablear mas registros
);

wishbone_slave wb_salve1 (
	.clock(wb_clock),				//Input
	.reset(reset),					//Input	
	.we_i(we_i),					//Input
	.host_data_i(wb_data_bus_i),	//Input
	.cmd_done_i(complete_cmd),		//Input---------------complete_cmd
	.data_done_i(data_complete),	//Input---------------data_complete
	.adr_i(adr_i),					//Input
	.strobe(strobe),				//Input
	.wb_data_i(wb_data_i),			//Input
	
	.new_data(new_data), 			//Output
	.new_command(new_command),		//Output
	.host_data_o(wb_data_bus_o),	//Output
	.wb_data_o(wb_data_o),			//Output
	.ack_o(ack_o),					//Output
	.fifo_read_en(rx_read_en),		//Output
	.fifo_write_en(tx_write_en ),	//Output
	.reg_read_en(reg_read_en),		//Output
	.reg_write_en(reg_write_en),	//Output
	.error_o(error_o),				//Output
	.adr_o(adr_o)					//Output
);


registers regs (		
	.clock(wb_clock),										//Input
	.reset(reset),											//Input
	.adr_i(adr_o),											//Input
	.reg_write_en(reg_write_en),							//Input
	.reg_read_en(reg_read_en),								//Input
	.command_complete(complete_cmd),									//Input------------------
	.data_i(wb_data_bus_o),									//Input
	.response_i(response),											//Input------------------
	.error_interrupt_status_i(0),							//Input------------------
	.normal_interrupt_status_i(0),							//Input------------------
	
	.block_size(block_size),								//Output
	.block_count(block_count),								//Output
	.argument(argument),									//Output
	.transfer_mode(transfer_mode),							//Output
	//.command(command),										//Output
	.present_state(present_state),							//Output
	.timeout_control(timeout_control),						//Output
	.software_reset(software_reset),						//Output
	.error_interrupt_status_o(error_interrupt_status_o),	//Output
	.data_o(reg_bus_o)									//Output
);

fifo_controller #(128) fifoController (
	.wishbone_clock(wb_clock), 	//Input
	.sd_clock(sd_clock), 		//Input
	.reset(reset), 				//Input
	.data_tx_in(wb_data_bus_o), //Input
	.data_rx_in(data_rx_in),	//Input-------------------data_rx_in
	.enable_in({rx_read_en, rx_write_en, tx_read_en, tx_write_en }), //Input---------------------rx_read_en, rx_write_en, tx_read_en, tx_write_en 
	
	.q_tx_out(q_tx_out), 		//Output
	.q_rx_out(fifo_bus_o),		//Output
	.status_out(fifo_status) 	//Output

);

/*fifo  #(128) tx_fifo(
		.write_clock(wb_clock),	//input
		.read_clock(sd_clock), 			//input
		.reset(reset), 					//input
		.data(wb_data_bus_o), 				//input 
		.write_enable(tx_write_en),	//input
		.read_enable(tx_read_en), 	//input
		.q(q_tx_out),  					//output 
		.fifo_full(fifo_status[0]),  	//output
		.fifo_empty(fifo_status[1]) 		//output
	);
	
	fifo #(128) rx_fifo(
		.write_clock(sd_clock),			//input
		.read_clock(wb_clock),	//input
		.reset(reset), 					//input
		.data(data_rx_in), 				//input 
		.write_enable(rx_write_en),	//input
		.read_enable(rx_read_en), 	//input
		.q(fifo_bus_o),  					//output
		.fifo_full(fifo_status[2]),  	//output
		.fifo_empty(fifo_status[3]) 		//output
	);
*/	


endmodule

