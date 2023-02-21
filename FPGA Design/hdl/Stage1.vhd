library ieee;
use ieee.std_logic_1164.all;

entity IF_Register_PC is
port(
	clk:	in	std_logic;
	reset:	in	std_logic;
	data:	in	std_logic_vector(31 downto 0);
	outpt:	out	std_logic_vector(31 downto 0));
end;

architecture one of IF_Register_PC is
begin

end;

-- 

library ieee;
use ieee.std_logic_1164.all;
entity IF_PC_Adder is
port(
	inpt:	in	std_logic_vector(31 downto 0);
	outpt:	out	std_logic_vector(31 downto 0));
end;

architecture one of IF_PC_Adder is
begin

end;

--

library ieee;
use ieee.std_logic_1164.all;
entity IF_Instruction_Memory is
port(
	clk:		in	std_logic;
	data_in:	in	std_logic_vector(31 downto 0);
	address:	in	std_logic_vector(31 downto 0);
	R_nW:		in	std_logic;
	data_out:	out	std_logic_vector(31 downto 0));
end;

architecture one of IF_Instruction_Memory is
begin

end;

--
library ieee;
use ieee.std_logic_1164.all;

entity IF_ID_Pipeline_Register is
port(
	clk:			in	std_logic;
	En:				in	std_logic;
	reset:			in	std_logic;
	Inst_in:		in	std_logic_vector(31 downto 0);
	next_addr_in:	in	std_logic_vector(31 downto 0);
	Inst_out:		out	std_logic_vector(31 downto 0);
	next_addr_out:	out std_logic_vector(31 downto 0));
end;

architecture one of IF_ID_Pipeline_Register is
begin
end;

--

library ieee;
use ieee.std_logic_1164.all;

entity Stage1 is
port(
	clk:					in	std_logic;
	reset:					in	std_logic;
	data_stage3:			in	std_logic_vector(31 downto 0);
	Inst_out_Stage2:		out	std_logic_vector(31 downto 0);
	next_addr_out_stage2:	out	std_logic_vector(31 downto 0));
end;

architecture one of Stage1 is

	-- / Components \ --
	component IF_Register_PC
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		data:	in	std_logic_vector(31 downto 0);
		outpt:	out	std_logic_vector(31 downto 0));
	end component;
	
	component IF_PC_Adder
	port(
		inpt:	in	std_logic_vector(31 downto 0);
		outpt:	out	std_logic_vector(31 downto 0));
	end component;
	
	component IF_Instruction_Memory
	port(
		clk:		in	std_logic;
		data_in:	in	std_logic_vector(31 downto 0);
		address:	in	std_logic_vector(31 downto 0);
		R_nW:		in	std_logic;
		data_out:	out	std_logic_vector(31 downto 0));
	end component;
	
	component IF_ID_Pipeline_Register
	port(
		clk:			in	std_logic;
		En:				in	std_logic;
		reset:			in	std_logic;
		Inst_in:		in	std_logic_vector(31 downto 0);
		next_addr_in:	in	std_logic_vector(31 downto 0);
		Inst_out:		out	std_logic_vector(31 downto 0);
		next_addr_out:	out std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --

	-- / Signals \ --
	signal PC_in:	std_logic_vector(31 downto 0);
	signal PC_out:	std_logic_vector(31 downto 0);
	signal IR:		std_logic_vector(31 downto 0);
	-- / Signals \ --

begin

	U1:	IF_Register_PC port map (
		clk		=>	clk,
		reset	=>	reset,
		data	=>	data_stage3,
		outpt	=>	PC_out);
	
	U2: IF_PC_Adder port map(
		inpt	=>	PC_out,
		outpt	=>	PC_in);
	
	U3:	IF_Instruction_Memory port map(
		clk			=>	clk,
		data_in		=>	(others => '0'),
		address		=>	PC_out,
		R_nW		=>	'1',
		data_out	=>	IR);
		
	U4:	IF_ID_Pipeline_Register port map(
		clk				=>	clk,
		En				=>	'1',
		reset			=>	reset,
		Inst_in			=>	IR,
		next_addr_in	=>	PC_in,
		Inst_out		=>	Inst_out_Stage2,
		next_addr_out	=>	next_addr_out_stage2);
	
end;
