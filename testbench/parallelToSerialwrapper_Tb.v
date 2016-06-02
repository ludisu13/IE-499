`include "definitionsparalleltoSerial.v"
`include "../code/parallelToSerial.v"
`include "../code/paralleltoserialwrapper.v"
`include "generator_paralleltoSerial.v"
`include "../code/ffd.v"
`include "../code/counter.v"
`include "../code/pad.v"
module TestBench;



	wire clock;
	wire reset;
	wire Enable;
	wire load_send;
	wire serial;
	wire [(`WIDTH-1):0] parallel;
	
	
assign parallel=64'hF0F0F0F0F0F0F0F0;
assign Enable=1'b1;
wire complete;
wire [(`WIDTH-1):0] framesize;
assign framesize = 8'd64;

paralleltoserialWrapper # (`WIDTH) pts(
.Clock(clock),
.Reset(reset),
.Enable(Enable),
.framesize(framesize),
.load_send(load_send),
.complete(complete),
.serial(serial),.
parallel(parallel));

generatorparalleltoserial gpts(
.clock(clock),
.reset(reset),
.load_send(load_send)
);
assign serialpad=load_send ? serial : 1'bz ;
PAD pad1(
.clock(clock),
.output_input(1'b1),
.data_in(serialpad),
.enable(load_send),
.data_out(data_out),
.io_port(port)
);

	
	initial begin
	
		$dumpfile("ptswrapper.vcd");
		$dumpvars;	
		#4500
		$display("test finished");
		$finish;
	end

endmodule
