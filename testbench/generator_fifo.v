module generator_fifo (
	output wire [`DATA_WIDTH-1:0] data,
	output wire write_enable,
	output wire read_enable,	
	output wire reset,
	output wire write_clock,
	output wire read_clock
);

read_clock_gen rcg(read_clock);
write_clock_gen wcg(write_clock);
reset_gen resg(reset);
data_gen datg(data);
write_enable_gen weng(write_enable);
read_enable_gen reng(read_enable);

endmodule

module read_clock_gen(output clock);
reg clock;
initial
	begin
		clock=1'b0;
	end
always
	begin
	#`READ_CLOCK_HALF_PERIOD;
	clock=1'b1;
	#`READ_CLOCK_HALF_PERIOD;
	clock=1'b0;
	end
endmodule

module write_clock_gen(output clock);
reg clock;
initial
	begin
		clock=1'b0;
	end
always
	begin
	#`WRITE_CLOCK_HALF_PERIOD;
	clock=1'b1;
	#`WRITE_CLOCK_HALF_PERIOD;
	clock=1'b0;
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

module data_gen (output [`DATA_WIDTH-1:0] data);
reg [`DATA_WIDTH-1:0] data;
initial
	begin
		data = `DATA_WIDTH'b0;
	end
always 
	begin
		#`NEW_DATA
		data = data +`DATA_WIDTH'b1;
	end
endmodule

module write_enable_gen (output we);
reg we;
initial 
	begin
		we = 1'b0; // Initial -> no WRITE
	end
always
	begin
		#`NO_WRITE
		we = 1'b1;
		#`WRITE
		we = 1'b0;
	end
endmodule

module read_enable_gen (output re);
reg re;
initial 
	begin
		re = 1'b0; // Initial -> no READ
	end
always
	begin
		#`NO_READ
		re = 1'b1;
		#`READ
		re = 1'b0;
	end
endmodule
