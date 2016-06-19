`include "definitionsWBSlave3.v"
`include "../code/wishbone_slave5.v"
`include "../code/fifo2.v"
`include "../code/fifo_wrapper.v"
`include "../code/definitions_registers.v"
`include "../code/registers.v"
`include "../code/wishbone_master2.v"
module TestBench;

	//Inputs
	// Common Inputs
	wire wb_clock;
	wire sd_clock;
	wire reset;
	
	//Inputs from Host
	wire [127:0] 	wb_data_bus_i;
	wire 			cmd_done_i;
	wire 			data_done_i;
	
	//Inputs from Wishbone Master
	wire 			we_i;
	wire [4:0] 		adr_i;
	wire 			strobe;
	wire [127:0] 	wb_data_i;
	
	
	// Outputs
	
	//Outputs to Host
	wire 			new_data;
	wire 			new_command;
	wire [127:0] 	wb_data_bus_o;
	wire			fifo_read_en;
	wire 			fifo_write_en;
	wire			reg_read_en;
	wire 			reg_write_en;
		
	//Outputs to Wishbone Master
	wire [127:0]	wb_data_o;
	wire 			ack_o;
	wire 			error_o;
	wire [4:0] 		adr_o;
	
	//Registers Outputs
	wire [11:0] 	block_size;
	wire [15:0] 	block_count;
	wire [31:0] 	argument;
	wire [15:0] 	transfer_mode;
	wire [15:0] 	command;
	wire [15:0]		present_state;
	wire [15:0] 	timeout_control;
	wire [2:0]		software_reset;
	wire [15:0]		error_interrupt_status_o;
	
	//Fifo Outputs
	wire [127:0] q_tx_out;
	wire [3:0]   fifo_status;
	//Fifo Inputs 
	wire [127:0] sd_data_i;
	
	wire [127:0] fifo_bus_o;
	wire [127:0] reg_bus_o;
	

	assign wb_data_bus_i = (reg_read_en == 1'b1)? reg_bus_o : (fifo_read_en == 1'b1)? fifo_bus_o : 128'b0;
		
	// Instantiate the Unit Under Test (UUT)
	wishbone_slave wb_salve1 (
		.clock(wb_clock),				//Input
		.reset(reset),					//Input	
		.we_i(we_i),					//Input
		.host_data_i(wb_data_bus_i),	//Input
		.cmd_done_i(cmd_done_i),		//Input
		.data_done_i(data_done_i),		//Input
		.adr_i(adr_i),					//Input
		.strobe(strobe),				//Input
		.wb_data_i(wb_data_i),			//Input
		
		.new_data(new_data), 			//Output
		.new_command(new_command),		//Output
		.host_data_o(wb_data_bus_o),	//Output
		.wb_data_o(wb_data_o),			//Output
		.ack_o(ack_o),					//Output
		.fifo_read_en(fifo_read_en),	//Output
		.fifo_write_en(fifo_write_en),	//Output
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
		.command_complete(1'b0),								//Input
		.data_i(wb_data_bus_o),									//Input
		.response_i(128'b0),									//Input
		.error_interrupt_status_i(16'b0),						//Input
		.normal_interrupt_status_i(16'b0),						//Input
		
		.block_size(block_size),								//Output
		.block_count(block_count),								//Output
		.argument(argument),									//Output
		.transfer_mode(transfer_mode),							//Output
		.command(command),										//Output
		.present_state(present_state),							//Output
		.timeout_control(timeout_control),						//Output
		.software_reset(software_reset),						//Output
		.error_interrupt_status_o(error_interrupt_status_o),	//Output
		.data_o(reg_bus_o)									//Output
	);
	
	fifo_controller #(128) fifoController (
		.wishbone_clock(wb_clock), 	//Input
		.sd_clock(wb_clock), 		//Input
		.reset(reset), 				//Input
		.data_tx_in(wb_data_bus_o), //Input
		.data_rx_in(sd_data_i),	 	//Input
		.enable_in({fifo_read_en, 1'b1, 1'b0, fifo_write_en }), //Input
		
		.q_tx_out(q_tx_out), 		//Output
		.q_rx_out(fifo_bus_o),	//Output
		.status_out(fifo_status) 	//Output
	
	);
	
	// Instantiate generator of signals
	wishbone_master WBM(
		.ack_i(ack_o),
		.wb_data_i(wb_data_o),
		.error_i(error_o),
		.wb_clock(wb_clock),
		.reset(reset),
		.host_data_i(sd_data_i),
		.cmd_done_i(cmd_done_i),
		.data_done_i(data_done_i),
		.we_o(we_i),
		.adr_o(adr_i),
		.strobe_o(strobe),
		.wb_data_o(wb_data_i)
	);

	initial begin

	$dumpfile("signalsWbFifoReg.vcd");
	$dumpvars;	
	#1500
	$display("test finished");
	$finish;
	end

endmodule
