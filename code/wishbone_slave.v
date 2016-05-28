module wishbone_slave ( // Wishbone Slave

	//Common Inputs
	input wire 		clock,
	input wire 		reset,
	
	
	//Inputs from Host
	input wire [63:0]	host_data_i,
	
	//Outputs to Host
	output reg 		new_data,
	output reg 		new_command,
	output reg	[63:0]	host_data_o,
	
	//Inputs from Wishbone Master
	input wire 		we_i, //write_enable 
	input wire 		adr_i, // Command (adr_i = 0) or Data (adr_i = 1)
	input wire 		strobe, // Strobe
	input wire [63:0] 	wb_data_i,
	
	//Outputs to Wishbone Master
	output reg [63:0]	wb_data_o,
	output reg 		ack_o
	
);

// registers
parameter SIZE = 2;
reg [SIZE-1:0] state; // 3 states
reg [SIZE-1:0] next_state;
reg setup_done;// Output to host
parameter RESET		= 2'd0; 
parameter IDLE   		=  2'd1;
parameter READWRITE	=  2'd2;


//Next state logic
always @(*) begin
	case(state) 

		RESET:
			begin
				next_state = IDLE;
			end
		
		IDLE:
			begin
				if(strobe) 
					next_state = READWRITE;
				else 
					next_state = IDLE;
			end
		
		READWRITE:
			begin
				if (setup_done)	
					next_state =  IDLE;  
				else 
					next_state =  READWRITE;
			end
		
		default:
			next_state = RESET;
	endcase 
end


//Outputs logic
always @(*) begin
	case(state)
	
		RESET:
			begin
				ack_o 		<= 1'b0;
				setup_done 	<= 1'b0;
				new_command <= 1'b0;
				new_data	<= 1'b0;
				host_data_o <= 64'b0;
				wb_data_o	<= 64'b0;
			end
		
		IDLE:
			begin
				ack_o 		<= 1'b0;
				setup_done 	<= 1'b0;
				new_command <= 1'b0;
				new_data	<= 1'b0;
				host_data_o <= 64'b0;
				wb_data_o	<= 64'b0;
			end
		
		READWRITE:
			begin	
				if(we_i) begin	
					ack_o 		<= 1'b0;
					setup_done 	<= 1'b1;
					wb_data_o	<= 64'b0;
					host_data_o	<= wb_data_i;
					if (adr_i) begin
						new_data	<= 1'b1;
						new_command <= 1'b0;
					end
					else begin
						new_command <= 1'b1;
						new_data 	<= 1'b0;
					end
				end
				else begin
					ack_o		<= 1'b1;
					setup_done 	<= 1'b1;
					new_command <= 1'b0;
					new_data	<= 1'b0;	
					host_data_o <= 64'b0;
					wb_data_o 	<= host_data_i;		
				end
			end
		
		default:
			begin
				ack_o 		<= 1'b0;
				setup_done 	<= 1'b0;
				new_command <= 1'b0;
				new_data	<= 1'b0;	
				host_data_o <= 64'b0;
				wb_data_o 	<= 64'b0;
			end
	endcase
end

always @ (posedge clock  ) begin 
	if (reset) begin
		state <=  RESET;
	end 
	else begin
		state <=  next_state;
	end
end


endmodule
