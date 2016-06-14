`include "definitionsCMDcontroller.v"
`include "generator_cmdcontroller.v"
`include "../code/ffd.v"
`include "../code/pad.v"
`include "../code/counter.v"
`include "../code/parallelToSerial.v"
`include "../code/serialToParallel.v"
`include "../code/serialtoparallelwrapper.v"
`include "../code/paralleltoserialwrapper.v"
`include "../code/cmd_phys_controller.v"
`include "../code/cmd_phys.v"
`include "../code/cmd_controller.v"

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
.idle_in(1'b0),
.cmd_to_send(command),
.cmd_pin(pin),
.ack_out(ack_phys_to_controller),
.strobe_out(strobe_phys_controller),
.response(response_phys_control)
);

cmd_controller host_cmd(
.clock(sd_clock),
.reset(reset),
.new_command(go_command),
.cmd_argument(32'b0),
.cmd_index(6'd7),
.TIMEOUT_ENABLE(1'b0),
.ack_in(ack_phys_to_controller),
.strobe_in(strobe_phys_controller),
.cmd_in(response_phys_control),
.TIMEOUT(1'b0),
.strobe_out(strobe_controller_phys),
.ack_out(ack_controller_phys),
.cmd_out(command)
);

generatorCMDcontroller gencmd(
.clock(sd_clock),
.reset(reset),
.newCMD(go_command));

reg Enable_card;
reg load_send_card;
wire [39:0]command_sd;
assign command_sd={2'b0,6'd7,32'd789};

paralleltoserialWrapper # (49,8) sd(
.Clock(sd_clock),
.Reset(reset),
.Enable(Enable_card),
.framesize(8'd49),
.load_send(load_send_card),
.complete(complete_card),
.serial(pin),.
parallel({command_sd,9'b1}));


	
	initial begin
		Enable_card=1'b0;
		load_send_card=1'b0;
		$dumpfile("cmd_all.vcd");
		$dumpvars;	
		#4500
		Enable_card=1'b1;
		load_send_card=1'b0;
		#5000
		load_send_card=1'b1;
		#2000

		#10000
		
		$display("test finished");
		$finish;
	end

endmodule