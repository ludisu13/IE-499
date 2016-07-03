`include "definitionsTestRegisters.v"
`include "../code/registers.v"
`include "generatorRegisters.v"
module TestBench;

	//Inputs
	wire			clock;
	wire 			reset;
	wire [4:0] 		adr_i;
	wire			reg_write_en;
	wire 			reg_read_en;
	wire 			command_complete;
	wire [127:0]	data_i;
	wire [127:0]	response_i;
	wire [15:0]		error_interrupt_status_i;
	wire [15:0]		normal_interrupt_status_i;
	
	
	// Outputs
	
	wire [11:0] 	block_size;
	wire [15:0] 	block_count;
	wire [31:0] 	argument;
	wire [15:0] 	transfer_mode;
	wire [15:0] 	command;
	wire [15:0]		present_state;
	wire [15:0] 	timeout_control;
	wire [2:0]		software_reset;
	wire [15:0]		error_interrupt_status_o;
	wire [127:0]	data_o;
	
	// Instantiate the Unit Under Test (UUT)
	
	registers regs (		
		.clock(clock),											//Input
		.reset(reset),											//Input
		.adr_i(adr_i),											//Input
		.reg_write_en(reg_write_en),							//Input
		.reg_read_en(reg_read_en),								//Input
		.command_complete(command_complete),					//Input
		.data_i(data_i),										//Input
		.response_i(response_i),								//Input
		.error_interrupt_status_i(error_interrupt_status_i),	//Input
		.normal_interrupt_status_i(normal_interrupt_status_i),	//Input
		.block_size(block_size),								//Output
		.block_count(block_count),								//Output
		.argument(argument),									//Output
		.transfer_mode(transfer_mode),							//Output
		.command(command),										//Output
		.present_state(present_state),							//Output
		.timeout_control(timeout_control),						//Output
		.software_reset(software_reset),						//Output
		.error_interrupt_status_o(error_interrupt_status_o),	//Output
		.data_o(data_o)											//Output
	);
	
	// Instantiate generator of signals
	generatorRegisters genReg(
		.clock(clock),											//Output
		.reset(reset),											//Output
		.adr_i(adr_i),											//Output
		.reg_write_en(reg_write_en),							//Output
		.reg_read_en(reg_read_en),								//Output
		.command_complete(command_complete),					//Output
		.data_i(data_i),										//Output
		.response_i(response_i),								//Output
		.error_interrupt_status_i(error_interrupt_status_i),	//Output
		.normal_interrupt_status_i(normal_interrupt_status_i)	//Output
	);
	
	
	
	initial begin

	$dumpfile("writeRegisters.vcd");
	$dumpvars;	
	#2100
	$display("test finished");
	$finish;
	end

endmodule
