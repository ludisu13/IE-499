module cmd_controller(

	// Inputs from Host Interface
	input clock,
	input reset,
	
	input data_read,
	input data_write,
	
	input [31:0] argument_reg,
	
	
	// Inputs and Outputs from Serial Host
	input ack_in,
	input req_in,
	input [39:0] cmd_in,
	
	output ack_out,
	output req_oout,
	output [39:0] cmd_out,
	
	output idle_out,



);









endmodule 
