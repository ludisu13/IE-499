`include "definitionsWBSlave.v"
`include "../code/wishbone_slave2.v"
`include "generatorWBSlave.v"
module TestBench;

	//Inputs
	// Common Inputs
	wire clock;
	wire reset;
	
	//Inputs from Host
	wire [63:0] host_data_i;
	wire done_i;
	
	//Inputs from Wishbone Master
	wire we_i;
	wire adr_i;
	wire strobe;
	wire [63:0] wb_data_i;
	
	
	// Outputs
	
	//Outputs to Host
	wire new_data;
	wire new_command;
	wire [63:0] host_data_o;
	
	//Outputs to Wishbone Master
	wire [63:0] wb_data_o;
	wire ack_o;
	
	// Instantiate the Unit Under Test (UUT)
	wishbone_slave wb_salve1 (
		.clock(clock),				//Input
		.reset(reset),				//Input	
		.we_i(we_i),				//Input
		.host_data_i(host_data_i),	//Input
		.done_i(done_i),
		.adr_i(adr_i),				//Input
		.strobe(strobe),			//Input
		.wb_data_i(wb_data_i),		//Input
		
		.new_data(new_data), 		//Output
		.new_command(new_command),	//Output
		.host_data_o(host_data_o),	//Output
		.wb_data_o(wb_data_o),		//Output
		.ack_o(ack_o)				//Output
	);
	
	// Instantiate generator of signals
	generatorWBSlave WBSgen(
		.clock(clock),
		.reset(reset),
		.host_data_i(host_data_i),
		.done_i(done_i),
		.we_i(we_i),
		.adr_i(adr_i),
		.strobe(strobe),
		.wb_data_i(wb_data_i)
	);

	initial begin

	$dumpfile("signalsWishboneSlave.vcd");
	$dumpvars;	
	#2500
	$display("test finished");
	$finish;
	end

endmodule
