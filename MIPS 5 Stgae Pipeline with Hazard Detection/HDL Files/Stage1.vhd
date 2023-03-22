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
	Instruction:		out	std_logic_vector(31 downto 0));
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
	
	U4:	IF_ID port map(
		reset		=>	reset,
		clk			=>	clk,
		En			=>	Pipeline_Enable,
		PC_next_in	=>	PC_next,
		PC_next_out	=>	PC_in_Pipeline,
		IR_in		=>	Instrutction_Memory_out,
		IR_out		=>	Instruction);
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