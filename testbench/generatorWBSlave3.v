module generatorWBSlave(
// inputs from host
output wire clock,
output wire reset,
output wire [127:0]	host_data_i,
output wire cmd_done_i,
output wire data_done_i,
//inputs from master
output wire we_i, //write_enable 
output wire [4:0] adr_i, // Command (adr_i = 0) or Data (adr_i = 1)
output wire strobe, // Strobe
output wire [127:0] wb_data_i

);

clock_gen clk1(clock);
reset_gen r1(reset);
host_data_in_gen hDatag(host_data_i);
cmd_done_in_gen cmddgen(cmd_done_i);
data_done_in_gen datadgen(data_done_i);
we_in_gen weg(we_i);
adr_in_gen  adrg(adr_i);
strobe_in_gen strg(strobe);
wb_data_in_gen wbDatag(wb_data_i);

endmodule

module clock_gen(output clock);
reg clock;
initial
	begin
		clock=1'b0;
	end
always
	begin
	#`CLOCK_HALF_PERIOD;
	clock=1'b0;
	#`CLOCK_HALF_PERIOD;
	clock=1'b1;
	end
endmodule

module reset_gen(output reset);
reg reset;
initial
	begin
		reset=1'b0;
		#`RESET_FIRE_TIME
		reset=1'b1;
		#`RESET_DEACTIVATE_TIME
		reset=1'b0;
	end
endmodule

module host_data_in_gen (output [127:0] host_data);
reg [127:0] host_data;
initial
	begin
		host_data = 128'b0;
	end
always 
	begin
		#`NEW_HOST_DATA
		host_data = host_data +128'b1;
	end
endmodule

module cmd_done_in_gen (output done);
reg done;
initial
	begin
		done = 1'b0;
	end
always 
	begin
		#`CMD_DONE_UP
		done = 1'b1;
		#`CMD_DONE_DOWN
		done = 1'b0;
	end
endmodule

module data_done_in_gen (output done);
reg done;
initial
	begin
		done = 1'b0;
	end
always 
	begin
		#`DATA_DONE_UP
		done = 1'b1;
		#`DATA_DONE_DOWN
		done = 1'b0;
	end
endmodule

module we_in_gen (output we_in);
reg we_in;
initial 
	begin
		we_in = 1'b0; // Initial -> read from SD
	end
always
	begin
		#`WRITE_TO_SD
		we_in = 1'b1;
		#`READ_FROM_SD
		we_in = 1'b1;//
	end
endmodule

module adr_in_gen (output [4:0] adr_in);
reg [4:0] adr_in;
initial
	begin
		
		adr_in=5'b0; //Initial -> Command
	end
always
	begin
		#`ADR_IN
		adr_in = adr_in +5'b1;
		//adr_in = 5'd16;
		if(adr_in == 5'd20)
			adr_in = 5'd0;
	end
endmodule

module strobe_in_gen (output strobe_in);
reg strobe_in;
initial
	begin
		strobe_in = 1'b0;
	end
always
	begin
		#`STROBE_DOWN_TIME;
		strobe_in=1'b1;
		#`STROBE_UP_TIME;
		strobe_in=1'b1;//
	end
endmodule

module wb_data_in_gen (output [127:0] wb_data);
reg [127:0] wb_data;
initial
	begin
		wb_data = 128'b0;
	end
always 
	begin
		#`NEW_WB_DATA
		wb_data = wb_data +128'd5;
	end
endmodule
