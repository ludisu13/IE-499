`timescale 1ns / 1ps
`include "../code/fifo2.v"
module TestBench;

	// Inputs
	reg write_clock;
	reg read_clock;
	reg reset;
	reg [31:0]data;
	reg write_enable;
	reg read_enable;
	
	// Outputs
	wire [31:0] q;
	wire fifo_full;
	wire fifo_empty;
	
	// Instantiate the Unit Under Test (UUT)
	fifo fifo1 (
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

	always
	begin
		#10  write_clock = ! write_clock;
		#15  read_clock  = ! read_clock;

	end
	
	initial begin
	
		$dumpfile("signals.vcd");
		$dumpvars;	
		// Initialize Inputs
		write_clock = 0;
		read_clock = 0;
		reset = 0;
		read_enable = 0;
		write_enable = 0;
		data = 32'd2;
		
		// Wait 100 ns for global reset to finish
		#10;
		reset = 1;
		#50
		reset = 0;
		
		//Test data write
		#20
		write_enable = 1;
		#50
		write_enable = 0;
		
		//Test data read
		#30
		read_enable = 1;
		#30
		read_enable = 0;
		
		//Test Empty signal
		#30
		read_enable = 1;
		#30
		read_enable = 0;
		
		//Test full signal
		#20
		write_enable = 1;
		#60
		data = 32'd3;
		#60
		data = 32'd4;
		#60
		data = 32'd5;
		#60
		data = 32'd6;
		#60
		data = 32'd7;
		#60
		data = 32'd8;
		#60
		data = 32'd9;
		#60
		data = 32'd10;
		#60
		data = 32'd11;	
		//Test data read
		#60
		write_enable = 0;
		read_enable = 1;
		#1000
			
		$finish;
	end

endmodule
