library ieee;
use ieee.std_logic_1164.all;

entity MicroProcessor is
port(
	reset:						in	std_logic;
	clk:						in	std_logic;
	Instruction_Data_input:		in	std_logic_vector(7	downto 0);
	Instruction_Address_input:	in	std_logic_vector(31 downto 0);
	En_Program:					in	std_logic;	-- En_Program = '1' Read state	|	En_Program = '0' Write State
	Instruction_Data_output:	out	std_logic_vector(31 downto 0));
end;

architecture one of MicroProcessor is

	--/ Components Declaration \--
	component Adder
	port(
		input:	in	std_logic_vector(31 downto 0);
		output:	out	std_logic_vector(31 downto 0));
	end component;
	
	component PC
	port(
		reset:	in	std_logic;
		clk:	in	std_logic;
		input:	in	std_logic_vector(31 downto 0);
		output:	out	std_logic_vector(31 downto 0));
	end component;
	
	component Instruction_Memory
	port (
		clk, rd_nwr :	in	std_logic;	-- rd_nwr = '1' - Read	|	rd_nwr = '0' - Write
		addr:			in	std_Logic_vector (31 downto 0);
		data_in:		in	std_logic_vector (7  downto 0);
		data_out:		out	std_logic_vector (31 downto 0));
	end component;
	
	component IF_ID
	port(
		clk: 			in	std_logic;						--	Clock input signal: Active in RISING Edge
		reset:			in	std_logic;						--	Reset input signal: Active HIGH
		Inst_in:		in	std_logic_vector(31 downto 0);	--	Instruction get from the "Intruction Memory"
		Inst_out:		out	std_logic_vector(31 downto 0));
	end component;
	
	component MuxProgrammer
	port(
		sel:	in	std_logic;
		input0:	in	std_logic_vector(31 downto 0);
		input1:	in	std_logic_vector(31 downto 0);
		output:	out	std_logic_vector(31 downto 0));
	end component;
	--/ Components Declaration \--
	
	--/ Signals Declaration \--
	signal PC_input:						std_logic_vector(31 downto 0);
	signal PC_output:						std_logic_vector(31 downto 0);
	signal IR_input:						std_logic_vector(31 downto 0);
	signal IR_output:						std_logic_vector(31 downto 0);
	signal Addr_Instruction_Memory_Input:	std_logic_vector(31 downto 0);
	--/ Signals Declaration \--

begin
	
	Instruction_Data_output <= IR_output;
	
	U1: PC
		port map (
			reset	=>	reset,
			clk		=>	clk,
			input	=>	PC_input,
			output	=>	PC_output);
	
	U2:	Adder
		port map (
			input	=>	PC_output,
			output	=>	PC_input);
	
	U3: Instruction_Memory
		port map (
			clk			=>	clk,
			rd_nwr		=>	En_Program,	-- En_Program = '1' Read state	|	En_Program = '0' Write State
			addr		=>	Addr_Instruction_Memory_Input,
			data_in		=>	Instruction_Data_input,
			data_out	=>	IR_input);
			
	U4: IF_ID
		port map (
			clk			=>	clk,
			reset		=>	reset,
			Inst_in		=>	IR_input,
			Inst_out	=>	IR_output);
			
	U5:	MuxProgrammer
		port map (
			sel		=>	En_Program,
			input0	=>	Instruction_Address_input,
			input1	=>	PC_output,
			output	=>	Addr_Instruction_Memory_Input);
end;