module generatorRegisters(

output wire			clock,
output wire 			reset,
output wire [4:0] 		adr_i,
output wire			reg_write_en,
output wire 			reg_read_en,
output wire 			command_complete,
output wire [127:0]	data_i,
output wire [127:0]	response_i,
output wire [15:0]		error_interrupt_status_i,
output wire [15:0]		normal_interrupt_status_i
);

clock_gen clk1(clock);
reset_gen r1(reset);
adr_in_gen  adrg(adr_i);
reg_write_en_gen rweg(reg_write_en);
reg_read_en_gen rreg(reg_read_en);
cmd_complete_gen ccg(command_complete);
data_in_gen datag(data_i);
response_in_gen rig(response_i);
error_int_status_gen eisg(error_interrupt_status_i);
normal_int_status_gen nisg(normal_interrupt_status_i);
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

module adr_in_gen (output [4:0] adr_in);
reg [4:0] adr_in;
initial
	begin
		#120
		adr_in=5'd15; //Initial -> Command
		#160;
	end
always
	begin
		#`ADR_IN
		adr_in = adr_in +5'b1;
		//adr_in = 5'd16;
		if(adr_in == 5'd16)
			adr_in = 5'd0;
	end
endmodule

module reg_write_en_gen (output reg_write_en);
reg reg_write_en;
initial 
	begin
		reg_write_en = 1'b0; // Initial -> no write
//	end
//always
//	begin
		#`NOWRITE
		reg_write_en= 1'b1;
		#`WRITE
		reg_write_en = 1'b0; // Write
	end
endmodule

module reg_read_en_gen (output reg_read_en);
reg reg_read_en;
initial 
	begin
		reg_read_en = 1'b0; // Initial -> no read
//	end
//always
//	begin
		#`NOREAD
		reg_read_en = 1'b1;
		#`READ
		reg_read_en = 1'b0; // Read
	end
endmodule

module cmd_complete_gen (output command_complete);
reg command_complete;
initial 
	begin
		command_complete = 1'b0; 
	end
always
	begin
		#`NOCMD
		command_complete = 1'b1;
		#`CMD
		command_complete = 1'b0; 
	end
endmodule

module data_in_gen (output [127:0] data_i);
reg [127:0] data_i;
initial
	begin
		data_i = 128'b0;
	end
always 
	begin
		#`NEW_DATA
		data_i = data_i +128'd2;
	end
endmodule

module response_in_gen (output [127:0] response_i);
reg [127:0] response_i;
initial
	begin
		response_i = 128'b0;
	end
always 
	begin
		#`NEW_RESPONSE
		response_i = response_i +128'ha3157934b95c7a64789213fd456e;
	end
endmodule

module error_int_status_gen (output [15:0] error_interrupt_status_i);
reg [15:0] error_interrupt_status_i;
initial
	begin
		error_interrupt_status_i = 1'b0;
	end
always
	begin
		#`NOERROR
		error_interrupt_status_i = error_interrupt_status_i + 15'd7;
		//#`ERROR
		//error_interrupt_status_i = 1'b0;
	end
endmodule

module normal_int_status_gen (output [15:0] normal_interrupt_status_i);
reg [15:0] normal_interrupt_status_i;
initial
	begin
		normal_interrupt_status_i = 1'b0;
	end
always
	begin
		#`NONORMAL
		normal_interrupt_status_i = normal_interrupt_status_i + 15'd9;
		//#`NORMAL
		//normal_interrupt_status_i = 1'b0;
	end
endmodule
