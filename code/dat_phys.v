`include "paralleltoserialwrapper.v"
`include "counter.v"
`include "ffd.v"
`include "pad.v"
`include "serialtoparallelwrapper.v"
`include "serialToParallel.v"
`include "parallelToSerial.v"
`include "dat_phys_controller.v"
module dat_phys(
	input wire sd_clock,
	input wire reset,
	// Inputs from host
	input wire strobe_in,   // request received
	input wire ack_in,	
	input wire idle_in,	//response received
	input wire [63:0]TIMEOUT_REG,
	input wire [3:0] blocks, // amount of blocks 
	input wire writeRead,
	input wire multiple,
	// output to host
	output wire serial_ready,
	output wire complete, 
	output wire ack_out,
	//PAD_Pin
	
	inout  wire cmd_pin,
	//OUTPUT TO HOST AND REGISTERS;
	output wire DATA_TIMEOUT,
	//OUTPUT TO FIFO
	output wire read_enable,
	output wire [31:0] dataToFIFO,
	output wire write_enable,
	//INPUTFROM FIFO
	input wire status,
	input wire [31:0] dataFROMFIFO
);
wire [49:0]frame_to_send;
assign frame_to_send={1'b0,dataFROMFIFO,17'b1};
wire [49:0]frame_received;
wire waiting_response;
wire [7:0]framesize_reception=(waiting_response==1'b1)?8'd3:8'd50;

paralleltoserialWrapper # (50,8) ptsw_dat(
.Clock(sd_clock),
.Reset(reset_wrapper),
.Enable(enable_pts_wrapper),
.framesize(8'd50),
.load_send(load_send),
.complete(transmission_complete),
.serial(serialpad),.
parallel(frame_to_send));

serialToParallelWrapper # (50,8) stpw_dat(
.Clock(sd_clock),
.Reset(reset_wrapper),
.framesize(framesize_reception),
.Enable(enable_stp_wrapper),
.serial(padserial),
.complete(reception_complete),.
parallel(frame_received));
///pad
PAD dat_PAD(
.clock(sd_clock),
.output_input(pad_state),
.data_in(serialpad),
.enable(pad_enable),
.data_out(padserial),
.io_port(cmd_pin)
);
dat_phys_controller dat1(
.sd_clock(sd_clock),
.reset(reset),
.strobe_in(strobe_in),
.ack_in(ack_in),
.TIMEOUT_REG(TIMEOUT_REG),
.blocks(blocks),
.writeRead(writeRead),
.multiple(multiple),
.idle_in(idle_in),
.serial_ready(serial_ready),
.complete(complete),
.ack_out(ack_out),
.transmission_complete(transmission_complete),
.reception_complete(reception_complete),
.dataRead(frame_received[48:17]),
.reset_wrapper(reset_wrapper),
.load_send(load_send),
.enable_pts_wrapper(enable_pts_wrapper),
.enable_stp_wrapper(enable_stp_wrapper),
.waiting_response(waiting_response),
.pad_state(pad_state),
.pad_enable(pad_enable),
.write_fifo_enable(write_enable),
.read_fifo_enable(read_enable),
.dataReadTOFIFO(dataToFIFO)
);
	
	endmodule
