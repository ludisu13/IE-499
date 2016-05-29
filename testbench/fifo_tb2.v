`include "definitionsFifo.v"
`include "../code/fifo2.v"
`include "generator_fifo.v"
module TestBench;

	// Inputs
	wire write_clock;
	wire read_clock;
	wire reset;
	wire [`DATA_WIDTH-1:0]data;
	wire write_enable;
	wire read_enable;
	
	// Outputs
	wire [`DATA_WIDTH-1:0] q;
	wire fifo_full;
	wire fifo_empty;
	
	// Instantiate the Unit Under Test (UUT)
	fifo #`DATA_WIDTH fifo1  (
		.write_clock(write_clock),	//input
		.read_clock(read_clock), 	//input
		.reset(reset), 				//input
		.data(data), 				//input 32
		.write_enable(write_enable),//input
		.read_enable(read_enable), 	//input
		.q(q),  					//output 32
		.fifo_full(fifo_full),  	//output
		.fifo_empty(fifo_empty) 	//output
	);
	
	// Instantiate generator of signals
	generator_fifo gen_fifo (
		.data(data),
		.write_enable(write_enable),
		.read_enable(read_enable),
		.reset(reset),
		.read_clock(read_clock),
		.write_clock(write_clock)	
	);
	
	initial begin
		$dumpfile("signalsFifo2.vcd");
		$dumpvars;	
		#1100
		$display("test finished");				
		$finish;
	end

endmodule
