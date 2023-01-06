-- Designed By: Ariel Ohayon

-- Final Microprocessor Module (not finished)

library ieee;
use ieee.std_logic_1164.all;

entity MicroProcessor is
port(
	reset:						in	std_logic;
	clk:						in	std_logic;
	Instruction_Data_input:		in	std_logic_vector(7	downto 0);
	Instruction_Address_input:	in	std_logic_vector(31 downto 0);
	En_Program:					in	std_logic;	-- En_Program = '1' Read state	|	En_Program = '0' Write State
	
	R_Type:		out std_logic;
	I_Type:		out std_logic;	
	J_Type:		out std_logic;
	BUS_Type:	out std_logic;
			
	ReadReg1:	out std_logic_vector(4 downto 0);
	ReadReg2:	out std_logic_vector(4 downto 0);
	WriteReg:	out std_logic_vector(4 downto 0);
	
	Op_Code:	out std_logic_vector(1 downto 0);
	Op_Shift:	out std_logic;
	Op_Arith:	out std_logic;
	Op_Logic:	out std_logic;
	Op_Branch:	out std_logic;
	Op_Mem:		out std_logic;
	Sig_nUnsig:	out std_logic;
	Hi_nLo:		out std_logic);
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
		R_Type:			out	std_logic;
		I_Type:			out	std_logic;
		J_Type:			out	std_logic;
		BUS_Type:		out	std_logic;
	
		ReadReg1:		out std_logic_vector(4 downto 0);
		ReadReg2:		out std_logic_vector(4 downto 0);
		WriteReg:		out std_logic_vector(4 downto 0);
	
		Op_Code:		out std_logic_vector(1 downto 0);	-- Output for ALU
		Op_Shift:		out std_logic;						-- Output for ALU
		Op_Arith:		out std_logic;						-- Output for ALU
		Op_Logic:		out std_logic;						-- Output for ALU
		Op_Branch:		out std_logic;						-- Output for ALU
		Op_Mem:			out	std_logic;
		Sig_nUnsig:		out std_logic;						-- Output for ALU	(if the bit '1' the op is with sign bit else the operation unsigned)
		Hi_nLo:			out std_logic);
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
	signal Addr_Instruction_Memory_Input:	std_logic_vector(31 downto 0);
	--/ Signals Declaration \--

begin
	
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
			R_Type		=>	R_Type,
			I_Type		=>	I_Type,
			J_Type		=>	J_Type,
			BUS_Type	=>	BUS_Type,
			
			ReadReg1	=>	ReadReg1,
			ReadReg2	=>	ReadReg2,
			WriteReg	=>	WriteReg,
	
			Op_Code		=>	Op_Code,
			Op_Shift	=>	Op_Shift,
			Op_Arith	=>	Op_Arith,
			Op_Logic	=>	Op_Logic,
			Op_Branch	=>	Op_Branch,
			Op_Mem		=>	Op_Mem,
			Sig_nUnsig	=>	Sig_nUnsig,
			Hi_nLo		=>	Hi_nLo);
			
	U5:	MuxProgrammer
		port map (
			sel		=>	En_Program,
			input0	=>	Instruction_Address_input,
			input1	=>	PC_output,
			output	=>	Addr_Instruction_Memory_Input);
end;
