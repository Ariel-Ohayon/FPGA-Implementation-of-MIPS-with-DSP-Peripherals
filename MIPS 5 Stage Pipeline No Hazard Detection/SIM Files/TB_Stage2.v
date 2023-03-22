`timescale 1ns/1ns
module TB_Stage2;

	reg				T_reset;
	reg				T_clk;
	reg				T_En_Pipeline;
	reg		[31:0]	T_instruction;
	reg		[31:0]	T_STG25_data_in;
	reg		[4:0]	T_STG25_addr_Write_Reg;
	reg				T_STG25_En_Write_Reg;
	
	wire	[31:0]	T_ALU_operand1;
	wire	[31:0]	T_ALU_operand2;
	wire	[5:0]	T_opcode;
	wire	[4:0]	T_Addr_Write_Reg;
	wire			T_En_Write_Reg;
	wire			T_JMP_BR_flag;
	wire			T_Mem_Read;
	wire			T_Mem_Write;

	Stage2	DUT (
		.reset					(T_reset),
		.clk					(T_clk),
		.En_Pipeline			(T_En_Pipeline),
		.instruction			(T_instruction),
		.STG25_data_in			(T_STG25_data_in),
		.STG25_addr_Write_Reg	(T_STG25_addr_Write_Reg),
		.STG25_En_Write_Reg		(T_STG25_En_Write_Reg),
		.ALU_operand1			(T_ALU_operand1),
		.ALU_operand2			(T_ALU_operand2),
		.opcode					(T_opcode),
		.Addr_Write_Reg			(T_Addr_Write_Reg),
		.En_Write_Reg			(T_En_Write_Reg),
		.JMP_BR_flag			(T_JMP_BR_flag),
		.Mem_Read				(T_Mem_Read),
		.Mem_Write				(T_Mem_Write));
	
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
		
		T_En_Pipeline = 1'b1;
		T_instruction = 32'd0;
		
		T_STG25_En_Write_Reg = 1'b0;
		T_STG25_addr_Write_Reg = 5'd0;
		T_STG25_data_in = 32'd0;
		#20;
		
		T_reset = 1'b0;
		#10;
		T_STG25_En_Write_Reg = 1'b1;
		
		T_STG25_addr_Write_Reg = 5'd2;
		T_STG25_data_in = 32'd2;
		#20;
		T_STG25_addr_Write_Reg = 5'd3;
		T_STG25_data_in = 32'd3;
		#40;
		T_STG25_data_in = 32'd0;
		T_STG25_En_Write_Reg = 1'b0;
		
		T_instruction = 32'h221804; // add
		#20;
		T_instruction = 32'h221805; // sub
		#20;
		T_instruction = 32'h221806; // mul
		#20;
		T_instruction = 32'h221807; // div
		#20;
		T_instruction = 32'h221808; // and
		#20;
		T_instruction = 32'h221809; // or
		#20;
		T_instruction = 32'h22180a; // nor
		#20;
		T_instruction = 32'h22180b; // xor
		#20;
		T_instruction = 32'h221818; // sll
		#20;
		T_instruction = 32'h221819; // srl
		#20;
		T_instruction = 32'h22181a; // sla
		#20;
		T_instruction = 32'h22181b; // sra
		#20; // until here TB for R Type instructions (320ns)
		
		T_instruction = 32'h10220005; // addi
		#20;
		T_instruction = 32'h14220005; // subi
		#20;
		T_instruction = 32'h18220005; // muli
		#20;
		T_instruction = 32'h1c220005; // divi
		#20;
		T_instruction = 32'h90220005; // addhi
		#20;
		T_instruction = 32'h94220005; // subhi
		#20;
		T_instruction = 32'h98220005; // mulhi
		#20;
		T_instruction = 32'h9c220005; // divhi
		#20;
		T_instruction = 32'h20220005; // andi
		#20;
		T_instruction = 32'h24220005; // ori
		#20;
		T_instruction = 32'h28220005; // nori
		#20;
		T_instruction = 32'h2c220005; // xori
		#20;
		T_instruction = 32'ha0220005; // andhi
		#20;
		T_instruction = 32'ha4220005; // orhi
		#20;
		T_instruction = 32'ha8220005; // norhi
		#20;
		T_instruction = 32'hac220005; // xorhi
		#20;
		T_instruction = 32'h30430005; // beq
		#20;
		T_instruction = 32'h34430005; // bne
		#20;
		T_instruction = 32'h38430005; // bgt
		#20;
		T_instruction = 32'h3c430005; // ble
		#20;
		T_instruction = 32'h4430005; // ldw
		#20;
		T_instruction = 32'h8430005; // stw
		#20;
		T_instruction = 32'hfc000005; // jmp
		#20;
	end
	
endmodule

// run 780ns