library ieee;
use ieee.std_logic_1164.all;

entity MIPS_core is
port(
	clk:	in	std_logic;
	reset:	in	std_logic);
end;

architecture one of MIPS_core is
	
	-- / Components \ --
	component Stage1
	port(
		clk:					in	std_logic;
		reset:					in	std_logic;
		data_stage3:			in	std_logic_vector(31 downto 0);
		Inst_out_Stage2:		out	std_logic_vector(31 downto 0);
		next_addr_out_stage2:	out	std_logic_vector(31 downto 0));
	end component;
	
	component Stage2
	port(
		clk:							in	std_logic;
		reset:							in	std_logic;
	
		-- Interface with the Prev Stage:
		Inst_in_stage1:					in	std_logic_vector(31 downto 0);
		next_addr_in_stage1:			in	std_logic_vector(31 downto 0);
	
		-- Interface with the next Stage:
		En_Write_stage5:				in	std_logic;
		Write_Reg_stage5:				in	std_logic_vector(4  downto 0);
		data_in_stage5:					in	std_logic_vector(31 downto 0);
	
		Register_Write_addr_out_stage3:	out	std_logic_vector(4  downto 0);
		data1_out_stage3:				out	std_logic_vector(31 downto 0);
		data2_out_stage3:				out	std_logic_vector(31 downto 0);
		imm_out_stage3:					out	std_logic_vector(15 downto 0);
		next_addr_out_stage3:			out	std_logic_vector(31 downto 0);
	
		-- Control signals goes to the next stage:
		ALU_Op_Code_out_stage3:			out	std_logic_vector(5 downto 0);
		ALU_src_out_stage3:				out	std_logic;
		En_Integer_out_stage3:			out	std_logic;
		En_Float_out_stage3:			out	std_logic;
		Memory_Read_out_stage3:			out	std_logic;
		Memory_Write_out_stage3:		out	std_logic;
		Write_Register_out_stage3:		out	std_logic;
		WB_MUX_out_stage3:				out	std_logic_vector(1 downto 0));
	end component;
	
	component Stage3
	port(
		clk:							in	std_logic;
		reset:							in	std_logic;
		PC_next_addr:					out	std_logic_vector(31 downto 0);
	
		-- all of this inputs connects to the outputs of stage 2
		EX_Register_Write_addr:			in	std_logic_vector(4  downto 0);
		EX_data1:						in	std_logic_vector(31 downto 0);
		EX_data2:						in	std_logic_vector(31 downto 0);
		EX_imm:							in	std_logic_vector(15 downto 0);
		EX_next_addr_out:				in	std_logic_vector(31 downto 0);
	
		-- Control Signals: from stage 2
		EX_ALU_Op_Code:					in	std_logic_vector(5 downto 0);
		EX_ALU_src:						in	std_logic;
		EX_En_Integer:					in	std_logic;
		EX_En_Float:					in	std_logic;
		EX_Memory_Read:					in	std_logic;
		EX_Memory_Write:				in	std_logic;
		EX_Write_Register:				in	std_logic;
		EX_WB_MUX:						in	std_logic_vector(1 downto 0);
	
		-- all the outputs goes to stage4
		stage4_FPU_Result_out:			out	std_logic_vector(31 downto 0);
		stage4_ALU_result_out:			out	std_logic_vector(31 downto 0);
		stage4_data2_out:				out	std_logic_vector(31 downto 0);
		stage4_Write_Register_addr_out:	out	std_logic_vector(4  downto 0);
		stage4_Memory_Read_out:			out	std_logic;
		stage4_Memory_Write_out:		out	std_logic;
		stage4_Write_Register_out:		out	std_logic;
		stage4_WB_MUX_out:				out	std_logic_vector(1 downto 0));
	end component;
	
	component Stage4
	port(
		clk:							in	std_logic;
		reset:							in	std_logic;
	
		-- All of this inputs comes from stage3
		MEM_FPU_result:					in	std_logic_vector(31 downto 0);
		MEM_ALU_result:					in	std_logic_vector(31 downto 0);
		MEM_data:						in	std_logic_vector(31 downto 0);
		MEM_Write_Register_addr:		in	std_logic_vector(4  downto 0);
	
		-- Control Signals Inputs:
		MEM_Memory_Read:				in	std_logic;
		MEM_Memory_Write:				in	std_logic;
		MEM_Write_Register:				in	std_logic;
		MEM_WB_MUX:						in	std_logic_vector(1 downto 0);
	
	
		-- Outputs:
		stage5_FPU_result_out:			out	std_logic_vector(31 downto 0);
		stage5_ALU_result_out:			out	std_logic_vector(31 downto 0);
		stage5_Data_Memory_out:			out	std_logic_vector(31 downto 0);
		stage5_Write_Register_addr_out:	out	std_logic_vector(4  downto 0);
		stage5_Write_Register_out:		out	std_logic;
		stage5_WB_MUX_out:				out	std_logic_vector(1  downto 0));
	end component;
	
	component Stage5
	port(
		clk:	in	std_logic;	-- No need to use right now
		reset:	in	std_logic;	-- No need to use right now
		-- Inputs from stage 4:
		stage4_WB_FPU_result:		in	std_logic_vector(31 downto 0);
		stage4_WB_ALU_result:		in	std_logic_vector(31 downto 0);
		stage4_WB_Data_Memory:		in	std_logic_vector(31 downto 0);
		stage4_WB_Register_addr:	in	std_logic_vector(4  downto 0);
		stage4_WB_Write_Register:	in	std_logic;
		stage4_WB_MUX:				in	std_logic_vector(1  downto 0);
	
		-- Output for stage2:
		stage2_WB_Write_Register:	out	std_logic;						-- To Enable Write function to Register
		stage2_Register_data:		out	std_logic_vector(31 downto 0);	-- Send the data to the Register
		stage2_Register_addr:		out	std_logic_vector(4  downto 0));	-- Send the address of the Register.
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	
	-- Signals Stage 1:
	signal sig_stage_13_data:			std_logic_vector(31 downto 0);
	signal sig_stage_12_Inst_out:		std_logic_vector(31 downto 0);
	signal sig_stage_12_next_addr_out:	std_logic_vector(31 downto 0);
	
	-- Signals Stage 2:
	signal sig_stage_25_En_Write:		std_logic;
	signal sig_stage_25_Write_Reg:		std_logic_vector(4  downto 0);
	signal sig_stage_25_Reg_Data:		std_logic_vector(31 downto 0);
	
	signal sig_stage_23_Reg_addr_Write:	std_logic_vector(4  downto 0);
	signal sig_stage_23_data1_out:		std_logic_vector(31 downto 0);
	signal sig_stage_23_data2_out:		std_logic_vector(31 downto 0);
	signal sig_stage_23_imm_out:		std_logic_vector(15 downto 0);
	signal sig_stage_23_next_addr_out:	std_logic_vector(31 downto 0);
	
	signal sig_stage_23_ALU_Op_Code:	std_logic_vector(5  downto 0);
	signal sig_stage_23_ALU_src:		std_logic;
	signal sig_stage_23_En_Integer:		std_logic;
	signal sig_stage_23_En_Float:		std_logic;
	signal sig_stage_23_Memory_Read:	std_logic;
	signal sig_stage_23_Memory_Write:	std_logic;
	signal sig_stage_23_Reg_Write:		std_logic;
	signal sig_stage_23_WB_MUX:			std_logic_vector(1  downto 0);
	
	-- Signals Stage 3:
	signal sig_stage_34_FPU_result:		std_logic_vector(31 downto 0);
	signal sig_stage_34_ALU_result:		std_logic_vector(31 downto 0);
	signal sig_stage_34_data2:			std_logic_vector(31 downto 0);
	signal sig_stage_34_Reg_addr:		std_logic_vector(4  downto 0);
	
	signal sig_stage_34_Memory_Read:	std_logic;
	signal sig_stage_34_Memory_Write:	std_logic;
	signal sig_stage_34_Write_Reg:		std_logic;
	signal sig_stage_34_WB_MUX:			std_logic_vector(1  downto 0);
	
	-- Signals Stage 4:
	signal sig_stage_45_FPU_result:		std_logic_vector(31 downto 0);
	signal sig_stage_45_ALU_result:		std_logic_vector(31 downto 0);
	signal sig_stage_45_Data_Memory:	std_logic_vector(31 downto 0);
	signal sig_stage_45_Reg_addr:		std_logic_vector(4  downto 0);
	signal sig_stage_45_Write_Reg:		std_logic;
	signal sig_stage_45_WB_MUX:			std_logic_vector(1  downto 0);
	
	-- / Signals \ --
	
	
