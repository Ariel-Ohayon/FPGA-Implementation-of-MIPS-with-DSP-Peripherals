library ieee;
use ieee.std_logic_1164.all;

entity On_Core_Debugger is
port(
	reset:					in	std_logic;
	clk:					in	std_logic;
	rx:						in	std_logic;
	ProgMode:				out	std_logic;
	Addr_Prog:				out	std_logic_vector(7 downto 0);
	Data_Prog:				out	std_logic_vector(31 downto 0);
	CPU_clk:				out	std_logic:='0';
	CPU_reset:				out	std_logic:='0';
	En_Data_Mem:		out	std_logic;
	tx:					out	std_logic;
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
end;

architecture one of On_Core_Debugger is
	-- / Components \ --
	component Debugger_Reciever
	port(
		reset:			in	std_logic;
		clk:			in	std_logic;
		rx:				in	std_logic;
		ProgMode:		out	std_logic;
		Addr_Prog:		out	std_logic_vector(7 downto 0);
		Data_Prog:		out	std_logic_vector(31 downto 0);
		CPU_clk:		out	std_logic:='0';
		CPU_reset:		out	std_logic:='0';
		Read_IM:		out	std_logic;
		reg_sel:		out	std_logic_vector(7 downto 0);
		En_Data_Mem:	out	std_logic;
		Read_Reg:		out	std_logic);
	end component;
	
	component Debugger_Transmitter
	port(
		reset:					in		std_logic;
		clk:					in		std_logic;
		tx:						out	std_logic;
		trig:					in		std_logic;
		reg_sel:				in		std_logic_vector(7 downto 0);
		Read_Reg:				in		std_logic;
		Debug_Instruction_sel:	in		std_logic;
		Debug_Instruction:		in		std_logic_vector(31 downto 0);
		Debug_Reg0:				in		std_logic_vector(31 downto 0);
		Debug_Reg1:				in		std_logic_vector(31 downto 0);
		Debug_Reg2:				in		std_logic_vector(31 downto 0);
		Debug_Reg3:				in		std_logic_vector(31 downto 0);
		Debug_Reg4:				in		std_logic_vector(31 downto 0);
		Debug_Reg5:				in		std_logic_vector(31 downto 0);
		Debug_Reg6:				in		std_logic_vector(31 downto 0);
		Debug_Reg7:				in		std_logic_vector(31 downto 0);
		Debug_Reg8:				in		std_logic_vector(31 downto 0);
		Debug_Reg9:				in		std_logic_vector(31 downto 0);
		Debug_Reg10:			in		std_logic_vector(31 downto 0);
		Debug_Reg11:			in		std_logic_vector(31 downto 0);
		Debug_Reg12:			in		std_logic_vector(31 downto 0);
		Debug_Reg13:			in		std_logic_vector(31 downto 0);
		Debug_Reg14:			in		std_logic_vector(31 downto 0);
		Debug_Reg15:			in		std_logic_vector(31 downto 0);
		Debug_Reg16:			in		std_logic_vector(31 downto 0);
		Debug_Reg17:			in		std_logic_vector(31 downto 0);
		Debug_Reg18:			in		std_logic_vector(31 downto 0);
		Debug_Reg19:			in		std_logic_vector(31 downto 0);
		Debug_Reg20:			in		std_logic_vector(31 downto 0);
		Debug_Reg21:			in		std_logic_vector(31 downto 0);
		Debug_Reg22:			in		std_logic_vector(31 downto 0);
		Debug_Reg23:			in		std_logic_vector(31 downto 0);
		Debug_Reg24:			in		std_logic_vector(31 downto 0);
		Debug_Reg25:			in		std_logic_vector(31 downto 0);
		Debug_Reg26:			in		std_logic_vector(31 downto 0);
		Debug_Reg27:			in		std_logic_vector(31 downto 0);
		Debug_Reg28:			in		std_logic_vector(31 downto 0);
		Debug_Reg29:			in		std_logic_vector(31 downto 0);
		Debug_Reg30:			in		std_logic_vector(31 downto 0);
		Debug_Reg31:			in		std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --
	
	signal reg_sel:	std_logic_vector(7 downto 0);
	signal Read_Reg:	std_logic;
	signal Read_IM:	std_logic;
	
begin
	
	U1:	Debugger_Reciever port map(
		reset		=>	reset,
		clk			=>	clk,
		rx			=>	rx,
		ProgMode	=>	ProgMode,
		Addr_Prog	=>	Addr_Prog,
		Data_Prog	=>	Data_Prog,
		CPU_clk		=>	CPU_clk,
		CPU_reset	=>	CPU_reset,
		Read_IM		=>	Read_IM,
		reg_sel		=>	reg_sel,
		En_Data_Mem	=>	En_Data_Mem,
		Read_Reg	=>	Read_Reg);
	
	U2:	Debugger_Transmitter port map(
		reset					=>	reset,
		clk						=>	clk,
		tx						=>	tx,
		trig					=>	Read_IM or Read_Reg,
		reg_sel					=>	reg_sel,
		Read_Reg				=>	Read_Reg,
		Debug_Instruction_sel	=>	Read_IM,
		Debug_Instruction		=>	Debug_Instruction,
		Debug_Reg0				=>	Debug_Reg0,
		Debug_Reg1				=>	Debug_Reg1,
		Debug_Reg2				=>	Debug_Reg2,
		Debug_Reg3				=>	Debug_Reg3,
		Debug_Reg4				=>	Debug_Reg4,
		Debug_Reg5				=>	Debug_Reg5,
		Debug_Reg6				=>	Debug_Reg6,
		Debug_Reg7				=>	Debug_Reg7,
		Debug_Reg8				=>	Debug_Reg8,
		Debug_Reg9				=>	Debug_Reg9,
		Debug_Reg10				=>	Debug_Reg10,
		Debug_Reg11				=>	Debug_Reg11,
		Debug_Reg12				=>	Debug_Reg12,
		Debug_Reg13				=>	Debug_Reg13,
		Debug_Reg14				=>	Debug_Reg14,
		Debug_Reg15				=>	Debug_Reg15,
		Debug_Reg16				=>	Debug_Reg16,
		Debug_Reg17				=>	Debug_Reg17,
		Debug_Reg18				=>	Debug_Reg18,
		Debug_Reg19				=>	Debug_Reg19,
		Debug_Reg20				=>	Debug_Reg20,
		Debug_Reg21				=>	Debug_Reg21,
		Debug_Reg22				=>	Debug_Reg22,
		Debug_Reg23				=>	Debug_Reg23,
		Debug_Reg24				=>	Debug_Reg24,
		Debug_Reg25				=>	Debug_Reg25,
		Debug_Reg26				=>	Debug_Reg26,
		Debug_Reg27				=>	Debug_Reg27,
		Debug_Reg28				=>	Debug_Reg28,
		Debug_Reg29				=>	Debug_Reg29,
		Debug_Reg30				=>	Debug_Reg30,
		Debug_Reg31				=>	Debug_Reg31);
end;

-- SubModule: Debugger_Reciever --

library ieee;
use ieee.std_logic_1164.all;

entity Debugger_Reciever is
port(
	reset:			in	std_logic;
	clk:				in	std_logic;
	rx:				in	std_logic;
	ProgMode:		out	std_logic;
	Addr_Prog:		out	std_logic_vector(7 downto 0);
	Data_Prog:		out	std_logic_vector(31 downto 0);
	CPU_clk:			out	std_logic:='0';
	CPU_reset:		out	std_logic:='0';
	Read_IM:			out	std_logic;
	reg_sel:			out	std_logic_vector(7 downto 0);
	En_Data_Mem:	out	std_logic;
	Read_Reg:		out	std_logic);
	--HEX_sel:		out	std_logic_vector(2 downto 0));
end;

architecture one of Debugger_Reciever is
	-- / Components \ --
	component Reciever
	port(
		reset:		in	std_logic;
		clk_50:		in	std_logic;
		rx:			in	std_logic;
		Data_out:	out	std_logic_vector(7 downto 0);
		recv_flag:	out	std_logic);
	end component;
	
	component UART_Four_Packet_RECV
	port(
		reset:		in		std_logic;
		clk:			in		std_logic;
		clk_50:		in		std_logic;
		Data_in:		in		std_logic_vector(7  downto 0);
		Data_out:	out	std_logic_vector(31 downto 0);
		clk_packet:	out	std_logic);
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal byte_Data_out:	std_logic_vector(7 downto 0);
	signal recv_flag:			std_logic;
	signal packet_Data_out:	std_logic_vector(31 downto 0);
	signal clk_packet:		std_logic;
	signal sProgMode:			std_logic;
	
	signal packet_count:		integer range 0 to 4:=0;
	
	signal UART_clk:	std_logic;
	signal EOF:			std_logic;
	signal trig_in_trans:	std_logic;
	signal Data_in_Trans:	std_logic_vector(7 downto 0);
	signal Data_to_send:		std_logic_vector(31 downto 0);
	signal trig:				std_logic;
	signal sEn_Data_Mem:		std_logic;
	-- / Signals \ --
	
begin
	U1:	Reciever port map(
		reset			=>	reset,
		clk_50		=>	clk,
		rx				=>	rx,
		Data_out		=>	byte_Data_out,
		recv_flag	=>	recv_flag);
		
	U2:	UART_Four_Packet_RECV port map(
		reset			=>	reset,
		clk			=>	recv_flag,
		clk_50		=>	clk,
		Data_in		=>	byte_Data_out,
		Data_out		=>	packet_Data_out,
		clk_packet	=>	clk_packet);
		
	process(reset,clk_packet)begin
		if(reset = '1')then
			CPU_clk <= '0';
			CPU_reset <= '0';
			sProgMode <= '1';
			Read_IM <= '0';
			sEn_Data_Mem <= '0';
		elsif(clk_packet 'event and clk_packet = '0')then
			case(packet_Data_out)is
				when x"6B6C6363"	=>	-- "cclk"
					CPU_clk <= '1';
					CPU_reset <= '0';
				when x"30303030"	=>
					CPU_clk <= '0';
					CPU_reset <= '0';
				when x"31545352"	=>	-- "RST1"
					CPU_reset <= '1';
					CPU_clk <= '0';
				when others=>
					CPU_clk	<= '0';
					CPU_reset <= '0';
			end case;
			if(packet_Data_out = x"30454D49")then
				sProgMode <= '0';
			elsif(packet_Data_out = x"31454D49")then
				sProgMode <= '1';
			elsif(packet_Data_out = x"45524D49")then
				Read_IM <= '1';
			elsif(packet_Data_out(23 downto 0) = x"474552")then
				reg_sel <= packet_data_out(31 downto 24);
				Read_Reg <= '1';
			elsif(packet_Data_out = x"31454D44")then	-- DME1 = 
				sProgMode <= '1';
				sEn_Data_Mem <= '1';
			elsif(packet_Data_out = x"30454D44")then	-- DME0
				sEn_Data_Mem <= '0';
			else
				reg_sel <= (others => '0');
				Read_IM <= '0';
				Read_Reg <= '0';
			end if;
		end if;
	end process;
	
	
	process(reset,clk_packet)begin
		if(reset = '1')then
			packet_count <= 0;
		elsif(clk_packet 'event and clk_packet = '1')then
			if(sProgMode = '0' or (sEn_Data_Mem = '1'))then
				packet_count <= packet_count+1;
				if(packet_count = 4)then
					packet_count <= 1;
				end if;
			else
				packet_count <= 0;
			end if;
		end if;
	end process;
	
	process(sProgMode,reset,clk_packet)begin
		if(reset = '1')then
			--HEX_sel <= (others=>'0');
			Addr_Prog <= (others=>'0');
			Data_Prog <= (others=>'0');
		elsif(clk_packet 'event and clk_packet = '0')then
			if(sProgMode = '0' or (sEn_Data_Mem = '1'))then
				if(packet_count = 1)then 		Addr_Prog <= packet_Data_out(7 downto 0); --Hex_sel <= "001";
				elsif(packet_count = 2)then	Data_Prog <= packet_Data_out; --Hex_sel <= "010";
				end if;
			else
				--Hex_sel <= (others => '0');
			end if;
		end if;
	end process;
	ProgMode <= sProgMode;
	En_Data_Mem <= sEn_Data_Mem;
end;

-- SubModule: Debugger_Transmitter --

library ieee;
use ieee.std_logic_1164.all;

entity Debugger_Transmitter is
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

architecture one of Debugger_Transmitter is
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

-- SubModule: Reciever --

library ieee;
use ieee.std_logic_1164.all;

entity Reciever is
port(
	reset:		in	std_logic;
	clk_50:		in	std_logic;
	rx:			in	std_logic;
	Data_out:	out	std_logic_vector(7 downto 0);
	recv_flag:	out	std_logic);
end;

architecture one of Reciever is
	signal sData:			std_logic_vector(9 downto 0);
	signal counter:			integer := 0;
	signal clk:				std_logic;
	signal prescaler:		integer range 0 to 434 := 0;
begin
	
	process(reset,clk_50)begin
		if(reset = '1')then
			recv_flag <= '0';
			prescaler <= 0;
			clk <= '0';
			counter <= 0;
		elsif(clk_50 'event and clk_50 = '1')then
			recv_flag <= '0';
			if(rx = '0' or counter > 0)then
				if(prescaler = 434)then
					prescaler <= 0;
					clk <= '0';
					counter <= counter+1;
				elsif(prescaler < 434/2)then
					prescaler <= prescaler + 1;
					clk <= '0';
				else
					prescaler <= prescaler + 1;
					clk <= '1';
				end if;
				if(counter = 10)then
					counter <= 0;
					recv_flag <= '1';
				end if;
			end if;
		end if;
	end process;
	
	process(reset,clk)begin
		if(reset='1')then
			sData <= (others => '1');
			Data_out <= (others=>'0');
		elsif(clk 'event and clk = '1')then
			sData <= rx & sData(9 downto 1);
			if(rx = '0' or counter > 0)then
				if(counter >= 9)then
					Data_out <= sData(9 downto 2);
				end if;
			end if;
		end if;
	end process;
end;

-- SubModule: UART_Four_Packet_RECV --

library ieee;
use ieee.std_logic_1164.all;

entity UART_Four_Packet_RECV is
port(
	reset:		in		std_logic;
	clk:			in		std_logic;
	clk_50:		in		std_logic;
	Data_in:		in		std_logic_vector(7  downto 0);
	Data_out:	out	std_logic_vector(31 downto 0);
	clk_packet:	out	std_logic);
end;

architecture one of UART_Four_Packet_RECV is
	signal sig:	std_logic_vector(31 downto 0);
	signal counter:integer range 0 to 4 := 0;
	signal clk_packet_signal:	std_logic;
	signal sclk_packet:			std_logic;
begin
	process(reset,clk)begin
		if(reset = '1')then
			sig <= (others=>'0');
		elsif(clk 'event and clk = '1')then
			sig <= Data_in & sig(31 downto 8);
		end if;
	end process;
	
	process(reset,clk)begin
		if(reset = '1')then
			clk_packet_signal <= '0';
			counter <= 0;
		elsif(clk 'event and clk = '1')then
			clk_packet_signal <= '0';
			counter <= counter+1;
			if(counter = 3)then
				counter <= 0;
				clk_packet_signal <= '1';
			end if;
		end if;
	end process;
	
	process(clk_packet_signal,reset)begin
		if(reset = '1')then
			Data_out <= (others=>'0');
		elsif(clk_packet_signal 'event and clk_packet_signal = '1')then
			Data_out <= sig;
		end if;
	end process;
	
	process(reset,clk_50)begin
		if(reset = '1')then
			sclk_packet <= '0';
		elsif(clk_50 'event and clk_50 = '1')then
			sclk_packet <= clk_packet_signal;
		end if;
	end process;
	
	clk_packet <= (not sclk_packet) and clk_packet_signal;
	
end;

-- SubModule: UART_Transmitter --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UART_Transmitter is
port(
	reset:		in	std_logic;
	clk_50: 	in	std_logic;
	Data_in:	in	std_logic_vector(7 downto 0);
	tx:			out	std_logic := '1';
	trig:		in	std_logic;
	EOF:		out	std_logic;
	UART_clk:	out	std_Logic);
end;

architecture one of UART_Transmitter is

	type state is (IDLE, STRT,D0,D1,D2,D3,D4,D5,D6,D7,STP);
	signal ns,ps,nsp: state;
	signal counter: integer range 0 to 434 := 0;					-- Baud Rate = 115200[BPS]
	signal UARTclk: std_logic;

begin
	UART_clk <= UARTclk;
	P1:process(reset,clk_50)
	begin
		if (reset = '1') then
			UARTclk <= '0';
			counter <= 0;
		elsif (clk_50 'event and clk_50 = '1') then
			if(ps = IDLE)then
				if(trig = '1')then
					nsp <= STRT;
				else
					nsp <= IDLE;
				end if;
			end if;
			if (counter = 434) then
				counter <= 0;
				UARTclk <= '0';
			elsif (counter < 434/2) then
				UARTclk <= '0';
				counter <= counter+1;
			else
				UARTclk <= '1';
				counter <= counter+1;
			end if;
		end if;
	end process;

	P2:process(UARTclk,reset)
	begin
		if (reset = '1') then
			ps <= IDLE;
		elsif (UARTclk 'event and UARTclk = '1') then
			ps <= ns;
		end if;
	end process;
	
	P3:process(ps,trig)
	begin
		EOF <= '0';
		case (ps) is
		when IDLE => 
			ns <= nsp;
			tx <= '1';
		when STRT =>
			ns <= D0;
			tx <= '0';
		when D0 =>
			ns <= D1;
			tx <= Data_in(0);
		when D1 =>
			ns <= D2;
			tx <= Data_in(1);
		when D2 =>
			ns <= D3;
			tx <= Data_in(2);
		when D3 =>
			ns <= D4;
			tx <= Data_in(3);
		when D4 =>
			ns <= D5;
			tx <= Data_in(4);
		when D5 =>
			ns <= D6;
			tx <= Data_in(5);
		when D6 =>
			ns <= D7;
			tx <= Data_in(6);
		when D7 =>
			tx <= Data_in(7);
			ns <= STP;
		when STP =>
			EOF <= '1';
			ns <= IDLE;
			tx <= '1';
		end case;
	end process;
end;

-- SubModule: UART_Four_Packet_TRAN --

library ieee;
use ieee.std_logic_1164.all;

entity UART_Four_Packet_TRAN is
port(
	reset:		in	std_logic;
	UART_clk:	in	std_logic;
	trig_in:	in	std_logic;
	Data_in:	in	std_logic_vector(31 downto 0);
	EOF:		in	std_logic;
	trig_out:	out	std_logic;
	Data_out:	out	std_logic_vector(7  downto 0));
end;

architecture one of UART_Four_Packet_TRAN is
	
	type state is(IDLE, send_packet1, send_packet2, send_packet3, send_packet4);
	signal ps,ns:state;
	
begin
	process(reset,UART_clk)begin
		if(reset = '1')then
			ps <= IDLE;
		elsif(UART_clk 'event and UART_clk = '1')then
			ps <= ns;
		end if;
	end process;
	
	process(ps,trig_in,Data_in,EOF)begin
		trig_out <= '1';
		case(ps)is
			when IDLE	=>
				trig_out <= '0';
				Data_out <= (others => '0');
				if(trig_in = '1')then
					ns <= send_packet1;
				else
					ns <= IDLE;
				end if;
			when send_packet1	=>
				Data_out <= Data_in(7 downto 0);
				if(EOF = '1')then
					ns <= send_packet2;
				else
					ns <= send_packet1;
				end if;
			when send_packet2	=>
				Data_out <= Data_in(15 downto 8);
				if(EOF = '1')then
					ns <= send_packet3;
				else
					ns <= send_packet2;
				end if;
			when send_packet3	=>
				Data_out <= Data_in(23 downto 16);
				if(EOF = '1')then
					ns <= send_packet4;
				else
					ns <= send_packet3;
				end if;
			when send_packet4	=>
				Data_out <= Data_in(31 downto 24);
				if(EOF = '1')then
					ns <= IDLE;
				else
					ns <= send_packet4;
				end if;
		end case;
	end process;
end;