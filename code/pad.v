
module PAD(
    input wire clock,      
    input wire output_input,  // 1 salida, 0 entrada
    input wire  data_in,    // datos a mandar a la tarjeta
    output wire data_out,   // datos recibidos de la tarjeta
    inout  wire io_port,     // el PAD
    input wire enable
    );

    reg dataToCARD;
    reg dataFROMCARD;    

    assign io_port  = output_input ?dataToCARD: 1'bz;
    assign data_out = dataFROMCARD;

    always @ (posedge clock)
    if(enable)	
		begin
			dataFROMCARD <= io_port;
			dataToCARD <= data_in;
		end
	else 
		begin
			dataFROMCARD <= 1'b0;
			dataToCARD <= 1'b0;
		
		end


endmodule
