library ieee;
use ieee.std_logic_1164.all;

entity MIPS is
port(
	reset:	in	std_logic;
	clk:	in	std_logic;
	ProgMode:	in	std_logic;
	Addr_Prog:	in	std_logic_vector(7 downto 0);
	Data_Prog:	in	std_logic_vector(31 downto 0);
	Debug_En_Prog_Data_Mem:	in	std_logic;
	Debug_Mem_Data_out:		out	std_Logic_vector(31 downto 0);
	Debug_Instruction:		out	std_logic_vector(31 downto 0);
	Debug_Reg0:				out	std_logic_vector(31 downto 0);
	Debug_Reg1:				out	std_logic_vector(31 downto 0);
	Debug_Reg2:				out	std_logic_vector(31 downto 0);
	Debug_Reg3:				out	std_logic_vector(31 downto 0);
	Debug_Reg4:				out	std_logic_vector(31 downto 0);
	Debug_Reg5:				out	std_logic_vector(31 downto 0);
	Debug_Reg6:				out	std_logic_vector(31 downto 0);
	Debug_Reg7:				out	std_logic_vector(31 downto 0);
	Debug_Reg8:				out	std_logic_vector(31 downto 0);
	Debug_Reg9:				out	std_logic_vector(31 downto 0);
	Debug_Reg10:			out	std_logic_vector(31 downto 0);
	Debug_Reg11:			out	std_logic_vector(31 downto 0);
	Debug_Reg12:			out	std_logic_vector(31 downto 0);
	Debug_Reg13:			out	std_logic_vector(31 downto 0);
	Debug_Reg14:			out	std_logic_vector(31 downto 0);
	Debug_Reg15:			out	std_logic_vector(31 downto 0);
	Debug_Reg16:			out	std_logic_vector(31 downto 0);
	Debug_Reg17:			out	std_logic_vector(31 downto 0);
	Debug_Reg18:			out	std_logic_vector(31 downto 0);
	Debug_Reg19:			out	std_logic_vector(31 downto 0);
	Debug_Reg20:			out	std_logic_vector(31 downto 0);
	Debug_Reg21:			out	std_logic_vector(31 downto 0);
	Debug_Reg22:			out	std_logic_vector(31 downto 0);
	Debug_Reg23:			out	std_logic_vector(31 downto 0);
	Debug_Reg24:			out	std_logic_vector(31 downto 0);
	Debug_Reg25:			out	std_logic_vector(31 downto 0);
	Debug_Reg26:			out	std_logic_vector(31 downto 0);
	Debug_Reg27:			out	std_logic_vector(31 downto 0);
	Debug_Reg28:			out	std_logic_vector(31 downto 0);
	Debug_Reg29:			out	std_logic_vector(31 downto 0);
	Debug_Reg30:			out	std_logic_vector(31 downto 0);
	Debug_Reg31:			out	std_logic_vector(31 downto 0);
	Debug_Operand1:			out	std_Logic_vector(31 downto 0);
	Debug_Operand2:			out	std_Logic_vector(31 downto 0);
	Debug_ALU_Result:		out	std_logic_vector(31 downto 0));
end;

