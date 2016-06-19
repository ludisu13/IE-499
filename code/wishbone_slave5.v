module wishbone_slave ( // Wishbone Slave

	//Common Inputs
	input wire 		clock,
	input wire 		reset,
	
	
	//Inputs from Host
	input wire [127:0]	host_data_i,
	input wire 		cmd_done_i,
	input wire 		data_done_i,
	
	//Outputs to Host
	output reg 		new_data,
	output reg 		new_command,
	output reg	[127:0]	host_data_o,
	output reg			fifo_read_en,
	output reg			fifo_write_en,
	output reg			reg_read_en,
	output reg			reg_write_en,
	output reg	[4:0]	adr_o,
	
	//Inputs from Wishbone Master
	input wire 		we_i, //write_enable 
	input wire [4:0]	adr_i, 
	input wire 		strobe, // Strobe
	input wire [127:0] wb_data_i,
	
	//Outputs to Wishbone Master
	output reg [127:0]	wb_data_o,
	output reg 		ack_o,
	output reg			error_o
	
);

// registers
parameter SIZE = 4;
reg [SIZE-1:0] state = 3'd0; // 4 states
reg [SIZE-1:0] next_state;
reg dummy_count;

parameter RESET		= 3'd0; 
parameter IDLE   		= 3'd1;
parameter READ			= 3'd2;
parameter WRITE		= 3'd3;
parameter EXEC			= 3'd4;
parameter WBWAIT		= 3'd5;


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
					if(adr_i == 5'd16 || adr_i == 5'd19)
						next_state = EXEC;
					else
						next_state = WRITE;
				else 
					next_state = IDLE;
			end
		
		READ:
			begin
				if(!strobe)
					next_state = IDLE;
				else if(!we_i)
					next_state = READ;
				else
					if(adr_i == 5'd16 || adr_i == 5'd19)
						next_state = EXEC;
					else
						next_state = WRITE;
			end
			
		WRITE:
			begin
				if(!strobe) 
					next_state = IDLE;
				else if(we_i)
					begin
						if(adr_i == 5'd16 || adr_i == 5'd19) // CMD EX o DAT EX
							next_state = EXEC;
						else
							next_state = WRITE;
					end
				else 
					next_state = READ;
			
				//else if(adr_i == 5'd16 || adr_i == 5'd19) // CMD EX
				//	begin
				//		if(we_i)
				//			next_state = EXEC;
				//		else
				//			next_state = READ;
				//	end
					
				//else
				//	if(we_i)
				//		next_state = WRITE;
				//	else
				//		next_state = READ;
			end
			
		EXEC:
			begin
				next_state = WBWAIT;
			end
			
		WBWAIT:
			begin
				if(cmd_done_i || data_done_i)
					begin
						if(we_i)
							if(adr_i == 5'd16 || adr_i == 5'd19)
								next_state = EXEC;
							else
								next_state = WRITE;
						else
							next_state = READ;
					end
				else
						next_state = WBWAIT;
				
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
				ack_o 		  = 1'b0;
				new_command   = 1'b0;
				new_data	  = 1'b0;
				host_data_o   = 128'b0;
				wb_data_o	  = 128'b0;
				fifo_read_en  = 1'b0;
				fifo_write_en = 1'b0;
				reg_read_en   = 1'b0;
				reg_write_en  = 1'b0;
				error_o		  = 1'b0;
				adr_o		  = 5'b0;
			end
		
		IDLE:
			begin
				ack_o 		  = 1'b0;
				new_command   = 1'b0;
				new_data	  = 1'b0;
				host_data_o   = 128'b0;
				wb_data_o	  = 128'b0;
				fifo_read_en  = 1'b0;
				fifo_write_en = 1'b0;
				reg_read_en   = 1'b0;
				reg_write_en  = 1'b0;
				error_o		  = 1'b0;
				adr_o 		  = 5'b0;
			end
		
		READ:
			begin
				ack_o 		= 1'b1;
				new_command = 1'b0;
				new_data	= 1'b0;
				host_data_o = 128'b0;
				error_o		= 1'b0;
				if(adr_i == 5'd18)
					begin
						fifo_read_en  = 1'b1;
						fifo_write_en = 1'b0;
						reg_read_en   = 1'b0;
						reg_write_en  = 1'b0;
					end
				else if(adr_i >=0 && adr_i<=15)
					begin
						fifo_read_en  = 1'b0;
						fifo_write_en = 1'b0;
						reg_read_en   = 1'b1;
						reg_write_en  = 1'b0;
					end	
				else
					begin
						fifo_read_en  = 1'b0;
						fifo_write_en = 1'b0;
						reg_read_en   = 1'b0;
						reg_write_en  = 1'b0;
						error_o		  = 1'b1;
					end
				wb_data_o	= host_data_i;
				adr_o 		= adr_i;
			end				
		
		WRITE:
			begin	
				if(adr_i == 5'd16) // CMD
					begin
						ack_o 		= 1'b1;
						new_command = 1'b1;
						new_data	= 1'b0;
						host_data_o = wb_data_i;
						wb_data_o	= 128'b0;
						fifo_read_en  = 1'b0;
						fifo_write_en = 1'b0;
						reg_read_en   = 1'b0;
						reg_write_en  = 1'b0;
						error_o		  = 1'b0;
						adr_o		  = adr_i;
					end
				else if (adr_i == 5'd17) //FIFO WRITE
					begin
						ack_o 		= 1'b1;
						new_command = 1'b0;
						new_data	= 1'b0;
						host_data_o = wb_data_i;
						wb_data_o = 128'b0;
						fifo_read_en  = 1'b0;
						fifo_write_en = 1'b1;
						reg_read_en   = 1'b0;
						reg_write_en  = 1'b0;
						error_o		  = 1'b0;
						adr_o		  = adr_i;
					end
				else if (adr_i == 5'd19) //DATA EXECUTE
					begin
						ack_o 		= 1'b1;
						new_command = 1'b0;
						new_data	= 1'b1;
						host_data_o = 128'b0;
						wb_data_o	= 128'b0;
						fifo_read_en  = 1'b0;
						fifo_write_en = 1'b0;
						reg_read_en   = 1'b0;
						reg_write_en  = 1'b0;
						error_o		  = 1'b0;
						adr_o		  = adr_i;
					end
				else if(adr_i >= 5'd0 && adr_i <=5'd15)// REG
					begin
						ack_o 		= 1'b1;
						new_command = 1'b0;
						new_data	= 1'b0;
						host_data_o = wb_data_i;
						wb_data_o	= 128'b0;
						fifo_read_en = 1'b0;
						fifo_write_en = 1'b0;
						reg_read_en   = 1'b0;
						reg_write_en  = 1'b1;
						error_o		  = 1'b0;
						adr_o		  = adr_i;
					end
				else 
					begin
						ack_o 		= 1'b1;
						new_command = 1'b0;
						new_data	= 1'b0;
						host_data_o = 128'b0;
						wb_data_o	= 128'b0;
						fifo_read_en = 1'b0;
						fifo_write_en = 1'b0;
						reg_read_en   = 1'b0;
						reg_write_en  = 1'b0;
						error_o		  = 1'b1;
						adr_o		  = 5'b0;
					end
			end
		EXEC:
			begin
			if(adr_i == 5'd16) begin
				new_command = 1'b1;
				new_data = 1'b0;
			end
			else if(adr_i == 5'd19) begin
				new_data = 1'b1;
				new_command = 1'b0;
			end
				ack_o	 	  = 1'b1;
				//new_command   = 1'b0;
				//new_data	  = 1'b0;	
				host_data_o   = 128'b0;
				wb_data_o 	  = 128'b0;
				fifo_read_en  = 1'b0;
				fifo_write_en = 1'b0;
				reg_read_en   = 1'b0;
				reg_write_en  = 1'b0;
				error_o		  = 1'b0;
				adr_o		  = 5'b0;
			end
		
		WBWAIT:
			begin
				if(cmd_done_i || data_done_i)
					ack_o	  = 1'b1;
				else 
					ack_o 	  = 1'b0;
				new_command   = 1'b0;
				new_data	  = 1'b0;	
				host_data_o   = 128'b0;
				wb_data_o 	  = 128'b0;
				fifo_read_en  = 1'b0;
				fifo_write_en = 1'b0;
				reg_read_en   = 1'b0;
				reg_write_en  = 1'b0;
				error_o		  = 1'b0;
				adr_o		  = 5'b0;
			end
		
		default:
			begin
				ack_o 		  = 1'b0;
				new_command   = 1'b0;
				new_data	  = 1'b0;	
				host_data_o   = 128'b0;
				wb_data_o 	  = 128'b0;
				fifo_read_en  = 1'b0;
				fifo_write_en = 1'b0;
				reg_read_en   = 1'b0;
				reg_write_en  = 1'b0;
				error_o		  = 1'b0;
				adr_o 		  = 5'b0;
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
