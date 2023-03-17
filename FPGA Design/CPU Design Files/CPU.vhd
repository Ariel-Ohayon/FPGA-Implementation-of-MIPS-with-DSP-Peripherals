library ieee;
use ieee.std_logic_1164.all;

entity CPU is
port(
	reset:		in		std_logic;
	clk:			in		std_logic;
	CPU_clk:		out	std_logic;
	CPU_reset:	out	std_logic;
	rx:			in		std_logic;
	tx:			out	std_logic);
end;

architecture one of CPU is
	
	-- / Components \ --
	component Debugger
	port(
		reset:		in		std_logic;
		clk:		in		std_logic;
		serial_in:	in		std_logic; -- RX
		serial_out:	out	std_logic; -- TX
		clkout:		out	std_logic;
		resetout:	out	std_logic;
		ProgMode:	out	std_logic;
		Addr_out:	out	std_logic_vector(7 downto 0);
		Data_out:	out	std_logic_vector(31 downto 0);
		I_MEM_Read_Debug:	out	std_logic;
		Addr_Read_Debug:	out	std_logic_vector(7 downto 0);
		Debug_S1_Instruction_Data:	in std_logic_vector(31 downto 0);
		Debug_S1_PC_Addr:	in	std_logic_vector(7 downto 0));
	end component;
	
	component MIPS_Core
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		ProgMode:	in	std_logic;
		ADDR_Prog:	in	std_logic_vector(7 downto 0);
		DATA_Prog:	in	std_logic_vector(31 downto 0);
		En_Prog_Data_MEM:	in	std_logic;
		I_MEM_Read_Debug:	in	std_logic;
		Addr_Read_Debug:	in	std_logic_vector(7 downto 0);
		Debug_S1_Instruction_Data:	out	std_logic_vector(31 downto 0);
		Debug_S1_PC_Addr:	out	std_logic_vector(7 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal sCPU_clk:	std_logic;
	signal sCPU_reset:	std_logic;
	signal ProgMode:	std_logic;
	signal Addr_Instruction_Memory:			std_logic_vector(7 downto 0);
	signal Data_Instruction_Memory_CPUin:	std_logic_vector(31 downto 0);
	signal Data_Instruction_Memory_CPUout:	std_logic_vector(31 downto 0);
	signal I_MEM_Read_Debug:	std_logic;
	signal Addr_Read_Debug:		std_logic_vector(7 downto 0);
	signal Debug_S1_Instruction_Data:	std_logic_vector(31 downto 0);
	signal Debug_S1_PC_Addr:	std_logic_vector(7 downto 0);
	-- / Signals \ --

begin
	
	CPU_clk <= sCPU_clk;
	CPU_reset <= sCPU_reset;
	
	U1:	MIPS_Core port map(
				clk								=>	sCPU_clk,
				reset								=>	sCPU_reset,
				ProgMode							=>	ProgMode,
				ADDR_Prog						=>	Addr_Instruction_Memory,
				DATA_Prog						=>	Data_Instruction_Memory_CPUin,
				En_Prog_Data_MEM				=>	'1',	-- To Enable R/W data from data memory in stage 4
				I_MEM_Read_Debug				=>	I_MEM_Read_Debug,
				Addr_Read_Debug				=>	Addr_Read_Debug,
				Debug_S1_Instruction_Data	=>	Debug_S1_Instruction_Data,
				Debug_S1_PC_Addr				=>	Debug_S1_PC_Addr);
				
	U2:	Debugger port map(
				reset			=>	reset,
				clk			=>	clk,
				serial_in	=>	rx, -- RX
				serial_out	=>	tx, -- TX
				clkout		=>	sCPU_clk,
				resetout		=>	sCPU_reset,
				ProgMode		=>	ProgMode,
				Addr_out		=>	Addr_Instruction_Memory,
				Data_out		=>	Data_Instruction_Memory_CPUin,
				I_MEM_Read_Debug	=>	I_MEM_Read_Debug,
				Addr_Read_Debug => Addr_Read_Debug,
				Debug_S1_Instruction_Data => Debug_S1_Instruction_Data,
				Debug_S1_PC_Addr => Debug_S1_PC_Addr);
	
end;
