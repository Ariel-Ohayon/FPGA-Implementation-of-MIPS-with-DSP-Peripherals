library ieee;
use ieee.std_logic_1164.all;

entity MIPS_Top_Module is
port(
	reset:	in	std_logic;
	clk:	in	std_logic;
	RX:		in	std_logic;
	TX:		out	std_logic);
end;

architecture one of MIPS_Top_Module is
	-- / Components \ --
	component MIPS
	port(
		reset:	in	std_logic;
		clk:	in	std_logic;
		ProgMode:	in	std_logic;
		Addr_Prog:	in	std_logic_vector(7 downto 0);
		Data_Prog:	in	std_logic_vector(31 downto 0);
		Debug_En_Prog_Data_Mem:	in	std_logic;
		Debug_Mem_Data_out:		out	std_Logic_vector(31 downto 0);
		Debug_Instruction:		out	std_logic_vector(31 downto 0);
		Debug_Reg0:				out	std_logic_vector(31 downto 0);
		Debug_Reg1:				out	std_logic_vector(31 downto 0);
		Debug_Reg2:				out	std_logic_vector(31 downto 0);
		Debug_Reg3:				out	std_logic_vector(31 downto 0);
		Debug_Reg4:				out	std_logic_vector(31 downto 0);
		Debug_Reg5:				out	std_logic_vector(31 downto 0);
		Debug_Reg6:				out	std_logic_vector(31 downto 0);
		Debug_Reg7:				out	std_logic_vector(31 downto 0);
		Debug_Reg8:				out	std_logic_vector(31 downto 0);
		Debug_Reg9:				out	std_logic_vector(31 downto 0);
		Debug_Reg10:			out	std_logic_vector(31 downto 0);
		Debug_Reg11:			out	std_logic_vector(31 downto 0);
		Debug_Reg12:			out	std_logic_vector(31 downto 0);
		Debug_Reg13:			out	std_logic_vector(31 downto 0);
		Debug_Reg14:			out	std_logic_vector(31 downto 0);
		Debug_Reg15:			out	std_logic_vector(31 downto 0);
		Debug_Reg16:			out	std_logic_vector(31 downto 0);
		Debug_Reg17:			out	std_logic_vector(31 downto 0);
		Debug_Reg18:			out	std_logic_vector(31 downto 0);
		Debug_Reg19:			out	std_logic_vector(31 downto 0);
		Debug_Reg20:			out	std_logic_vector(31 downto 0);
		Debug_Reg21:			out	std_logic_vector(31 downto 0);
		Debug_Reg22:			out	std_logic_vector(31 downto 0);
		Debug_Reg23:			out	std_logic_vector(31 downto 0);
		Debug_Reg24:			out	std_logic_vector(31 downto 0);
		Debug_Reg25:			out	std_logic_vector(31 downto 0);
		Debug_Reg26:			out	std_logic_vector(31 downto 0);
		Debug_Reg27:			out	std_logic_vector(31 downto 0);
		Debug_Reg28:			out	std_logic_vector(31 downto 0);
		Debug_Reg29:			out	std_logic_vector(31 downto 0);
		Debug_Reg30:			out	std_logic_vector(31 downto 0);
		Debug_Reg31:			out	std_logic_vector(31 downto 0);
		Debug_Operand1:			out	std_Logic_vector(31 downto 0);
		Debug_Operand2:			out	std_Logic_vector(31 downto 0);
		Debug_ALU_Result:		out	std_logic_vector(31 downto 0));
	end component;
	
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
		Debug_Instruction:	in	std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal CPU_reset:	std_logic;
	signal CPU_clk:	std_logic;
	signal ProgMode:	std_logic;
	signal Addr_Prog:	std_logic_vector(7  downto 0);
	signal Data_Prog:	std_logic_vector(31 downto 0);
	signal Debug_En_Prog_Data_Mem:	std_logic;
	signal Debug_Mem_Data_out:			std_logic_vector(31 downto 0);
	signal Debug_Instruction:			std_logic_vector(31 downto 0);
	signal Debug_Reg0:					std_logic_vector(31 downto 0);
	signal Debug_Reg1:					std_logic_vector(31 downto 0);
	signal Debug_Reg2:					std_logic_vector(31 downto 0);
	signal Debug_Reg3:					std_logic_vector(31 downto 0);
	signal Debug_Reg4:					std_logic_vector(31 downto 0);
	signal Debug_Reg5:					std_logic_vector(31 downto 0);
	signal Debug_Reg6:					std_logic_vector(31 downto 0);
	signal Debug_Reg7:					std_logic_vector(31 downto 0);
	signal Debug_Reg8:					std_logic_vector(31 downto 0);
	signal Debug_Reg9:					std_logic_vector(31 downto 0);
	signal Debug_Reg10:					std_logic_vector(31 downto 0);
	signal Debug_Reg11:					std_logic_vector(31 downto 0);
	signal Debug_Reg12:					std_logic_vector(31 downto 0);
	signal Debug_Reg13:					std_logic_vector(31 downto 0);
	signal Debug_Reg14:					std_logic_vector(31 downto 0);
	signal Debug_Reg15:					std_logic_vector(31 downto 0);
	signal Debug_Reg16:					std_logic_vector(31 downto 0);
	signal Debug_Reg17:					std_logic_vector(31 downto 0);
	signal Debug_Reg18:					std_logic_vector(31 downto 0);
	signal Debug_Reg19:					std_logic_vector(31 downto 0);
	signal Debug_Reg20:					std_logic_vector(31 downto 0);
	signal Debug_Reg21:					std_logic_vector(31 downto 0);
	signal Debug_Reg22:					std_logic_vector(31 downto 0);
	signal Debug_Reg23:					std_logic_vector(31 downto 0);
	signal Debug_Reg24:					std_logic_vector(31 downto 0);
	signal Debug_Reg25:					std_logic_vector(31 downto 0);
	signal Debug_Reg26:					std_logic_vector(31 downto 0);
	signal Debug_Reg27:					std_logic_vector(31 downto 0);
	signal Debug_Reg28:					std_logic_vector(31 downto 0);
	signal Debug_Reg29:					std_logic_vector(31 downto 0);
	signal Debug_Reg30:					std_logic_vector(31 downto 0);
	signal Debug_Reg31:					std_logic_vector(31 downto 0);
	signal Debug_Operand1:				std_logic_vector(31 downto 0);
	signal Debug_Operand2:				std_logic_vector(31 downto 0);
	signal Debug_ALU_Result:			std_logic_vector(31 downto 0);
	-- / Signals \ --

