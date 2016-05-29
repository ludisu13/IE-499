
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
	reg control;
    always @ (posedge clock)
    if(enable )	
		begin
			dataFROMCARD <= io_port;
			if(!control)
				begin
					control <=1'b1;
				end
			if(control)
				begin
					dataToCARD <= data_in;
					control <=1'b1;
				end
		end
	else 
		begin
			dataFROMCARD <= 1'bz;
			dataToCARD <= 1'bz;
			control <=1'b0;
		
		end


endmodule
