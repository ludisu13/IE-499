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
`include "../code/dat_controller.v"
`include "generator_sd.v"
//`include "../code/paralleltoserialwrapper_Sd.v"


module TestBench;
wire pad;
wire [15:0] timeout_value;

wire [3:0] blocks_host_phys;

dat_controller datc(
.clock(clock),
.reset(reset),
.writeRead(1'b0),
.newDat(new_Dat),
.blockCount(4'd2),
.multipleData(1'b0),
.serial_ready(sr_phys_host),
.complete(complete_phys_host),
.ack_in(ack_phys_host),
.fifo_okay(1'b1),
.transfer_complete(kk),
.strobe_out(strobe_host_phys),
.ack_out(ack_host_phys),
.blocks(blocks_host_phys),
.multiple(multiple_host_phys),
.writereadphys(wr_host_phys),
.idle_out(idle_out),
.TIMEOUT_REG(16'd78),
.timeout_enable(1'b1),
.timeout(dataTimeout),
.TIMEOUT_VALUE(timeout_value)

);


dat_phys dat(
.DATA_TIMEOUT(dataTimeout),
.sd_clock(sd_clock),
.reset(reset),
.strobe_in(strobe_host_phys),
.ack_in(ack_host_phys),
.idle_in(idle_out),
.TIMEOUT_REG(timeout_value),
.blocks(blocks_host_phys),
.writeRead(wr_host_phys),
.multiple(multiple_host_phys),
.dat_pin(dat_pin),
.dataFROMFIFO(32'hAB45FEDC),
.serial_ready(sr_phys_host),
.complete(complete_phys_host),
.ack_out(ack_phys_host)
);

generatorCMDcontroller gencmd(
.clock(clock),
.reset(reset));

generatorSD gsd(
.clock(sd_clock));
reg Enable_card;
reg load_send_card;

wire [49:0] data_to_card;
wire [31:0] data_block;
assign data_block=32'hFABCDE40;
assign data_to_card={1'b0,data_block,16'hFFFF,1'b1};
paralleltoserialWrapper # (51,8) sd(
.Clock(sd_clock),
.Reset(reset_card),
.Enable(Enable_card),
.framesize(8'd51),
.load_send(1'b0),
.complete(complete_card),
.serial(dat_pin),.
parallel({1'b0,data_to_card}));

reg new_Dat;
reg reset_card;

	initial begin
	$dumpfile("dat_all_read_int.vcd");
		$dumpvars;	
		Enable_card=1'b1;
		reset_card=1'b0;
		new_Dat=1'b1;
		#500
		new_Dat=1'b0;
		#5000
		$display("test finished");
		$finish;
	end

endmodule
