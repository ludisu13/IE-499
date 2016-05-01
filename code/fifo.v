module fifo # ( parameter DATA_WIDTH = 32, FIFO_SIZE = 8, SIZE_BITS = 3) (
	
	input wire [DATA_WIDTH-1:0] data,
	input wire write_enable,
	input wire read enable,
	
	input wire reset,
	input wire write_clock,
	input wire read_clock,
	
	output reg [DATA_WIDTH-1:0] q,
	output reg fifo_full,
	output reg fifo_empty

);

	wire [SIZE_BITS-1:0] read_pointer;
	wire [SIZE_BITS-1:0] write_pointer;
	reg  [DATA_WIDTH-1:0] fifo_mem [MEM_SIZE-1:0];

//Write

	always @(posedge write_clock or posedge reset) begin
		if (reset) begin
			read_pointer 	<= SIZE_BITS'b0;
			write_pointer 	<= SIZE_BITS'b0;
			full 			<= 1'b0;
			empty			<= 1'b1;
		end
		else if (write_enable & ~fifo_full) begin
			data <= fifo_mem[write_pointer];
			write_pointer <= write_pointer + 1b'1; 
		end
	end
	
//Read

	always @(posedge read_clock or posedge reset) begin
		if (reset) begin
			read_pointer 	<= SIZE_BITS'b0;
			write_pointer 	<= SIZE_BITS'b0;
			full 			<= 1'b0;
			empty			<= 1'b1;
		end
		else if (read_enable & ~fifo_empty) begin
			q <= fifo_mem[read_pointer];
			read_pointer <= read_pointer + 1b'1; 
		end
	end
	
	assign fifo_empty = (write_pointer == read_pointer)? 1:0;
	assign fifo_full = (read_pointer == write_pointer+1'b1)? 1:0;
endmodule
