//`include "parallelToSerial.v"
//`include "counter.v"
//`include "ffd.v"
module paralleltoserialWrapper # (parameter WIDTH=8,parameter FRAME_SIZE_WIDTH=8)
(
	input wire Clock,
	input wire Reset,
	input wire Enable,
	input wire [(FRAME_SIZE_WIDTH-1):0] framesize,
	input wire load_send,// send high load low activate on rising edge
	output wire serial,
	output wire complete,
	input wire[(WIDTH-1):0] parallel
	);
wire serialTemp;
Paralleltoserial #(WIDTH) pts(
.Clock(Clock),
.Reset(Reset),
.Enable(Enable&go),
.serial(serialTemp),
.parallel(parallel),
.load_send(load_send)
);
wire [(FRAME_SIZE_WIDTH-1):0] initialValue;
assign initialValue=0;
wire [(FRAME_SIZE_WIDTH-1):0] Value;
wire [(FRAME_SIZE_WIDTH-1):0] countValue;
UPCOUNTER_POSEDGE # (FRAME_SIZE_WIDTH) counter1(
.Clock(Clock),
.Reset(Reset),
.Initial(initialValue),
.Enable(Enable&go&load_send),
.Q(countValue)
);
wire go;
assign serial=(complete==1'b1 | load_send==1'b0)? 1'bz:serialTemp;
assign go= ((framesize-1'b1)<countValue) ? 1'b0:1'b1;
assign complete=((framesize-1'b1)<countValue) ? 1'b1:1'b0;
endmodule
