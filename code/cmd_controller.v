module cmd_controller(

	// Inputs from Host Interface
	input wire clock,
	input wire reset,
	
	//input wire data_read,
	//input wire data_write,
	input wire new_command,
	input wire [31:0] argument_reg,
	input wire [5:0] cmd_index,	
	// Inputs and Outputs from Serial Host
	input wire ack_in,
	input wire req_in,
	input wire [39:0] cmd_in,
	input wire serial_ready
	
	output reg ack_out,
	output reg req_out,
	output reg [39:0] cmd_out,
	
	output reg idle_out,
	output wire busy,
);

input wire ack_in;
parameter SIZE = 3;
reg [SIZE-1:0] state;
reg [SIZE-1:0] next_state;
parameter RESET= 3'b000; 
parameter IDLE   =  3'b001;
parameter SETTING_OUTPUTS   =  3'b010;
parameter OUTPUTS_RECEIVED  =  3'b100;

always @ ( state  or setup_done or new_command or ack_in or serial_ready)
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
    if (setup_done && serial_ready)             
       next_state = EXECUTE;  
     else   
       next_state = SETTING_OUTPUTS;
   end  
 EXECUTE:    begin
       if (ack_in) begin
          next_state = IDLE;
      end     
      else begin
         next_state = EXECUTE;
      end
 end       
   
  
 default : next_state  = IDLE;
 
 endcase 
    
end

always @(posedge clock or reset)
	begin
		case(state)
		
				RESET:
					begin
					
					
					end
		
				IDLE:	
					begin
					
					
					end
				SETTING_OUTPUTS:
					begin
					
					end
					
				EXECUTE:
					begin
					
					
					end
		
		
		
		
		
		
		
		default:
		
		
		
		endcase
	end	




always @ (posedge clock or posedge reset  )
begin : FSM_SEQ
  if (reset ) begin
    state <= #1 RESET;
 end 
 else begin
    state <= #1 next_state;
 end
end






endmodule 