begin
	Debug_En_Prog_Data_Mem <= '0';
	U1:	MIPS port map(
	reset							=>	CPU_reset,
	clk							=>	CPU_clk,
	ProgMode						=>	ProgMode,
	Addr_Prog					=>	Addr_Prog,
	Data_Prog					=>	Data_Prog,
	Debug_En_Prog_Data_Mem	=>	Debug_En_Prog_Data_Mem,
	Debug_Mem_Data_out		=>	Debug_Mem_Data_out,
	Debug_Instruction			=>	Debug_Instruction,
	Debug_Reg0					=>	Debug_Reg0,
	Debug_Reg1					=>	Debug_Reg1,
	Debug_Reg2					=>	Debug_Reg2,
	Debug_Reg3					=>	Debug_Reg3,
	Debug_Reg4					=>	Debug_Reg4,
	Debug_Reg5					=>	Debug_Reg5,
	Debug_Reg6					=>	Debug_Reg6,
	Debug_Reg7					=>	Debug_Reg7,
	Debug_Reg8					=>	Debug_Reg8,
	Debug_Reg9					=>	Debug_Reg9,
	Debug_Reg10					=>	Debug_Reg10,
	Debug_Reg11					=>	Debug_Reg11,
	Debug_Reg12					=>	Debug_Reg12,
	Debug_Reg13					=>	Debug_Reg13,
	Debug_Reg14					=>	Debug_Reg14,
	Debug_Reg15					=>	Debug_Reg15,
	Debug_Reg16					=>	Debug_Reg16,
	Debug_Reg17					=>	Debug_Reg17,
	Debug_Reg18					=>	Debug_Reg18,
	Debug_Reg19					=>	Debug_Reg19,
	Debug_Reg20					=>	Debug_Reg20,
	Debug_Reg21					=>	Debug_Reg21,
	Debug_Reg22					=>	Debug_Reg22,
	Debug_Reg23					=>	Debug_Reg23,
	Debug_Reg24					=>	Debug_Reg24,
	Debug_Reg25					=>	Debug_Reg25,
	Debug_Reg26					=>	Debug_Reg26,
	Debug_Reg27					=>	Debug_Reg27,
	Debug_Reg28					=>	Debug_Reg28,
	Debug_Reg29					=>	Debug_Reg29,
	Debug_Reg30					=>	Debug_Reg30,
	Debug_Reg31					=>	Debug_Reg31,
	Debug_Operand1				=>	Debug_Operand1,
	Debug_Operand2				=>	Debug_Operand2,
	Debug_ALU_Result			=>	Debug_ALU_Result);
	
	U2: Debugger port map(
		reset						=>	reset,
		clk							=>	clk,
		serial_in					=>	RX,
		serial_out					=>	TX,
		clkout						=>	CPU_clk,
		resetout					=>	CPU_reset,
		ProgMode					=>	ProgMode,
		Addr_out					=>	Addr_Prog,
		Data_out					=>	Data_Prog,
		Debug_Instruction			=>	Debug_Instruction);
end;