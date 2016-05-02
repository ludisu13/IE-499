`include "fifo.v";

module fifo_controller (
	
	input wire wishbone_clock,
	input wire sd_clock,
	input wire reset,
	input wire [31:0] data_tx_in,
	input wire [31:0] data_rx_in,
	input wire [3:0] enable_in,
	output wire [31:0] q_tx_out,
	output wire [31:0] q_rx_out,
	output wire [3:0] status_out
);

	fifo tx_fifo (
		.write_clock(wishbone_clock),	//input
		.read_clock(sd_clock), 			//input
		.reset(reset), 					//input
		.data(data_tx_in), 				//input 32
		.write_enable(enable_in[0]),	//input
		.read_enable(enable_in[1]), 	//input
		.q(q_tx_out),  					//output 32
		.fifo_full(status_out[0]),  	//output
		.fifo_empty(status_out[1]) 		//output
	);
	
	fifo rx_fifo (
		.write_clock(sd_clock),			//input
		.read_clock(wishbone_clock),	//input
		.reset(reset), 					//input
		.data(data_rx_in), 				//input 32
		.write_enable(enable_in[2]),	//input
		.read_enable(enable_in[3]), 	//input
		.q(q_rx_out),  					//output 32
		.fifo_full(status_out[2]),  	//output
		.fifo_empty(status_out[3]) 		//output
	);
	

endmodule
