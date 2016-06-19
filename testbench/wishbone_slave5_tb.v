`include "definitionsWBSlave3.v"
`include "../code/wishbone_slave5.v"
`include "generatorWBSlave3.v"
module TestBench;

	//Inputs
	// Common Inputs
	wire clock;
	wire reset;
	
	//Inputs from Host
	wire [127:0] host_data_i;
	wire cmd_done_i;
	wire data_done_i;
	
	//Inputs from Wishbone Master
	wire we_i;
	wire [4:0] adr_i;
	wire strobe;
	wire [127:0] wb_data_i;
	
	
	// Outputs
	
	//Outputs to Host
	wire 		new_data;
	wire 		new_command;
	wire [127:0] host_data_o;
	wire		fifo_read_en;
	wire 		fifo_write_en;
	wire		reg_read_en;
	wire 		reg_write_en;
	
	
	//Outputs to Wishbone Master
	wire [127:0] wb_data_o;
	wire 		ack_o;
	wire 		error_o;
	
	// Instantiate the Unit Under Test (UUT)
	wishbone_slave wb_salve1 (
		.clock(clock),				//Input
		.reset(reset),				//Input	
		.we_i(we_i),				//Input
		.host_data_i(host_data_i),	//Input
		.cmd_done_i(cmd_done_i),	//Input
		.data_done_i(data_done_i),	//Input
		.adr_i(adr_i),				//Input
		.strobe(strobe),			//Input
		.wb_data_i(wb_data_i),		//Input
		
		.new_data(new_data), 		//Output
		.new_command(new_command),	//Output
		.host_data_o(host_data_o),	//Output
		.wb_data_o(wb_data_o),		//Output
		.ack_o(ack_o),				//Output
		.fifo_read_en(fifo_read_en),//Output
		.fifo_write_en(fifo_write_en),//Output
		.reg_read_en(reg_read_en),	//Output
		.reg_write_en(reg_write_en),//Output
		.error_o(error_o)			//Output
	);
	
	// Instantiate generator of signals
	generatorWBSlave WBSgen(
		.clock(clock),
		.reset(reset),
		.host_data_i(host_data_i),
		.cmd_done_i(cmd_done_i),
		.data_done_i(data_done_i),
		.we_i(we_i),
		.adr_i(adr_i),
		.strobe(strobe),
		.wb_data_i(wb_data_i)
	);

	initial begin

	$dumpfile("signalsWishboneSlave5.vcd");
	$dumpvars;	
	#1500
	$display("test finished");
	$finish;
	end

endmodule
