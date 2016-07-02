//PRUEBA EXEC
`timescale 1ns / 1ps
`ifndef DEFINTIONS_V
`define DEFINTIONS_V
	
`define CLOCK_HALF_PERIOD 20
`define RESET_FIRE_TIME 60
`define RESET_DEACTIVATE_TIME 30
`define NEW_HOST_DATA 40
`define CMD_DONE_UP 1400////
`define CMD_DONE_DOWN 40 //
`define DATA_DONE_UP 1720//
`define DATA_DONE_DOWN 40 //
`define WRITE_TO_SD 680
`define READ_FROM_SD 580
`define ADR_IN 80
`define ADR_IN2 80
`define STROBE_UP_TIME 200
`define STROBE_DOWN_TIME 40
`define NEW_WB_DATA 40
`define NO_WWAIT 200
`define WWAIT 40
`define NO_RWAIT 1000
`define RWAIT 120

`endif


//PRUEBA FIFO
//~ `timescale 1ns / 1ps
//~ `ifndef DEFINTIONS_V
//~ `define DEFINTIONS_V
	//~ 
//~ `define CLOCK_HALF_PERIOD 20
//~ `define RESET_FIRE_TIME 60
//~ `define RESET_DEACTIVATE_TIME 30
//~ `define NEW_HOST_DATA 40
//~ `define CMD_DONE_UP 350////
//~ `define CMD_DONE_DOWN 40 //
//~ `define DATA_DONE_UP 400//
//~ `define DATA_DONE_DOWN 50 //
//~ `define WRITE_TO_SD 160
//~ `define READ_FROM_SD 120
//~ `define ADR_IN 80
//~ `define ADR_IN2 80
//~ `define STROBE_UP_TIME 200
//~ `define STROBE_DOWN_TIME 40
//~ `define NEW_WB_DATA 40
//~ `define NO_WWAIT 200
//~ `define WWAIT 40
//~ `define NO_RWAIT 1000
//~ `define RWAIT 120
//~ 
//~ `endif
