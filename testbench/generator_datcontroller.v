module generatorDatcontroller(
// inputs from host
output wire clock,
output wire reset,
output wire writeRead,
output wire newDat,
//inputs from physical layer
output wire serial_ready,
output wire complete,
output wire ack_in,
//inputs from fifoController
output wire fifo_okay)
;

clock_gen clk1(clock);
reset_gen r1(reset);
newDat_gen nDG(newDat);
serialReady_gen sRg(serial_ready);
complete_gen  cg(complete);
fifo_okay_gen fog(fifo_okay);
ack_in_gen aig(ack_in);
writeRead_gen wRg(writeRead);



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

module newDat_gen(output newDat);
reg newDat;
initial
	begin
		#`NEW_DATA_REQUEST_TIME;
		newDat=1;
	end

endmodule

module writeRead_gen(output writeRead);
reg writeRead;
initial
	begin
		#`WRITE_READ_TIME;
		writeRead=`WRITE_READ;
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

module complete_gen(output complete);
reg complete;
initial
	begin
		complete=1'b0;
		#`COMPLETE_TIME;
		complete=1'b1;
	end
endmodule

module ack_in_gen(output ack_in);
reg ack_in;
initial
	begin
		ack_in=1'b0;
		#`ACK_IN_TIME;
		ack_in=1'b1;
	end
endmodule

module fifo_okay_gen(output fifo_okay);
reg fifo_okay;
initial
	begin
		fifo_okay=1'b0;
		#`FIFOOKAY_TIME;
		fifo_okay=1'b1;
	end
endmodule


