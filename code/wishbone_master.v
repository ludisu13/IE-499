module wishbone_master (

	input wire clock,
	input wire reset,
	output reg we_o,
	
	input wire request,
	input wire wb_data_i,
	
	output reg adr_o,
	output reg wb_data_o,
	output wire strobe_o,
	
	
);



endmodule
