`include "definitionsDatcontroller.v"
`include "../code/dat_controller.v"
`include "generator_datcontroller.v"
module TestBench;


wire Clock;
wire Reset;
wire writeRead;
wire newDat;
wire serial_ready;
wire complete;
wire ack_in;
wire fifo_okay;
wire busy;
wire write_Data;
wire read_Data;
wire transfer_complete;
wire strobe_out;
wire ack_out;

dat_controller dat_controller_1(
.clock(Clock),
.reset(Reset),
.writeRead(writeRead),
.newDat(newDat),
.serial_ready(serial_ready),
.complete(complete),
.ack_in(ack_in),
.fifo_okay(fifo_okay),
.busy(busy),
.write_Data(write_Data),
.read_Data(read_Data),
.transfer_complete(transfer_complete),
.strobe_out(strobe_out),
.ack_out(ack_out)

);

generatorDatcontroller genDat(
.clock(Clock),
.reset(Reset),
.writeRead(writeRead),
.newDat(newDat),
.serial_ready(serial_ready),
.complete(complete),
.ack_in(ack_in),
.fifo_okay(fifo_okay)
);
	
	initial begin
	
		$dumpfile("signalsDatController.vcd");
		$dumpvars;	
		#2500
		$display("test finished");
		$finish;
	end

endmodule
