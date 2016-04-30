module cmd_controller(

	// Inputs from Host Interface
	input wire clock,
	input wire reset,
	
	input wire data_read,
	input wire data_write,
	
	input wire [31:0] argument_reg,
	
	
	// Inputs and Outputs from Serial Host
	input wire ack_in,
	input wire req_in,
	input wire [39:0] cmd_in,
	
	output reg ack_out,
	output reg req_oout,
	output reg [39:0] cmd_out,
	
	output reg idle_out,



);









endmodule 
