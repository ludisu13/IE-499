
module generatorSDclock(
// inputs from host
output wire clock);

clock_gen clk1(clock);




endmodule
module clock_gen(output clock);
reg clock;
initial
	begin
		clock=1'b0;
	end
always
		begin
		#`HALF_PERIOD_SD;
		clock=1'b1;
		#`HALF_PERIOD_SD;
		clock=1'b0;
		end
endmodule


