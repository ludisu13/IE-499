module wishbone_slave ( // Wishbone Slave

	//Common Inputs
	input wire 		clock,
	input wire 		reset,
	
	
	//Inputs from Host
	input wire [63:0]	host_data_i,
	input wire 		cmd_done_i,
	input wire 		data_done_i,
	
	//Outputs to Host
	output reg 		new_data,
	output reg 		new_command,
	output reg	[63:0]	host_data_o,
	output reg			fifo_read_en,
	output reg			fifo_write_en,
	output reg			reg_read_en,
	output reg			reg_write_en,
	
	//Inputs from Wishbone Master
	input wire 		we_i, //write_enable 
	input wire [4:0]	adr_i, // Command (adr_i = 0) or Data (adr_i = 1)
	input wire 		strobe, // Strobe
	input wire [63:0] 	wb_data_i,
	
	//Outputs to Wishbone Master
	output reg [63:0]	wb_data_o,
	output reg 		ack_o
	
);

// registers
parameter SIZE = 3;
reg [SIZE-1:0] state = 2'd0; // 4 states
reg [SIZE-1:0] next_state;
reg dummy_count;

parameter RESET		= 2'd0; 
parameter IDLE   		= 2'd1;
parameter READ			= 2'd2;
parameter WRITE		= 2'd3;


//Next state logic
always @(*) begin
	case(state) 

		RESET:
			begin
				next_state = IDLE;
			end
		
		IDLE:
			begin
				if(strobe & !we_i) 
					next_state = READ;
				else if(strobe & we_i)
					next_state = WRITE;
				else 
					next_state = IDLE;
			end
		
		READ:
			begin
				next_state = WAIT;
			end
			
		WRITE:
			begin
				if(!strobe) 
					next_state = IDLE;
			
				else if(adr_i == 5'd18) // CMD
					begin
						if(cmd_done_i)
							begin
								if(we_i)
									next_state = WRITE;
								else
									next_state = READ;
							end
						else 
							next_state = WRITE;
					end
				else if(adr_i == 5'd21) // DATA
					begin
						if(data_done_i)
							begin
								if(we_i)
									next_state = WRITE;
								else
									next_state = READ;
							end
						else 
							next_state = WRITE;
					end
				else
					if(we_i)
						next_state = WRITE;
					else
						next_state = READ;
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
				ack_o 		  <= 1'b0;
				new_command   <= 1'b0;
				new_data	  <= 1'b0;
				host_data_o   <= 64'b0;
				wb_data_o	  <= 64'b0;
				fifo_read_en  <= 1'b0;
				fifo_write_en <= 1'b0;
				reg_read_en   <= 1'b0;
				reg_write_en  <= 1'b0;
			end
		
		IDLE:
			begin
				ack_o 		<= 1'b0;
				new_command <= 1'b0;
				new_data	<= 1'b0;
				host_data_o <= 64'b0;
				wb_data_o	<= 64'b0;
				fifo_read_en  <= 1'b0;
				fifo_write_en <= 1'b0;
				reg_read_en   <= 1'b0;
				reg_write_en  <= 1'b0;
			end
		
		READ:
			begin
				ack_o 		<= 1'b1;
				new_command <= 1'b0;
				new_data	<= 1'b0;
				host_data_o <= 64'b0;
				if(adr_i == 5'd20)
					begin
						fifo_read_en  <= 1'b1;
						fifo_write_en <= 1'b0;
						reg_read_en   <= 1'b0;
						reg_write_en  <= 1'b0;
					end
				else 
					begin
						fifo_read_en  <= 1'b0;
						fifo_write_en <= 1'b0;
						reg_read_en   <= 1'b1;
						reg_write_en  <= 1'b0;
					end	
				wb_data_o	<= host_data_i;
			end				
		
		WRITE:
			begin	
				if(adr_i == 5'd18) // CMD
					begin
						ack_o 		<= 1'b0;
						if(dummy_count == 1'b1)
							ack_o 		<= 1'b1;
						new_command <= 1'b1;
						new_data	<= 1'b0;
						host_data_o <= wb_data_i;
						wb_data_o	<= 64'b0;
						fifo_read_en  <= 1'b0;
						fifo_write_en <= 1'b0;
						reg_read_en   <= 1'b0;
						reg_write_en  <= 1'b0;
					end
				else if (adr_i == 5'd19) //FIFO
					begin
						ack_o 		<= 1'b1;
						new_command <= 1'b0;
						new_data	<= 1'b0;
						host_data_o <= wb_data_i;
						wb_data_o	<= 64'b0;
						fifo_read_en  <= 1'b0;
						fifo_write_en <= 1'b1;
						reg_read_en   <= 1'b0;
						reg_write_en  <= 1'b0;
					end
				else if (adr_i == 5'd21) //DATA EXECUTE
					begin
						ack_o 		<= 1'b0;
						if(dummy_count == 1'b1)
							ack_o 		<= 1'b1;
						new_command <= 1'b0;
						new_data	<= 1'b1;
						host_data_o <= 64'b0;
						wb_data_o	<= 64'b0;
						fifo_read_en  <= 1'b0;
						fifo_write_en <= 1'b0;
						reg_read_en   <= 1'b0;
						reg_write_en  <= 1'b0;
					end
				else // REG
					begin
						ack_o 		<= 1'b1;
						new_command <= 1'b0;
						new_data	<= 1'b0;
						host_data_o <= wb_data_i;
						wb_data_o	<= 64'b0;
						fifo_read_en  <= 1'b0;
						fifo_write_en <= 1'b0;
						reg_read_en   <= 1'b0;
						reg_write_en  <= 1'b1;
					end
			end
			
		WAIT:
			begin
				ack_o 		<= 1'b1;
				new_command <= 1'b0;
				new_data	<= 1'b0;
				host_data_o <= 64'b0;
				wb_data_o	<= 64'b0;
				fifo_read_en  <= 1'b0;
				fifo_write_en <= 1'b0;
				reg_read_en   <= 1'b0;
				reg_write_en  <= 1'b0;
			end
		
		default:
			begin
				ack_o 		<= 1'b0;
				new_command <= 1'b0;
				new_data	<= 1'b0;	
				host_data_o <= 64'b0;
				wb_data_o 	<= 64'b0;
				fifo_read_en  <= 1'b0;
				fifo_write_en <= 1'b0;
				reg_read_en   <= 1'b0;
				reg_write_en  <= 1'b0;
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
	
	if(state == WRITE)
		begin
			dummy_count<=dummy_count+1'b1;
			if(dummy_count==1'b1)
				dummy_count<=dummy_count;
		end
	else 
		dummy_count<=1'b0;
end


endmodule
