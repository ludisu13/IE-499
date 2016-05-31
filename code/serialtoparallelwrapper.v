`include "serialToParallel.v"
`include "counter.v"

module serialToParallelWrapper # (parameter WIDTH=8)
(
	input wire Clock,
	input wire Reset,
	input wire Enable,
	input wire [(WIDTH-1):0] framesize,
	output wire serial,
	output wire complete,
	input wire[(WIDTH-1):0] parallel
	);

serialToParallel stp(
.Clock(Clock),
.Reset(Reset),
.Enable(Enable&go),
.serial(serial),
.parallel(parallel)
);
wire [(WIDTH-1):0] initialValue;
assign initialValue=0;
wire [(WIDTH-1):0] Value;
wire [(WIDTH-1):0] countValue;
UPCOUNTER_POSEDGE # (WIDTH) counter1(
.Clock(clock),
.Reset(reset),
.Initial(initialValue),
.Enable(enable),
.Q(countValue)
);
wire go;
assign go= (framesize==countValue) ? 1'b1:1'b0;
assign complete=(framesize==countValue) ? 1'b1:1'b0;
endmodule
