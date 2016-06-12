`include "definitionsparalleltoSerial.v"
`include "../code/ffd.v"
`include "../code/pad.v"
`include "../code/counter.v"
`include "../code/parallelToSerial.v"
`include "../code/serialToParallel.v"
`include "../code/serialtoparallelwrapper.v"
`include "../code/paralleltoserialwrapper.v"
`include "generator_paralleltoSerial.v"

module TestBench;



	wire clock;
	wire reset;
	wire Enable;
	wire load_send;
	wire serialpad;
	wire [(`WIDTH-1):0] parallel;
	
	
assign parallel=64'hF0F0F0F0F0F0F0F0;
assign Enable=1'b1;


 	


generatorparalleltoserial gpts(
.clock(clock),
.reset(reset),
.load_send(load_send)
);

PAD padoutput(
.clock(clock),
.output_input(1'b1),
.data_in(serialpad),
.enable(load_send),
.data_out(data_out),
.io_port(port)
);
wire serialToParallel;
wire port;

PAD padinput(
.clock(clock),
.output_input(1'b0),
.data_in(serialpad),
.enable(1'b1),
.data_out(serialToParallel),
.io_port(port)
);
wire complete_pts,complete_stp;
wire [(`WIDTH-1):0] parallelin;
wire [(`WIDTH-1):0] framesize;
assign framesize = 8'd64;

paralleltoserialWrapper # (`WIDTH) ptsw(
.Clock(clock),
.Reset(reset),
.Enable(Enable),
.framesize(framesize),
.load_send(load_send),
.complete(complete_pts),
.serial(serialpad),.
parallel(parallel));

serialToParallelWrapper # (`WIDTH) stpw(
.Clock(clock),
.Reset(reset),
.framesize(framesize),
.Enable(Enable),
.serial(port),
.complete(complete_stp),.
parallel(parallelin));


	
	initial begin
	
		$dumpfile("wrappers.vcd");
		$dumpvars;	
		#7000
		$display("test finished");
		$finish;
	end

endmodule
