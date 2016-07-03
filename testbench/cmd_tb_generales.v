`include "definitionsCMDcontroller.v"
`include "generator_cmdcontroller.v"
`include "generator_sd.v"
`include "../code/ffd.v"
`include "../code/pad.v"
`include "../code/counter.v"
`include "../code/parallelToSerial.v"
`include "../code/serialToParallel.v"
`include "../code/serialtoparallelwrapperCMD.v"
`include "../code/paralleltoserialwrapper.v"
`include "../code/cmd_phys_controller.v"
`include "../code/cmd_phys.v"
`include "../code/cmd_controller.v"
`include "../code/paralleltoserialwrapper_Sd.v"
module TestBench;

wire [39:0]command;
wire pin;
wire clock;
wire reset;
wire ack_in;
wire strobe_in;
wire strobe_phys_controller;
wire ack_phys_to_controller;
wire strobe_controller_phys;
wire ack_controller_phys;
wire [135:0] response_phys_control;
cmd_phys physical(
.sd_clock(sd_clock),
.reset(reset),
.strobe_in( strobe_controller_phys),
.ack_in(ack_controller_phys),
.idle_in(idle_out),
.cmd_to_send(command),
.cmd_pin(pin),
.ack_out(ack_phys_to_controller),
.strobe_out(strobe_phys_controller),
.response(response_phys_control),
.serialReady(serialr),
.COMMAND_TIMEOUT(timeout)
);

cmd_controller host_cmd(
.idle_out(idle_out),
.clock(clock),
.reset(reset),
.new_command(go_command),
.cmd_argument(32'hFA74CD23),
.cmd_index(6'd12),
.TIMEOUT_ENABLE(1'b1),
.ack_in(ack_phys_to_controller),
.strobe_in(strobe_phys_controller),
.cmd_in(response_phys_control),
.TIMEOUT(timeout),
.serial_ready(serialr),
.strobe_out(strobe_controller_phys),
.ack_out(ack_controller_phys),
.cmd_out(command)
);

generatorCMDcontroller gencmd(
.clock(clock),
.reset(reset),
.newCMD(go_command));

generatorSD gsd(
.clock(sd_clock));
reg Enable_card;
reg load_send_card;
wire [46:0]command_sd;
wire [31:0]response=32'h3BA692AF;
wire [5:0]response_index=6'd11;
assign command_sd={2'b0,response_index,response,7'b0};
assign response_frame={command_sd,1'b1};

paralleltoserialWrapper # (49,8) sd(
.Clock(sd_clock),
.Reset(reset),
.Enable(Enable_card),
.framesize(8'd49),
.load_send(load_send_card),
.complete(complete_card),
.serial(pin),.
parallel({1'b0,command_sd,2'b11}));


	
	initial begin
		Enable_card=1'b0;
		load_send_card=1'b0;
		$dumpfile("cmd_all_int.vcd");
		$dumpvars;	
		#4500
		#10000
		
		$display("test finished");
		$finish;
	end

endmodule
