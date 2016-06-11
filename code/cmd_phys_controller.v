
module cmd_phys_controller(
	input wire sd_clock,
	input wire reset,
	// Inputs from host
	input wire strobe_in,   // request received
	input wire ack_in,		//response received
	input wire idle_in, // sets as idle
	input wire TIMEOUT_ENABLE,
	// output to host
	output reg ack_out,// acknowledge of package reception from host
	output reg strobe_out, // states that a response has been received
	output reg [135:0] response,
	//Inputs from wrapper
	input wire [135:0] pad_response,
	input wire transmission_complete,
	input wire reception_complete,
	//Outputs to wrapper
	output reg reset_wrapper,
	output reg pad_state,
	output reg pad_enable,
	output reg enable_pts_wrapper,
	output reg enable_stp_wrapper,
	output wire COMMAND_TIMEOUT
	
	
	);




parameter SIZE = 4;
reg [SIZE-1:0] state;
reg [SIZE-1:0] next_state;
parameter RESET= 4'd0; 
parameter IDLE   =  4'd1;
parameter LOAD_COMMAND= 4'd2;
parameter SEND_COMMAND  =  4'd3;
parameter WAIT_RESPONSE  =  4'd4;
parameter SEND_RESPONSE = 4'd5;
parameter WAIT_ACK =4'd6;



reg load_send;
reg loaded;
reg response_sent;
reg [6:0]timeout_count;

assign COMMAND_TIMEOUT=(timeout_count==7'd64) ? 1'b1:1'b0;

always @ ( * )
begin 
 case(state)
 RESET:
		begin
			next_state=IDLE;
		end
 IDLE:   begin
      if (strobe_in) begin
          next_state = LOAD_COMMAND;
      end     
      else begin
         next_state = IDLE;
      end   
 end  
LOAD_COMMAND:   begin
      if (loaded) begin
          next_state = SEND_COMMAND;
      end     
      else begin
         next_state = LOAD_COMMAND;
      end   
 end          
 SEND_COMMAND:begin
    if (transmission_complete)             
       next_state = WAIT_RESPONSE;  
     else   
       next_state = SEND_COMMAND;
   end  
WAIT_RESPONSE:    begin
       if (reception_complete) begin
          next_state = SEND_RESPONSE;
      end     
      else begin
         next_state = WAIT_RESPONSE;
      end
      end
SEND_RESPONSE:    begin
       if (response_sent) begin
          next_state = WAIT_ACK;
      end     
      else begin
         next_state = SEND_RESPONSE;
      end
      end
WAIT_ACK:    begin
       if (ack_out) begin
          next_state = IDLE;
      end     
      else begin
         next_state = WAIT_ACK;
      end
 end       
   
  
 default : next_state  = RESET;
 
 endcase 
    
end
//logica de salida

always @(* )
	begin
		case(state)
		
				RESET:
					begin
						ack_out=1'b0;
						strobe_out=1'b0;
						response=0;
						load_send=1'b0;
						loaded=1'b0;
						reset_wrapper=1'b1;
						response_sent=1'b0;
						pad_state=1'b0;
						pad_enable=1'b0;
						enable_pts_wrapper=1'b0;
						enable_stp_wrapper=1'b0;
					end
				IDLE:	
					begin
						ack_out=1'b0;
						strobe_out=1'b0;
						response=0;
						load_send=1'b0;
						loaded=1'b0;
						reset_wrapper=1'b1;
						response_sent=1'b0;
						pad_state=1'b0;
						pad_enable=1'b0;
						enable_pts_wrapper=1'b0;
						enable_stp_wrapper=1'b0;
					end
				LOAD_COMMAND:
					begin
						ack_out=1'b0;
						strobe_out=1'b0;
						response=0;
						load_send=1'b0;
						loaded=1'b1;
						reset_wrapper=1'b0;
						response_sent=1'b0;
						pad_state=1'b1;
						pad_enable=1'b1;
						enable_pts_wrapper=1'b1;
						enable_stp_wrapper=1'b0;
					end
				SEND_COMMAND:
					begin
						ack_out=1'b0;
						strobe_out=1'b0;
						response=0;
						load_send=1'b1;
						loaded=1'b1;
						reset_wrapper=1'b0;
						response_sent=1'b0;
						pad_state=1'b1;
						pad_enable=1'b1;
						enable_pts_wrapper=1'b1;
						enable_stp_wrapper=1'b0;
					end
				WAIT_RESPONSE:
					begin
						ack_out=1'b0;
						strobe_out=1'b0;
						response=0;
						load_send=1'b0;
						loaded=1'b1;
						reset_wrapper=1'b0;
						response_sent=1'b0;
						pad_state=1'b0;
						pad_enable=1'b1;
						enable_pts_wrapper=1'b0;
						enable_stp_wrapper=1'b1;
					end
				SEND_RESPONSE:
					begin
						ack_out=1'b0;
						strobe_out=1'b1;
						response=pad_response;
						load_send=1'b0;
						loaded=1'b0;
						reset_wrapper=1'b0;
						response_sent=1'b1;
						pad_state=1'b0;
						pad_enable=1'b0;
						enable_pts_wrapper=1'b0;
						enable_stp_wrapper=1'b0;
					end
				WAIT_ACK:
					begin
						strobe_out=1'b0;  
						response=pad_response;//set response
						load_send=1'b0;
						loaded=1'b0;
						reset_wrapper=1'b0;
						response_sent=1'b0;
						pad_state=1'b0;
						pad_enable=1'b0;
						enable_pts_wrapper=1'b0;
						enable_stp_wrapper=1'b0;
						if(ack_in)
							begin
							ack_out=1'b1;
							end
						else
							begin
							ack_out=1'b0;
							end
					end
					
				
				default:
					begin
					
					end
		
		
		endcase
end	




always @ (posedge sd_clock  )
	begin 
		if (reset) 
			begin
				state <=  RESET;
			end 
		else 
			begin 
				if(idle_in)
					begin
						state<=IDLE;
					end
				else 
					begin
						state <=  next_state;
					end
				end
		if(state==WAIT_RESPONSE)
			begin
				timeout_count<=timeout_count+7'b1;
			end	
		else
			begin
				timeout_count<=7'b0;
			end
		
		end
	

endmodule 



