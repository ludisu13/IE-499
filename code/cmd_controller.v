module cmd_controller(

	// Inputs from host 
	input wire clock,
	input wire reset,
	input wire new_command,
	input wire [31:0] cmd_argument,
	input wire [5:0] cmd_index,	
	input wire [31:0] command_timeout_REG,
	// Input from physical layer
	input wire ack_in,
	input wire strobe_in,
	input wire [39:0] cmd_in,
	input wire serial_ready,
	// Outputs to host
	output reg [39:0] cmd_out,
	output reg busy,
	//Outputs to physical layer
	output reg strobe_out,
	output reg ack_out,
	output reg idle_out,
	output reg [31:0]response,
	output reg command_complete,
	output reg command_timeout,
	output reg command_index_error
);

// registers
parameter SIZE = 3;
reg setup_done;
reg [SIZE-1:0] state;
reg [SIZE-1:0] next_state;
reg [31:0] count;
parameter RESET= 3'b000; 
parameter IDLE   =  3'b001;
parameter SETTING_OUTPUTS   =  3'b010;
parameter PROCESSING  =  3'b100;


always @ ( state  or setup_done or new_command or ack_in )
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
       if (ack_in) begin
          next_state = IDLE;
      end     
      else begin
         next_state = PROCESSING;
      end
 end       
   
  
 default : next_state  = RESET;
 
 endcase 
    
end





always @(posedge clock )
	begin
		case(state)
		
				RESET:
					begin
						busy=0;
						response=32'b0;
						strobe_out=0;
						ack_out=0;
						cmd_out=39'b0;
						command_complete=0;
						command_timeout=0;
						command_index_error=0;
						idle_out=1;
						setup_done=0;
					end
				IDLE:	
					begin
						busy=0;
						response=32'b0;
						strobe_out=0;
						ack_out=0;
						cmd_out=39'b0;
						command_complete=0;
						command_timeout=0;
						command_index_error=0;
						idle_out=0;
						setup_done=0;
					end
				SETTING_OUTPUTS:
					begin
						strobe_out=1;
						cmd_out[39:38]=2'b01;         
						cmd_out[37:32]=cmd_index;
						cmd_out[31:0]= cmd_argument;
						busy=1;
						response=32'b0;
						ack_out=0;
						idle_out=0;
						setup_done=1;
						command_complete=0;
						command_timeout=0;
						command_index_error=0;
					end
				PROCESSING:
					begin
						cmd_out=cmd_out;
						command_complete=0;
						command_index_error=0;
						command_timeout=0;
						busy=1;
						strobe_out=1;
						idle_out=1;
						response=32'b0;
						setup_done=1;
						ack_out=1;    
							if(strobe_in)
								begin
									if(cmd_in[37:32]==cmd_out[37:32])
										begin
												response=cmd_in[31:0];
												ack_out=1;
												command_complete=1;
										end
									else
										begin
												command_index_error=1;
										end	
								end
							else
								begin
									if(count>command_timeout_REG)
										begin
												command_timeout=1;
										end
									else
										begin
												count=count+1;
										end	
								
								end
							
						
					end
		default:
		
		
		busy=0;
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
	end

endmodule 
