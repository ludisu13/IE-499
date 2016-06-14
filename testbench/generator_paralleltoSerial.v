
module generatorparalleltoserial(

output wire clock,
output wire reset,
output wire load_send
)
;

clock_gen clk1(clock);
reset_gen r1(reset);
load_send_gen lsg(load_send);





endmodule
module clock_gen(output clock);
reg clock;
initial
	begin
		clock=1'b0;
	end
always
		begin
		#`HALF_PERIOD;
		clock=1'b1;
		#`HALF_PERIOD;
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

module load_send_gen(output load_send);
reg load_send;
initial
	begin
		load_send=1'b0;
		#`LOAD_TIME;
		load_send=1'b0;
		#`SEND_TIME;
		load_send=1'b1;
	end

endmodule



