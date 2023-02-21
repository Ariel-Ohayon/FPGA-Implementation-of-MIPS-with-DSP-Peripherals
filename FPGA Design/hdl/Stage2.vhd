library ieee;
use ieee.std_logic_1164.all;

entity ID_Control_Unit is
port(
	Instruction:	in	std_logic_vector(31 downto 0);
	ALU_Op_Code:	out	std_logic_vector(5 downto 0);
	ALU_src:		out	std_logic;
	En_Integer:		out	std_logic;
	En_Float:		out	std_logic;
	Memory_Read:	out	std_logic;
	Memory_Write:	out	std_logic;
	Register_Read:	out std_logic;
	Register_Write:	out	std_logic;
	WB_MUX:			out	std_logic_vector(1 downto 0));
end;

architecture one of ID_Control_Unit is
begin

end;

--

library ieee;
use ieee.std_logic_1164.all;

entity ID_Register_File is
port(
	clk:		in	std_logic;
	reset:		in	std_logic;
	En_Read:	in	std_logic;
	En_Write:	in	std_logic;
	Read_Reg1:	in	std_logic_vector(4  downto 0);
	Read_Reg2:	in	std_logic_vector(4  downto 0);
	Write_Reg:	in	std_logic_vector(4  downto 0);
	data_in:	in	std_logic_vector(31 downto 0);
	data1:		out	std_logic_vector(31 downto 0);
	data2:		out	std_logic_vector(31 downto 0));
end;

architecture one of ID_Register_File is
begin
end;

--

library ieee;
use ieee.std_logic_1164.all;

entity ID_EX_Pipeline_Register is
port(

	-- Inputs:
	clk:						in	std_logic;
	En:							in	std_logic;
	reset:						in	std_logic;
	Register_Write_addr_in:		in	std_logic_vector(4  downto 0);
	data1_in:					in	std_logic_vector(31 downto 0);
	data2_in:					in	std_logic_vector(31 downto 0);
	imm_in:						in	std_Logic_vector(15 downto 0);
	next_addr_in:				in	std_logic_vector(31 downto 0);
	
	-- Input Control Signals:
	ALU_Op_Code_in:				in	std_logic_vector(5 downto 0);
	ALU_src_in:					in	std_logic;
	En_Integer_in:				in	std_logic;
	En_Float_in:				in	std_logic;
	Memory_Read_in:				in	std_logic;
	Memory_Write_in:			in	std_logic;
	Write_Register_in:			in	std_logic;
	WB_MUX_in:					in	std_logic_vector(1 downto 0);
	
	-- Outputs:
	Register_Write_addr_out:	out	std_logic_vector(4  downto 0);
	data1_out:					out	std_logic_vector(31 downto 0);
	data2_out:					out	std_logic_vector(31 downto 0);
	imm_out:					out	std_logic_vector(15 downto 0);
	next_addr_out:				out	std_logic_vector(31 downto 0);
	
	-- Output Control Signals:
	ALU_Op_Code_out:			out	std_logic_vector(5  downto 0);
	ALU_src_out:				out	std_logic;
	En_Integer_out:				out	std_logic;
	En_Float_out:				out	std_logic;
	Memory_Read_out:			out	std_logic;
	Memory_Write_out:			out	std_logic;
	Write_Register_out:			out	std_logic;
	WB_MUX_out:					out	std_logic_vector(1 downto 0));
end;

architecture one of ID_EX_Pipeline_Register is
begin
end;

--

library ieee;
use ieee.std_logic_1164.all;

entity Stage2 is
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
end;

