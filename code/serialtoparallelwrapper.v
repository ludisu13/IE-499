//`include "serialToParallel.v"
//`include "counter.v"

module serialToParallelWrapper # (parameter WIDTH=8,parameter FRAME_SIZE_WIDTH=8)
(
	input wire Clock,
	input wire Reset,
	input wire Enable,
	input wire [(FRAME_SIZE_WIDTH-1):0] framesize,
	input wire serial,
	output wire complete,
	output wire[(WIDTH-1):0] parallel
	);

serialToParallel #(WIDTH)stp(
.Clock(Clock),
.Reset(Reset),
.Enable(Enable&go&validData),
.serial(serial),
.parallel(parallel)
);
wire [(FRAME_SIZE_WIDTH-1):0] initialValue;
assign initialValue=0;
wire [(FRAME_SIZE_WIDTH-1):0] Value;
wire [(FRAME_SIZE_WIDTH-1):0] countValue;
UPCOUNTER_POSEDGE # (FRAME_SIZE_WIDTH) counter1(
.Clock(Clock),
.Reset(Reset),
.Initial(initialValue),
.Enable(Enable&go&validData),
.Q(countValue)
);
wire go;
assign go= (framesize==countValue) ? 1'b0:1'b1;
assign complete=(framesize==countValue) ? 1'b1:1'b0;
assign validData= (serial===1'bz) ? 1'b0:1'b1;
endmodule
