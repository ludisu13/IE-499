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
`include "../code/paralleltoserialwrapper_Sd.v"

module TestBench;

wire [39:0]command;
assign command={2'b0,6'd7,32'b0};
wire pin;
wire clock;
wire reset;
wire ack_in;
wire strobe_in;

cmd_phys physical(
.sd_clock(sd_clock),
.reset(reset),
.strobe_in(strobe_in),
.ack_in(ack_in),
.idle_in(1'b0),
.cmd_to_send(command),
.cmd_pin(pin)
);


generatorCMDcontroller gencmd(
.clock(sd_clock),
.reset(reset),
.strobe_in(strobe_in),
.ack_in(ack_in));

reg Enable_card;
reg load_send_card;

paralleltoserialWrapper # (49,8) sd(
.Clock(sd_clock),
.Reset(reset),
.Enable(Enable_card),
.framesize(8'd49),
.load_send(load_send_card),
.complete(complete_card),
.serial(pin),.
parallel({command,9'b10}));


	
	initial begin
		Enable_card=1'b0;
		load_send_card=1'b0;
		$dumpfile("cmd_phys.vcd");
		$dumpvars;	
		#4500
		Enable_card=1'b1;
		load_send_card=1'b0;
		#5000
		load_send_card=1'b1;
		#2000

		#10000
		Enable_card
		$display("test finished");
		$finish;
	end

endmodule
