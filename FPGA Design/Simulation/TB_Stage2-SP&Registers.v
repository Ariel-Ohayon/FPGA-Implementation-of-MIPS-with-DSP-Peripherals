`timescale 1ns/1ns
module tb_Stage2_2();

reg			t_clk;
reg			t_reset;
reg			t_En_Pipeline;
reg[31:0]	t_Instruction;
reg[4:0]	t_Addr_Write_Reg;
reg			t_Reg_Write_En_in;

wire[7:0]	t_SP_Data;
wire[5:0]	t_ALU_Op_Code_out;
wire		t_ALU_src_out;
wire		t_En_Integer_out;
wire		t_En_Float_out;
wire		t_Memory_Read_out;
wire		t_Memory_Write_out;
wire		t_Reg_Write_En_out;
wire		t_WB_Mux_sel_out;
wire		t_CALL_flag_out;
wire		t_RET_flag_out;
wire		t_BR_flag_out;
wire[4:0]	t_Addr_Write_Reg_out;
wire[31:0]	t_data1_out	;
wire[31:0]	t_data2_out	;
wire[15:0]	t_imm_out	;
wire		t_JMP_flag_out;
	
reg	[31:0]	t_data_in;
	
wire		t_F_Read_Reg_En;
	
reg	[31:0]	t_Forward_Data_in;
reg	[1:0]	t_Forward_Selector;
integer i;
stage2 DUT(
	.clk			   (t_clk),
	.reset			   (t_reset),
	.En_Pipeline	   (t_En_Pipeline),
	.Instruction	   (t_Instruction),
	.Addr_Write_Reg	   (t_Addr_Write_Reg),
	.Reg_Write_En_in   (t_Reg_Write_En_in),
	.SP_Data		   (t_SP_Data),
	.ALU_Op_Code_out   (t_ALU_Op_Code_out),
	.ALU_src_out	   (t_ALU_src_out),
	.En_Integer_out	   (t_En_Integer_out),
	.En_Float_out	   (t_En_Float_out),
	.Memory_Read_out   (t_Memory_Read_out),
	.Memory_Write_out  (t_Memory_Write_out),
	.Reg_Write_En_out  (t_Reg_Write_En_out),
	.WB_Mux_sel_out	   (t_WB_Mux_sel_out),
	.CALL_flag_out	   (t_CALL_flag_out),
	.RET_flag_out	   (t_RET_flag_out),
	.BR_flag_out	   (t_BR_flag_out),
	.Addr_Write_Reg_out(t_Addr_Write_Reg_out),
	.data1_out		   (t_data1_out),
	.data2_out		   (t_data2_out),	
	.imm_out		   (t_imm_out),	
	.JMP_flag_out	   (t_JMP_flag_out),	
	.data_in		   (t_data_in),	
	.F_Read_Reg_En	   (t_F_Read_Reg_En),
	.Forward_Data_in   (t_Forward_Data_in),
	.Forward_Selector  (t_Forward_Selector));
	
	always
	begin
		t_clk=1'b1;
		#10;
		t_clk=1'b0;
		#10;
	end

	initial
	begin
	t_reset=1'd1;
	t_En_Pipeline=1'd1;
	
	t_Instruction=32'd0;
	
	t_Addr_Write_Reg=5'd0;
	t_Reg_Write_En_in=1'd0;
	t_data_in=32'd0;
	
	t_Forward_Data_in=32'd0;
	t_Forward_Selector=2'd0;
	
	#20;
	t_reset=1'd0;
	for (i=0;i<3;i=i+1)begin
		t_Instruction=32'hf8000063;
		#20;
	end
	for(i=0;i<3;i=i+1)begin
		t_Instruction=32'hf4000000;
		#20;
	end
	
	t_Addr_Write_Reg=5'd0;
	t_Reg_Write_En_in=1'd1;
	t_data_in=32'd2;
	#20;
	t_Addr_Write_Reg=5'd5;
	t_Reg_Write_En_in=1'd1;
	t_data_in=32'd7;
	#20;
	t_Addr_Write_Reg=5'd2;
	t_Reg_Write_En_in=1'd1;
	t_data_in=32'd18;
	#20;
	t_Addr_Write_Reg=5'd3;
	t_Reg_Write_En_in=1'd1;
	t_data_in=32'd9;
	#20;
	
	t_Reg_Write_En_in=1'd0;
	t_Instruction = 32'h00402804;
	#20;
	t_Instruction=32'h00e21804;
	#20;
end
endmodule
// run 260ns
