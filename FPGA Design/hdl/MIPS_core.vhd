library ieee;
use ieee.std_logic_1164.all;

entity MIPS_Core is
port(
	clk:	in	std_logic;
	reset:	in	std_logic;
	ProgMode:	in	std_logic;
	ADDR_Prog:	in	std_logic_vector(11 downto 0);
	DATA_Prog:	in	std_logic_vector(31 downto 0);
	En_Prog_Data_MEM:	in	std_logic);
end;

architecture one of MIPS_Core is

	-- / Components \ --
	component Stage1
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		ProgMode:	in	std_logic;
		Instruction_Data:	in	std_logic_vector(31 downto 0);
		Instruction_addr:	in	std_logic_vector(11 downto 0);
		En_Pipeline:	in	std_logic;
		Instruction_out:	out	std_logic_vector(31 downto 0);
		addr_BR_JMP:	in	std_logic_vector(11 downto 0);
		PC_sel:	in	std_logic);
	end component;
	component Stage2
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		En_Pipeline:	in	std_logic;
		Instruction:	in	std_logic_vector(31 downto 0);
		Addr_Write_Reg:	in	std_logic_vector(4 downto 0);
		Reg_Write_En_in:	in	std_logic;
		SP_Data:	out	std_logic_vector(7 downto 0);
		ALU_Op_Code_out:	out	std_logic_vector(5 downto 0);
		ALU_src_out:	out	std_logic;
		En_Integer_out:	out	std_logic;
		En_Float_out:	out	std_logic;
		Memory_Read_out:	out	std_logic;
		Memory_Write_out:	out	std_logic;
		Reg_Write_En_out:	out	std_logic;
		WB_Mux_sel_out:	out	std_logic;
		CALL_flag_out:	out	std_logic;
		RET_flag_out:	out	std_logic;
		BR_flag_out:	out	std_logic;
		Addr_Write_Reg_out:	out	std_logic_vector(4 downto 0);
		data1_out:	out	std_logic_vector(31 downto 0);
		data2_out:	out	std_logic_vector(31 downto 0);
		imm_out:	out	std_logic_vector(15 downto 0);
		JMP_flag_out:	out	std_logic;
		data_in:	in	std_logic_vector(31 downto 0);
		F_Read_Reg_En:	out	std_logic;
		Forward_Data_in:	in	std_logic_vector(31 downto 0);
		Forward_Selector:	in	std_logic_vector(1 downto 0));
	end component;
	component Stage3
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		SP_Data:	in	std_logic_vector(7 downto 0);
		ALU_Op_Code:	in	std_logic_vector(5 downto 0);
		ALU_src:	in	std_logic;
		En_Integer:	in	std_logic;
		En_Float:	in	std_logic;
		Memory_Read_in:	in	std_logic;
		Memory_Write_in:	in	std_logic;
		Reg_Write_En_in:	in	std_logic;
		WB_Mux_sel_in:	in	std_logic;
		CALL_flag_in:	in	std_logic;
		RET_flag_in:	in	std_logic;
		BR_flag_in:	in	std_logic;
		Addr_Write_Reg_in:	in	std_logic_vector(4 downto 0);
		data1_in:	in	std_logic_vector(31 downto 0);
		data2_in:	in	std_logic_vector(31 downto 0);
		imm_in:	in	std_logic_vector(15 downto 0);
		Result_out:	out	std_logic_vector(31 downto 0);
		Memory_Read_out:	out	std_logic;
		Memory_Write_out:	out	std_logic;
		Reg_Write_En_out:	out	std_logic;
		WB_Mux_sel_out:	out	std_logic;
		Addr_Write_Reg_out:	out	std_logic_vector(4 downto 0);
		imm_out:	out	std_logic_vector(15 downto 0);
		BR_Ex_out:	out	std_logic;
		CALL_flag_out:	out	std_logic;
		RET_flag_out:	out	std_logic;
		SP_Data_out:	out	std_logic_vector(7 downto 0);
		data1_out:	out	std_logic_vector(31 downto 0);
		JMP_flag_in:	in	std_logic;
		JMP_flag_out:	out	std_logic;
		Result_out_no_Pipeline:	out	std_logic_vector(31 downto 0));
	end component;
	component Stage4
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		Memory_Read:	in	std_logic;
		Memory_Write:	in	std_logic;
		SP_Data:	in	std_logic_vector(7 downto 0);
		data1:	in	std_logic_vector(31 downto 0);
		Result:	in	std_logic_vector(31 downto 0);
		CALL_flag:	in	std_logic;
		RET_flag:	in	std_logic;
		Reg_Write_En_in:	in	std_logic;
		WB_Mux_sel_in:	in	std_logic;
		Addr_Write_Reg_in:	in	std_logic_vector(4 downto 0);
		imm:	in	std_logic_vector(15 downto 0);
		BR_Ex:	in	std_logic;
		next_PC:	out	std_logic_vector(11 downto 0);
		Memory_Data:	out	std_logic_vector(31 downto 0);
		Result_out:	out	std_logic_vector(31 downto 0);
		Reg_Write_En_out:	out	std_logic;
		WB_Mux_sel_out:	out	std_logic;
		Addr_Write_Reg_out:	out	std_logic_vector(4 downto 0);
		JMP_flag:	in	std_logic;
		BR_JMP_Ex:	out	std_logic;
		Mem_out_no_Pipeline:	out	std_logic_vector(31 downto 0);
		ALU_out_no_Pipeline:	out	std_logic_vector(31 downto 0);
		En_Prog_data_MEM:	in	std_logic;
		data_MEM_in:	in	std_logic_vector(31 downto 0);
		addr_MEM_in:	in	std_logic_vector(7 downto 0));
	end component;
	component Stage5
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		Memory_Data:	in	std_logic_vector(31 downto 0);
		ALU_Data:	in	std_logic_vector(31 downto 0);
		Reg_Write_En_in:	in	std_logic;
		WB_Mux_sel:	in	std_logic;
		Addr_Write_Reg_in:	in	std_logic_vector(4 downto 0);
		Reg_Write_En_out:	out	std_logic;
		Addr_Write_Reg_out:	out	std_logic_vector(4 downto 0);
		Reg_Write_Data_out:	out	std_logic_vector(31 downto 0));
	end component;
	component Hazard_Unit
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		STG3_flag:	in	std_logic;
		STG4_flag:	in	std_logic;
		En_IF_ID:	out	std_logic;
		En_ID_EX:	out	std_logic;
		Pipeline_reset:	out	std_logic);
	end component;
	component Forward_Unit
	port(
		inpt_Stage3:	in	std_logic_vector(31 downto 0);
		inpt_Stage4_Mem:	in	std_logic_vector(31 downto 0);
		inpt_Stage4_ALU:	in	std_logic_vector(31 downto 0);
		En_Read_Reg:	in	std_logic;
		Addr_Read_Reg1:	in	std_logic_vector(4 downto 0);
		Addr_Read_Reg2:	in	std_logic_vector(4 downto 0);
		Addr_Write_Reg_Stage3:	in	std_logic_vector(4 downto 0);
		Addr_Write_Reg_Stage4:	in	std_logic_vector(4 downto 0);
		outpt_STG2:	out	std_logic_vector(31 downto 0);
		Forward_Selector:	out	std_logic_vector(1 downto 0));
	end component;
	-- / Components \ --

	-- / Signals\ --
	signal EN_IF_ID:	std_logic;
	signal EN_ID_EX:	std_logic;
	signal stage12_Instruction:	std_logic_vector(31 downto 0);
	signal stage14_next_PC:	std_logic_vector(11 downto 0);
	signal stage14_PC_sel:	std_logic;
	signal stage25_Addr_Write_Reg:	std_logic_vector(4 downto 0);
	signal stage25_Reg_Write_En:	std_logic;
	signal stage23_SP_Data:	std_logic_vector(7 downto 0);
	signal stage23_ALU_Op_Code:	std_logic_vector(5 downto 0);
	signal stage23_ALU_src:	std_logic;
	signal stage23_En_Integer:	std_logic;
	signal stage23_En_Float:	std_logic;
	signal stage23_Memory_Read:	std_logic;
	signal stage23_Memory_Write:	std_logic;
	signal stage23_Reg_Write_En:	std_logic;
	signal stage23_WB_Mux_sel:	std_logic;
	signal stage23_CALL:	std_logic;
	signal stage23_RET:	std_logic;
	signal stage23_BR:	std_logic;
	signal stage23_Addr_Write_Reg:	std_logic_vector(4 downto 0);
	signal stage23_data1:	std_logic_vector(31 downto 0);
	signal stage23_data2:	std_logic_vector(31 downto 0);
	signal stage23_imm:	std_logic_vector(15 downto 0);
	signal stage23_JMP:	std_logic;
	signal stage34_result:	std_logic_vector(31 downto 0);
	signal stage34_Memory_Read:	std_logic;
	signal stage34_Memory_Write:	std_logic;
	signal stage34_Reg_Write_En:	std_logic;
	signal stage34_WB_Mux_sel:	std_logic;
	signal stage34_Addr_Write_Reg:	std_logic_vector(4 downto 0);
	signal stage34_imm:	std_logic_vector(15 downto 0);
	signal stage34_BR_Ex:	std_logic;
	signal stage34_CALL:	std_logic;
	signal stage34_RET:	std_logic;
	signal stage34_SP_Data:	std_logic_vector(7 downto 0);
	signal stage34_data1:	std_logic_vector(31 downto 0);
	signal stage34_JMP:	std_logic;
	signal stage45_Result:	std_logic_vector(31 downto 0);
	signal stage45_Memory_Data:	std_logic_vector(31 downto 0);
	signal stage45_Reg_Write_En:	std_logic;
	signal stage45_WB_Mux_sel:	std_logic;
	signal stage45_Addr_Write_Reg:	std_logic_vector(4 downto 0);
	signal stage25_data_in:	std_logic_vector(31 downto 0);
	signal Hazard_Pipeline_reset:	std_logic;
	signal STG3_Result:	std_logic_vector(31 downto 0);
	signal STG4_Result_Mem:	std_logic_vector(31 downto 0);
	signal STG4_Result_ALU:	std_logic_vector(31 downto 0);
	signal F_Read_Reg_En:	std_logic;
	signal F_Sel:	std_logic_vector(1 downto 0);
	signal F_Data_STG2:	std_logic_vector(31 downto 0);
	signal pipeline_reset:	std_logic;
	signal n_clk:	std_logic;
	signal STG3_flag:	std_logic;
	signal STG4_flag:	std_logic;
	-- / Signals \ --

