`include "../testbench/definitionsWBMaster.v"

module wishbone_master (

	//Inputs
	input wire clock,
	input wire reset,	
	input wire ack_i,
	input wire wb_data_i,
	
	//Outputs To Slave
	output reg we_o,
	output reg adr_o,
	output reg [63:0] wb_data_o,
	output wire strobe_o,
	
	
);

we_out_gen weg(we_o);
adr_out_gen  adrg(adr_o);
strobe_out_gen strg(strobe_o);
wb_data_out_gen wbDatag(wb_data_o);

endmodule


module we_out_gen (output we_out);
reg we_out;
initial 
	begin
		we_out = 1'b0; // Initial -> read from SD
	end
always
	begin
		#`WRITE_TO_SD
		we_out = 1'b1;
		#`READ_FROM_SD
		we_out = 1'b0;
	end
endmodule

module adr_out_gen (output adr_out);
reg adr_out;
initial
	begin
		adr_out=1'b0; //Initial -> Command
	end
always
	begin
		#`ADR_TO_DATA;
		adr_out=1'b1;
		#`ADR_TO_CMD;
		adr_out=1'b0;
	end
endmodule

module strobe_out_gen (output strobe_out);
reg strobe_out;
initial
	begin
		strobe_out=1'b0;
		#`STROBE_OUT_TIME;
		strobe_out=1'b1;
	end
endmodule

module wb_data_out_gen (output [63:0] wb_data);
reg [63:0] wb_data;
initial
	begin
		wb_data = 64'b0;
	end
always 
	begin
		#`NEW_WB_DATA
		wb_data = wb_data +64'b1;
	end
endmodule
