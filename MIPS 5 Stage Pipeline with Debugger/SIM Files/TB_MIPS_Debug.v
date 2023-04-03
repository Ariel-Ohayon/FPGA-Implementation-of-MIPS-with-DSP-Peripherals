`timescale 1ns/1ns
module TB_MIPS_Debug;

	reg		T_reset;
	reg		T_clk;
	reg		T_rx;
	reg	[4:0]	T_Debug_selector;
	reg			T_Debug_sel_Instruction;
	
	wire		T_CPU_reset_out;
	wire		T_CPU_clk_out;
	wire		T_ProgMode_out;

	MIPS_Top_Module	DUT(
	.reset					(T_reset),
	.clk					(T_clk),
	.rx						(T_rx),
	.Debug_selector			(T_Debug_selector),
	.Debug_sel_Instruction	(T_Debug_sel_Instruction),
	//HEX0:							out	std_logic_vector(6 downto 0);
	//HEX1:							out	std_logic_vector(6 downto 0);
	//HEX2:							out	std_logic_vector(6 downto 0);
	//HEX3:							out	std_logic_vector(6 downto 0);
	//HEX4:							out	std_logic_vector(6 downto 0);
	//HEX5:							out	std_logic_vector(6 downto 0);
	//HEX6:							out	std_logic_vector(6 downto 0);
	//HEX7:							out	std_logic_vector(6 downto 0);
	.CPU_reset_out			(T_CPU_reset_out),
	.CPU_clk_out			(T_CPU_clk_out),
	.ProgMode_out			(T_ProgMode_out));
	
	always
	begin
		T_clk = 1'b0;
		#10;
		T_clk = 1'b1;
		#10;
	end
	
	initial
	begin
		T_reset = 1'b0;
		T_Debug_sel_Instruction = 1'b1;
		T_Debug_selector = 5'd0;
		T_rx = 1'b1;
		#20;
		T_reset = 1'b1;
		#20;
		Read_Packet_UART(32'h31545352);
		Read_Packet_UART(32'h30303030);
		#20;
		Read_Packet_UART(32'h30454D49);
		Read_Packet_UART(32'h31454D49);
	end
	
	
	task Read_Byte_UART;
	input	[7:0]	data;
	integer i;
	begin
		T_rx = 1'b0; // Start Bit
		#8680.555556;
		for (i = 0; i < 8; i = i + 1)begin
			T_rx = data[i];
			#8680.555556;
		end
		T_rx = 1'b1; // Stop Bit
		#8680.555556;
	end
	endtask // run time = 0.086805555[msec]
	
	task Read_Packet_UART;
		input	[31:0]	data;
	begin
		Read_Byte_UART(data[7:0]);
		Read_Byte_UART(data[15:8]);
		Read_Byte_UART(data[23:16]);
		Read_Byte_UART(data[31:24]);
	end
	endtask // run time =
	
endmodule