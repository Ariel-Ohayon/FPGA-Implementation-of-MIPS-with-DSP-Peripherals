library ieee;
use ieee.std_logic_1164.all;

entity MIPS is
port(
	reset:	in	std_logic;
	clk:	in	std_logic;
	ProgMode:	in	std_logic;
	Addr_Prog:	in	std_logic_vector(7 downto 0);
	Data_Prog:	in	std_logic_vector(31 downto 0));
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
		Instruction:		out	std_logic_vector(31 downto 0));
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
		ALU_operand1:				out	std_logic_vector(31 downto 0);
		ALU_operand2:				out	std_logic_vector(31 downto 0);
		opcode:						out	std_logic_vector(5  downto 0);
		Addr_Write_Reg:				out	std_logic_vector(4  downto 0);
		En_Write_Reg:				out	std_logic;
		JMP_BR_flag:				out	std_Logic;
		Mem_Read:					out	std_logic;
		Mem_Write:					out	std_logic;
		Data_Mem_Write_Data:		out	std_logic_vector(31 downto 0);
		BR_JMP_Addr:				out	std_logic_vector(7  downto 0);
		BR_JMP_flag_no_Pipeline:	out	std_logic;
		Hazard_Read_Addr1:			out	std_Logic_vector(4 downto 0);
		Hazard_Read_Addr2:			out	std_Logic_vector(4 downto 0));
	end component;
	
	component Stage3
	port(
		reset:						in	std_logic;
		clk:						in	std_logic;
		En_Pipeline:				in	std_logic;
		operand1:					in	std_logic_vector(31 downto 0);
		operand2:					in	std_logic_vector(31 downto 0);
		Op_Code:					in	std_logic_vector(5  downto 0);
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
		BR_JMP_Addr_out:			out	std_logic_vector(7 downto 0));
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
		selector_out:			out	std_logic);
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
		
		frwd_sel_mem_op1:		out	std_logic;
		frwd_sel_alu4_op1:	out	std_logic;
		frwd_sel_alu3_op1:	out	std_logic;
		frwd_sel_mem_op2:		out	std_logic;
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
	signal forward_sel_mem_op1:	std_logic;
	signal forward_sel_alu4_op1:	std_logic;
	signal forward_sel_alu3_op1:	std_logic;
	signal forward_sel_mem_op2:	std_logic;
	signal forward_sel_alu4_op2:	std_logic;
	signal forward_sel_alu3_op2:	std_logic;
	
	signal Forward_Read_Addr1:	std_Logic_vector(4 downto 0);
	signal Forward_Read_Addr2:	std_Logic_vector(4 downto 0);
	-- / Forward Signals \ --
	
	signal mask:	std_logic;
	
	-- / Signals \ --
	
begin
		
	U1: Stage1 port map(
		reset			=>	reset,
		clk				=>	clk,
		Pipeline_Enable	=>	En_IF_ID,
		ProgMode		=>	ProgMode,
		input_JMP_Addr	=>	BR_JMP_Addr_31,
		BR_JMP_flag_in	=>	BR_JMP_flag_in, -- need to fix it.
		Addr_Prog		=>	Addr_Prog,
		Data_Prog		=>	Data_Prog,
		Instruction		=>	Instruction);
	
	U2:	Stage2 port map(
		reset					=>	reset,
		clk						=>	clk,
		En_Pipeline				=>	En_ID_EX,
		instruction				=>	Instruction,
		STG25_data_in			=>	data_in_25,
		STG25_addr_Write_Reg	=>	addr_write_reg_25,
		STG25_En_Write_Reg		=>	en_write_reg_25,
		ALU_operand1			=>	data_reg1,
		ALU_operand2			=>	data_reg2,
		opcode					=>	Op_Code,
		Addr_Write_Reg			=>	addr_write_reg_23,
		En_Write_Reg			=>	en_write_reg_23,
		JMP_BR_flag				=>	JMP_BR_flag_23,
		Mem_Read				=>	Mem_Read,
		Mem_Write				=>	Mem_Write,
		Data_Mem_Write_Data		=>	Data_Mem_Write_Data,
		BR_JMP_Addr				=>	BR_JMP_Addr_23,
		BR_JMP_flag_no_Pipeline	=>	BR_JMP_flag_STG2,
		Hazard_Read_Addr1		=>	Forward_Read_Addr1,
		Hazard_Read_Addr2		=>	Forward_Read_Addr2);
	
	U3:	Stage3 port map(
		reset					=>	reset,
		clk						=>	clk,
		En_Pipeline				=>	En_EX_MEM,
		operand1				=>	operand1,
		operand2				=>	operand2,
		Op_Code					=>	Op_Code,
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
		BR_JMP_Addr_out			=>	BR_JMP_Addr_31);
	
	U4:	Stage4 port map(
		reset				=>	reset,
		clk					=>	clk,
		En_Pipeline			=>	En_MEM_WB,
		ALU_Result_in		=>	ALU_result,
		Addr_Write_Reg_in	=>	addr_write_reg_34,
		En_Write_Reg_in		=>	en_write_reg_34,
		Mem_Read			=>	Mem_Read_34,
		Mem_Write			=>	Mem_Write_34,
		Data_Mem_Write_Data	=>	Data_Mem_Write_Data_34,
		ALU_Result_out		=>	ALU_Result_45,
		Mem_Result_out		=>	Mem_Result_45,
		Addr_Write_Reg_out	=>	Addr_Write_Reg_45,
		En_Write_Reg_out	=>	en_write_reg_45,
		selector_out		=>	selector);
	
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
		
		frwd_sel_mem_op1		=>	forward_sel_mem_op1,
		frwd_sel_alu4_op1		=>	forward_sel_alu4_op1,
		frwd_sel_alu3_op1		=>	forward_sel_alu3_op1,
		
		frwd_sel_mem_op2		=>	forward_sel_mem_op2,
		frwd_sel_alu4_op2		=>	forward_sel_alu4_op2,
		frwd_sel_alu3_op2		=>	forward_sel_alu3_op2);
		
	operand1 <= Mem_Result_45 when(forward_sel_mem_op1 = '1')else
				data_in_25 when(forward_sel_alu4_op1 = '1')else
				ALU_Result when(forward_sel_alu3_op1 = '1')else data_reg1;
					
	operand2 <= Mem_Result_45 when(forward_sel_mem_op2 = '1')else
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