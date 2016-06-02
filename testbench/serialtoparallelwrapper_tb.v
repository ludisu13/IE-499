`include "definitionsparalleltoSerial.v"
`include "../code/ffd.v"
`include "../code/pad.v"
`include "../code/counter.v"
`include "../code/parallelToSerial.v"
`include "../code/serialToParallel.v"
`include "../code/serialtoparallelwrapper.v"
`include "generator_paralleltoSerial.v"

module TestBench;



	wire clock;
	wire reset;
	wire Enable;
	wire load_send;
	wire serial;
	wire [(`WIDTH-1):0] parallel;
	
	
assign parallel=64'hF0F0F0F0F0F0F0F0;
assign Enable=1'b1;


 	
Paralleltoserial # (`WIDTH) pts(
.Clock(clock),
.Reset(reset),
.Enable(Enable),
.load_send(load_send),
.serial(serial),.
parallel(parallel));

generatorparalleltoserial gpts(
.clock(clock),
.reset(reset),
.load_send(load_send)
);

assign serialpad=load_send ? serial : 1'bz ;
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
wire complete;
wire [(`WIDTH-1):0] parallelin;
wire [(`WIDTH-1):0] framesize;
assign framesize = 8'd64;
serialToParallelWrapper # (`WIDTH) stpw(
.Clock(clock),
.Reset(reset),
.framesize(framesize),
.Enable(Enable),
.serial(port),
.complete(complete),.
parallel(parallelin));


	
	initial begin
	
		$dumpfile("serialtoparallel.vcd");
		$dumpvars;	
		#7000
		$display("test finished");
		$finish;
	end

endmodule
