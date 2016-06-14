`include "definitionsCMDcontroller.v"
`include "generator_cmdcontroller.v"
`include "../code/ffd.v"
`include "../code/pad.v"
`include "../code/counter.v"
`include "../code/parallelToSerial.v"
`include "../code/serialToParallel.v"
`include "../code/serialtoparallelwrapper.v"
`include "../code/paralleltoserialwrapper.v"
`include "../code/dat_phys_controller.v"
`include "../code/dat_phys.v"
`include "../code/paralleltoserialwrapper_Sd.v"


module TestBench;
wire pad;
dat_phys dat(
.sd_clock(sd_clock),
.reset(reset),
.strobe_in(strobe_in),
.ack_in(1'b0),
.idle_in(1'b0),
.TIMEOUT_REG(16'd100),
.blocks(4'd4),
.writeRead(1'b0),
.multiple(1'b1),
.dat_pin(pad),
.dataFROMFIFO(32'b0)
);

generatorCMDcontroller gencmd(
.clock(sd_clock),
.reset(reset),
.strobe_in(strobe_in)
);
reg Enable_card;
reg load_send_card;

paralleltoserialWrappersd # (50,8) sd(
.Clock(sd_clock),
.Reset(reset),
.Enable(Enable_card),
.framesize(8'd51),
.load_send(load_send_card),
.complete(complete_card),
.serial(pad),.
parallel(to_send));



wire [49:0] to_send;
assign to_send=50'd7924;
	initial begin
		Enable_card=1'b0;
		load_send_card=1'b0;
		$dumpfile("dat_phys_2.vcd");
		$dumpvars;	
		#4500
		Enable_card=1'b1;
		load_send_card=1'b0;
		#5000
		load_send_card=1'b1;
		#19000
		$display("test finished");
		$finish;
	end

endmodule
