`timescale 10ns/1ns
module TB_IF;

	reg				T_reset;
	reg				T_clk;
	reg		[7 :0]	T_Instruction_Data_input;
	reg		[31:0]	T_Instruction_Address_input;
	reg				T_En_Program;
	wire	[31:0]	T_Instruction_Data_output;

	MicroProcessor DUT (
		.reset						(T_reset),
		.clk						(T_clk),
		.Instruction_Data_input		(T_Instruction_Data_input),
		.Instruction_Address_input	(T_Instruction_Address_input),
		.En_Program					(T_En_Program),
		.Instruction_Data_output	(T_Instruction_Data_output));
	
	always
	begin
		T_clk = 1'b0;
		#1;
		T_clk = 1'b1;
		#1;
	end
	
	initial
	begin
		T_reset = 1'b1;
		T_En_Program = 1'b0;	//	Programming Mode - sort values to Instruction Memory
		
		T_Instruction_Address_input	= 32'h00000000;
		T_Instruction_Data_input	=  8'b00000000;	//00
		
		#2;	//1
		
		T_Instruction_Address_input	= 32'h00000001;
		T_Instruction_Data_input	=  8'b00000001;	//01
		
		#2;	//2
		
		T_Instruction_Address_input	= 32'h00000002;
		T_Instruction_Data_input	=  8'b00000010;	//02
		
		#2;	//3
		
		T_Instruction_Address_input	= 32'h00000003;
		T_Instruction_Data_input	=  8'b00001000;	//08
		
		#2;	//4
		
		T_Instruction_Address_input	= 32'h00000004;
		T_Instruction_Data_input	=  8'b00001100;	//0C
		
		#2;	//5
		
		T_Instruction_Address_input	= 32'h00000005;
		T_Instruction_Data_input	=  8'b00001111;	//0F
		
		#2;	//6
		
		T_Instruction_Address_input	= 32'h00000006;
		T_Instruction_Data_input	=  8'b00101001;	//29
		
		#2;	//7
		
		T_Instruction_Address_input	= 32'h00000007;
		T_Instruction_Data_input	=  8'b11100100;	//E4
		
		#2;	//8
		
		T_Instruction_Address_input	= 32'h00000008;
		T_Instruction_Data_input	=  8'b00011010;	//1A
		
		#2;	//9
		
		T_Instruction_Address_input	= 32'h00000009;
		T_Instruction_Data_input	=  8'b10000001;	//81
		
		#2;	//10
		
		T_Instruction_Address_input	= 32'h0000000A;
		T_Instruction_Data_input	=  8'b00110001;	//31
		
		#2;	//11
		
		T_Instruction_Address_input	= 32'h0000000B;
		T_Instruction_Data_input	=  8'b11010010;	//D2
		
		#2;	//12
		
		T_Instruction_Address_input	= 32'h0000000C;
		T_Instruction_Data_input	=  8'b11011001;	//D9
		
		#2;	//13
		
		T_Instruction_Address_input	= 32'h0000000D;
		T_Instruction_Data_input	=  8'b00000010;	//02
		
		#2;	//14
		
		T_Instruction_Address_input	= 32'h0000000E;
		T_Instruction_Data_input	=  8'b01111111;	//7F
		
		#2;	//15
		
		T_Instruction_Address_input	= 32'h0000000F;
		T_Instruction_Data_input	=  8'b01010001;	//51
		
		#2;	//16
		
		#1;
		T_En_Program = 1'b1;
		#1;
		T_reset = 1'b0;
	end
	
endmodule

// -- run 420ns (10ns*16 = 160[nsec]) -- \\