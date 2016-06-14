
module generatorCMDcontroller(
// inputs from host
output wire clock,
output wire reset,
output wire newCMD,
//inputs from physical layer
output wire serial_ready,
output wire strobe_in,
output wire ack_in					)
;

clock_gen clk1(clock);
reset_gen r1(reset);
newCMD_gen nDG(newCMD);
serialReady_gen sRg(serial_ready);
strobe_in_gen  cg(strobe_in);
ack_in_gen aig(ack_in);




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

module newCMD_gen(output newCMD);
reg newCMD;
initial
	begin
		newCMD=1'b0;
		#`NEW_CMD_REQUEST_TIME;
		newCMD=1'b1;
		#1000
		newCMD=1'b0;
	end

endmodule



module serialReady_gen(output serialReady);
reg serialReady;
initial
	begin
		serialReady=1'b0;
		#`SERIAL_READY_TIME;
		serialReady=1'b1;
	end
endmodule

module strobe_in_gen(output strobe_in);
reg strobe_in;
initial
	begin
		strobe_in=1'b0;
		#`STROBE_IN_TIME;
		strobe_in=1'b1;
		#2000;
		strobe_in=1'b0;
	end
endmodule

module ack_in_gen(output ack_in);
reg ack_in;
initial
	begin
		ack_in=1'b0;
		#`ACK_IN_TIME;
		#12000;
		ack_in=1'b1;
	end
endmodule

