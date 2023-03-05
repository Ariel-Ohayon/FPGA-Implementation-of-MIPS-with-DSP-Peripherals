`timescale 1ns/1ns
module tb_Stage4_2();
	reg t_reset;
	reg t_clk;
	reg t_BR_Ex;
	reg t_JMP_flag;
	reg [15:0]t_imm;
	reg t_CALL_flag;
	reg  t_RET_flag;
	reg t_Memory_Read;
	reg t_Memory_Write;
	reg [31:0]t_Result;
	reg [11:0]t_SP_Data;
	reg [31:0]t_data1;
	reg [4:0]t_Addr_Write_Reg_in;
	reg  t_Reg_Write_En_in;
	reg	 t_WB_Mux_sel_in;	
	
	wire        t_BR_JMP_Ex;
	wire [11:0] t_next_PC;
	wire [31:0] t_Mem_out_no_Pipeline;
	wire [31:0]t_ALU_out_no_Pipeline;
	wire [31:0] t_Result_out;
	wire [4:0]  t_Addr_Write_Reg_out;
	wire [31:0] t_Memory_Data;
	wire 		t_Reg_Write_En_out;
	wire 		t_WB_Mux_sel_out;
	
	Stage4	DUT(
		.clk					(t_clk),
		.reset					(t_reset),
		.BR_Ex					(t_BR_Ex),
		.JMP_flag				(t_JMP_flag),
		.imm					(t_imm),
		.CALL_flag				(t_CALL_flag),
		.RET_flag				(t_RET_flag),
		.Memory_Read			(t_Memory_Read),
		.Memory_Write     		(t_Memory_Write),
		.Result     			(t_Result),
		.SP_Data				(t_SP_Data),
		.data1					(t_data1),
		.Addr_Write_Reg_in		(t_Addr_Write_Reg_in),
		.Reg_Write_En_in		(t_Reg_Write_En_in),
		.WB_Mux_sel_in			(t_WB_Mux_sel_in),
		.BR_JMP_Ex			    (t_BR_JMP_Ex),
		.next_PC				(t_next_PC),
		.Mem_out_no_Pipeline	(t_Mem_out_no_Pipeline),
		.ALU_out_no_Pipeline    (t_ALU_out_no_Pipeline),
		.Result_out             (t_Result_out),
		.Addr_Write_Reg_out		(t_Addr_Write_Reg_out),
		.Memory_Data			(t_Memory_Data),
		.Reg_Write_En_out		(t_Reg_Write_En_out),
		.WB_Mux_sel_out		    (t_WB_Mux_sel_out));
	
	always
	begin
		t_clk=1'b1;
		#10;
		t_clk=1'b0;
		#10;
	end	
		initial
	begin
	t_reset=1'b1;
	t_BR_Ex=1'd0;
	t_JMP_flag=1'd0;
	t_imm=16'd0;
	t_CALL_flag=1'd0;
	t_RET_flag=1'd0;
	t_Memory_Read=1'd0;
	t_Memory_Write=1'd0;
	t_Result=32'd0;
	t_SP_Data=12'd0;
	t_data1=32'd0;
	t_Addr_Write_Reg_in=5'd0;
	t_Reg_Write_En_in=1'd0;
	t_WB_Mux_sel_in=1'd0;
	#20;
	t_imm=16'd9;
	#20;
	t_BR_Ex=1'b1;
	#20;
	t_BR_Ex=1'b0;
	t_JMP_flag=1'b1;
	#20;
	t_JMP_flag=1'b0;
	#20;
	end
	endmodule
	// run 100ns
