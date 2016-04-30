module cmd_controller(

	// Inputs from Host Interface
	input clock,
	input reset,
	
	input data_read,
	input data_write,
	
	input argument_reg,
	
	
	// Inputs and Outputs from Serial Host
	input ack_in,
	input req_in,
	input cmd_in,
	
	output ack_out,
	output req_oout,
	output cmd_out,
	
	output idle_out,



);









endmodule 
