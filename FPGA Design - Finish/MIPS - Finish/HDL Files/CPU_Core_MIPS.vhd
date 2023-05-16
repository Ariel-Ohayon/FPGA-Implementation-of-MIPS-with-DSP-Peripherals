library ieee;
use ieee.std_logic_1164.all;

entity CPU_Core_MIPS is
port(
	reset:						in		std_logic;
	clk:							in		std_logic;
	rx:							in		std_logic;
	tx:							out	std_logic;
	CPU_reset_out:				out	std_logic;
	CPU_clk_out:				out	std_logic;
	ProgMode_out:				out	std_logic;
	Peripheral_Address:	out	std_logic_vector(15 downto 0);
	Peripheral_WData:		out	std_logic_vector(31 downto 0);
	Peripheral_RData:		in		std_logic_vector(31 downto 0);
	Peripheral_Control_Enable:	out	std_logic;
	Peripheral_Control_Write:	out	std_logic);
end;

architecture one of CPU_Core_MIPS is
	
	-- / Components \ --
	component MIPS
	port(
		reset:	in	std_logic;
		clk:	in	std_logic;
		ProgMode:	in	std_logic;
		Addr_Prog:	in	std_logic_vector(7 downto 0);
		Data_Prog:	in	std_logic_vector(31 downto 0);
		
		Peripheral_Address:	out	std_logic_vector(15 downto 0);
		Peripheral_WData:		out	std_logic_vector(31 downto 0);
		Peripheral_RData:		in		std_logic_vector(31 downto 0);
		Peripheral_Control_Enable:	out	std_logic;
		Peripheral_Control_Write:	out	std_logic;
		
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
	
	component On_Core_Debugger
	port(
		reset:					in	std_logic;
		clk:					in	std_logic;
		rx:						in	std_logic;
		ProgMode:				out	std_logic;
		Addr_Prog:				out	std_logic_vector(7 downto 0);
		Data_Prog:				out	std_logic_vector(31 downto 0);
		CPU_clk:				out	std_logic:='0';
		CPU_reset:				out	std_logic:='0';
		En_Data_Mem:			out	std_logic;
		tx:						out	std_logic;
		Debug_Instruction:		in	std_logic_vector(31 downto 0);
		Debug_Reg0:				in	std_logic_vector(31 downto 0);
		Debug_Reg1:				in	std_logic_vector(31 downto 0);
		Debug_Reg2:				in	std_logic_vector(31 downto 0);
		Debug_Reg3:				in	std_logic_vector(31 downto 0);
		Debug_Reg4:				in	std_logic_vector(31 downto 0);
		Debug_Reg5:				in	std_logic_vector(31 downto 0);
		Debug_Reg6:				in	std_logic_vector(31 downto 0);
		Debug_Reg7:				in	std_logic_vector(31 downto 0);
		Debug_Reg8:				in	std_logic_vector(31 downto 0);
		Debug_Reg9:				in	std_logic_vector(31 downto 0);
		Debug_Reg10:			in	std_logic_vector(31 downto 0);
		Debug_Reg11:			in	std_logic_vector(31 downto 0);
		Debug_Reg12:			in	std_logic_vector(31 downto 0);
		Debug_Reg13:			in	std_logic_vector(31 downto 0);
		Debug_Reg14:			in	std_logic_vector(31 downto 0);
		Debug_Reg15:			in	std_logic_vector(31 downto 0);
		Debug_Reg16:			in	std_logic_vector(31 downto 0);
		Debug_Reg17:			in	std_logic_vector(31 downto 0);
		Debug_Reg18:			in	std_logic_vector(31 downto 0);
		Debug_Reg19:			in	std_logic_vector(31 downto 0);
		Debug_Reg20:			in	std_logic_vector(31 downto 0);
		Debug_Reg21:			in	std_logic_vector(31 downto 0);
		Debug_Reg22:			in	std_logic_vector(31 downto 0);
		Debug_Reg23:			in	std_logic_vector(31 downto 0);
		Debug_Reg24:			in	std_logic_vector(31 downto 0);
		Debug_Reg25:			in	std_logic_vector(31 downto 0);
		Debug_Reg26:			in	std_logic_vector(31 downto 0);
		Debug_Reg27:			in	std_logic_vector(31 downto 0);
		Debug_Reg28:			in	std_logic_vector(31 downto 0);
		Debug_Reg29:			in	std_logic_vector(31 downto 0);
		Debug_Reg30:			in	std_logic_vector(31 downto 0);
		Debug_Reg31:			in	std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
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
	
	signal CPU_clk:		std_logic;
	signal CPU_reset:		std_logic;
	signal CPU_clk_debug:	std_logic;
	
	signal n_reset:std_logic;
	-- / Signals \ --
	
begin
	
	n_reset <= not reset;
	
	U1:	MIPS port map(
	reset								=>	CPU_reset,
	clk								=>	CPU_clk,
	ProgMode							=>	ProgMode,
	Addr_Prog						=>	Addr_Prog,
	Data_Prog						=>	Data_Prog,
	Peripheral_Address			=>	Peripheral_Address,
	Peripheral_WData				=>	Peripheral_WData,
	Peripheral_RData				=>	Peripheral_RData,
	Peripheral_Control_Enable	=>	Peripheral_Control_Enable,
	Peripheral_Control_Write	=>	Peripheral_Control_Write,
	Debug_En_Prog_Data_Mem		=>	Debug_En_Prog_Data_Mem,
	Debug_Mem_Data_out			=>	Debug_Mem_Data_out,
	Debug_Instruction				=>	Debug_Instruction,
	Debug_Reg0						=>	Debug_Reg0,
	Debug_Reg1						=>	Debug_Reg1,
	Debug_Reg2						=>	Debug_Reg2,
	Debug_Reg3						=>	Debug_Reg3,
	Debug_Reg4						=>	Debug_Reg4,
	Debug_Reg5						=>	Debug_Reg5,
	Debug_Reg6						=>	Debug_Reg6,
	Debug_Reg7						=>	Debug_Reg7,
	Debug_Reg8						=>	Debug_Reg8,
	Debug_Reg9						=>	Debug_Reg9,
	Debug_Reg10						=>	Debug_Reg10,
	Debug_Reg11						=>	Debug_Reg11,
	Debug_Reg12						=>	Debug_Reg12,
	Debug_Reg13						=>	Debug_Reg13,
	Debug_Reg14						=>	Debug_Reg14,
	Debug_Reg15						=>	Debug_Reg15,
	Debug_Reg16						=>	Debug_Reg16,
	Debug_Reg17						=>	Debug_Reg17,
	Debug_Reg18						=>	Debug_Reg18,
	Debug_Reg19						=>	Debug_Reg19,
	Debug_Reg20						=>	Debug_Reg20,
	Debug_Reg21						=>	Debug_Reg21,
	Debug_Reg22						=>	Debug_Reg22,
	Debug_Reg23						=>	Debug_Reg23,
	Debug_Reg24						=>	Debug_Reg24,
	Debug_Reg25						=>	Debug_Reg25,
	Debug_Reg26						=>	Debug_Reg26,
	Debug_Reg27						=>	Debug_Reg27,
	Debug_Reg28						=>	Debug_Reg28,
	Debug_Reg29						=>	Debug_Reg29,
	Debug_Reg30						=>	Debug_Reg30,
	Debug_Reg31						=>	Debug_Reg31,
	Debug_Operand1					=>	open,
	Debug_Operand2					=>	open,
	Debug_ALU_Result				=>	open);
	
	U2: On_Core_Debugger port map(
		reset		=>	n_reset,
		clk			=>	clk,
		rx			=>	rx,
		ProgMode	=>	ProgMode,
		Addr_Prog	=>	Addr_Prog,
		Data_Prog	=>	Data_Prog,
		CPU_clk		=>	CPU_clk_debug,
		CPU_reset	=>	CPU_reset,
		En_Data_Mem	=>	Debug_En_Prog_Data_Mem,
		tx							=>	tx,
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
		Debug_Reg31					=>	Debug_Reg31);
	
	ProgMode_out <= ProgMode;
	CPU_clk_out <= CPU_clk;
	CPU_reset_out <= CPU_reset;
	CPU_clk <= CPU_clk_debug;
	
end;