architecture one of Stage2 is
	
	-- / Components \ --
	component ID_Control_Unit
	port(
		Instruction:	in	std_logic_vector(31 downto 0);
		ALU_Op_Code:	out	std_logic_vector(5 downto 0);
		ALU_src:		out	std_logic;
		En_Integer:		out	std_logic;
		En_Float:		out	std_logic;
		Memory_Read:	out	std_logic;
		Memory_Write:	out	std_logic;
		Register_Read:	out std_logic;
		Register_Write:	out	std_logic;
		WB_MUX:			out	std_logic_vector(1 downto 0));
	end component;
	
	component ID_Register_File
	port(
		clk:		in	std_logic;
		reset:		in	std_logic;
		En_Read:	in	std_logic;
		En_Write:	in	std_logic;
		Read_Reg1:	in	std_logic_vector(4  downto 0);
		Read_Reg2:	in	std_logic_vector(4  downto 0);
		Write_Reg:	in	std_logic_vector(4  downto 0);
		data_in:	in	std_logic_vector(31 downto 0);
		data1:		out	std_logic_vector(31 downto 0);
		data2:		out	std_logic_vector(31 downto 0));
	end component;
	
	component ID_EX_Pipeline_Register
	port(

		-- Inputs:
		clk:						in	std_logic;
		En:							in	std_logic;
		reset:						in	std_logic;
		Register_Write_addr_in:		in	std_logic_vector(4  downto 0);
		data1_in:					in	std_logic_vector(31 downto 0);
		data2_in:					in	std_logic_vector(31 downto 0);
		imm_in:						in	std_Logic_vector(15 downto 0);
		next_addr_in:				in	std_logic_vector(31 downto 0);
	
		-- Input Control Signals:
		ALU_Op_Code_in:				in	std_logic_vector(5 downto 0);
		ALU_src_in:					in	std_logic;
		En_Integer_in:				in	std_logic;
		En_Float_in:				in	std_logic;
		Memory_Read_in:				in	std_logic;
		Memory_Write_in:			in	std_logic;
		Write_Register_in:			in	std_logic;
		WB_MUX_in:					in	std_logic_vector(1 downto 0);
	
		-- Outputs:
		Register_Write_addr_out:	out	std_logic_vector(4  downto 0);
		data1_out:					out	std_logic_vector(31 downto 0);
		data2_out:					out	std_logic_vector(31 downto 0);
		imm_out:					out	std_logic_vector(15 downto 0);
		next_addr_out:				out	std_logic_vector(31 downto 0);
	
		-- Output Control Signals:
		ALU_Op_Code_out:			out	std_logic_vector(5  downto 0);
		ALU_src_out:				out	std_logic;
		En_Integer_out:				out	std_logic;
		En_Float_out:				out	std_logic;
		Memory_Read_out:			out	std_logic;
		Memory_Write_out:			out	std_logic;
		Write_Register_out:			out	std_logic;
		WB_MUX_out:					out	std_logic_vector(1 downto 0));
	end component;
	-- / Components \ --

	 -- / Signals \ --
	 signal Instruction:		std_logic_vector(31 downto 0);
	 signal ID_next_addr:		std_logic_vector(31 downto 0);
	 signal ID_ALU_Op_Code:		std_logic_vector(5  downto 0);
	 signal ID_ALU_src:			std_logic;
	 signal ID_En_Integer:		std_logic;
	 signal ID_En_Float:		std_logic;
	 signal ID_Memory_Read:		std_logic;
	 signal ID_Memory_Write:	std_logic;
	 signal ID_Register_Read:	std_logic;
	 signal ID_Register_Write:	std_logic;
	 signal ID_WB_MUX:			std_logic_vector(1  downto 0);
	 signal ID_data1:			std_logic_vector(31 downto 0);
	 signal ID_data2:			std_logic_vector(31 downto 0);
	 -- / Signals \ --

begin
	
	Instruction  <= Inst_in_stage1;
	ID_next_addr <= next_addr_in_stage1;
	
	U1:	ID_Control_Unit port map(
		Instruction		=>	Instruction,
		
		ALU_Op_Code		=>	ID_ALU_Op_Code,
		ALU_src			=>	ID_ALU_src,
		En_Integer		=>	ID_En_Integer,
		En_Float		=>	ID_En_Float,
		Memory_Read		=>	ID_Memory_Read,
		Memory_Write	=>	ID_Memory_Write,
		Register_Read	=>	ID_Register_Read,
		Register_Write	=>	ID_Register_Write,
		WB_MUX			=>	ID_WB_MUX);
		
	U2:	ID_Register_File port map(
		clk			=>	(not clk),
		reset		=>	reset,
		En_Read		=>	ID_Register_Read,
		En_Write	=>	En_Write_stage5,
		Read_Reg1	=>	Instruction(25 downto 21),
		Read_Reg2	=>	Instruction(20 downto 16),
		Write_Reg	=>	Write_Reg_stage5,
		data_in		=>	data_in_stage5,
		data1		=>	ID_data1,
		data2		=>	ID_data2);
	
	U3:	ID_EX_Pipeline_Register port map(
		clk						=>	clk,
		En						=>	'1',
		reset					=>	reset,
		Register_Write_addr_in	=>	Instruction(15 downto 11),
		data1_in				=>	ID_data1,
		data2_in				=>	ID_data2,
		imm_in					=>	Instruction(15 downto 0),
		next_addr_in			=>	ID_next_addr,
		ALU_Op_Code_in			=>	ID_ALU_Op_Code,
		ALU_src_in				=>	ID_ALU_src,
		En_Integer_in			=>	ID_En_Integer,
		En_Float_in				=>	ID_En_Float,
		Memory_Read_in			=>	ID_Memory_Read,
		Memory_Write_in			=>	ID_Memory_Write,
		Write_Register_in		=>	ID_Register_Write,
		WB_MUX_in				=>	ID_WB_MUX,
		
		Register_Write_addr_out	=>	Register_Write_addr_out_stage3,
		data1_out				=>	data1_out_stage3,
		data2_out				=>	data2_out_stage3,
		imm_out					=>	imm_out_stage3,
		next_addr_out			=>	next_addr_out_stage3,
		ALU_Op_Code_out			=>	ALU_Op_Code_out_stage3,
		ALU_src_out				=>	ALU_src_out_stage3,
		En_Integer_out			=>	En_Integer_out_stage3,
		En_Float_out			=>	En_Float_out_stage3,
		Memory_Read_out			=>	Memory_Read_out_stage3,
		Memory_Write_out		=>	Memory_Write_out_stage3,
		Write_Register_out		=>	Write_Register_out_stage3,
		WB_MUX_out				=>	WB_MUX_out_stage3);
end;