architecture one of MIPS is

	-- / Components \ --
	component Stage1
	port(
		reset:				in	std_logic;
		clk:				in	std_logic;
		Pipeline_Enable:	in	std_logic;
		ProgMode:			in	std_Logic;
		input_JMP_Addr:		in	std_logic_vector(7 downto 0);
		BR_JMP_flag_in:		in	std_logic;
		Addr_Prog:			in	std_logic_vector(7  downto 0);
		Data_Prog:			in	std_logic_vector(31 downto 0);
		Instruction:		out	std_logic_vector(31 downto 0);
		next_PC:			out	std_logic_vector(7  downto 0);
		Instruction_no_pipeline:	out	std_logic_vector(31 downto 0));
	end component;
	
	component Stage2
	port(
		reset:						in	std_logic;
		clk:						in	std_logic;
		En_Pipeline:				in	std_logic;
		instruction:				in	std_logic_vector(31 downto 0);
		STG25_data_in:				in	std_logic_vector(31 downto 0);
		STG25_addr_Write_Reg:		in	std_logic_vector(4  downto 0);
		STG25_En_Write_Reg:			in	std_logic;
		next_PC:							in	std_logic_vector(7 downto 0);
		ALU_operand1:				out	std_logic_vector(31 downto 0);
		ALU_operand2:				out	std_logic_vector(31 downto 0);
		opcode:						out	std_logic_vector(5  downto 0);
		En_ALU:						out	std_logic;
		En_FPU:						out	std_logic;
		Addr_Write_Reg:				out	std_logic_vector(4  downto 0);
		En_Write_Reg:				out	std_logic;
		JMP_BR_flag:				out	std_Logic;
		Mem_Read:					out	std_logic;
		Mem_Write:					out	std_logic;
		Data_Mem_Write_Data:		out	std_logic_vector(31 downto 0);
		BR_JMP_Addr:				out	std_logic_vector(7  downto 0);
		BR_JMP_flag_no_Pipeline:	out	std_logic;
		Hazard_Read_Addr1:			out	std_Logic_vector(4 downto 0);
		Hazard_Read_Addr2:			out	std_Logic_vector(4 downto 0);
		
		Debug_Reg0:					out	std_logic_vector(31 downto 0);
		Debug_Reg1:					out	std_logic_vector(31 downto 0);
		Debug_Reg2:					out	std_logic_vector(31 downto 0);
		Debug_Reg3:					out	std_logic_vector(31 downto 0);
		Debug_Reg4:					out	std_logic_vector(31 downto 0);
		Debug_Reg5:					out	std_logic_vector(31 downto 0);
		Debug_Reg6:					out	std_logic_vector(31 downto 0);
		Debug_Reg7:					out	std_logic_vector(31 downto 0);
		Debug_Reg8:					out	std_logic_vector(31 downto 0);
		Debug_Reg9:					out	std_logic_vector(31 downto 0);
		Debug_Reg10:				out	std_logic_vector(31 downto 0);
		Debug_Reg11:				out	std_logic_vector(31 downto 0);
		Debug_Reg12:				out	std_logic_vector(31 downto 0);
		Debug_Reg13:				out	std_logic_vector(31 downto 0);
		Debug_Reg14:				out	std_logic_vector(31 downto 0);
		Debug_Reg15:				out	std_logic_vector(31 downto 0);
		Debug_Reg16:				out	std_logic_vector(31 downto 0);
		Debug_Reg17:				out	std_logic_vector(31 downto 0);
		Debug_Reg18:				out	std_logic_vector(31 downto 0);
		Debug_Reg19:				out	std_logic_vector(31 downto 0);
		Debug_Reg20:				out	std_logic_vector(31 downto 0);
		Debug_Reg21:				out	std_logic_vector(31 downto 0);
		Debug_Reg22:				out	std_logic_vector(31 downto 0);
		Debug_Reg23:				out	std_logic_vector(31 downto 0);
		Debug_Reg24:				out	std_logic_vector(31 downto 0);
		Debug_Reg25:				out	std_logic_vector(31 downto 0);
		Debug_Reg26:				out	std_logic_vector(31 downto 0);
		Debug_Reg27:				out	std_logic_vector(31 downto 0);
		Debug_Reg28:				out	std_logic_vector(31 downto 0);
		Debug_Reg29:				out	std_logic_vector(31 downto 0);
		Debug_Reg30:				out	std_logic_vector(31 downto 0);
		Debug_Reg31:				out	std_logic_vector(31 downto 0));
	end component;
	
	component Stage3
	port(
		reset:						in	std_logic;
		clk:						in	std_logic;
		En_Pipeline:				in	std_logic;
		operand1:					in	std_logic_vector(31 downto 0);
		operand2:					in	std_logic_vector(31 downto 0);
		Op_Code:					in	std_logic_vector(5  downto 0);
		En_ALU:						in	std_logic;
		En_FPU:						in	std_Logic;
		Addr_Write_Reg_in:			in	std_logic_vector(4 downto 0);
		En_Write_Reg_in:			in	std_logic;
		Mem_Read_in:				in	std_logic;
		Mem_Write_in:				in	std_logic;
		Data_Mem_Write_Data_in:		in	std_logic_vector(31 downto 0);
		BR_JMP_flag_in:				in	std_logic;
		BR_JMP_Addr_in:				in	std_logic_vector(7 downto 0);
		ALU_result:					out	std_logic_vector(31 downto 0);
		Addr_Write_Reg_out:			out	std_logic_vector(4  downto 0);
		En_Write_Reg_out:			out	std_logic;
		Mem_Read_out:				out	std_logic;
		Mem_Write_out:				out	std_logic;
		Data_Mem_Write_Data_out:	out	std_logic_vector(31 downto 0);
		BR_JMP_flag_out:			out	std_logic;
		BR_JMP_Addr_out:			out	std_logic_vector(7 downto 0);
		
		Debug_Operand1:				out	std_logic_vector(31 downto 0);
		Debug_Operand2:				out	std_logic_vector(31 downto 0);
		Debug_ALU_Result:			out	std_logic_vector(31 downto 0));
	end component;
	
	component Stage4
	port(
		reset:					in	std_logic;
		clk:					in	std_logic;
		En_Pipeline:			in	std_logic;
		ALU_Result_in:			in	std_logic_vector(31 downto 0);
		Addr_Write_Reg_in:		in	std_logic_vector(4  downto 0);
		En_Write_Reg_in:		in	std_logic;
		Mem_Read:				in	std_logic;
		Mem_Write:				in	std_logic;
		Data_Mem_Write_Data:	in	std_logic_vector(31 downto 0);
		ALU_Result_out:			out	std_logic_vector(31 downto 0);
		Mem_Result_out:			out	std_logic_vector(31 downto 0);
		Addr_Write_Reg_out:		out	std_logic_vector(4  downto 0);
		En_Write_Reg_out:		out	std_logic;
		selector_out:			out	std_logic;
		Mem_Result_out_No_Pipeline:	out	std_logic_vector(31 downto 0));
	end component;
	
	component Stage5
	port(
		selector:			in	std_logic;
		Addr_Write_Reg_in:	in	std_logic_vector(4  downto 0);
		En_Write_Reg_in:	in	std_logic;
		ALU_Data:			in	std_logic_vector(31 downto 0);
		Memory_Data:		in	std_logic_vector(31 downto 0);
		Data_out:			out	std_logic_vector(31 downto 0);
		Addr_Write_Reg_out:	out	std_logic_vector(4  downto 0);
		En_Write_Reg_out:	out	std_logic);
	end component;
	
	component Data_Hazard_Selector
	port(
		Forward_Read_Addr1:	in		std_logic_vector(4 downto 0);
		Forward_Read_Addr2:	in		std_logic_vector(4 downto 0);
		
		Frwd_Wr_Addr_STG3:	in		std_logic_vector(4 downto 0);
		Frwd_Wr_Addr_STG4:	in		std_logic_vector(4 downto 0);
		
		Mem_Read_STG3:			in		std_logic;
		Mem_Read_STG4:			in		std_logic;
		
		frwd_sel_mem4_op1:	out	std_logic;
		frwd_sel_mem5_op1:	out	std_logic;
		frwd_sel_alu4_op1:	out	std_logic;
		frwd_sel_alu3_op1:	out	std_logic;
		frwd_sel_mem4_op2:	out	std_logic;
		frwd_sel_mem5_op2:	out	std_Logic;
		frwd_sel_alu4_op2:	out	std_logic;
		frwd_sel_alu3_op2:	out	std_logic);
	end component;
	
	component Control_Hazard_Detection
	port(
		clk:				in	std_Logic;
		reset:				in	std_Logic;
		BR_JMP_flag_STG2:	in	std_logic;
		mask:				out	std_logic;
		En_IF_ID:			out	std_Logic);
	end component;
	
	-- / Components \ --
	
	-- / Signals \ --
	signal Instruction:	std_logic_vector(31 downto 0);
	signal En_IF_ID:		std_logic;
	signal En_ID_EX:		std_logic;
	signal En_EX_MEM:		std_logic;
	signal En_MEM_WB:		std_logic;
	
	signal data_in_25:	std_logic_vector(31 downto 0);
	signal addr_write_reg_25:	std_logic_vector(4 downto 0);
	signal en_write_reg_25:	std_logic;
	
	signal operand1:	std_logic_vector(31 downto 0);
	signal operand2:	std_logic_vector(31 downto 0);
	signal Op_Code:	std_logic_vector(5  downto 0);
	signal addr_write_reg_23:	std_logic_vector(4 downto 0);
	signal en_write_reg_23:		std_logic;
	signal JMP_BR_flag_23:		std_logic;
	signal Mem_Read:	std_logic;
	signal Mem_Write:	std_logic;
	signal Data_Mem_Write_Data:	std_logic_vector(31 downto 0);
	
	signal ALU_result:	std_logic_vector(31 downto 0);
	signal addr_write_reg_34:	std_logic_vector(4 downto 0);
	signal en_write_reg_34:	std_logic;
	signal Mem_Read_34:	std_logic;
	signal Mem_Write_34:	std_logic;
	signal Data_Mem_Write_Data_34:	std_logic_vector(31 downto 0);
	
	signal en_write_reg_45:	std_logic;
	signal Mem_Result_45:	std_logic_vector(31 downto 0);
	signal ALU_Result_45:	std_logic_vector(31 downto 0);
	signal Addr_Write_Reg_45:	std_logic_vector(4 downto 0);
	signal selector:	std_logic;
	
	signal BR_JMP_Addr_23:	std_logic_vector(7 downto 0);
	signal BR_JMP_flag_31:	std_logic;
	signal BR_JMP_Addr_31:	std_logic_vector(7 downto 0);
	signal BR_JMP_flag_STG2:	std_logic;
	signal BR_JMP_flag_in:	std_logic;
	
	signal data_reg1:			std_logic_vector(31 downto 0);
	signal data_reg2:			std_logic_vector(31 downto 0);
	
	-- / Forward Signals \ --
	signal forward_sel_mem4_op1:	std_logic;
	signal forward_sel_mem5_op1:	std_logic;
	signal forward_sel_alu4_op1:	std_logic;
	signal forward_sel_alu3_op1:	std_logic;
	
	
	signal forward_sel_mem4_op2:	std_logic;
	signal forward_sel_mem5_op2:	std_logic;
	signal forward_sel_alu4_op2:	std_logic;
	signal forward_sel_alu3_op2:	std_logic;
	
	signal Forward_Read_Addr1:	std_Logic_vector(4 downto 0);
	signal Forward_Read_Addr2:	std_Logic_vector(4 downto 0);
	-- / Forward Signals \ --
	
	signal Mem_Result_no_pipeline:	std_Logic_vector(31 downto 0);
	signal mask:	std_logic;
	
	-- / Signals \ --
	
	signal En_ALU:	std_logic;
	signal En_FPU:	std_logic;
	
	signal next_PC:	std_Logic_vector(7 downto 0);
	
	signal zero:				std_logic_vector(23 downto 0);
	signal Data_Mem_Addr_in:	std_logic_vector(31 downto 0);
	signal Data_Mem_Data_in:	std_logic_vector(31 downto 0);
