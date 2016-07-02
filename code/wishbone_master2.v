module wishbone_master (

input wire ack_i,
input wire [127:0] wb_data_i,
input wire error_i,

output wire wb_clock,
output wire reset,
output wire [127:0]	host_data_i,
output wire cmd_done_i,
output wire data_done_i,
output wire fifo_read_wait,
output wire fifo_write_wait,
//inputs from master
output wire we_o, //write_enable 
output wire [4:0] adr_o, // Command exec adr_o = 16, data exec adr_o = 19, regs adr_o =  0-15, fifo read  adr_o 18, fifo write adr_o 17 
output wire strobe_o, // Strobe
output wire [127:0] wb_data_o

);

clock_gen clk1(wb_clock);
reset_gen r1(reset);
host_data_in_gen hDatag(host_data_i);
cmd_done_in_gen cmddgen(cmd_done_i);
data_done_in_gen datadgen(data_done_i);
we_in_gen weg(we_o);
adr_out_gen  adrg(wb_clock, ack_i, adr_o);
strobe_in_gen strg(strobe_o);
wb_data_in_gen wbDatag(wb_data_o);
fifo_wwait_gen fwwg(fifo_write_wait);
fifo_rwait_gen frwg(fifo_read_wait);

endmodule

module clock_gen(output clock);
reg clock;
initial
	begin
		clock=1'b0;
	end
always
	begin
	#`CLOCK_HALF_PERIOD;
	clock=1'b0;
	#`CLOCK_HALF_PERIOD;
	clock=1'b1;
	end
endmodule

module reset_gen(output reset);
reg reset;
initial
	begin
		reset=1'b0;
		#`RESET_FIRE_TIME
		reset=1'b1;
		#`RESET_DEACTIVATE_TIME
		reset=1'b0;
	end
endmodule

module host_data_in_gen (output [127:0] host_data);
reg [127:0] host_data;
initial
	begin
		host_data = 128'b0;
	end
always 
	begin
		#`NEW_HOST_DATA
		host_data = host_data +128'h57cb2389045720de938457a02f9834;
	end
endmodule

module cmd_done_in_gen (output done);
reg done;
initial
	begin
		done = 1'b0;
	end
always 
	begin
		#`CMD_DONE_UP
		done = 1'b1;
		#`CMD_DONE_DOWN
		done = 1'b0;
	end
endmodule

module data_done_in_gen (output done);
reg done;
initial
	begin
		done = 1'b0;
	end
always 
	begin
		#`DATA_DONE_UP
		done = 1'b1;
		#`DATA_DONE_DOWN
		done = 1'b0;
	end
endmodule

module we_in_gen (output we_in);
reg we_in;
initial 
	begin
		we_in = 1'b1; // Initial -> read from SD
	end
always
	begin
		#`WRITE_TO_SD
		we_in = 1'b0;
		#`READ_FROM_SD
		we_in = 1'b1;//
	end
endmodule

module adr_out_gen (input wb_clock, input error_i, output [4:0] adr_o);
reg [4:0] adr_o;
initial
	begin
		adr_o=5'b0; 
		#120;
	end
always 
	begin
		#`ADR_IN
		//~ if(!error_i) begin
			adr_o = adr_o + 1'b1;
		//~ end
		//~ else begin
			//~ adr_o = adr_o;
		//~ end
		//~ if(ack_i == 1'b0)
			//~ adr_o = adr_o;
		//~ else 
			//~ adr_o = adr_o +5'b1;
			//~ if(adr_o == 5'd16 || adr_o == 5'd19) begin
				//~ if(ack_i == 1'b0)
					//~ adr_o = adr_o;
				//~ #`ADR_IN
				//~ if(ack_i == 1'b1) begin					
					//~ adr_o = adr_o + 5'b1;
		//~ end
			//~ end
			//~ else begin
		
				//PRUEBA FIFO!
				//~ #`ADR_IN
				//~ //adr_o = adr_o + 5'b1;
				//~ adr_o = 5'd17;
				//~ #`ADR_IN
			    //~ #`ADR_IN
				//~ #`ADR_IN
			    //~ #`ADR_IN
				//~ #`ADR_IN
			    //~ #`ADR_IN
				//~ #`ADR_IN
			    //~ //#`ADR_IN
				//~ adr_o = 5'd18;
				//~ #`ADR_IN
			    //~ #`ADR_IN
				//~ #`ADR_IN
			    //~ #`ADR_IN
				//~ #`ADR_IN
			    //~ #`ADR_IN
				//~ //#`ADR_IN
			    //~ #`ADR_IN;
		//~ end
		if(adr_o == 5'd20)
			adr_o = 5'd0;
	end
endmodule

module strobe_in_gen (output strobe_in);
reg strobe_in;
initial
	begin
		strobe_in = 1'b0;
	end
always
	begin
		#`STROBE_DOWN_TIME;
		strobe_in=1'b1;
		#`STROBE_UP_TIME;
		strobe_in=1'b1;//
	end
endmodule

module wb_data_in_gen (output [127:0] wb_data);
reg [127:0] wb_data;
initial
	begin
		wb_data = 128'd4;
	end
always 
	begin
		#`NEW_WB_DATA
		wb_data = wb_data +128'h8736495e6743ae4588d52a683952;
	end
endmodule

module fifo_wwait_gen (output fifo_write_wait);
reg fifo_write_wait;
initial
	begin
		fifo_write_wait = 1'b0;
	end
always 
	begin
		#`NO_WWAIT
		fifo_write_wait = 1'b0;
		#`WWAIT
		fifo_write_wait = 1'b0;
	end
endmodule

module fifo_rwait_gen (output fifo_read_wait);
reg fifo_read_wait;
initial
	begin
		fifo_read_wait = 1'b0;
	end
always 
	begin
		#`NO_RWAIT
		fifo_read_wait = 1'b0;
		#`RWAIT
		fifo_read_wait = 1'b0;
	end
endmodule
