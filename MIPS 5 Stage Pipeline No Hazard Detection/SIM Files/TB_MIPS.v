`timescale 1ns/1ns
module TB_MIPS;
	
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
		T_Data_Prog = 32'h10200005; //
		#20;
		T_Addr_Prog = 8'd1;
		T_Data_Prog = 32'h10600008; //
		#20;
		T_Addr_Prog = 8'd2;
		T_Data_Prog = 32'h10e00002;
		#20;
		T_Addr_Prog = 8'd3;
		T_Data_Prog = 32'h30000001;
		#20;
		T_Addr_Prog = 8'd4;
		T_Data_Prog = 32'h4;
		#20;
		T_Addr_Prog = 8'd5;
		T_Data_Prog = 32'h4;
		#20;
		T_Addr_Prog = 8'd6;
		T_Data_Prog = 32'h12600010;
		#20;
		T_Addr_Prog = 8'd7;
		T_Data_Prog = 32'h10000000;
		#20;
		T_Addr_Prog = 8'd8;
		T_Data_Prog = 32'h411806;
		#20;
		T_ProgMode = 1'b1; // Run mode (Read)
		T_reset = 1'b1;
		#20;
		T_reset = 1'b0;
		#20;
		
	end
	
endmodule