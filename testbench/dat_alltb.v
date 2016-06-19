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
//`include "../code/paralleltoserialwrapper_Sd.v"


module TestBench;
wire pad;


wire [3:0] blocks_host_phys;

dat_controller datc(
.clock(sd_clock),
.reset(reset),
.writeRead(1'b1),
.newDat(new_Dat),
.blockCount(4'd2),
.multipleData(1'b1),
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
.dat_pin(dat_to_card),
.dataFROMFIFO(32'd3792842),
.serial_ready(sr_phys_host),
.complete(complete_phys_host),
.ack_out(ack_phys_host)
);










wire dat_to_card;
generatorCMDcontroller gencmd(
.clock(sd_clock),
.reset(reset)
);
reg Enable_card;
reg load_send_card;

wire [49:0] to_send;
wire [48:0] to_send_kk;
assign to_send_kk=48'd7924;
assign to_send={1'b1,to_send_kk};

paralleltoserialWrapper # (4,8) sd(
.Clock(sd_clock),
.Reset(reset_card),
.Enable(Enable_card),
.framesize(8'd4),
.load_send(load_send_card),
.complete(complete_card),
.serial(dat_to_card),.
parallel({4'b1010}));
reg new_Dat;
reg reset_card;

	initial begin
	$dumpfile("dat_all_send.vcd");
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
		#300
		load_send_card=1'b0;
		#19000
		load_send_card=1'b0;
		#400
		reset_card=1'b0;
		#50;
		reset_card=1'b1;
		#1000
		#6000
		load_send_card=1'b0;
		#300;
		load_send_card=1'b0;
		
		reset_card=1'b0;
		#200
		#2000
		load_send_card=1'b1;
		#160
		load_send_card=1'b0;
		#10000
		$display("test finished");
		$finish;
	end

endmodule
