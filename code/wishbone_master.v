module wishbone_master (

	//Inputs
	input wire clock,
	input wire reset,	
	input wire request,
	input wire wb_data_i,
	
	//Outputs To Slave
	output reg we_o,
	output reg adr_o,
	output reg wb_data_o,
	output wire strobe_o,
	
	
);



endmodule
