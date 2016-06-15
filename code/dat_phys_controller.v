
module dat_phys_controller(
	input wire sd_clock,
	input wire reset,
	///inputs from host 
	input wire strobe_in,   // request received
	input wire ack_in,		//response received
	input wire [15:0]TIMEOUT_REG,
	input wire [3:0] blocks, // amount of blocks 
	input wire writeRead,
	input wire multiple,
	input wire idle_in,
	///outputs to host
	output reg serial_ready,// acknowledge of package reception from host
	output reg complete, // states that a response has been received
	output reg ack_out,
	output wire DATA_TIMEOUT,
	///////////inputs from wrapper
	input wire transmission_complete,
	input wire reception_complete,
	input wire [31:0] dataRead,
	//////outputs to wrapper
	output reg reset_wrapper,
	output reg load_send,
	output reg enable_pts_wrapper,
	output reg enable_stp_wrapper,
	output reg waiting_response,
	//outputs to PAD
	output reg pad_state,
	output reg pad_enable,	
	//outputs TO FIFO
	output reg write_fifo_enable,
	output reg read_fifo_enable,
	output reg [31:0] dataReadTOFIFO
	);

parameter SIZE = 4;
reg [SIZE-1:0] state;
reg [SIZE-1:0] next_state;
parameter RESET= 4'd0; 
parameter IDLE   =  4'd1;
parameter LOAD_WRITE= 4'd2;
parameter SEND  =  4'd3;
parameter WAIT_RESPONSE  =  4'd4;
parameter READ = 4'd5;
parameter READ_FIFO_WRITE =4'd6;
parameter READ_WRAPPER_RESET =4'd7;
parameter WAIT_ACK =4'd8;


reg dummy_count;
reg [15:0]timeout_count;
reg [3:0]blockCount;
reg loaded;
assign DATA_TIMEOUT=(timeout_count==TIMEOUT_REG) ? 1'b1:1'b0;
always @ ( * )
begin 
 case(state)
 RESET:
		begin
			next_state=IDLE;
		end
 IDLE:   begin
      if (strobe_in) begin
          if(writeRead)
			begin
				next_state=LOAD_WRITE;
			end	
		else
			begin
				next_state=READ;
			end
      end     
      else begin
         next_state = IDLE;
      end   
 end  
LOAD_WRITE:   begin
      if (loaded) begin
          next_state = SEND;
      end     
      else begin
         next_state = LOAD_WRITE;
      end   
 end          
 SEND:begin
    if (transmission_complete)             
       next_state = WAIT_RESPONSE;  
     else   
       next_state = SEND;
   end  
WAIT_RESPONSE:    begin
       if (reception_complete) begin
		if(!multiple || blockCount==blocks)
			begin
				next_state = WAIT_ACK; 
			end
		else
			begin
				next_state=LOAD_WRITE;
			end
      end     
      else begin
         next_state = WAIT_RESPONSE;
      end
      end

   
      
      
READ:    begin
       if (reception_complete) begin
          next_state = READ_FIFO_WRITE;
      end     
      else begin
         next_state = READ;
      end
      end
READ_FIFO_WRITE:    begin
		if(!multiple ||  blockCount==blocks)
			begin
				next_state = WAIT_ACK; 
			end
		else
			begin
				next_state=READ_WRAPPER_RESET;
			end
      end
           
READ_WRAPPER_RESET:begin
						next_state=READ;
					end
				
      
