`timescale 1ns/1ns
module TB_ALU;
	
	reg		[31:0]	T_inpt1;
	reg		[31:0]	T_inpt2;
	reg		[5:0]	T_Op_Code;
	reg 			T_En;
	
	wire	[31:0]	T_outpt;
	
	ALU	DUT(
		.inpt1		(T_inpt1),
		.inpt2		(T_inpt2),
		.outpt		(T_outpt),
		.Op_Code	(T_Op_Code),
		.En			(T_En));
	
	initial
	begin
		T_En = 1'b1;
		T_Op_Code = 6'b011000;
		T_inpt1 = 32'd2;
		T_inpt2 = 32'd5;
		#20;
		T_Op_Code = 6'b011001;
		#20;
		T_Op_Code = 6'b011010;
		#20;
		T_Op_Code = 6'b011011;
		#20;
	end
endmodule

// run 80ns //
