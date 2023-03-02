`timescale 1ns/1ns
module tb_Stage5();
	reg t_reset;
	reg t_clk;
	reg t_Reg_Write_En_in;
	reg [4:0]t_Addr_Write_Reg_in;
	reg [31:0]t_ALU_Data;
	reg [31:0]t_Memory_Data;
	reg  t_WB_MUX_sel;
	
	wire      t_Reg_Write_En_out;
	wire [4:0]t_Addr_Write_Reg_out;
	wire [31:0]t_Reg_Write_Data_out;
	
	Stage5	DUT(
		.clk		(t_clk),
		.reset		(t_reset),
		.Reg_Write_En_in		(t_Reg_Write_En_in),
		.Addr_Write_Reg_in		(t_Addr_Write_Reg_in),
		.ALU_Data		(t_ALU_Data),
		.Memory_Data	(t_Memory_Data),
		.WB_MUX_sel		(t_WB_MUX_sel),
		.Reg_Write_En_out		(t_Reg_Write_En_out),
		.Addr_Write_Reg_out     (t_Addr_Write_Reg_out),
		.Reg_Write_Data_out       (t_Reg_Write_Data_out));
		
	initial
	begin
		t_clk=1'b0;
		t_reset=1'b0;
		t_Reg_Write_En_in=1'b0;
		t_Addr_Write_Reg_in=5'd0;
		t_ALU_Data=32'd0;
		t_Memory_Data=32'd0;
		t_WB_MUX_sel=1'b0;
		#20;
		t_Reg_Write_En_in=1'b1;
		t_Addr_Write_Reg_in=5'd1;
		t_ALU_Data=32'd5;
		t_Memory_Data=32'd8;
		t_WB_MUX_sel=1'b0;
		#20;
		t_WB_MUX_sel=1'b1;
		#20;
		end
		endmodule
		//run 60ns