WAIT_ACK:    begin
       if (ack_in) begin
          next_state = IDLE;
      end     
      else begin
         next_state = WAIT_ACK;
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
						serial_ready=1'b0;
						complete=1'b0;
						ack_out=1'b0;
						reset_wrapper=1'b1;
						load_send=1'b0;
						enable_pts_wrapper=1'b0;
						enable_stp_wrapper=1'b0;
						waiting_response=1'b0;
						pad_state=1'b0;
						pad_enable=1'b0;
						write_fifo_enable=1'b0;
						read_fifo_enable=1'b0;
						dataReadTOFIFO=32'b0;
						loaded=1'b0;
						blockCount=4'b0;
					end
				IDLE:	
					begin
						serial_ready=1'b1;
						complete=1'b0;
						ack_out=1'b0;
						reset_wrapper=1'b0;
						load_send=1'b0;
						enable_pts_wrapper=1'b0;
						enable_stp_wrapper=1'b0;
						waiting_response=1'b0;
						pad_state=1'b0;
						pad_enable=1'b0;
						write_fifo_enable=1'b0;
						read_fifo_enable=1'b0;
						dataReadTOFIFO=32'b0;
						loaded=1'b0;
						blockCount=4'b0;
					end
				LOAD_WRITE:
					begin
						serial_ready=1'b0;
						complete=1'b0;
						ack_out=1'b0;
						reset_wrapper=1'b0;
						load_send=1'b0;
						enable_pts_wrapper=1'b1;
						enable_stp_wrapper=1'b0;
						waiting_response=1'b0;
						pad_state=1'b1;
						pad_enable=1'b1;
						write_fifo_enable=1'b1;
						read_fifo_enable=1'b0;
						dataReadTOFIFO=32'b0;
						loaded=1'b1;
						blockCount=blockCount;
					end
				SEND:
					begin
						serial_ready=1'b0;
						complete=1'b0;
						ack_out=1'b0;
						reset_wrapper=1'b0;
						load_send=1'b1;
						enable_pts_wrapper=1'b1;
						enable_stp_wrapper=1'b0;
						waiting_response=1'b0;
						pad_state=1'b1;
						pad_enable=1'b1;
						write_fifo_enable=1'b0;
						read_fifo_enable=1'b0;
						dataReadTOFIFO=32'b0;
						loaded=1'b0;
						if(transmission_complete)
							blockCount=blockCount+1'b1;
						else
							blockCount=blockCount;
					end
				WAIT_RESPONSE:
					begin
						serial_ready=1'b0;
						complete=1'b0;
						ack_out=1'b0;
						reset_wrapper=1'b0;
						load_send=1'b0;
						enable_pts_wrapper=1'b0;
						enable_stp_wrapper=1'b0;
						waiting_response=1'b1;
						pad_state=1'b0;
						pad_enable=1'b1;
						write_fifo_enable=1'b0;
						read_fifo_enable=1'b0;
						dataReadTOFIFO=32'b0;
						//if(dummy_count==1'b1)
						//	enable_stp_wrapper=1'b1;
						loaded=1'b0;
						blockCount=blockCount;
					end
				READ:
					begin
						serial_ready=1'b0;
						complete=1'b0;
						ack_out=1'b0;
						reset_wrapper=1'b0;
						load_send=1'b0;
						enable_pts_wrapper=1'b0;
						enable_stp_wrapper=1'b1;
						waiting_response=1'b0;
						pad_state=1'b0;
						pad_enable=1'b1;
						write_fifo_enable=1'b0;
						read_fifo_enable=1'b0;
						dataReadTOFIFO=32'b0;
						loaded=1'b0;
						if(reception_complete)
							blockCount=blockCount+1'b1;
						else
							blockCount=blockCount;
					end
				READ_FIFO_WRITE:
					begin
						serial_ready=1'b0;
						complete=1'b0;
						ack_out=1'b0;
						reset_wrapper=1'b0;
						load_send=1'b0;
						enable_pts_wrapper=1'b0;
						enable_stp_wrapper=1'b0;
						waiting_response=1'b0;
						pad_state=1'b0;
						pad_enable=1'b0;
						write_fifo_enable=1'b0;
						read_fifo_enable=1'b1;
						dataReadTOFIFO=dataRead;
						loaded=1'b0;
						blockCount=blockCount;
					end
				READ_WRAPPER_RESET:
					begin
						serial_ready=1'b0;
						complete=1'b0;
						ack_out=1'b0;
						reset_wrapper=1'b1;
						load_send=1'b0;
						enable_pts_wrapper=1'b0;
						enable_stp_wrapper=1'b0;
						waiting_response=1'b0;
						pad_state=1'b0;
						pad_enable=1'b0;
						write_fifo_enable=1'b0;
						read_fifo_enable=1'b0;
						dataReadTOFIFO=32'b0;
						loaded=1'b0;
						blockCount=blockCount;
					end
				WAIT_ACK:
					begin
						blockCount=4'b0;
						serial_ready=1'b0;
						complete=1'b1;
						ack_out=1'b0;
						reset_wrapper=1'b0;
						load_send=1'b0;
						enable_pts_wrapper=1'b0;
						enable_stp_wrapper=1'b0;
						waiting_response=1'b0;
						pad_state=1'b0;
						pad_enable=1'b0;
						write_fifo_enable=1'b0;
						read_fifo_enable=1'b0;
						dataReadTOFIFO=32'b0;
						if(ack_in)
							begin
							ack_out=1'b1;
							end
						else
							begin
							ack_out=1'b0;
							end
						loaded=1'b0;
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
				dummy_count<=dummy_count+1'b1;
				if(dummy_count==1'b1)
				dummy_count<=dummy_count;
				if(DATA_TIMEOUT==1'b0)
				timeout_count<=timeout_count+7'b1;
				if(DATA_TIMEOUT==1'b1)
				timeout_count<=timeout_count;
			end	
		else
			begin
			if(state==READ)
				begin
					dummy_count<=dummy_count+1'b1;
					if(dummy_count==1'b1)
						dummy_count<=dummy_count;
					if(DATA_TIMEOUT==1'b0)
					timeout_count<=timeout_count+7'b1;
					if(DATA_TIMEOUT==1'b1)
					timeout_count<=timeout_count;
				end
			else
				begin
				timeout_count<=7'b0;
				dummy_count<=1'b0;
				end
			end
		
		end
	

endmodule 

