#MAKEFILE
All:
	iverilog -o testbench testbench.v
	vvp testbench

signals: 
	iverilog -o testbench testbench.v
	vvp testbench
	gtkwave signals.gtkw

fifo:
	iverilog -o testbench fifo_tb.v
	vvp testbench
	gtkwave signals.vcd
datc:
	iverilog -o testbench_datcontroller dat_controller_tb.v
	vvp testbench_datcontroller
	gtkwave signalsDatController.vcd 
