library ieee;
use ieee.std_logic_1164.all;

entity Stage4 is
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
end;

architecture one of Stage4 is

	-- / Components \ --
	component MEM_Data_Memory
	port(
		clk:		in	std_logic;
		reset:		in	std_logic;
		Read:		in	std_logic;
		Write:		in	std_logic;
		data_in:	in	std_logic_vector(31 downto 0);
		address:	in	std_logic_vector(31 downto 0);
		data_out:	out	std_logic_vector(31 downto 0));
	end component;
	
	component MEM_WB_Pipeline_Register
	port(
		clk:						in	std_logic;
		En:							in	std_logic;
		reset:						in	std_logic;
		FPU_result_in:				in	std_logic_vector(31 downto 0);
		ALU_result_in:				in	std_logic_vector(31 downto 0);
		Data_Memory_in:				in	std_logic_vector(31 downto 0);
		Write_Register_addr_in:		in	std_logic_vector(4  downto 0);
		Write_Register_in:			in	std_logic;
		WB_MUX_in:					in	std_logic_vector(1  downto 0);
	
		FPU_result_out:				out	std_logic_vector(31 downto 0);
		ALU_result_out:				out	std_logic_vector(31 downto 0);
		Data_Memory_out:			out	std_logic_vector(31 downto 0);
		Write_Register_addr_out:	out	std_logic_vector(4  downto 0);
		Write_Register_out:			out	std_logic;
		WB_MUX_out:					out	std_logic_vector(1  downto 0));
	end component;
	-- / Components \ --
	
	 -- / Signals \ --
	 signal MEM_data_out:	std_logic_vector(31 downto 0);
	 -- / Signals \ --

begin

	U1:	MEM_Data_Memory port map(
		clk			=>	(not clk),
		reset		=>	reset,
		Read		=>	MEM_Memory_Read,
		Write		=>	MEM_Memory_Write,
		data_in		=>	MEM_data,
		address		=>	MEM_ALU_result,
		data_out	=>	MEM_data_out);
	
	U2:	MEM_WB_Pipeline_Register port map(
		clk						=>	clk,
		En						=>	'1',
		reset					=>	reset,
		FPU_result_in			=>	MEM_FPU_result,
		ALU_result_in			=>	MEM_ALU_result,
		Data_Memory_in			=>	MEM_data_out,
		Write_Register_addr_in	=>	MEM_Write_Register_addr,
		Write_Register_in		=>	MEM_Write_Register,
		WB_MUX_in				=>	MEM_WB_MUX,
		
		FPU_result_out			=>	stage5_FPU_result_out,
		ALU_result_out			=>	stage5_ALU_result_out,
		Data_Memory_out			=>	stage5_Data_Memory_out,
		Write_Register_addr_out	=>	stage5_Write_Register_addr_out,
		Write_Register_out		=>	stage5_Write_Register_out,
		WB_MUX_out				=>	stage5_WB_MUX_out);
end;

--

library ieee;
use ieee.std_logic_1164.all;

entity MEM_Data_Memory is
port(
	clk:		in	std_logic;
	reset:		in	std_logic;
	Read:		in	std_logic;
	Write:		in	std_logic;
	data_in:	in	std_logic_vector(31 downto 0);
	address:	in	std_logic_vector(31 downto 0);
	data_out:	out	std_logic_vector(31 downto 0));
end;

architecture one of MEM_Data_Memory is
begin
end;

--

library ieee;
use ieee.std_logic_1164.all;

entity MEM_WB_Pipeline_Register is
port(
	clk:						in	std_logic;
	En:							in	std_logic;
	reset:						in	std_logic;
	FPU_result_in:				in	std_logic_vector(31 downto 0);
	ALU_result_in:				in	std_logic_vector(31 downto 0);
	Data_Memory_in:				in	std_logic_vector(31 downto 0);
	Write_Register_addr_in:		in	std_logic_vector(4  downto 0);
	Write_Register_in:			in	std_logic;
	WB_MUX_in:					in	std_logic_vector(1  downto 0);
	
	FPU_result_out:				out	std_logic_vector(31 downto 0);
	ALU_result_out:				out	std_logic_vector(31 downto 0);
	Data_Memory_out:			out	std_logic_vector(31 downto 0);
	Write_Register_addr_out:	out	std_logic_vector(4  downto 0);
	Write_Register_out:			out	std_logic;
	WB_MUX_out:					out	std_logic_vector(1  downto 0));
end;

architecture one of MEM_WB_Pipeline_Register is
begin
end;