begin
	U1: Stage1 port map(
			clk	=>	clk,
			reset	=>	pipeline_reset,
			ProgMode	=>	ProgMode,
			Instruction_Data	=>	DATA_Prog,
			Instruction_addr	=>	ADDR_Prog,
			En_Pipeline	=>	EN_IF_ID,
			Instruction_out	=>	stage12_Instruction,
			addr_BR_JMP	=>	stage14_next_PC,
			PC_sel	=>	stage14_PC_sel);

	U2: Stage2 port map(
			clk	=>	clk,
			reset	=>	pipeline_reset,
			En_Pipeline	=>	EN_ID_EX,
			Instruction	=>	stage12_Instruction,
			Addr_Write_Reg	=>	stage25_Addr_Write_Reg,
			Reg_Write_En_in	=>	stage25_Reg_Write_En,
			SP_Data	=>	stage23_SP_Data,
			ALU_Op_Code_out	=>	stage23_ALU_Op_Code,
			ALU_src_out	=>	stage23_ALU_src,
			En_Integer_out	=>	stage23_En_Integer,
			En_Float_out	=>	stage23_En_Float,
			Memory_Read_out	=>	stage23_Memory_Read,
			Memory_Write_out	=>	stage23_Memory_Write,
			Reg_Write_En_out	=>	stage23_Reg_Write_En,
			WB_Mux_sel_out	=>	stage23_WB_Mux_sel,
			CALL_flag_out	=>	stage23_CALL,
			RET_flag_out	=>	stage23_RET,
			BR_flag_out	=>	stage23_BR,
			Addr_Write_Reg_out	=>	stage23_Addr_Write_Reg,
			data1_out	=>	stage23_data1,
			data2_out	=>	stage23_data2,
			imm_out	=>	stage23_imm,
			JMP_flag_out	=>	stage23_JMP,
			data_in	=>	stage25_data_in,
			F_Read_Reg_En	=>	F_Read_Reg_En,
			Forward_Data_in	=>	F_Data_STG2,
			Forward_Selector	=>	F_Sel);

	U3: Stage3 port map(
			clk	=>	clk,
			reset	=>	reset,
			SP_Data	=>	stage23_SP_Data,
			ALU_Op_Code	=>	stage23_ALU_Op_Code,
			ALU_src	=>	stage23_ALU_src,
			En_Integer	=>	stage23_En_Integer,
			En_Float	=>	stage23_En_Float,
			Memory_Read_in	=>	stage23_Memory_Read,
			Memory_Write_in	=>	stage23_Memory_Write,
			Reg_Write_En_in	=>	stage23_Reg_Write_En,
			WB_Mux_sel_in	=>	stage23_WB_Mux_sel,
			CALL_flag_in	=>	stage23_CALL,
			RET_flag_in	=>	stage23_RET,
			BR_flag_in	=>	stage23_BR,
			Addr_Write_Reg_in	=>	stage23_Addr_Write_Reg,
			data1_in	=>	stage23_data1,
			data2_in	=>	stage23_data2,
			imm_in	=>	stage23_imm,
			Result_out	=>	stage34_result,
			Memory_Read_out	=>	stage34_Memory_Read,
			Memory_Write_out	=>	stage34_Memory_Write,
			Reg_Write_En_out	=>	stage34_Reg_Write_En,
			WB_Mux_sel_out	=>	stage34_WB_Mux_sel,
			Addr_Write_Reg_out	=>	stage34_Addr_Write_Reg,
			imm_out	=>	stage34_imm,
			BR_Ex_out	=>	stage34_BR_Ex,
			CALL_flag_out	=>	stage34_CALL,
			RET_flag_out	=>	stage34_RET,
			SP_Data_out	=>	stage34_SP_Data,
			data1_out	=>	stage34_data1,
			JMP_flag_in	=>	stage23_JMP,
			JMP_flag_out	=>	stage34_JMP,
			Result_out_no_Pipeline	=>	STG3_Result);

	U4: Stage4 port map(
			clk	=>	clk,
			reset	=>	reset,
			Memory_Read	=>	stage34_Memory_Read,
			Memory_Write	=>	stage34_Memory_Write,
			SP_Data	=>	stage34_SP_Data,
			data1	=>	stage34_data1,
			Result	=>	stage34_result,
			CALL_flag	=>	stage34_CALL,
			RET_flag	=>	stage34_RET,
			Reg_Write_En_in	=>	stage34_Reg_Write_En,
			WB_Mux_sel_in	=>	stage34_WB_Mux_sel,
			Addr_Write_Reg_in	=>	stage34_Addr_Write_Reg,
			imm	=>	stage34_imm,
			BR_Ex	=>	stage34_BR_Ex,
			next_PC	=>	stage14_next_PC,
			Memory_Data	=>	stage45_Memory_Data,
			Result_out	=>	stage45_Result,
			Reg_Write_En_out	=>	stage45_Reg_Write_En,
			WB_Mux_sel_out	=>	stage45_WB_Mux_sel,
			Addr_Write_Reg_out	=>	stage45_Addr_Write_Reg,
			JMP_flag	=>	stage34_JMP,
			BR_JMP_Ex	=>	stage14_PC_sel,
			Mem_out_no_Pipeline	=>	STG4_Result_Mem,
			ALU_out_no_Pipeline	=>	STG4_Result_ALU,
			En_Prog_data_MEM	=>	En_Prog_Data_MEM,
			data_MEM_in	=>	DATA_Prog,
			addr_MEM_in	=>	ADDR_Prog(7 downto 0));

	U5: Stage5 port map(
			clk	=>	clk,
			reset	=>	reset,
			Memory_Data	=>	stage45_Memory_Data,
			ALU_Data	=>	stage45_Result,
			Reg_Write_En_in	=>	stage45_Reg_Write_En,
			WB_Mux_sel	=>	stage45_WB_Mux_sel,
			Addr_Write_Reg_in	=>	stage45_Addr_Write_Reg,
			Reg_Write_En_out	=>	stage25_Reg_Write_En,
			Addr_Write_Reg_out	=>	stage25_Addr_Write_Reg,
			Reg_Write_Data_out	=>	stage25_data_in);

	U6: Hazard_Unit port map(
			clk	=>	n_clk,
			reset	=>	reset,
			STG3_flag	=>	STG3_flag,
			STG4_flag	=>	STG4_flag,
			En_IF_ID	=>	EN_IF_ID,
			En_ID_EX	=>	EN_ID_EX,
			Pipeline_reset	=>	Hazard_Pipeline_reset);

	U7: Forward_Unit port map(
			inpt_Stage3	=>	STG3_Result,
			inpt_Stage4_Mem	=>	STG4_Result_Mem,
			inpt_Stage4_ALU	=>	STG4_Result_ALU,
			En_Read_Reg	=>	F_Read_Reg_En,
			Addr_Read_Reg1	=>	stage12_Instruction(25 downto 21),
			Addr_Read_Reg2	=>	stage12_Instruction(20 downto 16),
			Addr_Write_Reg_Stage3	=>	stage23_Addr_Write_Reg,
			Addr_Write_Reg_Stage4	=>	stage34_Addr_Write_Reg,
			outpt_STG2	=>	F_Data_STG2,
			Forward_Selector	=>	F_Sel);

	pipeline_reset <= reset or Hazard_Pipeline_reset;
	n_clk <= not clk;
	STG3_flag <= stage23_CALL or stage23_RET or stage23_BR or stage23_JMP;
	STG4_flag <= stage34_CALL or stage34_RET or stage34_BR_Ex or stage34_JMP;
