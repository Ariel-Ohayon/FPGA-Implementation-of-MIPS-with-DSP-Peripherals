module TB_FPU ();
	reg 	[31:0]	T_A;
	reg		[31:0]	T_B;
	wire	[31:0]	T_Result;
	
	FPU	DUT(
		.A		(T_A),
		.B		(T_B),
		.Result	(T_Result));
	
	initial
	begin
		T_A = 32'h420F0000;
		T_B = 32'h41A40000;
	end
endmodule