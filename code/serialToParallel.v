`include "ffd.v"
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
	begin
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
				
			
	

	