end;



-- SubModule: Hazard_Unit --

library ieee;
use ieee.std_logic_1164.all;

entity Hazard_Unit is
port(
	clk:in	std_logic;
	reset:in	std_logic;
	STG3_flag:in	std_logic;
	STG4_flag:in	std_logic;
	En_IF_ID:out	std_logic;
	En_ID_EX:out	std_logic;
	Pipeline_reset:out	std_logic);
end;

architecture one of Hazard_Unit is
	type state is (s0,s1,s2);
	signal ps,ns: state;
begin
	process(reset,clk)begin
		if (reset = '1')then
			ps <= s0;
		elsif(clk 'event and clk = '1')then
			ps <= ns;
		end if;
	end process;

	process(ps, STG3_flag, STG4_flag)begin
		En_IF_ID	<= '1';
		En_ID_EX	<= '1';
		Pipeline_reset	<= '0';
		case(ps)is
			when s0 =>
				En_IF_ID	<= '1';
				En_ID_EX	<= '1';
				Pipeline_reset	<= '0';
				if(STG3_flag = '1')then
					ns <= s1;
				else
					ns <= s0;
				end if;
			when s1 =>
				En_IF_ID <= '0';
				if(STG4_flag = '1')then
					ns <= s2;
				else
					ns <= s1;
				end if;
			when s2 =>
				En_IF_ID <= '0';
				En_ID_EX <= '0';
				Pipeline_reset <= '1';
				ns <= s0;
		end case;
	end process;
end;

-- SubModule: Forward_Unit --

library ieee;
use ieee.std_logic_1164.all;

entity Forward_Unit is
port(
	inpt_Stage3:in	std_logic_vector(31 downto 0);
	inpt_Stage4_Mem:in	std_logic_vector(31 downto 0);
	inpt_Stage4_ALU:in	std_logic_vector(31 downto 0);
	En_Read_Reg:in	std_logic;
	Addr_Read_Reg1:in	std_logic_vector(4 downto 0);
	Addr_Read_Reg2:in	std_logic_vector(4 downto 0);
	Addr_Write_Reg_Stage3:in	std_logic_vector(4 downto 0);
	Addr_Write_Reg_Stage4:in	std_logic_vector(4 downto 0);
	outpt_STG2:out	std_logic_vector(31 downto 0);
	Forward_Selector:out	std_logic_vector(1 downto 0));
end;

architecture one of Forward_Unit is
begin

end;
