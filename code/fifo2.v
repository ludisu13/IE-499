module fifo # ( parameter DATA_WIDTH = 32, parameter FIFO_SIZE = 8, parameter SIZE_BITS = 3) (
	
	input wire [DATA_WIDTH-1:0] data,
	input wire write_enable,
	input wire read_enable,
	
	input wire reset,
	input wire write_clock,
	input wire read_clock,
	
	output reg [DATA_WIDTH-1:0] q,
	output reg fifo_full,
	output reg fifo_empty

);

	reg [SIZE_BITS-1:0] read_pointer;
	reg [SIZE_BITS-1:0] write_pointer;
	reg [DATA_WIDTH-1:0] fifo_mem [FIFO_SIZE-1:0];

	wire [SIZE_BITS-1:0] almost_empty;
	wire [SIZE_BITS-1:0] almost_full;
	
	assign almost_empty = (write_pointer-read_pointer) -1; // If almost_empty = 0, the fifo will empty if you read
	assign almost_full = (read_pointer-write_pointer) -1;	// If almost_full = 0, the fifo will full if you write
//Write

	always @(posedge write_clock or posedge reset) begin
		if (reset) begin
			read_pointer 	<= 0;
			write_pointer 	<= 0;
			fifo_full		<= 0;
			fifo_empty		<= 1;
		end
		else if (write_enable & ~fifo_full) begin
			fifo_empty <=0;
			fifo_full <= (almost_full == 0);
			fifo_mem[write_pointer] <= data;
			write_pointer <= write_pointer + 1'b1; 
		end
	end
	
//Read

	always @(posedge read_clock or posedge reset) begin
		if (reset) begin
			read_pointer 	<= 0;
			write_pointer 	<= 0;
			fifo_full		<= 0;
			fifo_empty		<= 1;
			q <=0;
		end
		else if (read_enable & ~fifo_empty) begin
			fifo_empty = (almost_empty ==0);
			q <= fifo_mem[read_pointer];
			read_pointer <= read_pointer + 1'b1; 
		end
	end

endmodule
