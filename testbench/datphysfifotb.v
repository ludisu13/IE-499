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
`include "../code/fifo2.v"


module TestBench;
wire pad;
wire [31:0] dataFIFO;
dat_phys dat(
.sd_clock(sd_clock),
.reset(reset),
.strobe_in(strobe_in),
.ack_in(1'b0),
.idle_in(1'b0),
.TIMEOUT_REG(16'd100),
.blocks(4'd2),
.writeRead(1'b0),
.read_enable(write_enable),
.multiple(1'b1),
//.dat_pin(pad),
.dat_pin(dat_to_card),
.dataFROMFIFO(32'b0),
.dataToFIFO(dataFIFO)
);
wire dat_to_card;
generatorCMDcontroller gencmd(
.clock(sd_clock),
.reset(reset),
.strobe_in(strobe_in)
);

	fifo #(32,8,3) fifo1  (
		.write_clock(sd_clock),	//input
		.read_clock(sd_clock), 	//input
		.reset(reset), 				//input
		.data(dataFIFO), 				//input 32
		.write_enable(write_enable),//input
		.read_enable(read_enable), 	//input
	//	.q(q),  					//output 32
		.fifo_full(fifo_full),  	//output
		.fifo_empty(fifo_empty) 	//output
	);
reg Enable_card;
reg load_send_card;

wire [49:0] to_send;
wire [48:0] to_send_kk;
assign to_send_kk=48'd79233334;
assign to_send={1'b1,to_send_kk};

paralleltoserialWrappersd # (51,8) sd(
.Clock(sd_clock),
.Reset(reset_card),
.Enable(Enable_card),
.framesize(8'd51),
.load_send(load_send_card),
.complete(complete_card),
.serial(dat_to_card),.
parallel({to_send,1'b1}));

reg reset_card;
reg read_enable;
	initial begin
	$dumpfile("dat_phys_fifo.vcd");
		$dumpvars;	
		read_enable=1'b0;
		Enable_card=1'b0;
		reset_card=1'b0;
		load_send_card=1'b0;
		#50;
		reset_card=1'b1;
		#100
		#200;
		reset_card=1'b0;
		#200
		Enable_card=1'b0;
		load_send_card=1'b0;
		
		//$monitor($time);
		#4500
		Enable_card=1'b1;
		load_send_card=1'b0;
		#5000
		load_send_card=1'b1;
		$display("hola");
		#19000
		load_send_card=1'b0;
		#400
		reset_card=1'b0;
		#50;
		reset_card=1'b1;
		#1000
		#200;
		reset_card=1'b0;
		#200
		read_enable=1'b1;
		#40
		read_enable=1'b0;
		#2000
		load_send_card=1'b1;
		#10000
		$display("test finished");
		$finish;
	end

endmodule
