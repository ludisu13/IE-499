`include "paralleltoserialwrapper.v"
`include "counter.v"
`include "ffd.v"
`include "pad.v"
`include "serialtoparallelwrapper.v"
`include "serialToParallel.v"
`include "parallelToSerial.v"
`include "cmd_phys_controller.v"
module cmd_phys(
	input wire sd_clock,
	input wire reset,
	// Inputs from host
	input wire strobe_in,   // request received
	input wire ack_in,		//response received
	input wire idle_in, // sets as idle
	input wire [39:0] cmd_to_send,
	// output to host
	output wire ack_out,// acknowledge of package reception from host
	output wire strobe_out, // states that a response has been received
	output wire [39:0] response,
	
	//PAD_Pin
	
	inout  wire cmd_pin
	
);


wire transmission_complete;
wire reception_complete;
wire load_send;
wire reset_wrapper;
wire pad_state;
wire pad_enable;
wire enable_pts_wrapper;
wire enable_stp_wrapper;
wire [47:0] pad_response;
wire serialpad;
wire padserial;
wire [47:0]frame;
//wrappers
paralleltoserialWrapper # (48,8) ptsw(
.Clock(sd_clock),
.Reset(reset_wrapper),
.Enable(enable_pts_wrapper),
.framesize(8'd48),
.load_send(load_send),
.complete(transmission_complete),
.serial(serialpad),.
parallel(frame));

serialToParallelWrapper # (48,8) stpw(
.Clock(sd_clock),
.Reset(reset_wrapper),
.framesize(8'd48),
.Enable(enable_stp_wrapper),
.serial(padserial),
.complete(reception_complete),.
parallel(pad_response));
///pad
PAD command_PAD(
.clock(sd_clock),
.output_input(pad_state),
.data_in(serialpad),
.enable(pad_enable),
.data_out(padserial),
.io_port(cmd_pin)
);
//physical layer controller
cmd_phys_controller cpc(
.sd_clock(sd_clock),
.reset(reset),
.strobe_in(strobe_in),
.ack_in(ack_in),
.idle_in(idle_in),
.cmd_to_send(cmd_to_send),
.ack_out(ack_out),
.strobe_out(strobe_out),
.response(response),
.pad_response(pad_response),
.transmission_complete(transmission_complete),
.reception_complete(reception_complete),
.frame(frame),
.reset_wrapper(reset_wrapper),
.pad_state(pad_state),
.pad_enable(pad_enable),
.enable_pts_wrapper(enable_pts_wrapper),
.enable_stp_wrapper(enable_stp_wrapper)
);


endmodule