begin
	zero <= (others=>'0');
	U1: Stage1 port map(
		reset			=>	reset,
		clk				=>	clk,
		Pipeline_Enable	=>	En_IF_ID,
		ProgMode		=>	ProgMode,
		input_JMP_Addr	=>	BR_JMP_Addr_31,
		BR_JMP_flag_in	=>	BR_JMP_flag_in,
		Addr_Prog		=>	Addr_Prog,
		Data_Prog		=>	Data_Prog,
		Instruction		=>	Instruction,
		next_PC			=>	next_PC,
		Instruction_no_pipeline	=>	Debug_Instruction);
	
	U2:	Stage2 port map(
		reset					=>	reset,
		clk						=>	clk,
		En_Pipeline				=>	En_ID_EX,
		instruction				=>	Instruction,
		STG25_data_in			=>	data_in_25,
		STG25_addr_Write_Reg	=>	addr_write_reg_25,
		STG25_En_Write_Reg		=>	en_write_reg_25,
		next_PC					=>	next_PC,
		ALU_operand1			=>	data_reg1,
		ALU_operand2			=>	data_reg2,
		opcode					=>	Op_Code,
		En_ALU					=>	En_ALU,
		En_FPU					=>	En_FPU,
		Addr_Write_Reg			=>	addr_write_reg_23,
		En_Write_Reg			=>	en_write_reg_23,
		JMP_BR_flag				=>	JMP_BR_flag_23,
		Mem_Read				=>	Mem_Read,
		Mem_Write				=>	Mem_Write,
		Data_Mem_Write_Data		=>	Data_Mem_Write_Data,
		BR_JMP_Addr				=>	BR_JMP_Addr_23,
		BR_JMP_flag_no_Pipeline	=>	BR_JMP_flag_STG2,
		Hazard_Read_Addr1		=>	Forward_Read_Addr1,
		Hazard_Read_Addr2		=>	Forward_Read_Addr2,
		
		Debug_Reg0				=>	Debug_Reg0,
		Debug_Reg1				=>	Debug_Reg1,
		Debug_Reg2				=>	Debug_Reg2,
		Debug_Reg3				=>	Debug_Reg3,
		Debug_Reg4				=>	Debug_Reg4,
		Debug_Reg5				=>	Debug_Reg5,
		Debug_Reg6				=>	Debug_Reg6,
		Debug_Reg7				=>	Debug_Reg7,
		Debug_Reg8				=>	Debug_Reg8,
		Debug_Reg9				=>	Debug_Reg9,
		Debug_Reg10				=>	Debug_Reg10,
		Debug_Reg11				=>	Debug_Reg11,
		Debug_Reg12				=>	Debug_Reg12,
		Debug_Reg13				=>	Debug_Reg13,
		Debug_Reg14				=>	Debug_Reg14,
		Debug_Reg15				=>	Debug_Reg15,
		Debug_Reg16				=>	Debug_Reg16,
		Debug_Reg17				=>	Debug_Reg17,
		Debug_Reg18				=>	Debug_Reg18,
		Debug_Reg19				=>	Debug_Reg19,
		Debug_Reg20				=>	Debug_Reg20,
		Debug_Reg21				=>	Debug_Reg21,
		Debug_Reg22				=>	Debug_Reg22,
		Debug_Reg23				=>	Debug_Reg23,
		Debug_Reg24				=>	Debug_Reg24,
		Debug_Reg25				=>	Debug_Reg25,
		Debug_Reg26				=>	Debug_Reg26,
		Debug_Reg27				=>	Debug_Reg27,
		Debug_Reg28				=>	Debug_Reg28,
		Debug_Reg29				=>	Debug_Reg29,
		Debug_Reg30				=>	Debug_Reg30,
		Debug_Reg31				=>	Debug_Reg31);
	
	U3:	Stage3 port map(
		reset					=>	reset,
		clk						=>	clk,
		En_Pipeline				=>	En_EX_MEM,
		operand1				=>	operand1,
		operand2				=>	operand2,
		Op_Code					=>	Op_Code,
		En_ALU					=>	En_ALU,
		En_FPU					=>	En_FPU,
		Addr_Write_Reg_in		=>	addr_write_reg_23,
		En_Write_Reg_in			=>	en_write_reg_23,
		Mem_Read_in				=>	Mem_Read,
		Mem_Write_in			=>	Mem_Write,
		Data_Mem_Write_Data_in	=>	Data_Mem_Write_Data,
		BR_JMP_flag_in			=>	JMP_BR_flag_23,
		BR_JMP_Addr_in			=>	BR_JMP_Addr_23,
		ALU_result				=>	ALU_result,
		Addr_Write_Reg_out		=>	addr_write_reg_34,
		En_Write_Reg_out		=>	en_write_reg_34,
		Mem_Read_out			=>	Mem_Read_34,
		Mem_Write_out			=>	Mem_Write_34,
		Data_Mem_Write_Data_out	=>	Data_Mem_Write_Data_34,
		BR_JMP_flag_out			=>	BR_JMP_flag_31,
		BR_JMP_Addr_out			=>	BR_JMP_Addr_31,
		Debug_Operand1			=>	Debug_Operand1,
		Debug_Operand2			=>	Debug_Operand2,
		Debug_ALU_Result		=>	Debug_ALU_Result);
	
	U4:	Stage4 port map(
		reset				=>	reset,
		clk					=>	clk,
		En_Pipeline			=>	En_MEM_WB,
		ALU_Result_in		=>	Data_Mem_Addr_in,
		Addr_Write_Reg_in	=>	addr_write_reg_34,
		En_Write_Reg_in		=>	en_write_reg_34,
		Mem_Read			=>	Mem_Read_34,
		Mem_Write			=>	Mem_Write_34,
		Data_Mem_Write_Data	=>	Data_Mem_Data_in,
		ALU_Result_out		=>	ALU_Result_45,
		Mem_Result_out		=>	Mem_Result_45,
		Addr_Write_Reg_out	=>	Addr_Write_Reg_45,
		En_Write_Reg_out	=>	en_write_reg_45,
		selector_out		=>	selector,
		Mem_Result_out_No_Pipeline	=>	Mem_Result_no_pipeline);
	
	Data_Mem_Addr_in <= (zero & Addr_Prog) when(Debug_En_Prog_Data_Mem = '1')else (ALU_result);
	Data_Mem_Data_in <= Data_Prog when(Debug_En_Prog_Data_Mem = '1')else Data_Mem_Write_Data_34;
	Debug_Mem_Data_out <= Mem_Result_no_pipeline;
	
	U5:	Stage5 port map(
		selector			=>	selector,
		Addr_Write_Reg_in	=>	Addr_Write_Reg_45,
		En_Write_Reg_in		=>	en_write_reg_45,
		ALU_Data			=>	ALU_Result_45,
		Memory_Data			=>	Mem_Result_45,
		Data_out			=>	data_in_25,
		Addr_Write_Reg_out	=>	addr_write_reg_25,
		En_Write_Reg_out	=>	en_write_reg_25);

	U6:	Data_Hazard_Selector port map(
		Forward_Read_Addr1	=>	Forward_Read_Addr1,
		Forward_Read_Addr2	=>	Forward_Read_Addr2,
		
		Frwd_Wr_Addr_STG3		=>	addr_write_reg_34,
		Frwd_Wr_Addr_STG4		=>	Addr_Write_Reg_25,--
		
		Mem_Read_STG3			=>	Mem_Read_34,
		Mem_Read_STG4			=>	selector,
		
		frwd_sel_mem4_op1		=>	forward_sel_mem4_op1,
		frwd_sel_mem5_op1		=>	forward_sel_mem5_op1,
		frwd_sel_alu4_op1		=>	forward_sel_alu4_op1,
		frwd_sel_alu3_op1		=>	forward_sel_alu3_op1,
		
		frwd_sel_mem4_op2		=>	forward_sel_mem4_op2,
		frwd_sel_mem5_op2		=>	forward_sel_mem5_op2,
		frwd_sel_alu4_op2		=>	forward_sel_alu4_op2,
		frwd_sel_alu3_op2		=>	forward_sel_alu3_op2);
		
	operand1 <= Mem_Result_no_pipeline when(forward_sel_mem4_op1 = '1')else
				Mem_Result_45 when(forward_sel_mem5_op1 = '1')else
				data_in_25 when(forward_sel_alu4_op1 = '1')else
				ALU_Result when(forward_sel_alu3_op1 = '1')else data_reg1;
				
	operand2 <= Mem_Result_no_pipeline when(forward_sel_mem4_op2 = '1')else
				Mem_Result_45 when(forward_sel_mem5_op2 = '1')else
				data_in_25 when(forward_sel_alu4_op2 = '1')else
				ALU_Result when(forward_sel_alu3_op2 = '1')else data_reg2;
	
	U7:	Control_Hazard_Detection port map(
		clk					=>	clk,
		reset				=>	reset,
		BR_JMP_flag_STG2	=>	BR_JMP_flag_STG2,
		mask				=>	mask,
		En_IF_ID			=>	En_IF_ID);
	
	BR_JMP_flag_in <= BR_JMP_flag_31 and mask;
	En_ID_EX <= '1';
	En_EX_MEM <= '1';
	En_MEM_WB <= '1';
	

	
end;