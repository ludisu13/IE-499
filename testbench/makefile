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
