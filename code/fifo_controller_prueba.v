`include "fifo.v";

module fifo_controller (
	
	input wire wishbone_clock,
	input wire sd_clock,
	input wire reset,
	input wire [31:0] data_tx_in,
	input wire [31:0] data_rx_in,
	input wire [3:0] enable_in,
	output wire [31:0] q_tx_out,
	output wire [31:0] q_rx_out,
	output wire [3:0] status_out
);

	fifo tx_fifo (
		.write_clock(wishbone_clock),	//input
		.read_clock(sd_clock), 			//input
		.reset(reset), 					//input
		.data(data_tx_in), 				//input 32
		.write_enable(enable_in[0]),	//input
		.read_enable(enable_in[1]), 	//input
		.q(q_tx_out),  					//output 32
		.fifo_full(status_out[0]),  	//output
		.fifo_empty(status_out[1]) 		//output
	);
	
	fifo rx_fifo (
		.write_clock(sd_clock),			//input
		.read_clock(wishbone_clock),	//input
		.reset(reset), 					//input
		.data(data_rx_in), 				//input 32
		.write_enable(enable_in[2]),	//input
		.read_enable(enable_in[3]), 	//input
		.q(q_rx_out),  					//output 32
		.fifo_full(status_out[2]),  	//output
		.fifo_empty(status_out[3]) 		//output
	);
	
reg [SIZE-1:0] tx_state;
reg [SIZE-1:0] tx_next_state;

parameter TX_RESET		=  2'b00; 
parameter TX_IDLE   	=  2'b01;
parameter TX_READ_WRITE=  2'b10;
	
//TX FSM	
always @ ( tx_state  or enable_in[0] or enable_in[1] )
begin 
 case(tx_state)
 TX_RESET:
		begin
			tx_next_state=TX_IDLE;
		end
 TX_IDLE:   
		begin
		  if (enable_in[1] or enable_in[0]) begin
			  tx_next_state = TX_READ_WRITE;
		  end     
		  else begin
			 tx_next_state = TX_IDLE;
		  end   
		end       
 TX_READ_WRITE:	
		begin
			if (~enable_in[1] and ~enable_in[0])             
			   tx_next_state = TX_IDLE;  
			 else   
			   tx_next_state = TX_READ_WRITE;
		end  
  
 default : tx_next_state  = TX_IDLE;
 
 endcase 
    
end

always @ ( posedge wishbone_clock)
begin 
 case(tx_state)
 TX_RESET:
		begin
			q_tx_out		= 32'b0;
			status_out[0]	= 1'b0;
			status_out[1]	= 1'b1;
		end
 TX_IDLE:   
		begin
			
		end       
 TX_READ_WRITE:	
		begin
			
		end  
  
 default : 
 
 endcase 
    
end

always @ (posedge wishbone_clock or posedge reset  )
	begin : FSM_SEQ
		if (reset) 
			begin
				tx_state <=  TX_RESET;
			end 
		else 
			begin
				tx_state <=  tx_next_state;
		end
	end


//RX FSM

reg [SIZE-1:0] rx_state;
reg [SIZE-1:0] rx_next_state;

parameter RX_RESET		=  2'b00; 
parameter RX_IDLE   	=  2'b01;
parameter RX_READ_WRITE=  2'b10;
	
always @ ( rx_state  or enable_in[2] or enable_in[3] )
begin 
 case(rx_state)
 RX_RESET:
		begin
			rx_next_state=RX_IDLE;
		end
 RX_IDLE:   
		begin
		  if (enable_in[2] or enable_in[3]) begin
			  rx_next_state = RX_READ_WRITE;
		  end     
		  else begin
			 rx_next_state = RX_IDLE;
		  end   
		end       
 RX_READ_WRITE:	
		begin
			if (~enable_in[2] and ~enable_in[3])             
			   rx_next_state = RX_IDLE;  
			 else   
			   rx_next_state = RX_READ_WRITE;
		end  
  
 default : rx_next_state  = RX_IDLE;
 
 endcase 
    
end

always @ ( posedge sd_clock)
begin 
 case(rx_state)
 RX_RESET:
		begin
			q_rx_out		= 32'b0;
			status_out[2]	= 1'b0;
			status_out[3]	= 1'b1;
		end
 RX_IDLE:   
		begin
		  
		end       
 RX_READ_WRITE:	
		begin
			
		end  
  
 default : 
 
 endcase 

always @ (posedge sd_clock or posedge reset  )
	begin : FSM_SEQ
		if (reset) 
			begin
				rx_state <=  RX_RESET;
			end 
		else 
			begin
				rx_state <=  rx_next_state;
		end
	end

endmodule
