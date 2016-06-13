module cmd_controller(

	// Inputs from host 
	input wire clock,
	input wire reset,
	input wire new_command,
	input wire [31:0] cmd_argument,
	input wire [5:0] cmd_index,	//depending of command index response shouldbe of different size
		input wire TIMEOUT_ENABLE,
	// Input from physical layer
	input wire ack_in,
	input wire strobe_in,
	input wire [135:0] cmd_in, // 
	input wire TIMEOUT,

	
	//input wire serial_ready,
	//need to add a singal for transmission complete will require a new state
	// Outputs to host
	output reg busy,
	output reg setup_done,
	output reg [127:0]response,
	output reg command_complete,
	output reg command_timeout,
	output reg command_index_error,
	//Outputs to physical layer
	output reg strobe_out,
	output reg ack_out,
	output reg idle_out,
	output reg [39:0] cmd_out//physical layer
	
);

// registers
parameter SIZE = 2;
reg [SIZE-1:0] state;
reg [SIZE-1:0] next_state;
reg [31:0] count;
parameter RESET= 2'd0; 
parameter IDLE   =  2'd1;
parameter SETTING_OUTPUTS   =  2'd2;
parameter PROCESSING  =  2'd3;
wire stop_timeout=TIMEOUT && TIMEOUT_ENABLE;

always @ ( * )
begin 
 case(state)
 RESET:
		begin
			next_state=IDLE;
		end
 IDLE:   begin
      if (new_command) begin
          next_state = SETTING_OUTPUTS;
      end     
      else begin
         next_state = IDLE;
      end   
 end       
 SETTING_OUTPUTS:begin
    if (setup_done )             
       next_state = PROCESSING;  
     else   
			next_state = SETTING_OUTPUTS;
 
   end  
 PROCESSING:    begin
       if (ack_in || command_timeout) begin
          next_state = IDLE;
      end     
      else begin
         next_state = PROCESSING;
      end
 end       
   
  
 default : next_state  = RESET;
 
 endcase 
    
end





always @(* )
	begin
		case(state)
		
				RESET:
					begin
						busy=1'b0;
						response=32'b0;
						strobe_out=1'b0;
						ack_out=1'b0;
						cmd_out=39'b0;
						command_complete=1'b0;
						command_timeout=1'b0;
						command_index_error=1'b0;
						idle_out=1'b1;
						setup_done=1'b0;
						count=32'b0;
					end
				IDLE:	
					begin
						busy=1'b0;
						response=32'b0;
						strobe_out=1'b0;
						ack_out=1'b0;
						cmd_out=39'b0;
						command_complete=1'b0;
						command_timeout=1'b0;
						command_index_error=1'b0;
						idle_out=1'b1;
						setup_done=1'b0;
						count=32'b0;
					end
				SETTING_OUTPUTS:
					begin
						strobe_out=1'b1;
						cmd_out[39:38]=2'b01;         
						cmd_out[37:32]=cmd_index;
						cmd_out[31:0]= cmd_argument;
						busy=1'b1;
						response=32'b0;
						ack_out=1'b0;
						idle_out=1'b0;
						setup_done=1'b1;
						command_complete=1'b0;
						command_timeout=1'b0;
						command_index_error=1'b0;
						count=32'b0;
					end
				PROCESSING:
					begin
						cmd_out=cmd_out;
						command_complete=1'b0;
						command_index_error=1'b0;
						command_timeout=1'b0;
						busy=1'b1;
						strobe_out=1'b1;
						idle_out=1'b0;
						response=32'b0;
						setup_done=1'b0;
						ack_out=1'b0;   //long responses 2 9 10 // no response 0 4 15 // no check index 41S 
							if(strobe_in)
								begin
									command_complete=1'b1;
									ack_out=1'b1;
									if(cmd_index==6'd2 || cmd_index==6'd9 || cmd_index==6'd10 || cmd_index==6'd41)
										begin
											if(cmd_index==6'd41)
												begin
													response[31:0]=cmd_in[39:8]; 
												end
											else
												begin
													response[119:0]=cmd_in[127:8];
												end
				
										end
								   else
										begin
											if(cmd_index==6'd0 || cmd_index==6'd4 || cmd_index==6'd15 )
												begin
												command_index_error=1'b0;
												end
											else
												begin
													if(cmd_index==cmd_in[45:40])
														begin
															response[31:0]=cmd_in[39:8];
															command_index_error=1'b0;
														end
													else
														begin
															command_index_error=1'b1;
														end	
												end
										end
								end
							else 
								begin
									ack_out=1'b0;
								end
				end
		default:
		
		
		busy=1'b0;
		endcase
end	




always @ (posedge clock  )
	begin 
		if (reset) 
			begin
				state <=  RESET;
			end 
		else 
			begin
				state <=  next_state;
		end
		if(stop_timeout)
			begin
				state<=IDLE;
			end
		else
			begin
				state<=next_state;
			end
	end	

endmodule 
