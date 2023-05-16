library ieee;
use ieee.std_logic_1164.all;

entity MIPS is
port(
	reset:	in	std_logic;
	clk:	in	std_logic;
	ProgMode:	in	std_logic;
	Addr_Prog:	in	std_logic_vector(7 downto 0);
	Data_Prog:	in	std_logic_vector(31 downto 0);
	
	Peripheral_Address:	out	std_logic_vector(15 downto 0);
	Peripheral_WData:		out	std_logic_vector(31 downto 0);
	Peripheral_RData:		in		std_logic_vector(31 downto 0);
	Peripheral_Control_Enable:	out	std_logic;
	Peripheral_Control_Write:	out	std_logic;
	
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
		
		Peripheral_Address:	out	std_logic_vector(15 downto 0);
		Peripheral_write:	out	std_logic;
		Peripheral_Enable:	out	std_logic;
		Peripheral_WData:		out	std_logic_vector(31 downto 0);
		
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
		Debug_ALU_Result:			out	std_logic_vector(31 downto 0);
		Peripheral_RData:			in	std_logic_vector(31 downto 0);
		Peripheral_re:				in std_logic);	--Peripheral_Read_Enable
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
	
	signal Peripheral_WData_STG2:	std_logic_vector(31 downto 0);
	signal Peripheral_we:			std_logic;
	signal Peripheral_wr:			std_logic;
	signal Peripheral_en:			std_logic;
	
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
		
		Peripheral_Address	=>	Peripheral_Address,
		Peripheral_write		=>	Peripheral_wr,
		Peripheral_Enable		=>	Peripheral_en,
		Peripheral_WData		=>	Peripheral_WData_STG2,
		
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
	
	Peripheral_Control_Write <= Peripheral_wr;
	Peripheral_Control_Enable <= Peripheral_en;
	Peripheral_we <= Peripheral_wr and Peripheral_en;
	Peripheral_WData <= operand1 when(Peripheral_we = '1')else (others=>'0');
	
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
		Debug_ALU_Result		=>	Debug_ALU_Result,
		Peripheral_RData		=>	Peripheral_RData,
		Peripheral_re			=>	(not Peripheral_wr) and Peripheral_en);
	
	U4:	Stage4 port map(
		reset				=>	reset,
		clk					=>	clk,
		En_Pipeline			=>	En_MEM_WB,
		ALU_Result_in		=>	Data_Mem_Addr_in,
		Addr_Write_Reg_in	=>	addr_write_reg_34,
		En_Write_Reg_in		=>	en_write_reg_34,
		Mem_Read			=>	Mem_Read_34 and (not Debug_En_Prog_Data_Mem),
		Mem_Write			=>	Mem_Write_34 or Debug_En_Prog_Data_Mem,
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

-- SubModule: Stage1 --

library ieee;
use ieee.std_logic_1164.all;

entity Stage1 is
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
end;

architecture one of Stage1 is
	
	-- / Components \ --
	component PC_Register
	port(
		reset:	in	std_logic;
		clk:	in	std_logic;
		input:	in	std_logic_vector(7 downto 0);
		En:		in	std_logic;
		output:	out	std_logic_vector(7 downto 0));
	end component;
	
	component PC_Adder
	port(
		input:	in	std_logic_vector(7 downto 0);
		output:	out	std_logic_vector(7 downto 0));
	end component;
	
	component Instruction_Memory
	port(
		clk:		in	std_logic;
		R_nW:		in	std_logic;
		addr:		in	std_logic_vector(7 downto 0);
		Data_in:	in	std_logic_vector(31 downto 0);
		Data_out:	out	std_logic_vector(31 downto 0));
	end component;
	
	component IF_ID
	port(
		reset:			in	std_logic;
		clk:			in	std_logic;
		En:				in	std_logic;
		PC_next_in:		in	std_logic_vector(7 downto 0);
		PC_next_out:	out	std_logic_vector(7 downto 0);
		IR_in:			in	std_logic_vector(31 downto 0);
		IR_out:			out	std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal PC_in:					std_logic_vector(7  downto 0);
	signal PC_out:					std_logic_vector(7  downto 0);
	signal PC_next:					std_logic_vector(7  downto 0);
	signal Addr_in:					std_logic_vector(7  downto 0);
	signal Instrutction_Memory_out:	std_logic_vector(31 downto 0);
	signal PC_En:					std_logic;
	signal PC_in_Pipeline:			std_logic_vector(7 downto 0);
	-- / Signals \ --
	
begin
	
	PC_in <= input_JMP_Addr when(BR_JMP_flag_in = '1')else PC_in_Pipeline;
	
	U1:	PC_Register port map(
		reset	=>	reset,
		clk		=>	clk,
		input	=>	PC_in,
		En		=>	PC_En,
		output	=>	PC_out);
	PC_En <= Pipeline_Enable and ProgMode;
	
	U2:	PC_Adder port map(
		input	=>	PC_out,
		output	=>	PC_next);
	
	U3:	Instruction_Memory port map(
		clk			=>	clk,
		R_nW		=>	ProgMode,		-- ProgMode = '1': Read (Run state) | ProgMode = '0': Write (Program Mode)
		addr		=>	Addr_in,
		Data_in		=>	Data_Prog,
		Data_out	=>	Instrutction_Memory_out);
	Addr_in <= PC_out when(ProgMode = '1')else Addr_Prog;
	Instruction_no_pipeline <= Instrutction_Memory_out;
	
	U4:	IF_ID port map(
		reset		=>	reset,
		clk			=>	clk,
		En			=>	Pipeline_Enable,
		PC_next_in	=>	PC_next,
		PC_next_out	=>	PC_in_Pipeline,
		IR_in		=>	Instrutction_Memory_out,
		IR_out		=>	Instruction);
	next_PC <= PC_in_Pipeline;
end;

-- SubModule: PC_Register

library ieee;
use ieee.std_logic_1164.all;

entity PC_Register is
port(
	reset:	in	std_logic;
	clk:	in	std_logic;
	input:	in	std_logic_vector(7 downto 0);
	En:		in	std_logic;
	output:	out	std_logic_vector(7 downto 0));
end;

architecture one of PC_Register is
begin
	process(reset,clk)begin
		if(reset = '1')then
			output <= (others => '0');
		elsif(clk 'event and clk = '0')then
			if(En = '1')then
				output <= input;
			end if;
		end if;
	end process;
end;

-- SubModule: PC_Adder
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_Logic_unsigned.all;

entity PC_Adder is
port(
	input:	in	std_logic_vector(7 downto 0);
	output:	out	std_logic_vector(7 downto 0));
end;

architecture one of PC_Adder is
begin
	output <= input + 1;
end;

-- SubModule: Instruction_Memory
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

entity Instruction_Memory is
port(
	clk:		in	std_logic;
	R_nW:		in	std_logic;
	addr:		in	std_logic_vector(7 downto 0);
	Data_in:	in	std_logic_vector(31 downto 0);
	Data_out:	out	std_logic_vector(31 downto 0));
end;

architecture one of Instruction_Memory is
	type Memory_Block is array (0 to 255) of std_logic_vector(31 downto 0);
	
	signal Memory: Memory_Block;
begin
	process(clk,R_nW,addr)begin
		Data_out <= (others => 'Z');
		if(R_nW = '1')then	-- Read Operation
			Data_out <= Memory(CONV_INTEGER(addr));
		elsif(clk 'event and clk = '1')then
			Memory(CONV_INTEGER(addr)) <= Data_in;
		end if;
	end process;
end;

-- SubModule: IF_ID
library ieee;
use ieee.std_logic_1164.all;
entity IF_ID is
port(
	reset:			in	std_logic;
	clk:			in	std_logic;
	En:				in	std_logic;
	PC_next_in:		in	std_logic_vector(7 downto 0);
	PC_next_out:	out	std_logic_vector(7 downto 0);
	IR_in:			in	std_logic_vector(31 downto 0);
	IR_out:			out	std_logic_vector(31 downto 0));
end;

architecture one of IF_ID is
begin
	process(reset,clk)begin
		if(reset = '1')then
			PC_next_out <= (others => '0');
			IR_out <= (others => '0');
		elsif(clk 'event and clk = '1')then
			if(En = '1')then
				PC_next_out <= PC_next_in;
				IR_out <= IR_in;
			end if;
		end if;
	end process;
end;

-- SubModule: Stage2 --

library ieee;
use ieee.std_logic_1164.all;

entity Stage2 is
port(
	reset:						in	std_logic;
	clk:						in	std_logic;
	En_Pipeline:				in	std_logic;
	instruction:				in	std_logic_vector(31 downto 0);
	STG25_data_in:				in	std_logic_vector(31 downto 0);
	STG25_addr_Write_Reg:		in	std_logic_vector(4  downto 0);
	STG25_En_Write_Reg:			in	std_logic;
	next_PC:					in	std_logic_vector(7  downto 0);
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
	
	Peripheral_Address:	out	std_logic_vector(15 downto 0);
	Peripheral_write:	out	std_logic;
	Peripheral_Enable:	out	std_logic;
	Peripheral_WData:		out	std_logic_vector(31 downto 0);
	
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
end;

architecture one of Stage2 is
	-- / Components \ --
	component Control_Unit
	port(
		instruction:	in	std_logic_vector(31 downto 0);
		Addr_Read_Reg1:	out	std_logic_vector(4  downto 0);
		Addr_Read_Reg2:	out	std_logic_vector(4  downto 0);
		Addr_Write_Reg:	out	std_logic_vector(4  downto 0);
		En_Read_Reg:	out	std_logic;
		En_Write_Reg:	out	std_logic;
		ALU_Op_Code:	out	std_logic_vector(5  downto 0);
		ALU_src:		out	std_logic;
		En_ALU:			out	std_logic;
		En_FPU:			out	std_logic;
		JMP_BR_flag:	out	std_logic;
		Mem_Read:		out	std_logic;
		Mem_Write:		out	std_logic;
		BR_JMP_Addr:	out	std_logic_vector(7 downto 0);
		Call_flag:		out	std_logic;
		Ret_flag:		out	std_logic;
		Peripheral_Address:	out	std_logic_vector(15 downto 0);
		Peripheral_write:	out	std_logic;
		Peripheral_Enable:	out	std_logic);
	end component;
	
	component Register_File
	port(
		reset:			in	std_logic;
		clk:			in	std_logic;
		En_Read:		in	std_logic;
		En_Write:		in	std_logic;
		Addr_Read_Reg1:	in	std_logic_vector(4  downto 0);
		Addr_Read_Reg2:	in	std_logic_vector(4  downto 0);
		Addr_Write_Reg:	in	std_logic_vector(4  downto 0);
		data1:			out	std_logic_vector(31 downto 0);
		data2:			out	std_logic_vector(31 downto 0);
		datain:			in	std_logic_vector(31 downto 0);
		Debug_Reg0:		out	std_logic_vector(31 downto 0);
		Debug_Reg1:		out	std_logic_vector(31 downto 0);
		Debug_Reg2:		out	std_logic_vector(31 downto 0);
		Debug_Reg3:		out	std_logic_vector(31 downto 0);
		Debug_Reg4:		out	std_logic_vector(31 downto 0);
		Debug_Reg5:		out	std_logic_vector(31 downto 0);
		Debug_Reg6:		out	std_logic_vector(31 downto 0);
		Debug_Reg7:		out	std_logic_vector(31 downto 0);
		Debug_Reg8:		out	std_logic_vector(31 downto 0);
		Debug_Reg9:		out	std_logic_vector(31 downto 0);
		Debug_Reg10:	out	std_logic_vector(31 downto 0);
		Debug_Reg11:	out	std_logic_vector(31 downto 0);
		Debug_Reg12:	out	std_logic_vector(31 downto 0);
		Debug_Reg13:	out	std_logic_vector(31 downto 0);
		Debug_Reg14:	out	std_logic_vector(31 downto 0);
		Debug_Reg15:	out	std_logic_vector(31 downto 0);
		Debug_Reg16:	out	std_logic_vector(31 downto 0);
		Debug_Reg17:	out	std_logic_vector(31 downto 0);
		Debug_Reg18:	out	std_logic_vector(31 downto 0);
		Debug_Reg19:	out	std_logic_vector(31 downto 0);
		Debug_Reg20:	out	std_logic_vector(31 downto 0);
		Debug_Reg21:	out	std_logic_vector(31 downto 0);
		Debug_Reg22:	out	std_logic_vector(31 downto 0);
		Debug_Reg23:	out	std_logic_vector(31 downto 0);
		Debug_Reg24:	out	std_logic_vector(31 downto 0);
		Debug_Reg25:	out	std_logic_vector(31 downto 0);
		Debug_Reg26:	out	std_logic_vector(31 downto 0);
		Debug_Reg27:	out	std_logic_vector(31 downto 0);
		Debug_Reg28:	out	std_logic_vector(31 downto 0);
		Debug_Reg29:	out	std_logic_vector(31 downto 0);
		Debug_Reg30:	out	std_logic_vector(31 downto 0);
		Debug_Reg31:	out	std_logic_vector(31 downto 0));
	end component;
	
	component Stack_Memory
	port(
		reset:	in	std_logic;
		clk:	in	std_logic;
		push:	in	std_logic;
		pop:	in	std_logic;
		input:	in	std_Logic_vector(7 downto 0);
		outpt:	out	std_logic_vector(7 downto 0));
	end component;
	
	component ID_EX
	port(
		reset:						in	std_logic;
		clk:						in	std_logic;
		En:							in	std_logic;
		in_data1:					in	std_logic_vector(31 downto 0);
		in_data2:					in	std_logic_vector(31 downto 0);
		in_En_ALU:					in	std_logic;
		in_En_FPU:					in	std_logic;
		in_Addr_Write_Reg:			in	std_logic_vector(4  downto 0);
		in_En_Write_Reg:			in	std_logic;
		in_ALU_Op_Code:				in	std_logic_vector(5  downto 0);
		in_JMP_BR_flag:				in	std_logic;
		in_Mem_Read:				in	std_logic;
		in_Mem_Write:				in	std_logic;
		in_Data_Mem_Write_Data:		in	std_logic_vector(31 downto 0);
		in_BR_JMP_Addr:				in	std_Logic_vector(7 downto 0);
		in_Hazard_Read_Reg1:		in	std_logic_vector(4 downto 0);
		in_Hazard_Read_Reg2:		in	std_logic_vector(4 downto 0);
		
		Peripheral_Address_in:		in	std_logic_vector(15 downto 0);
		Peripheral_write_in:			in	std_logic;
		Peripheral_Enable_in:	in	std_logic;
		Peripheral_WData_in:		in	std_logic_vector(31 downto 0);
		
		out_data1:					out	std_logic_vector(31 downto 0);
		out_data2:					out	std_logic_vector(31 downto 0);
		out_En_ALU:					out	std_logic;
		out_En_FPU:					out	std_logic;
		out_Addr_Write_Reg:			out	std_logic_vector(4  downto 0);
		out_En_Write_Reg:			out	std_logic;
		out_ALU_Op_Code:			out	std_logic_vector(5  downto 0);
		out_JMP_BR_flag:			out	std_logic;
		out_Mem_Read:				out	std_logic;
		out_Mem_Write:				out	std_logic;
		out_Data_Mem_Write_Data:	out	std_logic_vector(31 downto 0);
		out_BR_JMP_Addr:			out	std_Logic_vector(7 downto 0);
		out_Hazard_Read_Reg1:		out	std_logic_vector(4 downto 0);
		out_Hazard_Read_Reg2:		out	std_logic_vector(4 downto 0);
		
		Peripheral_Address_out:		out	std_logic_vector(15 downto 0);
		Peripheral_write_out:		out	std_logic;
		Peripheral_Enable_out:		out	std_logic;
		Peripheral_WData_out:		out	std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal Addr_Read_Reg1:				std_logic_vector(4  downto 0);
	signal Addr_Read_Reg2:				std_logic_vector(4  downto 0);
	signal pipeline_Addr_Write_Reg:		std_logic_vector(4  downto 0);
	signal pipeline_En_Write_Reg:		std_logic;
	signal pipeline_ALU_Op_Code:		std_logic_vector(5  downto 0);
	signal pipeline_JMP_BR_flag:		std_logic;
	signal pipeline_Mem_Read:			std_logic;
	signal pipeline_Mem_Write:			std_logic;
	signal En_Read_Reg:					std_logic;
	signal ALU_src:						std_logic;
	signal Reg1_data:					std_logic_vector(31 downto 0);
	signal Reg2_data:					std_logic_vector(31 downto 0);
	signal pipeline_in_data2:			std_logic_vector(31 downto 0);
	signal zero_16bit:					std_logic_vector(15 downto 0);
	signal pipeline_BR_JMP_Addr:		std_logic_vector(7  downto 0);
	signal BR_JMP_Addr_Control_Unit:	std_logic_vector(7  downto 0);
	signal pipeline_En_ALU:	std_logic;
	signal pipeline_En_FPU:	std_logic;
	
	signal push:			std_logic;
	signal pop:				std_logic;
	signal Stack_Mem_out:	std_logic_vector(7 downto 0);
	signal Stack_flag:		std_logic;
	
	signal Peripheral_we:	std_logic;	-- Peripheral write enable
	
	signal per_wr:	std_logic;
	signal per_en:	std_logic;
	
	signal Peripheral_Address_pipeline_in:	std_logic_vector(15 downto 0);
	signal Peripheral_WData_pipeline_in:	std_logic_vector(31 downto 0);
	-- / Signals \ --
	
begin
	
	U1:	Control_Unit port map(
		instruction		=>	instruction,
		Addr_Read_Reg1	=>	Addr_Read_Reg1,
		Addr_Read_Reg2	=>	Addr_Read_Reg2,
		Addr_Write_Reg	=>	pipeline_Addr_Write_Reg,
		En_Read_Reg		=>	En_Read_Reg,
		En_Write_Reg	=>	pipeline_En_Write_Reg,
		ALU_Op_Code		=>	pipeline_ALU_Op_Code,
		ALU_src			=>	ALU_src,
		En_ALU			=>	pipeline_En_ALU,
		En_FPU			=>	pipeline_En_FPU,
		JMP_BR_flag		=>	pipeline_JMP_BR_flag,
		Mem_Read		=>	pipeline_Mem_Read,
		Mem_Write		=>	pipeline_Mem_Write,
		BR_JMP_Addr		=>	BR_JMP_Addr_Control_Unit,
		Call_flag		=>	push,
		Ret_flag		=>	pop,
		Peripheral_Address	=>	Peripheral_Address_pipeline_in,
		Peripheral_write		=>	per_wr,
		Peripheral_Enable		=>	per_en);
	
	Peripheral_we <= per_wr and per_en;
	Peripheral_WData_pipeline_in <= Reg1_data when(Peripheral_we = '1')else (others=>'0');	-- NOTE: Regx_data (?)
	
	U2:	Register_File port map(
		reset			=>	reset,
		clk				=>	clk,
		En_Read			=>	En_Read_Reg,
		En_Write		=>	STG25_En_Write_Reg,
		Addr_Read_Reg1	=>	Addr_Read_Reg1,
		Addr_Read_Reg2	=>	Addr_Read_Reg2,
		Addr_Write_Reg	=>	STG25_addr_Write_Reg,
		data1			=>	Reg1_data,
		data2			=>	Reg2_data,
		datain			=>	STG25_data_in,
		
		Debug_Reg0		=>	Debug_Reg0,
		Debug_Reg1		=>	Debug_Reg1,
		Debug_Reg2		=>	Debug_Reg2,
		Debug_Reg3		=>	Debug_Reg3,
		Debug_Reg4		=>	Debug_Reg4,
		Debug_Reg5		=>	Debug_Reg5,
		Debug_Reg6		=>	Debug_Reg6,
		Debug_Reg7		=>	Debug_Reg7,
		Debug_Reg8		=>	Debug_Reg8,
		Debug_Reg9		=>	Debug_Reg9,
		Debug_Reg10		=>	Debug_Reg10,
		Debug_Reg11		=>	Debug_Reg11,
		Debug_Reg12		=>	Debug_Reg12,
		Debug_Reg13		=>	Debug_Reg13,
		Debug_Reg14		=>	Debug_Reg14,
		Debug_Reg15		=>	Debug_Reg15,
		Debug_Reg16		=>	Debug_Reg16,
		Debug_Reg17		=>	Debug_Reg17,
		Debug_Reg18		=>	Debug_Reg18,
		Debug_Reg19		=>	Debug_Reg19,
		Debug_Reg20		=>	Debug_Reg20,
		Debug_Reg21		=>	Debug_Reg21,
		Debug_Reg22		=>	Debug_Reg22,
		Debug_Reg23		=>	Debug_Reg23,
		Debug_Reg24		=>	Debug_Reg24,
		Debug_Reg25		=>	Debug_Reg25,
		Debug_Reg26		=>	Debug_Reg26,
		Debug_Reg27		=>	Debug_Reg27,
		Debug_Reg28		=>	Debug_Reg28,
		Debug_Reg29		=>	Debug_Reg29,
		Debug_Reg30		=>	Debug_Reg30,
		Debug_Reg31		=>	Debug_Reg31);
	
	U3: Stack_Memory port map(
		reset	=>	reset,
		clk		=>	clk,
		push	=>	push,
		pop		=>	pop,
		input	=>	next_PC,
		outpt	=>	Stack_Mem_out);
	
	Stack_flag <= pop;
	pipeline_BR_JMP_Addr <= Stack_Mem_out when(Stack_flag = '1')else BR_JMP_Addr_Control_Unit;
	
	U4:	ID_EX port map(
		reset					=>	reset,
		clk						=>	clk,
		En						=>	En_Pipeline,
		in_data1				=>	Reg1_data,
		in_data2				=>	pipeline_in_data2,
		in_En_ALU				=>	pipeline_En_ALU,
		in_En_FPU				=>	pipeline_En_FPU,
		in_Addr_Write_Reg		=>	pipeline_Addr_Write_Reg,
		in_En_Write_Reg			=>	pipeline_En_Write_Reg,
		in_ALU_Op_Code			=>	pipeline_ALU_Op_Code,
		in_JMP_BR_flag			=>	pipeline_JMP_BR_flag,
		in_Mem_Read				=>	pipeline_Mem_Read,
		in_Mem_Write			=>	pipeline_Mem_Write,
		in_Data_Mem_Write_Data	=>	Reg2_data,
		in_BR_JMP_Addr			=>	pipeline_BR_JMP_Addr,
		in_Hazard_Read_Reg1		=>	Addr_Read_Reg1,
		in_Hazard_Read_Reg2		=>	Addr_Read_Reg2,
		
		Peripheral_Address_in	=>	Peripheral_Address_pipeline_in,
		Peripheral_write_in		=>	per_wr,
		Peripheral_Enable_in		=>	per_en,
		Peripheral_WData_in		=>	Peripheral_WData_pipeline_in,
		
		out_data1				=>	ALU_operand1,
		out_data2				=>	ALU_operand2,
		out_En_ALU				=>	En_ALU,
		out_En_FPU				=>	En_FPU,
		out_Addr_Write_Reg		=>	Addr_Write_Reg,
		out_En_Write_Reg		=>	En_Write_Reg,
		out_ALU_Op_Code			=>	opcode,
		out_JMP_BR_flag			=>	JMP_BR_flag,
		out_Mem_Read			=>	Mem_Read,
		out_Mem_Write			=>	Mem_Write,
		out_Data_Mem_Write_Data	=>	Data_Mem_Write_Data,
		out_BR_JMP_Addr			=>	BR_JMP_Addr,
		out_Hazard_Read_Reg1	=>	Hazard_Read_Addr1,
		out_Hazard_Read_Reg2	=>	Hazard_Read_Addr2,
		
		Peripheral_Address_out	=>	Peripheral_Address,
		Peripheral_write_out		=>	Peripheral_write,
		Peripheral_Enable_out	=>	Peripheral_Enable,
		Peripheral_WData_out		=>	Peripheral_WData);
		
		
	pipeline_in_data2 <= Reg2_data when(ALU_src  = '1')else zero_16bit & instruction(15 downto 0);
	zero_16bit <= (others => '0');
	
	BR_JMP_flag_no_Pipeline <= pipeline_JMP_BR_flag;
	
end;

-- SubModule: Register_File

library ieee;
use ieee.std_logic_1164.all;

entity Register_File is
port(
	reset:			in	std_logic;
	clk:			in	std_logic;
	En_Read:		in	std_logic;
	En_Write:		in	std_logic;
	Addr_Read_Reg1:	in	std_logic_vector(4  downto 0);
	Addr_Read_Reg2:	in	std_logic_vector(4  downto 0);
	Addr_Write_Reg:	in	std_logic_vector(4  downto 0);
	data1:			out	std_logic_vector(31 downto 0);
	data2:			out	std_logic_vector(31 downto 0);
	datain:			in	std_logic_vector(31 downto 0);
	
	Debug_Reg0:		out	std_logic_vector(31 downto 0);
	Debug_Reg1:		out	std_logic_vector(31 downto 0);
	Debug_Reg2:		out	std_logic_vector(31 downto 0);
	Debug_Reg3:		out	std_logic_vector(31 downto 0);
	Debug_Reg4:		out	std_logic_vector(31 downto 0);
	Debug_Reg5:		out	std_logic_vector(31 downto 0);
	Debug_Reg6:		out	std_logic_vector(31 downto 0);
	Debug_Reg7:		out	std_logic_vector(31 downto 0);
	Debug_Reg8:		out	std_logic_vector(31 downto 0);
	Debug_Reg9:		out	std_logic_vector(31 downto 0);
	Debug_Reg10:	out	std_logic_vector(31 downto 0);
	Debug_Reg11:	out	std_logic_vector(31 downto 0);
	Debug_Reg12:	out	std_logic_vector(31 downto 0);
	Debug_Reg13:	out	std_logic_vector(31 downto 0);
	Debug_Reg14:	out	std_logic_vector(31 downto 0);
	Debug_Reg15:	out	std_logic_vector(31 downto 0);
	Debug_Reg16:	out	std_logic_vector(31 downto 0);
	Debug_Reg17:	out	std_logic_vector(31 downto 0);
	Debug_Reg18:	out	std_logic_vector(31 downto 0);
	Debug_Reg19:	out	std_logic_vector(31 downto 0);
	Debug_Reg20:	out	std_logic_vector(31 downto 0);
	Debug_Reg21:	out	std_logic_vector(31 downto 0);
	Debug_Reg22:	out	std_logic_vector(31 downto 0);
	Debug_Reg23:	out	std_logic_vector(31 downto 0);
	Debug_Reg24:	out	std_logic_vector(31 downto 0);
	Debug_Reg25:	out	std_logic_vector(31 downto 0);
	Debug_Reg26:	out	std_logic_vector(31 downto 0);
	Debug_Reg27:	out	std_logic_vector(31 downto 0);
	Debug_Reg28:	out	std_logic_vector(31 downto 0);
	Debug_Reg29:	out	std_logic_vector(31 downto 0);
	Debug_Reg30:	out	std_logic_vector(31 downto 0);
	Debug_Reg31:	out	std_logic_vector(31 downto 0));
end;

architecture one of Register_File is

	-- / Components \ --
	component Register_File_Multiplexer
	port(
		selector:	in	std_logic_vector(4  downto 0);
		Reg0:		in	std_logic_vector(31 downto 0);
		Reg1:		in	std_logic_vector(31 downto 0);
		Reg2:		in	std_logic_vector(31 downto 0);
		Reg3:		in	std_logic_vector(31 downto 0);
		Reg4:		in	std_logic_vector(31 downto 0);
		Reg5:		in	std_logic_vector(31 downto 0);
		Reg6:		in	std_logic_vector(31 downto 0);
		Reg7:		in	std_logic_vector(31 downto 0);
		Reg8:		in	std_logic_vector(31 downto 0);
		Reg9:		in	std_logic_vector(31 downto 0);
		Reg10:		in	std_logic_vector(31 downto 0);
		Reg11:		in	std_logic_vector(31 downto 0);
		Reg12:		in	std_logic_vector(31 downto 0);
		Reg13:		in	std_logic_vector(31 downto 0);
		Reg14:		in	std_logic_vector(31 downto 0);
		Reg15:		in	std_logic_vector(31 downto 0);
		Reg16:		in	std_logic_vector(31 downto 0);
		Reg17:		in	std_logic_vector(31 downto 0);
		Reg18:		in	std_logic_vector(31 downto 0);
		Reg19:		in	std_logic_vector(31 downto 0);
		Reg20:		in	std_logic_vector(31 downto 0);
		Reg21:		in	std_logic_vector(31 downto 0);
		Reg22:		in	std_logic_vector(31 downto 0);
		Reg23:		in	std_logic_vector(31 downto 0);
		Reg24:		in	std_logic_vector(31 downto 0);
		Reg25:		in	std_logic_vector(31 downto 0);
		Reg26:		in	std_logic_vector(31 downto 0);
		Reg27:		in	std_logic_vector(31 downto 0);
		Reg28:		in	std_logic_vector(31 downto 0);
		Reg29:		in	std_logic_vector(31 downto 0);
		Reg30:		in	std_logic_vector(31 downto 0);
		Reg31:		in	std_logic_vector(31 downto 0);
		outpt:		out	std_logic_vector(31 downto 0));
	end component;
	
	component Rgister_File_Decoder
	generic(N:	integer := 2);
	port(
		inpt:	in	std_logic_vector(N-1 downto 0);
		outpt:	out	std_logic_vector((2**N)-1 downto 0));
	end component;
	
	component Register_File_Register
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		En:		in	std_logic;
		inpt:	in	std_logic_vector(31 downto 0);
		outpt:	out	std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --

	-- / Signals \ --
	signal Mux_in0:		std_logic_vector(31 downto 0);
	signal Mux_in1:		std_logic_vector(31 downto 0);
	signal Mux_in2:		std_logic_vector(31 downto 0);
	signal Mux_in3:		std_logic_vector(31 downto 0);
	signal Mux_in4:		std_logic_vector(31 downto 0);
	signal Mux_in5:		std_logic_vector(31 downto 0);
	signal Mux_in6:		std_logic_vector(31 downto 0);
	signal Mux_in7:		std_logic_vector(31 downto 0);
	signal Mux_in8:		std_logic_vector(31 downto 0);
	signal Mux_in9:		std_logic_vector(31 downto 0);
	signal Mux_in10:	std_logic_vector(31 downto 0);
	signal Mux_in11:	std_logic_vector(31 downto 0);
	signal Mux_in12:	std_logic_vector(31 downto 0);
	signal Mux_in13:	std_logic_vector(31 downto 0);
	signal Mux_in14:	std_logic_vector(31 downto 0);
	signal Mux_in15:	std_logic_vector(31 downto 0);
	signal Mux_in16:	std_logic_vector(31 downto 0);
	signal Mux_in17:	std_logic_vector(31 downto 0);
	signal Mux_in18:	std_logic_vector(31 downto 0);
	signal Mux_in19:	std_logic_vector(31 downto 0);
	signal Mux_in20:	std_logic_vector(31 downto 0);
	signal Mux_in21:	std_logic_vector(31 downto 0);
	signal Mux_in22:	std_logic_vector(31 downto 0);
	signal Mux_in23:	std_logic_vector(31 downto 0);
	signal Mux_in24:	std_logic_vector(31 downto 0);
	signal Mux_in25:	std_logic_vector(31 downto 0);
	signal Mux_in26:	std_logic_vector(31 downto 0);
	signal Mux_in27:	std_logic_vector(31 downto 0);
	signal Mux_in28:	std_logic_vector(31 downto 0);
	signal Mux_in29:	std_logic_vector(31 downto 0);
	signal Mux_in30:	std_logic_vector(31 downto 0);
	signal Mux_in31:	std_logic_vector(31 downto 0);
	signal En_Reg:		std_logic_vector(31 downto 0);
	signal sEn_Read:	std_logic_vector(31 downto 0);
	signal sdata1:		std_logic_vector(31 downto 0);
	signal sdata2:		std_logic_vector(31 downto 0);
	
	signal Reg_En:		std_logic_vector(31 downto 0);
	-- / Signals \ --

begin
	sEn_Read <= (others => En_Read);
	U1:	Rgister_File_Decoder generic map(5) port map(Addr_Write_Reg,En_Reg);
	
	U2:	Register_File_Multiplexer port map(
		Addr_Read_Reg1,
		Mux_in0,Mux_in1,Mux_in2,Mux_in3,Mux_in4,
		Mux_in5,Mux_in6,Mux_in7,Mux_in8,Mux_in9,
		
		Mux_in10,Mux_in11,Mux_in12,Mux_in13,Mux_in14,
		Mux_in15,Mux_in16,Mux_in17,Mux_in18,Mux_in19,
		
		Mux_in20,Mux_in21,Mux_in22,Mux_in23,Mux_in24,
		Mux_in25,Mux_in26,Mux_in27,Mux_in28,Mux_in29,
		
		Mux_in30,Mux_in31,
		
		sdata1);
	
	U3:	Register_File_Multiplexer port map(
		Addr_Read_Reg2,
		Mux_in0,Mux_in1,Mux_in2,Mux_in3,Mux_in4,
		Mux_in5,Mux_in6,Mux_in7,Mux_in8,Mux_in9,
		
		Mux_in10,Mux_in11,Mux_in12,Mux_in13,Mux_in14,
		Mux_in15,Mux_in16,Mux_in17,Mux_in18,Mux_in19,
		
		Mux_in20,Mux_in21,Mux_in22,Mux_in23,Mux_in24,
		Mux_in25,Mux_in26,Mux_in27,Mux_in28,Mux_in29,
		
		Mux_in30,Mux_in31,
		
		sdata2);
	
	data1 <= sEn_Read and sdata1;
	data2 <= sEn_Read and sdata2;
	
	Gen:for i in 0 to 31 Generate
		Reg_En(i) <= En_Write and En_Reg(i);
	end Generate;
	
	Reg0:	Register_File_Register port map(clk,reset,Reg_En(0),(others => '0'),Mux_in0);
	Reg1:	Register_File_Register port map(clk,reset,Reg_En(1),datain,Mux_in1);
	Reg2:	Register_File_Register port map(clk,reset,Reg_En(2),datain,Mux_in2);
	Reg3:	Register_File_Register port map(clk,reset,Reg_En(3),datain,Mux_in3);
	Reg4:	Register_File_Register port map(clk,reset,Reg_En(4),datain,Mux_in4);
	Reg5:	Register_File_Register port map(clk,reset,Reg_En(5),datain,Mux_in5);
	Reg6:	Register_File_Register port map(clk,reset,Reg_En(6),datain,Mux_in6);
	Reg7:	Register_File_Register port map(clk,reset,Reg_En(7),datain,Mux_in7);
	Reg8:	Register_File_Register port map(clk,reset,Reg_En(8),datain,Mux_in8);
	Reg9:	Register_File_Register port map(clk,reset,Reg_En(9),datain,Mux_in9);
	Reg10:	Register_File_Register port map(clk,reset,Reg_En(10),datain,Mux_in10);
	Reg11:	Register_File_Register port map(clk,reset,Reg_En(11),datain,Mux_in11);
	Reg12:	Register_File_Register port map(clk,reset,Reg_En(12),datain,Mux_in12);
	Reg13:	Register_File_Register port map(clk,reset,Reg_En(13),datain,Mux_in13);
	Reg14:	Register_File_Register port map(clk,reset,Reg_En(14),datain,Mux_in14);
	Reg15:	Register_File_Register port map(clk,reset,Reg_En(15),datain,Mux_in15);
	Reg16:	Register_File_Register port map(clk,reset,Reg_En(16),datain,Mux_in16);
	Reg17:	Register_File_Register port map(clk,reset,Reg_En(17),datain,Mux_in17);
	Reg18:	Register_File_Register port map(clk,reset,Reg_En(18),datain,Mux_in18);
	Reg19:	Register_File_Register port map(clk,reset,Reg_En(19),datain,Mux_in19);
	Reg20:	Register_File_Register port map(clk,reset,Reg_En(20),datain,Mux_in20);
	Reg21:	Register_File_Register port map(clk,reset,Reg_En(21),datain,Mux_in21);
	Reg22:	Register_File_Register port map(clk,reset,Reg_En(22),datain,Mux_in22);
	Reg23:	Register_File_Register port map(clk,reset,Reg_En(23),datain,Mux_in23);
	Reg24:	Register_File_Register port map(clk,reset,Reg_En(24),datain,Mux_in24);
	Reg25:	Register_File_Register port map(clk,reset,Reg_En(25),datain,Mux_in25);
	Reg26:	Register_File_Register port map(clk,reset,Reg_En(26),datain,Mux_in26);
	Reg27:	Register_File_Register port map(clk,reset,Reg_En(27),datain,Mux_in27);
	Reg28:	Register_File_Register port map(clk,reset,Reg_En(28),datain,Mux_in28);
	Reg29:	Register_File_Register port map(clk,reset,Reg_En(29),datain,Mux_in29);
	Reg30:	Register_File_Register port map(clk,reset,Reg_En(30),datain,Mux_in30);
	Reg31:	Register_File_Register port map(clk,reset,Reg_En(31),datain,Mux_in31);
	
	Debug_Reg0 <= Mux_in0;
	Debug_Reg1 <= Mux_in1;
	Debug_Reg2 <= Mux_in2;
	Debug_Reg3 <= Mux_in3;
	Debug_Reg4 <= Mux_in4;
	Debug_Reg5 <= Mux_in5;
	Debug_Reg6 <= Mux_in6;
	Debug_Reg7 <= Mux_in7;
	Debug_Reg8 <= Mux_in8;
	Debug_Reg9 <= Mux_in9;
	Debug_Reg10 <= Mux_in10;
	Debug_Reg11 <= Mux_in11;
	Debug_Reg12 <= Mux_in12;
	Debug_Reg13 <= Mux_in13;
	Debug_Reg14 <= Mux_in14;
	Debug_Reg15 <= Mux_in15;
	Debug_Reg16 <= Mux_in16;
	Debug_Reg17 <= Mux_in17;
	Debug_Reg18 <= Mux_in18;
	Debug_Reg19 <= Mux_in19;
	Debug_Reg20 <= Mux_in20;
	Debug_Reg21 <= Mux_in21;
	Debug_Reg22 <= Mux_in22;
	Debug_Reg23 <= Mux_in23;
	Debug_Reg24 <= Mux_in24;
	Debug_Reg25 <= Mux_in25;
	Debug_Reg26 <= Mux_in26;
	Debug_Reg27 <= Mux_in27;
	Debug_Reg28 <= Mux_in28;
	Debug_Reg29 <= Mux_in29;
	Debug_Reg30 <= Mux_in30;
	Debug_Reg31 <= Mux_in31;
end;

-- SubModule: Rgister_File_Decoder --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Rgister_File_Decoder is
generic(N:	integer := 2);
port(
	inpt:	in	std_logic_vector(N-1 downto 0);
	outpt:	out	std_logic_vector((2**N)-1 downto 0));
end;

architecture one of Rgister_File_Decoder is
begin
	process(inpt)begin
		outpt <= (others=>'0');
		outpt(CONV_INTEGER(inpt)) <= '1';
	end process;
end;

-- SubModule: Register_File_Multiplexer --

library ieee;
use ieee.std_logic_1164.all;

entity Register_File_Multiplexer is
port(
	selector:	in	std_logic_vector(4  downto 0);
	Reg0:		in	std_logic_vector(31 downto 0);
	Reg1:		in	std_logic_vector(31 downto 0);
	Reg2:		in	std_logic_vector(31 downto 0);
	Reg3:		in	std_logic_vector(31 downto 0);
	Reg4:		in	std_logic_vector(31 downto 0);
	Reg5:		in	std_logic_vector(31 downto 0);
	Reg6:		in	std_logic_vector(31 downto 0);
	Reg7:		in	std_logic_vector(31 downto 0);
	Reg8:		in	std_logic_vector(31 downto 0);
	Reg9:		in	std_logic_vector(31 downto 0);
	Reg10:		in	std_logic_vector(31 downto 0);
	Reg11:		in	std_logic_vector(31 downto 0);
	Reg12:		in	std_logic_vector(31 downto 0);
	Reg13:		in	std_logic_vector(31 downto 0);
	Reg14:		in	std_logic_vector(31 downto 0);
	Reg15:		in	std_logic_vector(31 downto 0);
	Reg16:		in	std_logic_vector(31 downto 0);
	Reg17:		in	std_logic_vector(31 downto 0);
	Reg18:		in	std_logic_vector(31 downto 0);
	Reg19:		in	std_logic_vector(31 downto 0);
	Reg20:		in	std_logic_vector(31 downto 0);
	Reg21:		in	std_logic_vector(31 downto 0);
	Reg22:		in	std_logic_vector(31 downto 0);
	Reg23:		in	std_logic_vector(31 downto 0);
	Reg24:		in	std_logic_vector(31 downto 0);
	Reg25:		in	std_logic_vector(31 downto 0);
	Reg26:		in	std_logic_vector(31 downto 0);
	Reg27:		in	std_logic_vector(31 downto 0);
	Reg28:		in	std_logic_vector(31 downto 0);
	Reg29:		in	std_logic_vector(31 downto 0);
	Reg30:		in	std_logic_vector(31 downto 0);
	Reg31:		in	std_logic_vector(31 downto 0);
	outpt:		out	std_logic_vector(31 downto 0));
end;

architecture one of Register_File_Multiplexer is
begin
	with selector select outpt <= 
	Reg0	when	"00000",	-- 0
	Reg1	when	"00001",	-- 1
	Reg2	when	"00010",	-- 2
	Reg3	when	"00011",	-- 3
	Reg4	when	"00100",	-- 4
	Reg5	when	"00101",	-- 5
	Reg6	when	"00110",	-- 6
	Reg7	when	"00111",	-- 7
	Reg8	when	"01000",	-- 8
	Reg9	when	"01001",	-- 9
	Reg10	when	"01010",	-- 10
	Reg11	when	"01011",	-- 11
	Reg12	when	"01100",	-- 12
	Reg13	when	"01101",	-- 13
	Reg14	when	"01110",	-- 14
	Reg15	when	"01111",	-- 15
	Reg16	when	"10000",	-- 16
	Reg17	when	"10001",	-- 17
	Reg18	when	"10010",	-- 18
	Reg19	when	"10011",	-- 19
	Reg20	when	"10100",	-- 20
	Reg21	when	"10101",	-- 21
	Reg22	when	"10110",	-- 22
	Reg23	when	"10111",	-- 23
	Reg24	when	"11000",	-- 24
	Reg25	when	"11001",	-- 25
	Reg26	when	"11010",	-- 26
	Reg27	when	"11011",	-- 27
	Reg28	when	"11100",	-- 28
	Reg29	when	"11101",	-- 29
	Reg30	when	"11110",	-- 30
	Reg31	when	others;	-- 31
end;

-- Submodule: Register_File_Register --

library ieee;
use ieee.std_logic_1164.all;

entity Register_File_Register is
port(
	clk:	in	std_logic;
	reset:	in	std_logic;
	En:		in	std_logic;
	inpt:	in	std_logic_vector(31 downto 0);
	outpt:	out	std_logic_vector(31 downto 0));
end;

architecture one of Register_File_Register is
begin
	process(clk,reset)begin
		if (reset = '1') then
			outpt <= (others => '0');
		elsif (clk 'event and clk = '0')then
			if(En = '1')then
				outpt <= inpt;
			end if;
		end if;
	end process;
end;

-- SubModule: Control_Unit

library ieee;
use ieee.std_logic_1164.all;

entity Control_Unit is
port(
	instruction:	in	std_logic_vector(31 downto 0);
	Addr_Read_Reg1:	out	std_logic_vector(4  downto 0);
	Addr_Read_Reg2:	out	std_logic_vector(4  downto 0);
	Addr_Write_Reg:	out	std_logic_vector(4  downto 0);
	En_Read_Reg:	out	std_logic;
	En_Write_Reg:	out	std_logic;
	ALU_Op_Code:	out	std_logic_vector(5  downto 0);
	ALU_src:		out	std_logic;
	En_ALU:			out	std_logic;
	En_FPU:			out	std_logic;
	JMP_BR_flag:	out	std_logic;
	Mem_Read:		out	std_logic;
	Mem_Write:		out	std_logic;
	BR_JMP_Addr:	out	std_Logic_vector(7 downto 0);
	Call_flag:		out	std_logic;
	Ret_flag:		out	std_logic;
	Peripheral_Address:	out	std_logic_vector(15 downto 0);
	Peripheral_write:	out	std_logic;
	Peripheral_Enable:	out	std_logic);
end;

architecture one of Control_Unit is
	-- / Components\ --
	component Control_Unit_Decoder
	port(
		input:	in	std_Logic_vector(5 downto 0);
		output:	out	std_Logic_vector(63 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal opcode:				std_logic_vector(5  downto 0);
	signal instruction_opcode:	std_logic_vector(5  downto 0);
	signal operation_opcode:	std_logic_vector(5  downto 0);
	signal R_Type:				std_logic;
	signal decode_opcode:		std_logic_vector(63 downto 0);
	signal ALU_src2:			std_logic;
	signal BR_JMP_indicator:	std_logic;
	signal sEn_FPU:			std_logic;
	-- / Signals \ --
	
begin

	instruction_opcode	<= instruction(31 downto 26);
	
	operation_opcode	<= instruction_opcode when(R_Type = '0')else instruction(5 downto 0);
	
	U:	Control_Unit_Decoder port map(
		input	=>	operation_opcode,
		output	=>	decode_opcode);
	
	En_ALU <= not sEn_FPU;
	En_FPU <= sEn_FPU;
	sEn_FPU <= R_Type and (decode_opcode(0) or decode_opcode(1) or decode_opcode(2) or decode_opcode(3));
	
	R_Type <= not (instruction_opcode(0) or instruction_opcode(1) or instruction_opcode(2) or
				   instruction_opcode(3) or instruction_opcode(4) or instruction_opcode(5));
	
	ALU_Op_Code <= operation_opcode;
	ALU_src  <= R_Type or decode_opcode(12) or decode_opcode(13) or decode_opcode(14) or decode_opcode(15);
	ALU_src2 <= decode_opcode(12) or decode_opcode(13) or decode_opcode(14) or decode_opcode(15);
	
	Addr_Read_Reg1 <= instruction(20 downto 16); -- rs
	
	Addr_Read_Reg2 <= instruction(15 downto 11)when(R_Type = '1')else
					  instruction(25 downto 21)when(ALU_src2='1')else
					  instruction(25 downto 21)when(decode_opcode(2) = '1')else
					  (others=>'0');
	
	Addr_Write_Reg <= instruction(25 downto 21) when(BR_JMP_indicator = '0')else "00000";
	
	BR_JMP_indicator <= decode_opcode(12) or decode_opcode(13) or decode_opcode(14) or decode_opcode(15) or
						decode_opcode(63) or decode_opcode(62) or decode_opcode(61);
	
	En_Read_Reg  <= '0' when (operation_opcode = "111111")else '1';
	En_Write_Reg <= not (decode_opcode(2) or BR_JMP_indicator) or decode_opcode(57);	-- add peripheral opcode
	Mem_Read	<= decode_opcode(1) and (not R_Type);
	Mem_Write	<= decode_opcode(2) and (not R_Type);
	
	BR_JMP_Addr <= instruction(7 downto 0)when(BR_JMP_indicator = '1')else(others => '0');
	
	JMP_BR_flag <= BR_JMP_indicator;
	Call_flag <= decode_opcode(62);
	Ret_flag  <= decode_opcode(61);
	
	Peripheral_Enable <= decode_opcode(56) or decode_opcode(57);
	Peripheral_write <= decode_opcode(56);
	
	Peripheral_Address <= instruction(15 downto 0);
end;

-- SubModule: Control_Unit_Decoder:
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_Logic_unsigned.all;

entity Control_Unit_Decoder is
port(
	input:	in	std_Logic_vector(5 downto 0);
	output:	out	std_Logic_vector(63 downto 0));
end;

architecture one of Control_Unit_Decoder is
begin
	process(input)begin
		output <= (others => '0');
		output(CONV_INTEGER(input)) <= '1';
	end process;
end;

-- SubModule: Stack_Memory --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Stack_Memory is
port(
	reset:	in	std_logic;
	clk:	in	std_logic;
	push:	in	std_logic;
	pop:	in	std_logic;
	input:	in	std_Logic_vector(7 downto 0);
	outpt:	out	std_logic_vector(7 downto 0));
end;

architecture one of Stack_Memory is
	
	component Stack_Pointer
	port(
		reset:	in	std_logic;
		clk:	in	std_logic;
		push:	in	std_logic;
		pop:	in	std_logic;
		outpt:	out	std_logic_vector(7 downto 0));
	end component;
	
	type t_Mem is array(0 to 255) of std_Logic_vector(7 downto 0);
	signal memory: t_Mem;
	signal address:	std_logic_vector(7 downto 0);
	
begin
	
	U:	Stack_Pointer port map(
		reset	=>	reset,
		clk		=>	clk,
		push	=>	push,
		pop		=>	pop,
		outpt	=>	address);
	
	process(push,pop,clk,address)begin
		outpt <= (others=>'Z');
		if(pop = '1')then -- Read_from Memory
			outpt <= memory(conv_integer(address));
		elsif(clk 'event and clk = '1')then
			if(push = '1')then
				memory(conv_integer(address)) <= input;
			end if;
		end if;
	end process;
end;

-- SubModule: Stack_Pointer --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Stack_Pointer is
port(
	reset:	in	std_logic;
	clk:	in	std_logic;
	push:	in	std_logic;
	pop:	in	std_logic;
	outpt:	out	std_logic_vector(7 downto 0));
end;

architecture one of Stack_Pointer is
	signal sout:	std_logic_vector(7 downto 0);
begin
	outpt <= sout;
	process(reset,clk)begin
		if(reset = '1')then
			sout <= (others => '0');
		elsif(clk 'event and clk = '0')then
			if(pop = '1')then
				sout <= sout - 1;
			elsif(push = '1')then
				sout <= sout + 1;
			end if;
		end if;
	end process;
end;

-- SubModule: ID_EX
library ieee;
use ieee.std_Logic_1164.all;

entity ID_EX is
port(
	reset:						in	std_logic;
	clk:						in	std_logic;
	En:							in	std_logic;
	in_data1:					in	std_logic_vector(31 downto 0);
	in_data2:					in	std_logic_vector(31 downto 0);
	in_En_ALU:					in	std_logic;
	in_En_FPU:					in	std_logic;
	in_Addr_Write_Reg:			in	std_logic_vector(4  downto 0);
	in_En_Write_Reg:			in	std_logic;
	in_ALU_Op_Code:				in	std_logic_vector(5  downto 0);
	in_JMP_BR_flag:				in	std_logic;
	in_Mem_Read:				in	std_logic;
	in_Mem_Write:				in	std_logic;
	in_Data_Mem_Write_Data:		in	std_logic_vector(31 downto 0);
	in_BR_JMP_Addr:				in	std_Logic_vector(7 downto 0);
	in_Hazard_Read_Reg1:		in	std_logic_vector(4 downto 0);
	in_Hazard_Read_Reg2:		in	std_logic_vector(4 downto 0);
	
	Peripheral_Address_in:		in	std_logic_vector(15 downto 0);
	Peripheral_write_in:			in	std_logic;
	Peripheral_Enable_in:	in	std_logic;
	Peripheral_WData_in:		in	std_logic_vector(31 downto 0);
	
	out_data1:					out	std_logic_vector(31 downto 0);
	out_data2:					out	std_logic_vector(31 downto 0);
	out_En_ALU:					out	std_logic;
	out_En_FPU:					out	std_logic;
	out_Addr_Write_Reg:			out	std_logic_vector(4  downto 0);
	out_En_Write_Reg:			out	std_logic;
	out_ALU_Op_Code:			out	std_logic_vector(5  downto 0);
	out_JMP_BR_flag:			out	std_logic;
	out_Mem_Read:				out	std_logic;
	out_Mem_Write:				out	std_logic;
	out_Data_Mem_Write_Data:	out	std_logic_vector(31 downto 0);
	out_BR_JMP_Addr:			out	std_Logic_vector(7 downto 0);
	out_Hazard_Read_Reg1:		out	std_logic_vector(4 downto 0);
	out_Hazard_Read_Reg2:		out	std_logic_vector(4 downto 0);
	
	Peripheral_Address_out:		out	std_logic_vector(15 downto 0);
	Peripheral_write_out:		out	std_logic;
	Peripheral_Enable_out:		out	std_logic;
	Peripheral_WData_out:		out	std_logic_vector(31 downto 0));
end;

architecture one of ID_EX is
begin
	process(reset,clk)begin
		if(reset = '1')then
			out_data1				<=	(others=>'0');
			out_data2				<=	(others=>'0');
			out_Addr_Write_Reg		<=	(others=>'0');
			out_En_Write_Reg		<=	'0';
			out_ALU_Op_Code			<=	(others=>'0');
			out_JMP_BR_flag			<=	'0';
			out_Mem_Read			<=	'0';
			out_Mem_Write			<=	'0';
			out_Data_Mem_Write_Data	<=	(others => '0');
			out_BR_JMP_Addr			<=	(others => '0');
			out_Hazard_Read_Reg1	<=	(others=>'0');
			out_Hazard_Read_Reg2	<=	(others=>'0');
			out_En_ALU				<=	'0';
			out_En_FPU				<=	'0';
			Peripheral_Address_out <= (others=>'0');
			Peripheral_WData_out <= (others => '0');
			Peripheral_Enable_out <= '0';
			Peripheral_write_out <= '0';
		elsif(clk 'event and clk = '1')then
			if(En = '1')then
				out_data1				<=	in_data1;
				out_data2				<=	in_data2;
				out_Addr_Write_Reg		<=	in_Addr_Write_Reg;
				out_En_Write_Reg		<=	in_En_Write_Reg;
				out_ALU_Op_Code			<=	in_ALU_Op_Code;
				out_JMP_BR_flag			<=	in_JMP_BR_flag;
				out_Mem_Read			<=	in_Mem_Read;
				out_Mem_Write			<=	in_Mem_Write;
				out_Data_Mem_Write_Data	<=	in_Data_Mem_Write_Data;
				out_BR_JMP_Addr			<=	in_BR_JMP_Addr;
				out_Hazard_Read_Reg1	<=	in_Hazard_Read_Reg1;
				out_Hazard_Read_Reg2	<=	in_Hazard_Read_Reg2;
				out_En_ALU				<=	in_En_ALU;
				out_En_FPU				<=	in_En_FPU;
				Peripheral_Address_out <= Peripheral_Address_in;
				Peripheral_WData_out <= Peripheral_WData_in;
				Peripheral_Enable_out <= Peripheral_Enable_in;
				Peripheral_write_out <= Peripheral_write_in;
			end if;
		end if;
	end process;
end;

-- SubModule: Stage3 --

library ieee;
use ieee.std_logic_1164.all;

entity Stage3 is
port(
	reset:						in	std_logic;
	clk:						in	std_logic;
	En_Pipeline:				in	std_logic;
	operand1:					in	std_logic_vector(31 downto 0);
	operand2:					in	std_logic_vector(31 downto 0);
	Op_Code:					in	std_logic_vector(5  downto 0);
	En_ALU:						in	std_logic;
	En_FPU:						in	std_logic;
	Addr_Write_Reg_in:			in	std_logic_vector(4 downto 0);
	En_Write_Reg_in:			in	std_logic;
	Mem_Read_in:				in	std_logic;
	Mem_Write_in:				in	std_logic;
	Data_Mem_Write_Data_in:		in	std_logic_vector(31 downto 0);
	BR_JMP_flag_in:			in	std_logic;
	BR_JMP_Addr_in:			in	std_logic_vector(7 downto 0);
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
	Debug_ALU_Result:			out	std_logic_vector(31 downto 0);
	Peripheral_RData:			in	std_logic_vector(31 downto 0);
	Peripheral_re:				in std_logic);
end;

architecture one of Stage3 is
	
	-- / Components \ --
	component ALU
	port(
		reset:	in	std_logic;
		clk:	in	std_logic;
		BR_JMP_flag:	in	std_logic;
		inpt1:in	std_logic_vector(31 downto 0);
		inpt2:in	std_logic_vector(31 downto 0);
		outpt:out	std_logic_vector(31 downto 0);
		Op_Code:in	std_logic_vector(5 downto 0);
		En:in	std_logic;
		BR_flag:	out	std_logic);
	end component;
	
	component EX_MEM
	port(
		reset:						in	std_logic;
		clk:						in	std_logic;
		En:							in	std_logic;
		ALU_Result_in:				in	std_logic_vector(31 downto 0);
		Addr_Write_Reg_in:			in	std_logic_vector(4  downto 0);
		En_Write_Reg_in:			in	std_logic;
		Mem_Read_in:				in	std_logic;
		Mem_Write_in:				in	std_logic;
		Data_Mem_Write_Data_in:		in	std_logic_vector(31 downto 0);
		BR_JMP_flag_in:		in	std_logic;
		BR_JMP_Addr_in:		in	std_logic_vector(7 downto 0);
		ALU_Result_out:				out	std_logic_vector(31 downto 0);
		Addr_Write_Reg_out:			out	std_logic_vector(4  downto 0);
		En_Write_Reg_out:			out	std_logic;
		Mem_Read_out:				out	std_logic;
		Mem_Write_out:				out	std_logic;
		Data_Mem_Write_Data_out:	out	std_logic_vector(31 downto 0);
		BR_JMP_flag_out:		out	std_logic;
		BR_JMP_Addr_out:		out	std_logic_vector(7 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal pipeline_ALU_Result:	std_logic_vector(31 downto 0);
	signal pipeline_BR_JMP_flag:	std_logic;
	-- / Signals \ --
	
	signal sALU_Result:	std_logic_vector(31 downto 0);
	signal sFPU_Result:	std_logic_vector(31 downto 0);
	
begin
	
	pipeline_ALU_Result <= Peripheral_RData when(Peripheral_re = '1')else
								  sALU_Result when(En_ALU = '1')else sFPU_Result;
	
	U1:	ALU port map(
		reset	=>	reset,
		clk		=>	clk,
		BR_JMP_flag	=>	BR_JMP_flag_in,
		inpt1	=>	operand1,
		inpt2	=>	operand2,
		outpt	=>	sALU_Result,
		Op_Code	=>	Op_Code,
		En		=>	En_ALU,
		BR_flag	=>	pipeline_BR_JMP_flag);
	
	U2: EX_MEM port map(
		reset					=>	reset,
		clk						=>	clk,
		En						=>	En_Pipeline,
		ALU_Result_in			=>	pipeline_ALU_Result,
		Addr_Write_Reg_in		=>	Addr_Write_Reg_in,
		En_Write_Reg_in			=>	En_Write_Reg_in,
		Mem_Read_in				=>	Mem_Read_in,
		Mem_Write_in			=>	Mem_Write_in,
		Data_Mem_Write_Data_in	=>	Data_Mem_Write_Data_in,
		BR_JMP_flag_in			=>	pipeline_BR_JMP_flag,
		BR_JMP_Addr_in			=>	BR_JMP_Addr_in,
		ALU_Result_out			=>	ALU_result,
		Addr_Write_Reg_out		=>	Addr_Write_Reg_out,
		En_Write_Reg_out		=>	En_Write_Reg_out,
		Mem_Read_out			=>	Mem_Read_out,
		Mem_Write_out			=>	Mem_Write_out,
		Data_Mem_Write_Data_out	=>	Data_Mem_Write_Data_out,
		BR_JMP_flag_out		=>	BR_JMP_flag_out,
		BR_JMP_Addr_out		=>	BR_JMP_Addr_out);
	
	Debug_Operand1 <= operand1;
	Debug_Operand2 <= operand2;
	Debug_ALU_Result <= sALU_Result;
end;

-- SubModule: ALU --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ALU is
port(
	reset:	in	std_logic;
	clk:	in	std_logic;
	BR_JMP_flag:	in	std_logic;
	inpt1:in	std_logic_vector(31 downto 0);
	inpt2:in	std_logic_vector(31 downto 0);
	outpt:out	std_logic_vector(31 downto 0);
	Op_Code:in	std_logic_vector(5 downto 0);
	En:in	std_logic;
	BR_flag:	out	std_logic);
end;

architecture one of ALU is
	
	-- / Components \ --
	component Division
	generic(Bits:integer:=32);
	port(
		dividend:	in	std_logic_vector(Bits-1 downto 0);
		divisor:	in	std_logic_vector(Bits-1 downto 0);
		Q:			out	std_logic_vector(Bits-1 downto 0);
		reminder:	out	std_logic_vector(Bits-1 downto 0));
	end component;
	
	component ShiftRegister
	port(
		inpt1:	in	std_logic_vector(4 downto 0);
		inpt2:	in	std_logic_vector(31 downto 0);
		AL:		in	std_logic;						--	AL - Arithmetic (1) / Logic (0)
		RL:		in	std_logic;						--	RL - Right (1) / Left (0)
		outpt:	out	std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal zero:			std_logic_vector(15 downto 0);
	signal mul:				std_logic_vector(63 downto 0);
	signal mulh:			std_logic_vector(63 downto 0);
	signal div_result:		std_logic_vector(31 downto 0);
	signal sel:				std_logic;
	signal divisor:			std_logic_vector(31 downto 0);
	signal ShiftReg_out:	std_logic_vector(31 downto 0);
	signal signal_AL:		std_logic;
	signal signal_RL:		std_logic;
	signal Shift_En:		std_logic;
	signal out_div:			std_logic;
	signal soutpt:			std_logic_vector(31 downto 0);
	signal mul_sel:			std_logic;
	signal mulh_sel:		std_logic;
	
	signal beq_flag:	std_logic;
	signal bne_flag:	std_logic;
	signal bgt_flag:	std_logic;
	signal ble_flag:	std_logic;
	-- / Signals \ --
	
begin

	U1: Division generic map(32) port map(
		dividend	=>	inpt2,
		divisor		=>	divisor,
		Q			=>	div_result,
		reminder	=>	open);
		
	U2:	ShiftRegister port map(
		inpt1	=>	inpt2(4 downto 0),
		inpt2	=>	inpt1,
		AL		=>	signal_AL,
		RL		=>	signal_RL,
		outpt	=>	ShiftReg_out);
	
	sel <= Op_Code(5);
	zero <= (others => '0');
	divisor <= inpt1(15 downto 0)&zero when(sel='1')else inpt1;
	
	mul	 <= inpt1 * inpt2;
	mulh <= (inpt1(15 downto 0)&zero) * inpt2;
	
	process(inpt1,inpt2,En,Op_Code)begin
		
		mul_sel <= '0';
		mulh_sel <= '0';
		out_div <= '0';
		Shift_En <= '0';
		soutpt <= (others => '0');
		signal_AL <= '0';
		signal_RL <= '0';
		
		if(En = '1')then
			case(Op_Code)is
				when "000001" => soutpt <= inpt1 + inpt2;
				when "000010" => soutpt <= inpt1 + inpt2;
				when "000100" => soutpt <= inpt1 + inpt2;									-- ADD
				when "000101" => soutpt <= inpt1 - inpt2;									-- SUB
				when "000110" => mul_sel <= '1';											-- MUL
				when "000111" => out_div <= '1';											-- DIV
				when "001000" => soutpt <= inpt1 and inpt2;									-- AND
				when "001001" => soutpt <= inpt1 or  inpt2;									-- OR
				when "001010" => soutpt <= inpt1 nor inpt2;									-- NOR
				when "001011" => soutpt <= inpt1 xor inpt2;									-- XOR
				when "011000" => Shift_En <= '1'; signal_AL <= '0'; signal_RL <= '0';		-- SLL
				when "011001" => Shift_En <= '1'; signal_AL <= '0'; signal_RL <= '1';		-- SRL
				when "011010" => Shift_En <= '1'; signal_AL <= '1'; signal_RL <= '0';		-- SLA
				when "011011" => Shift_En <= '1'; signal_AL <= '1'; signal_RL <= '1';		-- SRA
				when "100100" => soutpt <= inpt1 + (inpt2(15 downto 0)&zero);				-- ADDHI
				when "100101" => soutpt <= inpt2 - (inpt1(15 downto 0)&zero);				-- SUBHI
				when "100110" => mulh_sel <= '1';											-- MULHI
				when "100111" => out_div <= '1';											-- DIVHI
				when "101000" => soutpt <= inpt1(15 downto 0)&zero and inpt2;				-- ANDHI
				when "101001" => soutpt <= inpt1(15 downto 0)&zero or  inpt2;				-- ORHI
				when "101010" => soutpt <= inpt1(15 downto 0)&zero nor inpt2;				-- NORHI
				when "101011" => soutpt <= inpt1(15 downto 0)&zero xor inpt2;				-- XORHI
				when others=> soutpt <= (others => '0');
			end case;
		else
			soutpt <= (others => '0');
		end if;
		
		beq_flag <= '0';
		bne_flag <= '0';
		bgt_flag <= '0';
		ble_flag <= '0';
		
		case(Op_Code)is
			when "001100"	=>
				if(inpt1 = inpt2)then
					beq_flag <= '1';
				else
					beq_flag <= '0';
				end if;
			when "001101"	=>
				if(inpt1 /= inpt2)then
					bne_flag <= '1';
				else
					bne_flag <= '0';
				end if;
			when "001110"	=>
				if(inpt1 > inpt2)then
					bgt_flag <= '1';
				else
					bgt_flag <= '0';
				end if;
			when "001111"	=>
				if(inpt1 < inpt2)then
					ble_flag <= '1';
				else
					ble_flag <= '0';
				end if;
			when "111111"	=>	beq_flag <= '1'; bne_flag <= '1'; bgt_flag <= '1'; ble_flag <= '1';
			when others		=>	beq_flag <= '1'; bne_flag <= '1'; bgt_flag <= '1'; ble_flag <= '1';
		end case;
		
	end process;
	BR_flag <= (beq_flag or bne_flag or bgt_flag or ble_flag) and (BR_JMP_flag);
	
				
	outpt <= ShiftReg_out when(Shift_En = '1')else 
			 div_result when(out_div = '1')else
			 mul(31 downto 0)when(mul_sel = '1')else
			 mulh(31 downto 0)when(mulh_sel = '1')else
			 soutpt;
	
end;

-- SubModule: Division --

library ieee;
use ieee.std_logic_1164.all;

entity Division is
generic(Bits:integer:=32);
port(
	dividend:	in	std_logic_vector(Bits-1 downto 0);
	divisor:	in	std_logic_vector(Bits-1 downto 0);
	Q:			out	std_logic_vector(Bits-1 downto 0);
	reminder:	out	std_logic_vector(Bits-1 downto 0));
end;

architecture one of Division is
	
	type sigarr is array (0 to Bits) of std_logic_vector(Bits-1 downto 0);
	
	-- / Components \ --
	component Half_Divide
	generic(Bits:integer:=4);
	port(
		Xin:	in	std_logic_vector(Bits-1 downto 0);
		A:		in	std_logic;
		B:		in	std_logic_vector(Bits-1 downto 0);
		Xout:	out	std_logic_vector(Bits-1 downto 0);
		result:	out	std_logic);
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal sQ:			std_logic_vector(Bits-1 downto 0);
	signal Xout:	sigarr;
	-- / Signals \ --
	
begin
	Q <= not sQ;
	
	Xout(0) <= (others => '0');
	
	Gen:for i in 0 to Bits-1 Generate
		U:	Half_Divide generic map(Bits) port map(
			Xin		=>	Xout(i),
			A		=>	dividend(Bits-1-i),
			B		=>	divisor,
			Xout	=>	Xout(i+1),
			result	=>	sQ(Bits-1-i));
	end Generate;
	
	reminder <= Xout(Bits);
end;

-- SubModule: Half_Divide --

library ieee;
use ieee.std_logic_1164.all;

entity Half_Divide is
generic(Bits:integer:=4);
port(
	Xin:	in	std_logic_vector(Bits-1 downto 0);
	A:		in	std_logic;
	B:		in	std_logic_vector(Bits-1 downto 0);
	Xout:	out	std_logic_vector(Bits-1 downto 0);
	result:	out	std_logic);
end;

architecture one of Half_Divide is
	-- / Components \ --
	component Mux
	generic(Bits:integer:=4);
	port(
		in0:	in	std_logic_vector(Bits-1 downto 0);
		in1:	in	std_logic_vector(Bits-1 downto 0);
		sel:	in	std_logic;
		outpt:	out	std_logic_vector(Bits-1 downto 0));
	end component;
	
	component n_Bits_Subtractor	-- diff = A - B
	generic(Bits:integer:=4);
	port(
		A:		in	std_logic_vector(Bits-1 downto 0);
		B:		in	std_logic_vector(Bits-1 downto 0);
		Bin:	in	std_logic;
		diff:	out	std_logic_vector(Bits-1 downto 0);
		Bout:	out	std_logic);
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal Q:		std_logic;
	signal in0:		std_logic_vector(Bits-1 downto 0);
	signal concat:	std_logic_vector(Bits-1 downto 0);
	-- / Signals \ --
	
	
begin
	concat <= Xin(Bits-2 downto 0) & A;
	U1: Mux generic map(Bits) port map(
		in0		=>	in0,
		in1		=>	concat,
		sel		=>	Q,
		outpt	=>	Xout);
	U2:	n_Bits_Subtractor generic map(Bits) port map(
		A		=>	concat,
		B		=>	B,
		Bin		=>	'0',
		diff	=>	in0,
		Bout	=>	Q);
	result <= Q;
end;

-- SubModule: Mux --
library ieee;
use ieee.std_logic_1164.all;

entity Mux is
generic(Bits:integer:=3);
port(
	in0:	in	std_logic_vector(Bits-1 downto 0);
	in1:	in	std_logic_vector(Bits-1 downto 0);
	sel:	in	std_logic;
	outpt:	out	std_logic_vector(Bits-1 downto 0));
end;

architecture one of Mux is
begin
	outpt <= in1 when(sel = '1')else in0;
end;

-- SubModule: Subtractor --
library ieee;
use ieee.std_logic_1164.all;

entity Subtractor is	-- diff = A - B
port(
	A:		in	std_logic;
	B:		in	std_logic;
	Bin:	in	std_logic;	-- Borrow in
	diff:	out	std_logic;
	Bout:	out	std_logic);	-- Borrow out
end;

architecture one of Subtractor is
begin
	diff <= A xor B xor Bin;
	Bout <= ((not A)and B) or ((not A)and Bin) or (B and Bin);
end;

-- SubModule: n_Bits_Subtractor --

library ieee;
use ieee.std_logic_1164.all;

entity n_Bits_Subtractor is	-- diff = A - B
generic(Bits:integer:=4);
port(
	A:		in	std_logic_vector(Bits-1 downto 0);
	B:		in	std_logic_vector(Bits-1 downto 0);
	Bin:	in	std_logic;
	diff:	out	std_logic_vector(Bits-1 downto 0);
	Bout:	out	std_logic);
end;

architecture one of n_Bits_Subtractor is

	-- / Components \ --
	component Subtractor	-- diff = A - B
	port(
		A:		in	std_logic;
		B:		in	std_logic;
		Bin:	in	std_logic;	-- Borrow in
		diff:	out	std_logic;
		Bout:	out	std_logic);	-- Borrow out
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal Borrow:	std_logic_vector(Bits downto 0);
	-- / Signals \ --
begin
	Gen:for i in 0 to Bits-1 Generate
		Sub:	Subtractor port map(A(i),B(i),Borrow(i),diff(i),Borrow(i+1));
	end Generate;
	Borrow(0) <= Bin;
	Bout <= Borrow(Bits);
end;

-- SubModule: ShiftRegister --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ShiftRegister is
port(
	inpt1:	in	std_logic_vector(4 downto 0);
	inpt2:	in	std_logic_vector(31 downto 0);
	AL:		in	std_logic;						--	AL - Arithmetic (1) / Logic (0)
	RL:		in	std_logic;						--	RL - Right (1) / Left (0)
	outpt:	out	std_logic_vector(31 downto 0));
end;

architecture one of ShiftRegister is

	signal zero:	std_logic_vector(31 downto 0);
	signal mode:	std_logic_vector(1  downto 0);

begin
	
	mode <= AL & RL;
	zero <= (others => '0');
	
	process(inpt1,inpt2,mode)begin
		outpt <= (others => '0');
		if(inpt1 = "00000")then
			outpt <= inpt2;
		else
			for i in 1 to 31 loop
				if(CONV_INTEGER(inpt1) = i)then
					case(mode)is
						when "00"	=> outpt <= inpt2(31-i downto 0)&zero(i-1 downto 0);			-- Logic Left
						when "01"	=> outpt <= zero(i-1 downto 0)&inpt2(31 downto i);				-- Logic Right
						when "10"	=> outpt <= inpt2(31)&inpt2(30-i downto 0)&zero(i-1 downto 0);	-- Arithmetic Left
						when others	=> outpt <= inpt2(31)&zero(i-2 downto 0)&inpt2(31 downto i);	-- Arithmetic Right
					end case;
				end if;
			end loop;
		end if;
	end process;
end;

-- SubModule: EX_MEM --

library ieee;
use ieee.std_logic_1164.all;

entity EX_MEM is
port(
	reset:						in	std_logic;
	clk:						in	std_logic;
	En:							in	std_logic;
	ALU_Result_in:				in	std_logic_vector(31 downto 0);
	Addr_Write_Reg_in:			in	std_logic_vector(4  downto 0);
	En_Write_Reg_in:			in	std_logic;
	Mem_Read_in:				in	std_logic;
	Mem_Write_in:				in	std_logic;
	Data_Mem_Write_Data_in:		in	std_logic_vector(31 downto 0);
	BR_JMP_flag_in:			in	std_logic;
	BR_JMP_Addr_in:			in	std_logic_vector(7 downto 0);
	ALU_Result_out:				out	std_logic_vector(31 downto 0);
	Addr_Write_Reg_out:			out	std_logic_vector(4  downto 0);
	En_Write_Reg_out:			out	std_logic;
	Mem_Read_out:				out	std_logic;
	Mem_Write_out:				out	std_logic;
	Data_Mem_Write_Data_out:	out	std_logic_vector(31 downto 0);
	BR_JMP_flag_out:		out	std_Logic;
	BR_JMP_Addr_out:			out std_logic_vector(7 downto 0));
end;

architecture one of EX_MEM is
begin
	process(reset,clk)begin
		if(reset = '1')then
			ALU_Result_out			<=	(others => '0');
			Addr_Write_Reg_out		<=	(others => '0');
			En_Write_Reg_out		<=	'0';
			Mem_Read_out			<=	'0';
			Mem_Write_out			<=	'0';
			Data_Mem_Write_Data_out	<=	(others => '0');
			BR_JMP_Addr_out 		<=	(others => '0');
			BR_JMP_flag_out 		<=	'0';
		elsif(clk 'event and clk  = '1')then
			if(En = '1')then
				ALU_Result_out			<=	ALU_Result_in;
				Addr_Write_Reg_out		<=	Addr_Write_Reg_in;
				En_Write_Reg_out		<=	En_Write_Reg_in;
				Mem_Read_out			<=	Mem_Read_in;
				Mem_Write_out			<=	Mem_Write_in;
				Data_Mem_Write_Data_out <= Data_Mem_Write_Data_in;
				BR_JMP_Addr_out <= BR_JMP_Addr_in;
				BR_JMP_flag_out 		<= BR_JMP_flag_in;
			end if;
		end if;
	end process;
	
end;

-- SubModule: Stage4 --

library ieee;
use ieee.std_logic_1164.all;

entity Stage4 is
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
end;

architecture one of Stage4 is
	-- / Components \ --
	component Data_Memory
	port(
		clk:		in	std_logic;
		Mem_Read:		in	std_logic;
		Mem_Write:		in	std_logic;
		addr:		in	std_logic_vector(7 downto 0);
		Data_in:	in	std_logic_vector(31 downto 0);
		Data_out:	out	std_logic_vector(31 downto 0));
	end component;
	
	component MEM_WB
	port(
		reset:				in	std_logic;
		clk:				in	std_logic;
		En:					in	std_logic;
		Mem_Data_in:		in	std_logic_vector(31 downto 0);
		ALU_Data_in:		in	std_logic_vector(31 downto 0);
		En_Write_Reg_in:	in	std_logic;
		Addr_Write_Reg_in:	in	std_logic_vector(4  downto 0);
		Mem_Read:			in	std_logic;
		Mem_Data_out:		out	std_logic_vector(31 downto 0);
		ALU_Data_out:		out	std_logic_vector(31 downto 0);
		En_Write_Reg_out:	out	std_logic;
		Addr_Write_Reg_out:	out	std_logic_vector(4  downto 0);
		selector_out:		out	std_logic);
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal Mem_Data_out:	std_logic_vector(31 downto 0);
	signal En_Peripheral:	std_logic;
	-- / Signals \ --
	
begin
	U1:	Data_Memory port map(
		clk			=>	clk,
		Mem_Read	=>	Mem_Read,
		Mem_Write	=>	Mem_Write,
		addr		=>	ALU_Result_in(7 downto 0),
		Data_in		=>	Data_Mem_Write_Data,
		Data_out	=>	Mem_Data_out);
	Mem_Result_out_No_Pipeline <= Mem_Data_out;
	
	U2:	MEM_WB port map(
		reset				=>	reset,
		clk					=>	clk,
		En					=>	En_Pipeline,
		Mem_Data_in			=>	Mem_Data_out,
		ALU_Data_in			=>	ALU_Result_in,
		En_Write_Reg_in		=>	En_Write_Reg_in,
		Addr_Write_Reg_in	=>	Addr_Write_Reg_in,
		Mem_Read			=>	Mem_Read,
		Mem_Data_out		=>	Mem_Result_out,
		ALU_Data_out		=>	ALU_Result_out,
		En_Write_Reg_out	=>	En_Write_Reg_out,
		Addr_Write_Reg_out	=>	Addr_Write_Reg_out,
		selector_out		=>	selector_out);
end;

-- SubModule: Data_Memory

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Data_Memory is
port(
	clk:		in	std_logic;
	Mem_Read:		in	std_logic;
	Mem_Write:		in	std_logic;
	addr:		in	std_logic_vector(7 downto 0);
	Data_in:	in	std_logic_vector(31 downto 0);
	Data_out:	out	std_logic_vector(31 downto 0));
end;

architecture one of Data_Memory is
	type Memory_Block is array (0 to 255) of std_logic_vector(31 downto 0);
	signal Memory: Memory_Block;
begin
	process(clk,Mem_Read,Mem_Write,addr)begin
		Data_out <= (others => 'Z');
		if(Mem_Read = '1')then	-- Read Operation
			Data_out <= Memory(CONV_INTEGER(addr));
		elsif(clk 'event and clk = '0')then
			if(Mem_Write = '1')then
				Memory(CONV_INTEGER(addr)) <= Data_in;
			end if;
		end if;
	end process;
end;

-- SubModule: MEM_WB --

library ieee;
use ieee.std_logic_1164.all;

entity MEM_WB is
port(
	reset:				in	std_logic;
	clk:				in	std_logic;
	En:					in	std_logic;
	Mem_Data_in:		in	std_logic_vector(31 downto 0);
	ALU_Data_in:		in	std_logic_vector(31 downto 0);
	En_Write_Reg_in:	in	std_logic;
	Addr_Write_Reg_in:	in	std_logic_vector(4  downto 0);
	Mem_Read:			in	std_logic;
	Mem_Data_out:		out	std_logic_vector(31 downto 0);
	ALU_Data_out:		out	std_logic_vector(31 downto 0);
	En_Write_Reg_out:	out	std_logic;
	Addr_Write_Reg_out:	out	std_logic_vector(4  downto 0);
	selector_out:		out	std_logic);
end;

architecture one of MEM_WB is
begin
	process(reset,clk)begin
		if(reset = '1')then
			Mem_Data_out		<=	(others => '0');
			ALU_Data_out		<=	(others => '0');
			En_Write_Reg_out	<=	'0';
			Addr_Write_Reg_out	<=	(others => '0');
			selector_out		<=	'0';
		elsif(clk 'event and clk = '1')then
			if(En = '1')then
				Mem_Data_out		<=	Mem_Data_in;
				ALU_Data_out		<=	ALU_Data_in;
				En_Write_Reg_out	<=	En_Write_Reg_in;
				Addr_Write_Reg_out	<=	Addr_Write_Reg_in;
				selector_out		<=	Mem_Read;
			end if;
		end if;
	end process;
end;

-- SubModule: Stage5 --

library ieee;
use ieee.std_logic_1164.all;

entity Stage5 is
port(
	selector:			in	std_logic;
	Addr_Write_Reg_in:	in	std_logic_vector(4  downto 0);
	En_Write_Reg_in:	in	std_logic;
	ALU_Data:			in	std_logic_vector(31 downto 0);
	Memory_Data:		in	std_logic_vector(31 downto 0);
	Data_out:			out	std_logic_vector(31 downto 0);
	Addr_Write_Reg_out:	out	std_logic_vector(4  downto 0);
	En_Write_Reg_out:	out	std_logic);
end;

architecture one of Stage5 is
begin
	Data_out			<= Memory_Data when(selector = '1')else ALU_Data;
	En_Write_Reg_out	<= En_Write_Reg_in;
	Addr_Write_Reg_out	<= Addr_Write_Reg_in;
end;

-- SubModule: Data_Hazard_Selector --

library ieee;
use ieee.std_logic_1164.all;

entity Data_Hazard_Selector is
port(
	Forward_Read_Addr1:	in		std_logic_vector(4 downto 0);
	Forward_Read_Addr2:	in		std_logic_vector(4 downto 0);
	
	Frwd_Wr_Addr_STG3:	in		std_logic_vector(4 downto 0);
	Frwd_Wr_Addr_STG4:	in		std_logic_vector(4 downto 0);
	
	Mem_Read_STG3:		in		std_logic;
	Mem_Read_STG4:		in		std_logic;
	
	frwd_sel_mem4_op1:	out	std_logic;
	frwd_sel_mem5_op1:	out	std_logic;
	frwd_sel_alu4_op1:	out	std_logic;
	frwd_sel_alu3_op1:	out	std_logic;
	
	frwd_sel_mem4_op2:	out	std_logic;
	frwd_sel_mem5_op2:	out	std_logic;
	frwd_sel_alu4_op2:	out	std_logic;
	frwd_sel_alu3_op2:	out	std_logic);
end;

architecture one of Data_Hazard_Selector is
	signal input:	std_logic_vector(19 downto 0);
begin
	input <= Forward_Read_Addr1 & Forward_Read_Addr2 & Frwd_Wr_Addr_STG3 & Frwd_Wr_Addr_STG4;
	process(input)begin
		
		frwd_sel_mem4_op1	<=	'0';
		frwd_sel_mem5_op1	<=	'0';
		frwd_sel_alu4_op1	<=	'0';
		frwd_sel_alu3_op1	<=	'0';
		frwd_sel_mem4_op2	<=	'0';
		frwd_sel_mem5_op2	<=	'0';
		frwd_sel_alu4_op2	<=	'0';
		frwd_sel_alu3_op2	<=	'0';
		
		if((Frwd_Wr_Addr_STG3 = Forward_Read_Addr1)and(not (Forward_Read_Addr1 = "00000")))then
			if(Mem_Read_STG3 = '1')then
				frwd_sel_mem4_op1 <= '1';
			else
				frwd_sel_alu3_op1 <= '1';
			end if;
		elsif((Frwd_Wr_Addr_STG4 = Forward_Read_Addr1)and(not (Forward_Read_Addr1 = "00000")))then
			if(Mem_Read_STG4 = '1')then
				frwd_sel_mem5_op1 <= '1';
			else
				frwd_sel_alu4_op1 <= '1';
			end if;
		end if;
		if((Frwd_Wr_Addr_STG3 = Forward_Read_Addr2)and(not (Forward_Read_Addr2 = "00000")))then
			if(Mem_Read_STG3 = '1')then
				frwd_sel_mem4_op2 <= '1';
			else
				frwd_sel_alu3_op2 <= '1';
			end if;
		elsif((Frwd_Wr_Addr_STG4 = Forward_Read_Addr2)and(not (Forward_Read_Addr2 = "00000")))then
			if(Mem_Read_STG4 = '1')then
				frwd_sel_mem5_op2 <= '1';
			else
				frwd_sel_alu4_op2 <= '1';
			end if;
		end if;
	end process;
end;

-- SubModule: Control_Hazard_Detection --

library ieee;
use ieee.std_logic_1164.all;

entity Control_Hazard_Detection is
port(
	clk:				in	std_Logic;
	reset:				in	std_Logic;
	BR_JMP_flag_STG2:	in	std_logic;
	mask:				out	std_logic;
	En_IF_ID:			out	std_Logic);
end;

architecture one of Control_Hazard_Detection is
	type state is(s0,s1,s2,s3);
	signal ps,ns:	state;
begin
	process(reset,clk)begin
		if(reset = '1')then
			ps <= s0;
		elsif(clk 'event and clk = '1')then
			ps <= ns;
		end if;
	end process;
	
	process(ps,BR_JMP_flag_STG2)begin
		En_IF_ID <= '1';
		mask <= '1';
		case(ps)is
			when s0 =>
				if(BR_JMP_flag_STG2 = '1')then
					En_IF_ID <= '0';
					ns <= s1;
				else
					ns <= s0;
				end if;
			when s1 =>
				En_IF_ID <= '0';
				ns <= s2;
			when s2 =>
				ns <= s3;
			when s3 => 
				if(BR_JMP_flag_STG2 = '1')then
					En_IF_ID <= '0';
					ns <= s1;
				else
					ns <= s0;
				end if;
				mask <= '0';
				ns <= s0;
		end case;
	end process;
end;
