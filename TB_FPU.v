`timescale 10us/1us;
module TB_FPU ();
	reg 	[31:0]	T_A;
	reg		[31:0]	T_B;
	wire	[31:0]	T_Result;
	
	FPU	DUT(
		.A			(T_A),
		.B			(T_B),
		.Result		(T_Result));
	
	initial
	begin
		T_A = 32'h3FC00000;
		T_B = 32'h40500000;
		#1;
		T_A = 32'hC0500000;
		#1;
		T_A = 32'h40500000;
		T_B = 32'h3FC00000;
		#1;
		T_A = 32'h420F0000;
		T_B = 32'h31A40000;
		#1;
		T_B = 32'h41A40000;
		#1;
		T_B = 32'hC1A40000;
		#1;
		T_A = 32'hC1A40000;
		T_B = 32'h420F0000;
		#1;
		T_A = 32'h42300000;
		T_B = 32'h43a40000;
		#1;
		T_A = 32'hC2300000;
		#1;
		T_A = 32'h43a40000;
		T_B = 32'hC2300000;
		#1;
		T_A = 32'hC3A40000;
		#1;
		T_B = 32'h42300000;
		#1;
		T_A = 32'h42300000;
		T_B = 32'hC3A40000;
		#1;
	end
endmodule

// -- run 130us -- \\
