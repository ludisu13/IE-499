module dat_controller(

// inputs from host
input wire clock,
input wire reset,
input wire writeRead,
input wire newDat,//from wishbone 
input wire [3:0 ]blockCount,
input wire multipleData,
//inputs from physical layer
input wire serial_ready,
input wire complete,
input wire ack_in,
//inputs from fifoController
input wire fifo_okay,
//outputs to host
output reg transfer_complete,
//outputs to physical layer
output reg strobe_out,
output reg ack_out,
output reg [3:0] blocks,
output reg writereadphys,
output reg multiple
);

// registers
parameter SIZE = 3;
reg [SIZE-1:0] state;
reg [SIZE-1:0] next_state;
parameter RESET= 3'd0; 
parameter IDLE   = 3'd1;
parameter SETTING_OUTPUTS  =  3'd2;
parameter CHECK_FIFO= 3'd3; 
parameter TRANSMIT   = 3'd4;
parameter ACK   =  3'd5;







// registers


always @ ( *)
begin 
 case(state)
 RESET:
		begin
			next_state=IDLE;
		end
 IDLE:   begin
      if (newDat)
			begin
			next_state=SETTING_OUTPUTS;	
			end		
		else
			begin
          next_state = IDLE;
          end
      
		end       
SETTING_OUTPUTS:begin
    if (serial_ready)             
       next_state = CHECK_FIFO;  
     else   
       next_state = SETTING_OUTPUTS;
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
    
   
  
 default : next_state  = RESET;
 
 endcase 
    
end





always @(*)
	begin
		case(state)
			RESET:
				begin
					strobe_out=1'b0;
					ack_out=1'b0;
					transfer_complete=1'b0;
					writereadphys=1'b0;
					multiple=1'b0;
					blocks=4'b0;
				end
			IDLE:
				begin
					strobe_out=1'b0;
					ack_out=1'b0;
					transfer_complete=1'b0;
					writereadphys=1'b0;
					multiple=1'b0;
					blocks=4'b0;
				end
			SETTING_OUTPUTS:
				begin
					strobe_out=1'b0;
					ack_out=1'b0;
					transfer_complete=1'b0;
					writereadphys=writeRead;
					multiple=multipleData;
					blocks=blockCount;
				end
			CHECK_FIFO:
				begin
					strobe_out=1'b0;
					ack_out=1'b0;
					transfer_complete=1'b0;
					writereadphys=writereadphys;
					multiple=multiple;
					blocks=blocks;
				end
			TRANSMIT:
				begin
					writereadphys=writeRead;
					strobe_out=1'b1;
					ack_out=1'b0;
					multiple=multiple;
					blocks=blocks;
					if(complete)
						begin
							transfer_complete=1'b1;
						end
					else
						begin
							transfer_complete=1'b0;
						end
				end
			ACK:
				begin
					strobe_out=1'b0;
					ack_out=1'b1;
					transfer_complete=transfer_complete;
					writereadphys=writeRead;
					multiple=multipleData;
					blocks=blockCount;
				end
		
				
		default:
				begin
				
				end
		
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
