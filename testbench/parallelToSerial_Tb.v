`include "definitionsparalleltoSerial.v"
`include "../code/parallelToSerial.v"
`include "generator_paralleltoSerial.v"
`include "../code/ffd.v"
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
PAD pad1(
.clock(clock),
.output_input(1'b1),
.data_in(serialpad),
.enable(load_send),
.data_out(data_out),
.io_port(port)
);

	
	initial begin
	
		$dumpfile("signalsparalleltoserial.vcd");
		$dumpvars;	
		#2500
		$display("test finished");
		$finish;
	end

endmodule
