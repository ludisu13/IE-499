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


module TestBench;

wire [39:0]command;
assign command[37:32]=6'd7;
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


	
	initial begin
	
		$dumpfile("cmd_phys.vcd");
		$dumpvars;	
		#7000
		$display("test finished");
		$finish;
	end

endmodule
