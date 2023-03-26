`timescale 1ns/1ns
module TB_MIPS4;
	
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
		T_Data_Prog = 32'd274730462;
		#20;
		T_Addr_Prog = 8'd1;
		T_Data_Prog = 32'd4160749572;
		#20;
		T_Addr_Prog = 8'd2;
		T_Data_Prog = 32'd100663301;
		#20;
		T_Addr_Prog = 8'd3;
		T_Data_Prog = 32'd4227858435;
		#20;
		T_Addr_Prog = 8'd4;
		T_Data_Prog = 32'd272629760;
		#20;
		T_Addr_Prog = 8'd5;
		T_Data_Prog = 32'd270532609;
		#20;
		T_Addr_Prog = 8'd6;
		T_Data_Prog = 32'd8460296;
		#20;
		T_Addr_Prog = 8'd7;
		T_Data_Prog = 32'd880869385;
		#20;
		T_Addr_Prog = 8'd8;
		T_Data_Prog = 32'd272760833;
		#20;
		T_Addr_Prog = 8'd9;
		T_Data_Prog = 32'd6490137;
		#20;
		T_Addr_Prog = 8'd10;
		T_Data_Prog = 32'd878706694;
		#20;
		T_Addr_Prog = 8'd11;
		T_Data_Prog = 32'd138412037;
		#20;
		T_Addr_Prog = 8'd12;
		T_Data_Prog = 32'd4093640704;
		#20;

		T_reset = 1'b1;
		T_ProgMode = 1'b1;
		#20;
		T_reset = 1'b0;
		#20;
		
	end
	
endmodule