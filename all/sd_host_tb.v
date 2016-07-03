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
`include "../code/dat_phys_controller.v"
`include "../code/dat_phys.v"
`include "../code/dat_controller.v"
`include "../code/fifo2.v"
`include "../code/definitions_registers.v"
`include "../code/registers.v"
`include "../code/wishbone_slave5.v"
`include "../code/fifo_wrapper.v"
`include "definitionsWBSlave3.v"
`include "../code/wishbone_master2.v"
`include "../all/sd_host.v"

module TestBench;

//Inputs 
// Common Inputs
wire wb_clock;
wire reset;

//Inputs from Wishbone Master
wire 		we_i; //write_enable 
wire [4:0]	adr_i; 
wire 		strobe; // Strobe
wire [127:0] wb_data_i;

//Outputs to Wishbone Master
wire [127:0]	wb_data_o;
wire 			ack_o;
wire			error_o;

wire PIN_DAT;
wire PIN_CMD;


// Instantiate wishbone_master
wishbone_master WBM(
	.ack_i(ack_o),
	.wb_data_i(wb_data_o),
	.error_i(error_o),
	.wb_clock(wb_clock),
	.reset(reset),
	.we_o(we_i),
	.adr_o(adr_i),
	.strobe_o(strobe),
	.wb_data_o(wb_data_i)
);

sd_host SDH (
	.clock(wb_clock),
	.sd_clock(wb_clock),
	.wb_clock(wb_clock),
	.reset(reset),
	.we_i(we_i),
	.adr_i(adr_i),
	.strobe(strobe),
	.wb_data_i(wb_data_i),
	.wb_data_o(wb_data_o),
	.ack_o(ack_o),
	.error_o(error_o),
	.PIN_DAT(PIN_DAT),
	.PIN_CMD(PIN_CMD)

);


wire [39:0]command_sd;
assign command_sd={2'b0,6'd7,32'd789};
wire [7:0] data_response;
assign data_response={3'b111,1'b0,3'b010,1'b1};

paralleltoserialWrapper # (9,8) sd(
.Clock(wb_clock),
.Reset(reset),
.Enable(Enable_card),
.framesize(8'd9),
.load_send(load_send_card),
.complete(complete_card),
.serial(PIN_DAT),
.parallel({data_response,1'b1}));
reg Enable_card;
reg load_send_card;
reg reset_card;
initial begin

$dumpfile("../all/signalsSDHost.vcd");
$dumpvars;	
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
		#100
		//$monitor($time);
		#500

		#4500
		
		Enable_card=1'b1;
		load_send_card=1'b0;
		#5000
		
		load_send_card=1'b1;
		$display("hola");
		#360
		load_send_card=1'b0;
		Enable_card=1'b0;
		#2000
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
		
		#5000
		
$display("test finished");
$finish;
end

endmodule
