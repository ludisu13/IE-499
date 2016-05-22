`include "definitionsCMDcontroller.v"
`include "../code/cmd_controller.v"
`include "generator_cmdcontroller.v"
module TestBench;



	wire clock;
	wire reset;
	wire new_command;
	wire [31:0] cmd_argument;
	wire [5:0] cmd_index;	
	wire [31:0] command_timeout_REG;
	// Input from physical layer
	wire ack_in;
	wire strobe_in;
	wire [39:0] cmd_in;
	wire serial_ready;
	// Outputs to host
	wire [39:0] cmd_out;
	wire busy;
	wire setup_done;
	wire [31:0]response;
	wire command_complete;
	wire command_timeout;
    wire command_index_error;
	//Outputs to physical layer
	wire strobe_out;
	wire ack_out;
	wire idle_out;
	
	
assign cmd_argument=32'b0;
assign cmd_index=6'd24;
assign command_timeout_REG=32'd10;
assign cmd_in[37:32]=6'd24;
 	
cmd_controller cmd_controller_1(
.clock(clock),
.reset(reset),
.new_command(new_command),
.cmd_argument(cmd_argument),
.cmd_index(cmd_index),
.command_timeout_REG(command_timeout_REG),
.ack_in(ack_in),
.strobe_in(strobe_in),
.cmd_in(cmd_in),
.serial_ready(serial_ready),
.cmd_out(cmd_out),
.busy(busy),
.setup_done(setup_done),
.strobe_out(strobe_out),
.ack_out(ack_out),
.idle_out(idle_out),
.response(response),
.command_complete(command_complete),
.command_timeout(command_timeout),
.command_index_error(command_index_error)


);

generatorCMDcontroller gencmd(
.clock(clock),
.reset(reset),
.newCMD(new_command),
.serial_ready(serial_ready),
.strobe_in(strobe_in),
.ack_in(ack_in)
);
	
	initial begin
	
		$dumpfile("signalsCMDController.vcd");
		$dumpvars;	
		#2500
		$display("test finished");
		$finish;
	end

endmodule
