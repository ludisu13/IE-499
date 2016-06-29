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


wire [3:0] blocks_host_phys;
dat_controller datc(
.clock(clock),
.reset(reset),
.writeRead(1'b1),
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
.writereadphys(wr_host_phys)

);


dat_phys dat(
.sd_clock(sd_clock),
.reset(reset),
.strobe_in(strobe_host_phys),
.ack_in(ack_host_phys),
.idle_in(1'b0),
.TIMEOUT_REG(16'd100),
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

wire [7:0] data_response;
assign data_response={3'b111,1'b0,3'b010,1'b1};
paralleltoserialWrapper # (9,8) sd(
.Clock(sd_clock),
.Reset(reset_card),
.Enable(Enable_card),
.framesize(8'd9),
.load_send(load_send_card),
.complete(complete_card),
.serial(dat_pin),.
parallel({data_response,1'b1}));

reg new_Dat;
reg reset_card;

	initial begin
	$dumpfile("dat_all_send_single.vcd");
		$dumpvars;	
		Enable_card=1'b0;
		reset_card=1'b0;
		new_Dat=1'b0;
		load_send_card=1'b0;
		#50;
		reset_card=1'b1;
		#100
		#200;
		reset_card=1'b0;
		#200
		Enable_card=1'b0;
		load_send_card=1'b0;
		#100
		new_Dat=1'b1;
		//$monitor($time);
		#500
		new_Dat=1'b0;
		#4500
		
		Enable_card=1'b1;
		load_send_card=1'b0;
		#5000
		
		load_send_card=1'b1;
		$display("hola");
		#360
		load_send_card=1'b0;
		Enable_card=1'b0;
	/*	#2000
		reset_card=1'b1;
		#100
		reset_card=1'b0;
		#600
		Enable_card=1'b1;
		#500;
		load_send_card=1'b1;
		#360
		load_send_card=1'b0;
		Enable_card=1'b0;
		*/
		#5000
		$display("test finished");
		$finish;
	end

endmodule
