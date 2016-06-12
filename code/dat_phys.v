module dat_phys(
	input wire sd_clock,
	input wire reset,
	// Inputs from host
	input wire strobe_in,   // request received
	input wire ack_in,		//response received
	input wire TIMEOUT_ENABLE,// FROM REG
	input wire [3:0] blocks, // amount of blocks 
	input wire writeread
	
	// output to host
	output wire serial_ready,// acknowledge of package reception from host
	output wire complete, // states that a response has been received
	output wire ack_out,
	//PAD_Pin
	
	inout  wire cmd_pin,
	//OUTPUT TO HOST AND REGISTERS;
	output wire DATA_TIMEOUT
	//OUTPUT TO FIFO
	output wire read_enable
	output wire [31:0] dataToFIFO,
	output wire write_enable,
	//INPUTFROM FIFO
	input wire status,
	input wire [31:0] dataFROMFIFO
);

paralleltoserialWrapper # (48,8) ptsw_dat(
.Clock(sd_clock),
.Reset(reset_wrapper),
.Enable(enable_pts_wrapper),
.framesize(8'd48),
.load_send(load_send),
.complete(transmission_complete),
.serial(serialpad),.
parallel(frame));

serialToParallelWrapper # (136,8) stpw_dat(
.Clock(sd_clock),
.Reset(reset_wrapper),
.framesize(framesize_reception),
.Enable(enable_stp_wrapper),
.serial(padserial),
.complete(reception_complete),.
parallel(pad_response));
///pad
PAD dat_PAD(
.clock(sd_clock),
.output_input(pad_state),
.data_in(serialpad),
.enable(pad_enable),
.data_out(padserial),
.io_port(cmd_pin)
);

endmodule
