`include "../code/definitions_registers.v"
module registers (
	
	//Inputs
	input wire 		clock,
	input wire			reset,
	input wire	[4:0] 	adr_i, 
	input wire 		reg_write_en,
	input wire 		reg_read_en,
	input wire			command_complete,
	input wire	[127:0] data_i,
	input wire [127:0]	response_i,
	input wire [15:0] 	error_interrupt_status_i,
	input wire [15:0] 	normal_interrupt_status_i,
	//Outputs
	output reg	[11:0] 	block_size,
	output reg	[15:0] 	block_count,
	output reg	[31:0] 	argument,
	output reg	[15:0] 	transfer_mode,
	output reg	[15:0] 	command,
	output reg	[15:0]	present_state,
	output reg	[15:0] 	timeout_control,
	output reg	[2:0]	software_reset,
	output reg	[15:0]	error_interrupt_status_o,
	output reg	[127:0] data_o
);

reg [127:0]	response; //Para response tiene que haber un puerto de entrada que se llame response
reg [15:0] 	normal_interrupt_status;
reg [15:0] 	normal_interrupt_status_enable;
reg [15:0] 	error_interrupt_status_enable;
reg [15:0] 	normal_interrupt_signal_enable;
reg [15:0] 	error_interrupt_signal_enable;
reg [15:0] 	host_controller_version;

always @(posedge clock) begin
	
	if(reset) begin
		block_size 	<= 12'b0;
		block_count <= 16'b0;
		argument	<= 32'b0;
		transfer_mode <= 16'b0;
		command		<= 16'b0;
		present_state <= 16'b0;
		timeout_control <= 16'b0;
		software_reset <= 3'b0;
		error_interrupt_status_o <= 16'b0;
		data_o <= 128'b0;
		response <= 128'b0;
		normal_interrupt_status <= 16'b0;
		normal_interrupt_status_enable <= 16'b0;
		error_interrupt_status_enable <= 16'b0;
		normal_interrupt_signal_enable <= 16'b0;
		error_interrupt_signal_enable <= 16'b0;
		host_controller_version <= 16'b0;
	end

	if(reg_write_en) begin
		case(adr_i) 
			`BLOCK_SIZE:
				begin	
					block_size <= data_i[11:0];
				end
			`BLOCK_COUNT:
				begin
					block_count <= data_i[15:0];
				end
			`ARGUMENT:
				begin
					argument <= data_i[31:0];
				end
			`TRANSFER_MODE:
				begin
					transfer_mode <= data_i[15:0];
				end
			`COMMAND:
				begin
					command <= data_i[15:0];
				end
			`RESPONSE:
				begin
					response <= response;
				end
			`PRESENT_STATE:
				begin
					present_state <= present_state;
				end
			`TIMEOUT_CONTROL:
				begin
					timeout_control <= data_i[15:0];
				end
			`SOFTWARE_RESET:
				begin
					software_reset <= data_i[2:0];
				end
			`NORMAL_INTERRUPT_STATUS:
				begin
					normal_interrupt_status <= normal_interrupt_status;
				end
			`ERROR_INTERRUPT_STATUS:
				begin
					error_interrupt_status_o <= error_interrupt_status_i;
				end
			`NORMAL_INTERRUPT_STATUS_ENABLE:
				begin
					normal_interrupt_status_enable <= data_i[15:0];
				end
			`ERROR_INTERRUPT_STATUS_ENABLE:
				begin
					error_interrupt_status_enable <= data_i[15:0];
				end
			`NORMAL_INTERRUPT_SIGNAL_ENABLE:
				begin
					normal_interrupt_signal_enable <= data_i[15:0];
				end
			`ERROR_INTERRUPT_SIGNAL_ENABLE:
				begin
					error_interrupt_signal_enable <= data_i[15:0];
				end
			`HOST_CONTROLLER_VERSION:
				begin
					host_controller_version <= host_controller_version;
				end	
		endcase
	end
	else if (reg_read_en) begin
		case(adr_i) 
			`BLOCK_SIZE:
				begin
					data_o <= {116'b0 , block_size};
				end
			`BLOCK_COUNT:
				begin
					data_o <= {112'b0, block_count};
				end
			`ARGUMENT:
				begin
					data_o <= {96'b0, argument};
				end
			`TRANSFER_MODE:
				begin
					data_o <= {112'b0, transfer_mode};
				end
			`COMMAND:
				begin
					data_o <= {112'b0, command};
				end
			`RESPONSE:
				begin
					data_o <= response;
				end
			`PRESENT_STATE:
				begin
					data_o <= {112'b0, present_state};
				end
			`TIMEOUT_CONTROL:
				begin
					data_o <= {112'b0, timeout_control};
				end
			`SOFTWARE_RESET:
				begin
					data_o <= {125'b0, software_reset};
				end
			`NORMAL_INTERRUPT_STATUS:
				begin
					data_o <= {112'b0, normal_interrupt_status};
				end
			`ERROR_INTERRUPT_STATUS:
				begin
					data_o <= {112'b0, error_interrupt_status_o};
				end
			`NORMAL_INTERRUPT_STATUS_ENABLE:
				begin
					data_o <= {112'b0, normal_interrupt_status_enable};
				end
			`ERROR_INTERRUPT_STATUS_ENABLE:
				begin
					data_o <= {112'b0, error_interrupt_status_enable};
				end
			`NORMAL_INTERRUPT_SIGNAL_ENABLE:
				begin
					data_o <= {112'b0, normal_interrupt_signal_enable};
				end
			`ERROR_INTERRUPT_SIGNAL_ENABLE:
				begin
					data_o <= {112'b0, error_interrupt_signal_enable};
				end
			`HOST_CONTROLLER_VERSION:
				begin
					data_o <= {112'b0, host_controller_version};
				end	
		endcase
	end
	
	else begin
		if(command_complete) begin
			response = response_i;
			error_interrupt_status_o = error_interrupt_status_i;
			normal_interrupt_status = normal_interrupt_status_i;
			block_size = block_size;
			block_count = block_count;
			argument = argument;
			transfer_mode = transfer_mode;
			command = command;
			present_state = present_state;
			timeout_control = timeout_control;
			software_reset = software_reset;
			response = response; 
			normal_interrupt_status_enable = normal_interrupt_status_enable;
			error_interrupt_status_enable = error_interrupt_status_enable;
			normal_interrupt_signal_enable = normal_interrupt_signal_enable;
			error_interrupt_signal_enable = error_interrupt_signal_enable;
			host_controller_version = host_controller_version;
		end
		
	end
end

endmodule
