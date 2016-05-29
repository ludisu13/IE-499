#MAKEFILE
All:
	iverilog -o testbench testbench.v
	vvp testbench

signals: 
	iverilog -o testbench testbench.v
	vvp testbench
	gtkwave signals.gtkw

fifo:
	iverilog -o testbench_fifo fifo_tb.v
	vvp testbench_fifo
	gtkwave signalsFifo.vcd
		
fifo2:
	iverilog -o testbench_fifo2 fifo_tb2.v
	vvp testbench_fifo2
	gtkwave signalsFifo2.vcd

datc:
	iverilog -o testbench_datcontroller dat_controller_tb.v
	vvp testbench_datcontroller
	gtkwave signalsDatController.vcd 
cmdc:
	iverilog -o testbench_cmdcontroller cmd_controller_tb.v
	vvp testbench_cmdcontroller
	gtkwave signalsCMDController.vcd 
	
wbslave:
	iverilog -o testbench_wishbone_slave wishbone_slave_tb.v
	vvp testbench_wishbone_slave
	gtkwave signalsWishboneSlave.vcd 
pts: 
	iverilog -o testbench_parallelToSerial parallelToSerial_Tb.v
	vvp testbench_parallelToSerial
	gtkwave signalsparalleltoserial.vcd
