`timescale 1ns/1ns
module TB_MIPS2;
	
	reg			T_reset;
	reg			T_clk;
	reg			T_ProgMode;
	reg	[7:0]	T_Addr_Prog;
	reg	[31:0]	T_Data_Prog;
	
	MIPS	DUT(
		.reset		(T_reset),
		.clk		(T_clk),
		.ProgMode	(T_ProgMode),
		.Addr_Prog	(T_Addr_Prog),
		.Data_Prog	(T_Data_Prog));
		
	always
	begin
		T_clk = 1'b0;
		#10;
		T_clk = 1'b1;
		#10;
	end
	
	initial
	begin
		T_Addr_Prog = 8'd0;
		T_Data_Prog = 32'd0;
		T_reset = 1'b1;
		T_ProgMode = 1'b0; // Program mode (Write)
		#20;
		T_reset = 1'b0;
		
		T_Addr_Prog = 8'd0;
		T_Data_Prog = 32'h10200005;
		#20;
		T_Addr_Prog = 8'd1;
		T_Data_Prog = 32'h10400003;
		#20;
		T_Addr_Prog = 8'd2;
		T_Data_Prog = 32'h4;
		#20;
		T_Addr_Prog = 8'd3;
		T_Data_Prog = 32'h811005;
		#20;
		T_Addr_Prog = 8'd4;
		T_Data_Prog = 32'h211004;
		#20;
		T_reset = 1'b1;
		T_ProgMode = 1'b1;
		#20;
		T_reset = 1'b0;
		#20;
		
	end
	
endmodule