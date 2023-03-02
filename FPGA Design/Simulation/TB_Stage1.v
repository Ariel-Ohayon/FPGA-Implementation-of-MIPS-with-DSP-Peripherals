`timescale 1ns/1ns
module tb_Stage1();

	reg t_reset;
	reg t_clk;
	reg [11:0]t_instruction_addr;
	reg [31:0]t_instruction_data;
	reg  t_PC_sel;
	reg t_ProgMode;
	reg [11:0]t_addr_BR_JMP;
	reg t_EN_Pipeline;

	wire [31:0]t_instruction_out;


	Stage1	DUT(
		.clk		(t_clk),
		.reset		(t_reset),
		.Instruction_addr		(t_instruction_addr),
		.Instruction_Data	(t_instruction_data),
		.PC_sel		(t_PC_sel),
		.ProgMode		(t_ProgMode),
		.addr_BR_JMP     (t_addr_BR_JMP),
		.En_Pipeline       (t_EN_Pipeline),
		.Instruction_out(t_instruction_out));
	always
	begin
		t_clk=1'b1;
		#10;
		t_clk=1'b0;
		#10;
	end

	initial
	begin
		t_instruction_addr=12'd0;
		t_instruction_data=32'd0;
		t_PC_sel=1'b0;
		t_ProgMode=1'b0;
		t_addr_BR_JMP=12'd0;
		t_EN_Pipeline=1'b0;
		t_reset=1'b1;
		#20;
		t_reset=1'b0;
		t_instruction_data = 32'h00221804;
		#20;
		t_instruction_addr=12'd1;
		t_instruction_data = 32'h10220005;
		#20;
		t_instruction_addr=12'd2;
		t_instruction_data = 32'hfc00003d;	
		#20;
		t_instruction_addr=12'd3;
		t_instruction_data = 32'h04320003;
		#20;	
		t_ProgMode=1'b1;
		#10;
		t_EN_Pipeline=1'b1;
		#80;
	end

endmodule

// run 190ns
