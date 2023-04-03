library ieee;
use ieee.std_logic_1164.all;

entity Debugger2 is
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
end;

architecture one of Debugger2 is
	-- / Components \ --
	component UART_Transmitter
	port(
		reset:		in	std_logic;
		clk_50: 	in	std_logic;
		Data_in:	in	std_logic_vector(7 downto 0);
		tx:			out	std_logic := '1';
		trig:		in	std_logic;
		EOF:		out	std_logic;
		UART_clk:	out	std_Logic);
	end component;
	
	component UART_Four_Packet_TRAN
	port(
		reset:		in	std_logic;
		UART_clk:	in	std_logic;
		trig_in:	in	std_logic;
		Data_in:	in	std_logic_vector(31 downto 0);
		EOF:		in	std_logic;
		trig_out:	out	std_logic;
		Data_out:	out	std_logic_vector(7  downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal Data_in_Trans:	std_logic_vector(7 downto 0);
	signal trig_in_trans:	std_logic;
	signal EOF:					std_logic;
	signal UART_clk:			std_logic;
	signal Data_to_send:		std_logic_vector(31 downto 0);
	
	signal packet_trig:	std_logic;
	signal packet_trig1:	std_logic;
	signal packet_trig2:	std_logic;
	signal s1trig:			std_logic;
	signal Debug_Register:	std_logic_vector(31 downto 0);
	-- / Signals \ --
	
begin
	U3:	UART_Transmitter port map(
		reset		=>	reset,
		clk_50	=>	clk,
		Data_in	=>	Data_in_Trans,
		tx			=>	tx,
		trig		=>	trig_in_trans,
		EOF		=>	EOF,
		UART_clk	=>	UART_clk);
	
	U4:	UART_Four_Packet_TRAN port map(
		reset		=>	reset,
		UART_clk	=>	UART_clk,
		trig_in	=>	packet_trig,
		Data_in	=>	Data_to_send,
		EOF		=>	EOF,
		trig_out	=>	trig_in_trans,
		Data_out	=>	Data_in_Trans);
		
		process(reset,UART_clk)begin
			if(reset = '1')then
				s1trig <= '0';
			elsif(UART_clk 'event and UART_clk = '1')then
				s1trig <= trig;
			end if;
		end process;
		
		packet_trig <= (not s1trig) and trig;
		
		Data_to_send <= Debug_Instruction when(Debug_Instruction_sel = '1')else
							 Debug_Register when(Read_Reg = '1')else
							 (others => '0');
		process(Debug_Register,reg_sel)begin
			case(reg_sel)is
				when x"00"	=>	Debug_Register <= Debug_Reg0;
				when x"01"	=>	Debug_Register <= Debug_Reg1;
				when x"02"	=>	Debug_Register <= Debug_Reg2;
				when x"03"	=>	Debug_Register <= Debug_Reg3;
				when x"04"	=>	Debug_Register <= Debug_Reg4;
				when x"05"	=>	Debug_Register <= Debug_Reg5;
				when x"06"	=>	Debug_Register <= Debug_Reg6;
				when x"07"	=>	Debug_Register <= Debug_Reg7;
				when x"08"	=>	Debug_Register <= Debug_Reg8;
				when x"09"	=>	Debug_Register <= Debug_Reg9;
				when x"0A"	=>	Debug_Register <= Debug_Reg10;
				when x"0B"	=>	Debug_Register <= Debug_Reg11;
				when x"0C"	=>	Debug_Register <= Debug_Reg12;
				when x"0D"	=>	Debug_Register <= Debug_Reg13;
				when x"0E"	=>	Debug_Register <= Debug_Reg14;
				when x"0F"	=>	Debug_Register <= Debug_Reg15;
				when x"10"	=>	Debug_Register <= Debug_Reg16;
				when x"11"	=>	Debug_Register <= Debug_Reg17;
				when x"12"	=>	Debug_Register <= Debug_Reg18;
				when x"13"	=>	Debug_Register <= Debug_Reg19;
				when x"14"	=>	Debug_Register <= Debug_Reg20;
				when x"15"	=>	Debug_Register <= Debug_Reg21;
				when x"16"	=>	Debug_Register <= Debug_Reg22;
				when x"17"	=>	Debug_Register <= Debug_Reg23;
				when x"18"	=>	Debug_Register <= Debug_Reg24;
				when x"19"	=>	Debug_Register <= Debug_Reg25;
				when x"1A"	=>	Debug_Register <= Debug_Reg26;
				when x"1B"	=>	Debug_Register <= Debug_Reg27;
				when x"1C"	=>	Debug_Register <= Debug_Reg28;
				when x"1D"	=>	Debug_Register <= Debug_Reg29;
				when x"1E"	=>	Debug_Register <= Debug_Reg30;
				when x"1F"	=>	Debug_Register <= Debug_Reg31;
				when others	=>	Debug_Register <= (others=>'0');
			end case;
		end process;
end;