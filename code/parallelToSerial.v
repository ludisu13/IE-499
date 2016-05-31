`include "ffd.v"
module Paralleltoserial # (parameter WIDTH=8)
(
	input wire Clock,
	input wire Reset,
	input wire Enable,
	input wire load_send,// send high load low activate on rising edge
	output wire serial,
	input wire[(WIDTH-1):0] parallel
	);
wire [(WIDTH-1):0]ffdinputBus;
wire [(WIDTH-1):0]ffdqBus;
assign serial=ffdqBus[(WIDTH-1)];
FFD_POSEDGE_SYNCRONOUS_RESET # (WIDTH) ffd (.Clock(Clock),.Reset(Reset),.Enable(Enable),.D(ffdinputBus),.Q(ffdqBus));
genvar i;
generate

	for (i=0; i < WIDTH; i=i+1) 
		begin:PTS
			if(i==0)
				begin
					assign ffdinputBus[i]=(parallel[i] && !load_send)||(load_send && 1'b1);
				end
			else
				begin
					assign ffdinputBus[i]=(parallel[i] && !load_send)||( load_send && ffdqBus[i-1]);
				end		
		end
endgenerate
endmodule
				
				
