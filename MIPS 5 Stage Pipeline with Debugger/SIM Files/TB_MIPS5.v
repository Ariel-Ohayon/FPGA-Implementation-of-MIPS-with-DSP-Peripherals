`timescale 1ns/1ns
module TB_MIPS5;
	
	reg				T_reset;
	reg				T_clk;
	
	reg		[4:0]	T_Debug_selector;
	
	wire	[6:0]	T_HEX0;
	wire	[6:0]	T_HEX1;
	wire	[6:0]	T_HEX2;
	wire	[6:0]	T_HEX3;
	wire	[6:0]	T_HEX4;
	wire	[6:0]	T_HEX5;
	wire	[6:0]	T_HEX6;
	wire	[6:0]	T_HEX7;
	
	MIPS_Top_Module	DUT(
		.reset			(T_reset),
		.clk			(T_clk),
		.Debug_selector	(T_Debug_selector),
		.HEX0			(T_HEX0),
		.HEX1			(T_HEX1),
		.HEX2			(T_HEX2),
		.HEX3			(T_HEX3),
		.HEX4			(T_HEX4),
		.HEX5			(T_HEX5),
		.HEX6			(T_HEX6),
		.HEX7			(T_HEX7));
	
	always
	begin
		T_clk = 1'b0;
		#10;
		T_clk = 1'b1;
		#10;
	end
	
	initial
	begin
		T_Debug_selector = 5'd2;
		T_reset = 1'b1;
		#20;
		T_reset = 1'b0;
		
	end
	
endmodule