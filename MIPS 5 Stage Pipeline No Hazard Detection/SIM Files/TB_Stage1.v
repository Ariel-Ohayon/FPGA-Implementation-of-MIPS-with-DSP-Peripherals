`timescale 1ns/1ns
module TB_Stage1;
	
	reg				T_reset;
	reg				T_clk;
	reg				T_Pipeline_Enable;
	reg				T_ProgMode;
	reg		[31:0]	T_Data_Prog;
	reg		[7:0]	T_Addr_Prog;
	
	wire	[31:0]	T_Instruction;

	Stage1	DUT (
		.reset				(T_reset),
		.clk				(T_clk),
		.Pipeline_Enable	(T_Pipeline_Enable),
		.ProgMode			(T_ProgMode),
		.Data_Prog			(T_Data_Prog),
		.Addr_Prog			(T_Addr_Prog),
		.Instruction		(T_Instruction));
	
	always
	begin
		T_clk = 1'b0;
		#10;
		T_clk = 1'b1;
		#10;
	end
	
	initial
	begin
		T_reset = 1'b1;
		T_Pipeline_Enable = 1'b1;
		T_ProgMode = 1'b0; // Program State (Write)
		T_Addr_Prog = 8'd0;
		T_Data_Prog = 32'd0;
		
		#20;
		T_reset = 1'b0;
		T_Addr_Prog = 8'd0;
		T_Data_Prog = 32'd8;
		#20;
		T_Addr_Prog = 8'd1;
		T_Data_Prog = 32'd64;
		#20;
		T_Addr_Prog = 8'd2;
		T_Data_Prog = 32'd12;
		#20;
		T_Addr_Prog = 8'd3;
		T_Data_Prog = 32'd18;
		#20;
		
		T_ProgMode = 1'b1; // Run State (Read)
		#100;
	end
	
endmodule

// run 200ns