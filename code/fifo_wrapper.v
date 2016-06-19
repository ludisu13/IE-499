//`include "fifo2.v"

module fifo_controller # ( parameter DATA_WIDTH = 32, parameter FIFO_SIZE = 8, parameter SIZE_BITS = 3) (
	
	input wire wishbone_clock,
	input wire sd_clock,
	input wire reset,
	input wire [DATA_WIDTH-1:0] data_tx_in,
	input wire [DATA_WIDTH-1:0] data_rx_in,
	input wire [3:0] enable_in,
	output wire [DATA_WIDTH-1:0] q_tx_out,
	output wire [DATA_WIDTH-1:0] q_rx_out,
	output wire [3:0] status_out
);

	fifo  #(DATA_WIDTH, FIFO_SIZE, SIZE_BITS) tx_fifo(
		.write_clock(wishbone_clock),	//input
		.read_clock(sd_clock), 			//input
		.reset(reset), 					//input
		.data(data_tx_in), 				//input 
		.write_enable(enable_in[0]),	//input
		.read_enable(enable_in[1]), 	//input
		.q(q_tx_out),  					//output 
		.fifo_full(status_out[0]),  	//output
		.fifo_empty(status_out[1]) 		//output
	);
	
	fifo #(DATA_WIDTH, FIFO_SIZE, SIZE_BITS) rx_fifo(
		.write_clock(sd_clock),			//input
		.read_clock(wishbone_clock),	//input
		.reset(reset), 					//input
		.data(data_rx_in), 				//input 
		.write_enable(enable_in[2]),	//input
		.read_enable(enable_in[3]), 	//input
		.q(q_rx_out),  					//output
		.fifo_full(status_out[2]),  	//output
		.fifo_empty(status_out[3]) 		//output
	);
	

endmodule
