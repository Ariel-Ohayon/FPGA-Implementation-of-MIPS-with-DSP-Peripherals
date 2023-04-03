library ieee;
use ieee.std_logic_1164.all;

entity MIPS_Top_Module is
port(
	reset:						in		std_logic;
	clk:							in		std_logic;
	rx:							in		std_logic;
	tx:							out	std_logic;
	Debug_selector:			in		std_logic_vector(4 downto 0);
	Debug_sel_Instruction:	in		std_logic;
	HEX0:							out	std_logic_vector(6 downto 0);
	HEX1:							out	std_logic_vector(6 downto 0);
	HEX2:							out	std_logic_vector(6 downto 0);
	HEX3:							out	std_logic_vector(6 downto 0);
	HEX4:							out	std_logic_vector(6 downto 0);
	HEX5:							out	std_logic_vector(6 downto 0);
	HEX6:							out	std_logic_vector(6 downto 0);
	HEX7:							out	std_logic_vector(6 downto 0);
	CPU_reset_out:				out	std_logic;
	CPU_clk_out:				out	std_logic;
	ProgMode_out:				out	std_logic;
	Read_IM_out:				out	std_logic);
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
		reset:	in	std_logic;
		clk:	in	std_logic;
		rx:	in	std_logic;
		ProgMode:	out	std_logic;
		Addr_Prog:	out	std_logic_vector(7 downto 0);
		Data_Prog:	out	std_logic_vector(31 downto 0);
		CPU_clk:		out	std_logic;
		CPU_reset:	out	std_logic;
		Read_IM:		out	std_logic;
		Read_Reg:	out	std_logic;
		reg_sel:		out	std_logic_vector(7 downto 0);
		HEX_sel:		out	std_logic_vector(2 downto 0));
	end component;
	
	component Debugger2
	port(
		reset:						in		std_logic;
		clk:							in		std_logic;
		tx:							out	std_logic;
		trig:							in		std_logic;
		reg_sel:						in		std_logic_vector(7 downto 0);
		Read_Reg:					in		std_logic;
		Debug_Instruction_sel:	in		std_logic;
		Debug_Instruction:		in		std_logic_vector(31 downto 0);
		Debug_Reg0:					in		std_logic_vector(31 downto 0);
		Debug_Reg1:					in		std_logic_vector(31 downto 0);
		Debug_Reg2:					in		std_logic_vector(31 downto 0);
		Debug_Reg3:					in		std_logic_vector(31 downto 0);
		Debug_Reg4:					in		std_logic_vector(31 downto 0);
		Debug_Reg5:					in		std_logic_vector(31 downto 0);
		Debug_Reg6:					in		std_logic_vector(31 downto 0);
		Debug_Reg7:					in		std_logic_vector(31 downto 0);
		Debug_Reg8:					in		std_logic_vector(31 downto 0);
		Debug_Reg9:					in		std_logic_vector(31 downto 0);
		Debug_Reg10:				in		std_logic_vector(31 downto 0);
		Debug_Reg11:				in		std_logic_vector(31 downto 0);
		Debug_Reg12:				in		std_logic_vector(31 downto 0);
		Debug_Reg13:				in		std_logic_vector(31 downto 0);
		Debug_Reg14:				in		std_logic_vector(31 downto 0);
		Debug_Reg15:				in		std_logic_vector(31 downto 0);
		Debug_Reg16:				in		std_logic_vector(31 downto 0);
		Debug_Reg17:				in		std_logic_vector(31 downto 0);
		Debug_Reg18:				in		std_logic_vector(31 downto 0);
		Debug_Reg19:				in		std_logic_vector(31 downto 0);
		Debug_Reg20:				in		std_logic_vector(31 downto 0);
		Debug_Reg21:				in		std_logic_vector(31 downto 0);
		Debug_Reg22:				in		std_logic_vector(31 downto 0);
		Debug_Reg23:				in		std_logic_vector(31 downto 0);
		Debug_Reg24:				in		std_logic_vector(31 downto 0);
		Debug_Reg25:				in		std_logic_vector(31 downto 0);
		Debug_Reg26:				in		std_logic_vector(31 downto 0);
		Debug_Reg27:				in		std_logic_vector(31 downto 0);
		Debug_Reg28:				in		std_logic_vector(31 downto 0);
		Debug_Reg29:				in		std_logic_vector(31 downto 0);
		Debug_Reg30:				in		std_logic_vector(31 downto 0);
		Debug_Reg31:				in		std_logic_vector(31 downto 0));
	end component;
	
	component SevenSeg_Decoder
	port(
		inpt:  in  std_logic_vector(3 downto 0);
		outpt: out std_logic_vector (6 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal Debug_Reg:std_logic_vector((32*32)-1 downto 0);
	signal Debug_Op:std_logic:='0';
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
	
	signal HEX_Data:		std_logic_vector(31 downto 0);
	signal Debug_Data:	std_logic_vector(31 downto 0);
	signal BCD_Data:		std_logic_vector(31 downto 0);
	signal CPU_clk:		std_logic;
	signal CPU_reset:		std_logic;
	signal CPU_clk_debug:	std_logic;
	
	signal n_reset:std_logic;
	
	signal Debug_Hex:	std_logic_vector(2 downto 0);
	signal Read_IM:	std_logic;
	signal reg_sel:	std_logic_vector(7 downto 0);
	signal Read_Reg:	std_logic;
	-- / Signals \ --

begin
	
	n_reset <= not reset;
	
	Debug_Reg <= Debug_Reg0  & Debug_Reg1  & Debug_Reg2  & Debug_Reg3  & 
					 Debug_Reg4  & Debug_Reg5  & Debug_Reg6  & Debug_Reg7  & 
					 Debug_Reg8  & Debug_Reg9  & Debug_Reg10 & Debug_Reg11 & 
					 Debug_Reg12 & Debug_Reg13 & Debug_Reg15 & Debug_Reg16 & 
					 Debug_Reg16 & Debug_Reg17 & Debug_Reg18 & Debug_Reg19 & 
					 Debug_Reg20 & Debug_Reg21 & Debug_Reg22 & Debug_Reg23 & 
					 Debug_Reg24 & Debug_Reg25 & Debug_Reg26 & Debug_Reg27 & 
					 Debug_Reg28 & Debug_Reg29 & Debug_Reg30 & Debug_Reg31;
	
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
	
	process(Debug_selector,Debug_Reg,Debug_Op,Debug_ALU_Result,Debug_sel_Instruction)begin
		if(Debug_Hex = "001")then
			Debug_Data <= (others=>'0');
			Debug_Data(7 downto 0) <= Addr_Prog;
		elsif(Debug_Hex = "010")then
			Debug_Data <= Data_Prog;
		elsif(Debug_sel_Instruction = '1')then
			Debug_Data <= Debug_Instruction;
		else
			case(Debug_selector)is
				when "00000"	=>	Debug_Data <= Debug_Reg0;
				when "00001"	=> Debug_Data <= Debug_Reg1;
				when "00010"	=> Debug_Data <= Debug_Reg2;
				when "00011"	=> Debug_Data <= Debug_Reg3;
				when "00100"	=> Debug_Data <= Debug_Reg4;
				when "00101"	=> Debug_Data <= Debug_Reg5;
				when "00110"	=> Debug_Data <= Debug_Reg6;
				when "00111"	=> Debug_Data <= Debug_Reg7;
				when "01000"	=> Debug_Data <= Debug_Reg8;
				
				when "01001"	=> Debug_Data <= Debug_Reg9;
				when "01010"	=> Debug_Data <= Debug_Reg10;
				when "01011"	=> Debug_Data <= Debug_Reg11;
				when "01100"	=> Debug_Data <= Debug_Reg12;
				when "01101"	=> Debug_Data <= Debug_Reg13;
				when "01110"	=> Debug_Data <= Debug_Reg14;
				when "01111"	=> Debug_Data <= Debug_Reg15;
				
				when "10000"	=> Debug_Data <= Debug_Reg16;
				when "10001"	=> Debug_Data <= Debug_Reg17;
				when "10010"	=> Debug_Data <= Debug_Reg18;
				when "10011"	=> Debug_Data <= Debug_Reg19;
				when "10100"	=> Debug_Data <= Debug_Reg20;
				when "10101"	=> Debug_Data <= Debug_Reg21;
				when "10110"	=> Debug_Data <= Debug_Reg22;
				when "10111"	=> Debug_Data <= Debug_Reg23;
				
				when "11000"	=> Debug_Data <= Debug_Reg24;
				when "11001"	=> Debug_Data <= Debug_Reg25;
				when "11010"	=> Debug_Data <= Debug_Reg26;
				when "11011"	=> Debug_Data <= Debug_Reg27;
				when "11100"	=> Debug_Data <= Debug_Reg28;
				when "11101"	=> Debug_Data <= Debug_Reg29;
				when "11110"	=> Debug_Data <= Debug_Reg30;
				when others	=> Debug_Data <= Debug_Reg31;
				
			end case;
		end if;
	end process;
	
	U3: SevenSeg_Decoder port map(
		inpt	=>	HEX_Data(3 downto 0),
		outpt	=>	HEX0);
		
	U4: SevenSeg_Decoder port map(
		inpt	=>	HEX_Data(7 downto 4),
		outpt	=>	HEX1);
		
	U5: SevenSeg_Decoder port map(
		inpt	=>	HEX_Data(11 downto 8),
		outpt	=>	HEX2);
		
	U6: SevenSeg_Decoder port map(
		inpt	=>	HEX_Data(15 downto 12),
		outpt	=>	HEX3);
		
	U7: SevenSeg_Decoder port map(
		inpt	=>	HEX_Data(19 downto 16),
		outpt	=>	HEX4);
		
	U8: SevenSeg_Decoder port map(
		inpt	=>	HEX_Data(23 downto 20),
		outpt	=>	HEX5);
		
	U9: SevenSeg_Decoder port map(
		inpt	=>	HEX_Data(27 downto 24),
		outpt	=>	HEX6);
		
	U10: SevenSeg_Decoder port map(
		inpt	=>	HEX_Data(31 downto 28),
		outpt	=>	HEX7);
		
	
	HEX_Data <= Debug_Data;
	
	U11: Debugger port map(
		reset			=>	n_reset,
		clk			=>	clk,
		rx				=>	rx,
		ProgMode		=>	ProgMode,
		Addr_Prog	=>	Addr_Prog,
		Data_Prog	=>	Data_Prog,
		CPU_clk		=>	CPU_clk_debug,
		CPU_reset	=>	CPU_reset,
		Read_IM		=>	Read_IM,
		Read_Reg		=>	Read_Reg,
		reg_sel		=>	reg_sel,
		Hex_sel		=>	Debug_Hex);
		
	U12:	Debugger2 port map(
		reset							=>	n_reset,
		clk							=>	clk,
		tx								=>	tx,
		trig							=>	Read_IM or Read_Reg,
		Debug_Instruction_sel	=>	Read_IM,
		reg_sel						=>	reg_sel,
		Read_Reg						=>	Read_Reg,
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
	
	Read_IM_out <= Read_IM;
	ProgMode_out <= ProgMode;
	CPU_clk_out <= CPU_clk;
	CPU_reset_out <= CPU_reset;
	CPU_clk <= CPU_clk_debug;
end;