begin

	STG1:	Stage1 port map(
		clk						=>	clk,
		reset					=>	reset,
		data_stage3				=>	sig_stage_13_data,
		Inst_out_Stage2			=>	sig_stage_12_Inst_out,
		next_addr_out_stage2	=>	sig_stage_12_next_addr_out);
	
	STG2:	Stage2 port map(
		clk								=>	clk,
		reset							=>	reset,
		
		Inst_in_stage1					=>	sig_stage_12_Inst_out,
		next_addr_in_stage1				=>	sig_stage_12_next_addr_out,
		
		En_Write_stage5					=>	sig_stage_25_En_Write,
		Write_Reg_stage5				=>	sig_stage_25_Write_Reg,
		data_in_stage5					=>	sig_stage_25_Reg_Data,
	
		Register_Write_addr_out_stage3	=>	sig_stage_23_Reg_addr_Write,
		data1_out_stage3				=>	sig_stage_23_data1_out,
		data2_out_stage3				=>	sig_stage_23_data2_out,
		imm_out_stage3					=>	sig_stage_23_imm_out,
		next_addr_out_stage3			=>	sig_stage_23_next_addr_out,
		
		ALU_Op_Code_out_stage3			=>	sig_stage_23_ALU_Op_Code,
		ALU_src_out_stage3				=>	sig_stage_23_ALU_src,
		En_Integer_out_stage3			=>	sig_stage_23_En_Integer,
		En_Float_out_stage3				=>	sig_stage_23_En_Float,
		Memory_Read_out_stage3			=>	sig_stage_23_Memory_Read,
		Memory_Write_out_stage3			=>	sig_stage_23_Memory_Write,
		Write_Register_out_stage3		=>	sig_stage_23_Reg_Write,
		WB_MUX_out_stage3				=>	sig_stage_23_WB_MUX);
	
	STG3:	Stage3 port map(
		clk								=>	clk,
		reset							=>	reset,
		PC_next_addr					=>	sig_stage_13_data,
	
		-- all of this inputs connects to the outputs of stage 2
		EX_Register_Write_addr			=>	sig_stage_23_Reg_addr_Write,
		EX_data1						=>	sig_stage_23_data1_out,
		EX_data2						=>	sig_stage_23_data2_out,
		EX_imm							=>	sig_stage_23_imm_out,
		EX_next_addr_out				=>	sig_stage_23_next_addr_out,
	
		-- Control Signals: from stage 2
		EX_ALU_Op_Code					=>	sig_stage_23_ALU_Op_Code,
		EX_ALU_src						=>	sig_stage_23_ALU_src,
		EX_En_Integer					=>	sig_stage_23_En_Integer,
		EX_En_Float						=>	sig_stage_23_En_Float,
		EX_Memory_Read					=>	sig_stage_23_Memory_Read,
		EX_Memory_Write					=>	sig_stage_23_Memory_Write,
		EX_Write_Register				=>	sig_stage_23_Reg_Write,
		EX_WB_MUX						=>	sig_stage_23_WB_MUX,
	
		-- all the outputs goes to stage4
		stage4_FPU_Result_out			=>	sig_stage_34_FPU_result,
		stage4_ALU_result_out			=>	sig_stage_34_ALU_result,
		stage4_data2_out				=>	sig_stage_34_data2,
		stage4_Write_Register_addr_out	=>	sig_stage_34_Reg_addr,
		stage4_Memory_Read_out			=>	sig_stage_34_Memory_Read,
		stage4_Memory_Write_out			=>	sig_stage_34_Memory_Write,
		stage4_Write_Register_out		=>	sig_stage_34_Write_Reg,
		stage4_WB_MUX_out				=>	sig_stage_34_WB_MUX);
	
	STG4:	Stage4 port map(
		clk								=>	clk,
		reset							=>	reset,
	
		-- All of this inputs comes from stage3
		MEM_FPU_result					=>	sig_stage_34_FPU_result,
		MEM_ALU_result					=>	sig_stage_34_ALU_result,
		MEM_data						=>	sig_stage_34_data2,
		MEM_Write_Register_addr			=>	sig_stage_34_Reg_addr,
	
		-- Control Signals Inputs:	
		MEM_Memory_Read					=>	sig_stage_34_Memory_Read,
		MEM_Memory_Write				=>	sig_stage_34_Memory_Write,
		MEM_Write_Register				=>	sig_stage_34_Write_Reg,
		MEM_WB_MUX						=>	sig_stage_34_WB_MUX,
	
	
		-- Outputs:	
		stage5_FPU_result_out			=>	sig_stage_45_FPU_result,
		stage5_ALU_result_out			=>	sig_stage_45_ALU_result,
		stage5_Data_Memory_out			=>	sig_stage_45_Data_Memory,
		stage5_Write_Register_addr_out	=>	sig_stage_45_Reg_addr,
		stage5_Write_Register_out		=>	sig_stage_45_Write_Reg,
		stage5_WB_MUX_out				=>	sig_stage_45_WB_MUX);
	
	STG5:	Stage5 port map(
		clk							=>	clk,
		reset						=>	reset,
		-- Inputs from stage 4:
		stage4_WB_FPU_result		=>	sig_stage_45_FPU_result,
		stage4_WB_ALU_result		=>	sig_stage_45_ALU_result,
		stage4_WB_Data_Memory		=>	sig_stage_45_Data_Memory,
		stage4_WB_Register_addr		=>	sig_stage_45_Reg_addr,
		stage4_WB_Write_Register	=>	sig_stage_45_Write_Reg,
		stage4_WB_MUX				=>	sig_stage_45_WB_MUX,
	
		-- Output for stage2:
		stage2_WB_Write_Register	=>	sig_stage_25_En_Write,
		stage2_Register_data		=>	sig_stage_25_Reg_Data,
		stage2_Register_addr		=>	sig_stage_25_Write_Reg);

end;