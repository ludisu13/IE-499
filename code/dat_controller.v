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
output reg transfer_complete,
//outputs to physical layer
output reg strobe_out,
output reg ack_out
);

// registers
parameter SIZE = 3;
reg setup_done;
reg [SIZE-1:0] state;
reg [SIZE-1:0] next_state;
parameter RESET= 3'd0; 
parameter IDLE   = 3'd1;
parameter WRITE_COMMAND   =  3'd2;
parameter READ_COMMAND =  3'd3;
parameter CHECK_FIFO= 3'd4; 
parameter TRANSMIT   = 3'd5;
parameter ACK   =  3'd6;








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
          next_state = ACK;
      end     
      else begin
         next_state = TRANSMIT;
      end
      end
ACK:    begin
       if (ack_in) begin
          next_state =IDLE;
      end     
      else begin
         next_state =ACK;
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
					busy=1'b0;
					write_Data=1'b0;
					read_Data=1'b0;
					strobe_out=1'b0;
					ack_out=1'b0;
				end
			IDLE:
				begin
					busy=1'b0;
					write_Data=1'b0;
					read_Data=1'b0;
					strobe_out=1'b0;
					ack_out=1'b0;
				end
			WRITE_COMMAND:
				begin
					busy=1'b1;
					write_Data=1'b1;
					read_Data=1'b0;
					strobe_out=1'b1;
					ack_out=1'b0;
				end
			READ_COMMAND:
				begin
					busy=1;
					write_Data=1'b0;
					read_Data=1'b1;
					strobe_out=1'b1;
					ack_out=1'b0;
				end
			CHECK_FIFO:
				begin
					busy=0;
					write_Data=write_Data;
					read_Data=read_Data;
					strobe_out=1'b0;
					ack_out=1'b0;
				end
			TRANSMIT:
				begin
					busy=1'b1;
					write_Data=write_Data;
					read_Data=read_Data;
					strobe_out=1'b1;
					ack_out=1'b0;
				end
			ACK:
				begin
					busy=1'b1;
					write_Data=1'b0;
					read_Data=1'b0;
					strobe_out=1'b0;
					ack_out=1'b1;
					transfer_complete=1'b1;
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
