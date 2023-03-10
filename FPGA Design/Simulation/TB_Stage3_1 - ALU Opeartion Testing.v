`timescale 1ns/1ns
module TB_Stage3_1;
	
	
	reg					T_clk;
	reg					T_reset;
	reg		[7:0]		T_SP_Data;
	reg		[5:0]		T_ALU_Op_Code;
	reg					T_ALU_src;
	reg					T_En_Integer;
	reg					T_En_Float;
	reg					T_Memory_Read_in;
	reg					T_Memory_Write_in;
	reg					T_Reg_Write_En_in;
	reg					T_WB_Mux_sel_in;
	reg					T_CALL_flag_in;
	reg					T_RET_flag_in;
	reg					T_BR_flag_in;
	reg		[4:0]		T_Addr_Write_Reg_in;
	reg		[31:0]		T_data1_in;
	reg		[31:0]		T_data2_in;
	reg		[15:0]		T_imm_in;
	reg					T_JMP_flag_in;
	
	wire	[31:0]		T_Result_out;
	wire				T_Memory_Read_out;
	wire				T_Memory_Write_out;
	wire				T_Reg_Write_En_out;
	wire				T_WB_Mux_sel_out;
	wire	[4:0]		T_Addr_Write_Reg_out;
	wire	[15:0]		T_imm_out;
	wire				T_BR_Ex_out;
	wire				T_CALL_flag_out;
	wire				T_RET_flag_out;
	wire	[7:0]		T_SP_Data_out;
	wire	[31:0]		T_data1_out;
	wire				T_JMP_flag_out;
	wire	[31:0]		T_Result_out_no_Pipeline;
	
	Stage3	DUT	(
		.clk						(T_clk),
		.reset					(T_reset),
		.SP_Data					(T_SP_Data),
		.ALU_Op_Code				(T_ALU_Op_Code),
		.ALU_src					(T_ALU_src),
		.En_Integer				(T_En_Integer),
		.En_Float				(T_En_Float),
		.Memory_Read_in			(T_Memory_Read_in),
		.Memory_Write_in			(T_Memory_Write_in),
		.Reg_Write_En_in			(T_Reg_Write_En_in),
		.WB_Mux_sel_in			(T_WB_Mux_sel_in),
		.CALL_flag_in			(T_CALL_flag_in),
		.RET_flag_in				(T_RET_flag_in),
		.BR_flag_in				(T_BR_flag_in),
		.Addr_Write_Reg_in		(T_Addr_Write_Reg_in),
		.data1_in				(T_data1_in),
		.data2_in				(T_data2_in),
		.imm_in					(T_imm_in),
		.Result_out				(T_Result_out),
		.Memory_Read_out			(T_Memory_Read_out),
		.Memory_Write_out		(T_Memory_Write_out),
		.Reg_Write_En_out		(T_Reg_Write_En_out),
		.WB_Mux_sel_out			(T_WB_Mux_sel_out),
		.Addr_Write_Reg_out		(T_Addr_Write_Reg_out),
		.imm_out					(T_imm_out),
		.BR_Ex_out				(T_BR_Ex_out),
		.CALL_flag_out			(T_CALL_flag_out),
		.RET_flag_out			(T_RET_flag_out),
		.SP_Data_out				(T_SP_Data_out),
		.data1_out				(T_data1_out),
		.JMP_flag_in				(T_JMP_flag_in),
		.JMP_flag_out			(T_JMP_flag_out),
		.Result_out_no_Pipeline	(T_Result_out_no_Pipeline));
	always
	begin
		T_clk = 1'b1;
		#10;
		T_clk = 1'b0;
		#10;
	end
	
	initial
	begin
		T_reset = 1'b1;
		
		T_SP_Data			= 8'd0;
		T_ALU_Op_Code		= 6'd0;
		T_ALU_src			= 1'b0;
		T_En_Integer		= 1'b0;
		T_En_Float			= 1'b0;
		T_Memory_Read_in	= 1'b0;
		T_Memory_Write_in	= 1'b0;
		T_Reg_Write_En_in	= 1'b0;
		T_WB_Mux_sel_in		= 1'b0;
		T_CALL_flag_in		= 1'b0;
		T_RET_flag_in		= 1'b0;
		T_BR_flag_in		= 1'b0;
		T_Addr_Write_Reg_in	= 5'd0;
		T_data1_in			= 32'd0;
		T_data2_in			= 32'd0;
		T_imm_in			= 32'd0;
		T_JMP_flag_in		= 1'b0;
		
		#20;
		
		T_reset = 1'b0;
		T_En_Integer = 1'b1;
		T_ALU_Op_Code = 6'b000100; // ADD
		T_data1_in = 32'd15;
		T_data2_in = 32'd3;
		#20;
		T_ALU_Op_Code = 6'b000101; // SUB
		#20;
		T_ALU_Op_Code = 6'b000110; // MUL
		#20;
		T_ALU_Op_Code = 6'b000111; // DIV
		#20;
		T_ALU_Op_Code = 6'b001000; // AND
		T_data1_in = 32'h0000F0F0F;
		T_data2_in = 32'h000000ABC;
		#20;
		T_ALU_Op_Code = 6'b001001; // OR
		#20;
		T_ALU_Op_Code = 6'b001010; // NOR
		#20;
		T_ALU_Op_Code = 6'b001011; // XOR
		#20;
		T_ALU_Op_Code = 6'b011000; // SLL
		T_data1_in = 32'd5;
		T_data2_in = 32'd2;
		#20;
		T_ALU_Op_Code = 6'b011001; // SRL
		#20;
		T_ALU_Op_Code = 6'b011010; // SLA
		#20;
		T_ALU_Op_Code = 6'b011011; // SRA
		#20;
		T_ALU_src = 1'b1;
		T_ALU_Op_Code = 6'b100100; // ADDHI
		T_imm_in = 16'h003D;
		T_data1_in = 32'h0F000000;
		#20;
		T_ALU_Op_Code = 6'b100101; // SUBHI
		#20;
		T_ALU_Op_Code = 6'b100110; // MULHI
		#20;
		T_ALU_Op_Code = 6'b100111; // DIVHI
		#20;
		T_ALU_Op_Code = 6'b101000; // ANDHI
		#20;
		T_ALU_Op_Code = 6'b101001; // ORHI
		#20;
		T_ALU_Op_Code = 6'b101010; // NORHI
		#20;
		T_ALU_Op_Code = 6'b101011; // XORHI
		#20;
	end
endmodule

// run 420ns //
