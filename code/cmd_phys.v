`include "paralleltoserialwrapper.v"
`include "counter.v"
`include "ffd.v"
`include "pad.v"
`include "serialtoparallelwrapper.v"
`include "serialToParallel.v"
`include "parallelToSerial.v"
module cmd_phys(
	input wire sd_clock,
	input wire reset,
	// Inputs from host
	input wire strobe_in,   // request received
	input wire ack_in,		//response received
	input wire idle_in, // sets as idle
	input wire [39:0] cmd_to_send,
	// output to host
	output reg ack_out,// acknowledge of package reception from host
	output reg strobe_out, // states that a response has been received
	output reg [39:0] response,
	
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
paralleltoserialWrapper # (48) ptsw(
.Clock(sd_clock),
.Reset(reset_wrapper),
.Enable(enable_pts_wrapper),
.framesize(48'd48),
.load_send(load_send),
.complete(transmission_complete),
.serial(serialpad),.
parallel(frame));

serialToParallelWrapper # (48) stpw(
.Clock(sd_clock),
.Reset(reset_wrapper),
.framesize(48'd48),
.Enable(enable_stp_wrapper),
.serial(padserial),
.complete(reception_complete),.
parallel(pad_response));

PAD command_PAD(
.clock(sd_clock),
.output_input(pad_state),
.data_in(serialpad),
.enable(pad_enable),
.data_out(padserial),
.io_port(cmd_pin)
);

cmd_phys_controller cpc(


);
//enable to pad and wrapper parallel to serial must be at the same time as load 
// enable to wrapper serial to paralel must be when send is completed at the start of waiting for response state.

//logica de proximo estado
