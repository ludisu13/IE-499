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
	iverilog -o testbench_wishbone_slave5 wishbone_slave5_tb.v
	vvp testbench_wishbone_slave5
	gtkwave wbslave_exec.vcd 
	
WbFifoReg:
	iverilog -o testbench_WbFifoReg WbFifoReg_tb.v
	vvp testbench_WbFifoReg
	gtkwave signalsWbFifoReg.vcd 
	
registers:
	iverilog -o testbench_registers registers_tb.v
	vvp testbench_registers
	gtkwave signalsRegisters.vcd 
pts: 
	iverilog -o testbench_parallelToSerial parallelToSerial_Tb.v
	vvp testbench_parallelToSerial
	gtkwave signalsparalleltoserial.vcd
padconverter:
	iverilog -o padconverters padconverters_tb.v
	vvp padconverters
	gtkwave padconverters.vcd
stpwrapper:
	iverilog -o stpwrapper serialtoparallelwrapper_tb.v
	vvp stpwrapper
	gtkwave serialtoparallel.vcd
ptswrapper:
	iverilog -o ptswrapper parallelToSerialwrapper_Tb.v
	vvp ptswrapper
	gtkwave ptswrapper.vcd
wrapper:
	iverilog -o wrappers wrappers_Tb.v
	vvp wrappers
	gtkwave wrappers.vcd
cmd_phys:
	iverilog -o cmd_phys cmd_phys_tb.v
	vvp cmd_phys
	gtkwave cmd_phys.vcd
	
sd_host:
	iverilog -o ../all/sd_host_tb ../all/sd_host_tb.v
	vvp ../all/sd_host_tb
	gtkwave ../all/signalsSDHost.vcd
	
