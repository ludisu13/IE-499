
module generatorSD(
// inputs from host
output wire clock	)
;

clock_gen_sd clk1(clock);


endmodule
module clock_gen_sd(output clock);
reg clock;
reg first;
initial
	begin
		clock=1'b0;
		first=1'b0;
		
	end
always	
		if(!first)
			begin
				first=1'b1;
				#32;
			end
			
		else
			begin
				#`HALF_PERIOD_SD;
				clock=1'b1;
				#`HALF_PERIOD_SD;
				clock=1'b0;
		end
endmodule
