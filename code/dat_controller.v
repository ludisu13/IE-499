module dat_controller(

// inputs from host
input wire clock,
input wire reset,
input wire writeRead,
input wire newDat,
//inputs from physical layer
input wire serial_ready,
input wire complete,
input wire ack_in,
input wire strobe_in,
//inputs from fifoController
input wire fifo_okay,
//outputs to host
output reg busy,
output reg write_Data,
output reg read_Data,
//outputs to physical layer
output reg strobe_out,
output reg ack_out,
output reg transmit,
output reg receive
);

// registers
parameter SIZE = 6;
reg setup_done;
reg [SIZE-1:0] state;
reg [SIZE-1:0] next_state;
parameter RESET= 5'b00000; 
parameter IDLE   =  5'b00001;
parameter WRITE_COMMAND   =  5'b00010;
parameter READ_COMMAND =  5'b10000;
parameter CHECK_FIFO= 5'b01000; 
parameter TRANSMIT   =  5'b10000;






// registers


always @ ( state  or serial_ready or newDat or ack_in or fifo_okay )
begin 
 case(state)
 RESET:
		begin
			next_state=IDLE;
		end
 IDLE:   begin
      if (newDat)
			begin
				if(writeRead)
					next_state=WRITE_COMMAND;
				if(~writeRead)	
					next_state=READ_COMMAND;		
			end		
		else
			begin
          next_state = IDLE;
          end
      
		end       
WRITE_COMMAND:begin
    if (serial_ready)             
       next_state = CHECK_FIFO;  
     else   
       next_state = WRITE_COMMAND;
   end  
READ_COMMAND:    begin
       if (serial_ready) begin
          next_state = CHECK_FIFO;
      end     
      else begin
         next_state = READ_COMMAND;
      end
      end
CHECK_FIFO:    begin
       if (fifo_okay) begin
          next_state = TRANSMIT;
      end     
      else begin
         next_state = CHECK_FIFO;
      end
      end
TRANSMIT:    begin
       if (complete) begin
          next_state = IDLE;
      end     
      else begin
         next_state = TRANSMIT;
      end        
      
 end       
   
  
 default : next_state  = IDLE;
 
 endcase 
    
end





always @(posedge clock )
	begin
		case(state)
			RESET:
				begin
					busy=0;
					write_Data=0;
					read_Data=0;
					strobe_out=0;
					ack_out=0;
					transmit=0;
					receive=0;
				end
			IDLE:
				begin
				
				end
			WRITE_COMMAND:
				begin
				
				
				end
			READ_COMMAND:
				begin
				
				
				
				end
			CHECK_FIFO:
				begin
				
				
				end
			TRANSMIT:
				begin
				
				
				
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
