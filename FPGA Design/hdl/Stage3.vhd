library ieee;
use ieee.std_logic_1164.all;

entity Stage3 is
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
end;

architecture one of Stage3 is
	
	-- / Components \ --
	component EX_ALU_src_MUX
	port(
		imm:		in	std_logic_vector(15 downto 0);
		data2:		in	std_logic_vector(31 downto 0);
		selector:	in	std_logic;
		ALU_inpt:	out	std_logic_vector(31 downto 0));
	end component;
	
	component EX_ALU_IU
	port(
		inpt1:		in	std_logic_vector(31 downto 0);
		inpt2:		in	std_logic_vector(31 downto 0);
		Op_Code:	in	std_logic_vector(5  downto 0);
		En:			in	std_logic;
		outpt:		out	std_logic_vector(31 downto 0);
		BEQ_flag:	out	std_logic;
		BNE_flag:	out	std_logic;
		BGT_flag:	out	std_logic;
		BLE_flag:	out	std_logic);
	end component;
	
	component EX_ALU_FPU
	port(
		inpt1:		in	std_logic_vector(31 downto 0);
		inpt2:		in	std_logic_vector(31 downto 0);
		Op_Code:	in	std_logic_vector(1  downto 0);
		En:			in	std_logic;
		outpt:		out	std_logic_vector(31 downto 0));
	end component;
	
	component EX_Jump_Tester
	port(
		BEQ_flag:			in	std_logic;
		BGT_flag:			in	std_logic;
		BLE_flag:			in	std_logic;
		BNE_flag:			in	std_logic;
	
		imm_in:				in	std_logic_vector(15 downto 0);
		PC_next_addr_in:	in	std_logic_vector(31 downto 0);
	
		PC_next_addr_out:	out	std_logic_vector(31 downto 0));
	end component;
	
	component EX_MEM_Pipeline_Register
	port(
		clk:						in	std_logic;
		En:							in	std_logic;
		reset:						in	std_logic;
	
		FPU_result_in:				in	std_logic_vector(31 downto 0);
		ALU_result_in:				in	std_logic_vector(31 downto 0);
		data2_in:					in	std_logic_vector(31 downto 0);
		Write_Register_addr_in:		in	std_logic_vector(4 downto 0);
	
		-- Control Signals to the next stage:
		Memory_Read_in:				in	std_logic;
		Memory_Write_in:			in	std_logic;
		Write_Register_in:			in	std_logic;
		WB_MUX_in:					in	std_logic_vector(1 downto 0);
	
		-- Outputs:
		FPU_result_out:				out	std_logic_vector(31 downto 0);
		ALU_result_out:				out	std_logic_vector(31 downto 0);
		data2_out:					out	std_logic_vector(31 downto 0);
		Write_Register_addr_out:	out	std_logic_vector(4  downto 0);
	
		-- Output Control Signals:
		Memory_Read_out:			out	std_logic;
		Memory_Write_out:			out	std_logic;
		Write_Register_out:			out	std_logic;
		WB_MUX_out:					out	std_logic_vector(1 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal EX_ALU_B:	std_logic_vector(31 downto 0);
	signal EX_ALU_out:	std_logic_vector(31 downto 0);
	signal EX_FPU_out:	std_logic_vector(31 downto 0);
	signal EX_BEQ_flag:	std_logic;
	signal EX_BNE_flag:	std_logic;
	signal EX_BGT_flag:	std_logic;
	signal EX_BLE_flag:	std_logic;
	-- / Signals \ --

begin
	
	U1:	EX_ALU_src_MUX port map(
		imm			=>	EX_imm,
		data2		=>	EX_data2,
		selector	=>	EX_ALU_src,
		ALU_inpt	=>	EX_ALU_B);
	
	U2:	EX_ALU_IU port map(
		inpt1		=>	EX_data1,
		inpt2		=>	EX_ALU_B,
		En			=>	EX_En_Integer,
		Op_Code		=>	EX_ALU_Op_Code,
		outpt		=>	EX_ALU_out,
		BEQ_flag	=>	EX_BEQ_flag,
		BNE_flag	=>	EX_BNE_flag,
		BGT_flag	=>	EX_BGT_flag,
		BLE_flag	=>	EX_BLE_flag);
	
	U3:	EX_ALU_FPU	port map(
		inpt1	=>	EX_data1,
		inpt2	=>	EX_data2,
		Op_Code	=>	EX_ALU_Op_Code(1 downto 0),
		En		=>	EX_En_Float,
		outpt	=>	EX_FPU_out);
	
	U4:	EX_Jump_Tester port map(
		BEQ_flag			=>	EX_BEQ_flag,
		BNE_flag			=>	EX_BNE_flag,
		BGT_flag			=>	EX_BGT_flag,
		BLE_flag			=>	EX_BLE_flag,
		imm_in				=>	EX_imm,
		PC_next_addr_in		=>	EX_next_addr_out,
		PC_next_addr_out	=>	PC_next_addr);
	
	U5:	EX_MEM_Pipeline_Register port map(
		clk						=>	clk,
		En						=>	'1',
		reset					=>	reset,
		FPU_result_in			=>	EX_FPU_out,
		ALU_result_in			=>	EX_ALU_out,
		data2_in				=>	EX_data2,
		Write_Register_addr_in	=>	EX_Register_Write_addr,
		Memory_Read_in			=>	EX_Memory_Read,
		Memory_Write_in			=>	EX_Memory_Write,
		Write_Register_in		=>	EX_Write_Register,
		WB_MUX_in				=>	EX_WB_MUX,
		
		FPU_result_out			=>	stage4_FPU_Result_out,
		ALU_result_out			=>	stage4_ALU_result_out,
		data2_out				=>	stage4_data2_out,
		Write_Register_addr_out	=>	stage4_Write_Register_addr_out,
		Memory_Read_out			=>	stage4_Memory_Read_out,
		Memory_Write_out		=>	stage4_Memory_Write_out,
		Write_Register_out		=>	stage4_Write_Register_out,
		WB_MUX_out				=>	stage4_WB_MUX_out);
end;

-- EX_ALU_src_MUX

library ieee;
use ieee.std_logic_1164.all;

entity EX_ALU_src_MUX is
port(
	imm:		in	std_logic_vector(15 downto 0);
	data2:		in	std_logic_vector(31 downto 0);
	selector:	in	std_logic;
	ALU_inpt:	out	std_logic_vector(31 downto 0));
end;

architecture one of EX_ALU_src_MUX is
begin

end;

--

library ieee;
use ieee.std_logic_1164.all;

entity EX_ALU_IU is
port(
	inpt1:		in	std_logic_vector(31 downto 0);
	inpt2:		in	std_logic_vector(31 downto 0);
	Op_Code:	in	std_logic_vector(5  downto 0);
	En:			in	std_logic;
	outpt:		out	std_logic_vector(31 downto 0);
	BEQ_flag:	out	std_logic;
	BNE_flag:	out	std_logic;
	BGT_flag:	out	std_logic;
	BLE_flag:	out	std_logic);
end;

architecture one of EX_ALU_IU is
begin
end;

--

library ieee;
use ieee.std_logic_1164.all;

entity EX_ALU_FPU is
port(
	inpt1:		in	std_logic_vector(31 downto 0);
	inpt2:		in	std_logic_vector(31 downto 0);
	Op_Code:	in	std_logic_vector(1  downto 0);
	En:			in	std_logic;
	outpt:		out	std_logic_vector(31 downto 0));
end;

architecture one of EX_ALU_FPU is
begin

end;

--

library ieee;
use ieee.std_logic_1164.all;

entity EX_Jump_Tester is
port(
	BEQ_flag:			in	std_logic;
	BGT_flag:			in	std_logic;
	BLE_flag:			in	std_logic;
	BNE_flag:			in	std_logic;
	
	imm_in:				in	std_logic_vector(15 downto 0);
	PC_next_addr_in:	in	std_logic_vector(31 downto 0);
	
	PC_next_addr_out:	out	std_logic_vector(31 downto 0));
end;

architecture one of EX_Jump_Tester is
begin

end;

--

library ieee;
use ieee.std_logic_1164.all;

entity EX_MEM_Pipeline_Register is
port(
	clk:						in	std_logic;
	En:							in	std_logic;
	reset:						in	std_logic;
	
	FPU_result_in:				in	std_logic_vector(31 downto 0);
	ALU_result_in:				in	std_logic_vector(31 downto 0);
	data2_in:					in	std_logic_vector(31 downto 0);
	Write_Register_addr_in:		in	std_logic_vector(4 downto 0);
	
	-- Control Signals to the next stage:
	Memory_Read_in:				in	std_logic;
	Memory_Write_in:			in	std_logic;
	Write_Register_in:			in	std_logic;
	WB_MUX_in:					in	std_logic_vector(1 downto 0);
	
	-- Outputs:
	FPU_result_out:				out	std_logic_vector(31 downto 0);
	ALU_result_out:				out	std_logic_vector(31 downto 0);
	data2_out:					out	std_logic_vector(31 downto 0);
	Write_Register_addr_out:	out	std_logic_vector(4  downto 0);
	
	-- Output Control Signals:
	Memory_Read_out:			out	std_logic;
	Memory_Write_out:			out	std_logic;
	Write_Register_out:			out	std_logic;
	WB_MUX_out:					out	std_logic_vector(1 downto 0));
end;

architecture one of EX_MEM_Pipeline_Register is
begin

end;