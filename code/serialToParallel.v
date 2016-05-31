//`include "ffd.v"
//`include "counter.v"
module serialToParallel # (parameter WIDTH=8)
(
	input wire Clock,
	input wire Reset,
	input wire Enable,
	input wire serial,
	output wire[(WIDTH-1):0] parallel
	);
wire [(WIDTH-1):0] serialBus;
FFD_POSEDGE_SYNCRONOUS_RESET # (WIDTH) ffd (.Clock(Clock),.Reset(Reset),.Enable(Enable),.D(serialBus),.Q(parallel));
genvar i; 
for (i=0; i < WIDTH; i=i+1) 
	begin:STP
		if(i==0)
			begin
				assign serialBus[i]=serial;
			end
		else
			begin
				assign serialBus[i]=parallel[i-1];
			end
			
				
				
			end
endmodule
				
			
	
//add wrapper that counts based on frame size
//wrapper block should have an input based on expected frame sizes to count cycles required for a valid input or output
// data frame size based on 




	




