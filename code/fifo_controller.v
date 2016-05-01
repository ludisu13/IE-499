`include "fifo.v";

module fifo_controller (
	
	input wire write_clock,
	input wire read_clock,
	input wire reset,
	input wire [31:0] data,
	input wire [3:0] enables,
	output reg [31:0] q,
	output reg [3:0] status
);

	fifo tx_fifo (
		.write_clock(write_clock),	//input
		.read_clock(read_clock), 	//input
		.reset(reset), 				//input
		.data(data), 				//input 32
		.write_enable(enable[0]),	//input
		.read_enable(enable[1]), 	//input
		.q(q),  					//output 32
		.fifo_full(status[0]),  	//output
		.fifo_empty(status[1]) 		//output
	);
	
	fifo rx_fifo (
		.write_clock(write_clock),	//input
		.read_clock(read_clock), 	//input
		.reset(reset), 				//input
		.data(data), 				//input 32
		.write_enable(enable[2]),	//input
		.read_enable(enable[3]), 	//input
		.q(q),  					//output 32
		.fifo_full(status[2]),  	//output
		.fifo_empty(status[3]) 		//output
	);
	
	

endmodule
