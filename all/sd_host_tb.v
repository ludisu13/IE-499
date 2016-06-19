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

reg Enable_card;
reg load_send_card;
wire [39:0]command_sd;
assign command_sd={2'b0,6'd7,32'd789};

paralleltoserialWrapper # (49,8) sd(
.Clock(wb_clock),
.Reset(reset),
.Enable(Enable_card),
.framesize(8'd49),
.load_send(load_send_card),
.complete(complete_card),
.serial(PIN_CMD),
.parallel({command_sd,9'b1}));

initial begin

$dumpfile("../all/signalsSDHost.vcd");
$dumpvars;	
		Enable_card=1'b0;
		load_send_card=1'b0;
		#4500
		Enable_card=1'b1;
		load_send_card=1'b0;
		#5000
		load_send_card=1'b1;
		#2000
		load_send_card=1'b0;
		Enable_card=1'b0;
		#10000
		
$display("test finished");
$finish;
end

endmodule
