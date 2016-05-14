`include "RAM.v"

module FIFO_LIFO # (parameter SIZE=8,  parameter DEPTH=8, parameter MODE=0, parameter ADR_SIZE = 3 ) // Mode 0 => FIFO, Mode 1 => LIFO
(
	input wire Wr_clk, Rd_clk, RST, Wr_En_in, Rd_En_in,
	input wire [SIZE-1:0] Data_in,
	output wire [SIZE-1:0] Data_out,
	output wire Full, Empty
);

// Use empty/full flag to enable read/write
wire Wr_En, Rd_En;

// Block reading/writing when empty full
assign Wr_En = (Full)  ? 0 : Wr_En_in;
assign Rd_En = (Empty) ? 0: Rd_En_in;

// Read and Write Addresses
wire [ADR_SIZE-1:0] Read_Adr;
wire [ADR_SIZE-1:0] Write_Adr;

// Instanciate RAM memory
RAM # (.SIZE(SIZE), .DEPTH(DEPTH), .ADR_SIZE(ADR_SIZE)) Memory 
(
	.Data_in(Data_in),
	.ADR_Rd_In(Read_Adr),
	.ADR_Wr_In(Write_Adr),
	.Wr_En(Wr_En), 
	.Rd_En(Rd_En),
	.Data_out(Data_out),
	.Rd_clk(Rd_clk_real), // Clock depends on LIFO/FIFO mode
	.Wr_clk(Wr_clk)
);

// Manage dual read clock depending on operation MODE
/*
	When working on MODE=1 (LIFO) Rd_Clk is Wr_Clk
*/
//~ wire Rd_clk_real;
assign Rd_clk_real = (MODE) ? Wr_clk : Rd_clk; 	

// Asign Read and Write Addresses
assign Read_Adr  = (MODE) ? (final-1) : inicio;
assign Write_Adr = (MODE) ? (final)   : final ;

// Start and End pointers for LIFO
reg [ADR_SIZE-1:0] inicio;
reg [ADR_SIZE-1:0] final;

// Carry: is the ADR_SIZE's bit of final in order to know when a overflow occurs
reg	Carry;

// Register to detect full state
reg FIFO_full; 
reg FIFO_empty;

// Full Flag
assign Full = (MODE) ? (Carry) : (FIFO_full & (inicio==final)); 

// Empty Flag
assign Empty = (MODE) ? (final == 0) : ( FIFO_empty & (final==inicio) & ~Full);

// Flag for Almost FULL/EMPTY
/*
	Check when we are close of the inicio==final, we search if we are 
	close EMPTY of FULL condition. They are used to distinguish between
	Full and Empty conditions
*/
wire [ADR_SIZE-1:0] almost_full;
assign 	almost_full = ((inicio-final)-1); // When almost_full is in 0, the FIFO will get full if you write
wire [ADR_SIZE-1:0] almost_empty;
assign almost_empty = ((final-inicio)-1); // When almost_empty is in 0, the FIFO will get empty if you read

// Writing Logic (Final pointer logic)
always @ (posedge Wr_clk)
	begin
		if(RST) 
			begin
				final   <= 0;
				FIFO_full <=0;
				Carry <= 0;
			end
		else if (MODE==1) // LIFO
			begin
				if(Wr_En) // En caso de lectura
					{Carry,final} <= {Carry,final}+1;
				else  if (Rd_En) // En caso de escritura
					{Carry,final} <= {Carry,final}-1;
			end
		else if (MODE==0) // FIFO
			begin
				if(Wr_En) // En caso de lectura
					final <= final+1;		
						
				if (Wr_En_in)
					FIFO_full <= (almost_full == 0);
				else if (almost_full == 0)
					FIFO_full <= 0;
			end
	end
	
	


// Initial pointer logic
always @ (posedge Rd_clk)
	begin
		if(RST) 
			begin
				inicio <= 0;
				FIFO_empty <= 1;
			end
		else if(MODE==0) // FIFO
			begin
				if(Rd_En)
					begin
						inicio <= inicio+1;
					end
				if (Rd_En_in)
					FIFO_empty <= (almost_empty == 0);
				else
					FIFO_empty <= (final == inicio); // Update the FIFO_empty flag
			end
	end

endmodule
