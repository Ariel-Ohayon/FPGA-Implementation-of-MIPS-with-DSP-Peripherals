library ieee;
use ieee.std_logic_1164.all;

entity Debugger is
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
end;

architecture one of Debugger is
	
	-- / Components \ --
	component UART
	port(
		rst,clk: in std_logic;							-- 50[MHz] clk Signal
		rx: in std_logic;
		tx: out std_logic;
		sendTrig: in std_logic;							-- When sendTrig rising edge the transmitter start working
		SendFlag: buffer std_logic;			-- when SendFlag rising edge the transmitter finish send the data (1[Byte])
		recv_flag:	out	std_logic;
		Data_to_Send: in  std_logic_vector(7 downto 0);
		Data_Receive: out std_logic_vector(7 downto 0));
	end component;
	
	component Four_Packet_UART
	port(
		reset:			in		std_logic;
		inpt:				in		std_logic;
		En:				out	std_logic;
		parallel_in:	in		std_logic_vector(7 downto 0);
		byte0_out:	out	std_logic_vector(7 downto 0);
		byte1_out:	out	std_logic_vector(7 downto 0);
		byte2_out:	out	std_logic_vector(7 downto 0);
		byte3_out:	out	std_logic_vector(7 downto 0));
	end component;
	
	component Debugger_Decoder
	port(
		byte0:	in		std_logic_vector(7 downto 0);
		byte1:	in		std_logic_vector(7 downto 0);
		byte2:	in		std_logic_vector(7 downto 0);
		byte3:	in		std_logic_vector(7 downto 0);
		En:		in		std_logic;
		reset:	in		std_logic;
		
		CPU_reset:	out	std_logic;
		clkout:	out	std_logic;
		ProgMode:	out	std_logic);
	end component;
	
	component Instruction_Memory_Decoder
	port(
		reset:		in		std_logic;
		clk:			in		std_logic;
		Data_in:		in		std_logic_vector(31 downto 0);
		ProgMode:	in		std_logic;
		Addr_out:	out	std_logic_vector(7 downto 0);
		Data_out:	out	std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal srecv_flag:	std_logic;
	
	signal Trigger_pulse:	std_logic;
	signal Trigger_data:		std_logic;
	signal UART_module_parallel_out:	std_logic_vector(7 downto 0);
	
	signal recv_Data:	std_logic_vector(31 downto 0);
	
	signal byte0:	std_logic_vector(7 downto 0);
	signal byte1:	std_logic_vector(7 downto 0);
	signal byte2:	std_logic_vector(7 downto 0);
	signal byte3:	std_logic_vector(7 downto 0);
	signal Data_Packet:	std_logic_vector(31 downto 0);
	
	signal clk_packet:	std_logic;
	signal s1clk_packet:	std_logic;
	signal s2clk_packet:	std_logic;
	signal En_Packet:	std_logic;
	signal sclkout:	std_logic;
	
	signal n_reset:std_logic;
	signal sProgMode:	std_logic;
	-- / Signals \ --
	
begin
	n_reset <= not reset;
	U1:	UART port map(
		rst		=>	n_reset,
		clk		=>	clk,
		rx			=>	serial_in,
		tx			=>	serial_out,
		sendTrig	=>	'0',
		SendFlag	=>	open,
		recv_flag	=>	srecv_flag,
		Data_to_Send	=>	(others=>'0'),
		Data_Receive	=>	UART_module_parallel_out);
		
	U2:	Four_Packet_UART port map(
		reset			=>	n_reset,
		inpt			=>	srecv_flag,
		En				=>	En_Packet,
		parallel_in => UART_module_parallel_out,
		byte0_out	=>	byte0,
		byte1_out	=>	byte1,
		byte2_out	=>	byte2,
		byte3_out	=>	byte3);
	
	process(reset,clk)begin
		if(reset = '0')then
			s1clk_packet <= '0';
			s2clk_packet <= '0';
		elsif(clk 'event and clk ='1')then
			s1clk_packet <= En_Packet;
			s2clk_packet <= s1clk_packet;
		end if;
	end process;
	clk_packet <= s1clk_packet and (not s2clk_packet);
	
	Data_Packet <= byte3&byte2&byte1&byte0;
	
	U3: Debugger_Decoder port map(
		byte0		=>	byte0,
		byte1		=>	byte1,
		byte2		=>	byte2,
		byte3		=>	byte3,
		En			=>	clk_packet,
		reset		=>	n_reset,
		CPU_reset	=>	resetout,
		clkout		=>	clkout,
		ProgMode	=>	sProgMode);
		
	U4:	Instruction_Memory_Decoder port map(
		reset		=>	n_reset,
		clk		=>	clk_packet,
		Data_in	=>	Data_Packet,
		ProgMode	=>	sProgMode,
		Addr_out	=>	Addr_out,
		Data_out	=>	Data_out);
	
	-- process(reset,clk_packet)begin
		-- if(reset = '0')then
			-- byte_out <= (others=>'0');
		-- elsif(clk_packet 'event and clk_packet = '1')then
			-- case(sel)is
				-- when "00" => byte_out <= byte0;
				-- when "01" => byte_out <= byte1;
				-- when "10" => byte_out <= byte2;
				-- when others => byte_out <= byte3;
			-- end case;
		-- end if;
	-- end process;
	ProgMode <= sProgMode;
end;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Four_Packet_UART is
port(
	reset:			in		std_logic;
	inpt:				in		std_logic;
	En:				out	std_logic;
	parallel_in:	in		std_logic_vector(7 downto 0);
	byte0_out:	out	std_logic_vector(7 downto 0);
	byte1_out:	out	std_logic_vector(7 downto 0);
	byte2_out:	out	std_logic_vector(7 downto 0);
	byte3_out:	out	std_logic_vector(7 downto 0));
end;

architecture one of Four_Packet_UART is
	
	signal byte0_reg:	std_logic_vector(7 downto 0);
	signal byte1_reg:	std_logic_vector(7 downto 0);
	signal byte2_reg:	std_logic_vector(7 downto 0);
	signal byte3_reg:	std_logic_vector(7 downto 0);
	signal sEn:			std_logic;
	signal sEn_vec:	std_logic_vector(7 downto 0);
	signal counter:	std_logic_vector(3 downto 0);
	
begin
	
	process(reset,inpt)begin
		if(reset = '1')then
			counter <= (others=>'0');
			sEn <= '0';
		elsif(inpt 'event and inpt = '1')then
			if(counter = "011")then
				sEn <= '1';
				counter <= (others=>'0');
			else
				sEn <= '0';
				counter <= counter + 1;
			end if;
		end if;
	end process;
	
	-- Registers -- 
	process(reset,inpt)begin
		if(reset = '1')then
			byte0_reg <= (others => '0');
			byte1_reg <= (others => '0');
		elsif(inpt 'event and inpt = '1')then
			byte3_reg <= parallel_in;
			byte2_reg <= byte3_reg;
			byte1_reg <= byte2_reg;
			byte0_reg <= byte1_reg;
		end if;
	end process;
	-- Registers --
	
	En <= sEn;
	sEn_vec <= (others => sEn);
	byte0_out <= byte0_reg and sEn_vec;
	byte1_out <= byte1_reg and sEn_vec;
	byte2_out <= byte2_reg and sEn_vec;
	byte3_out <= byte3_reg and sEn_vec;
	
end;

-- Debugger Decoder --
library ieee;
use ieee.std_logic_1164.all;

entity Debugger_Decoder is
port(
	byte0:	in		std_logic_vector(7 downto 0);
	byte1:	in		std_logic_vector(7 downto 0);
	byte2:	in		std_logic_vector(7 downto 0);
	byte3:	in		std_logic_vector(7 downto 0);
	En:		in		std_logic;
	reset:	in		std_logic;
	clkout:	out	std_logic;
	CPU_reset:	out	std_logic;
	ProgMode:	out	std_logic);
end;

architecture one of Debugger_Decoder is
	signal data:		std_logic_vector(31 downto 0);
	signal sProgMode:	std_logic;
begin
	
	data <= byte3 & byte2 & byte1 & byte0;
	
	process(reset,En)begin
		if(reset = '1')then
			clkout <= '0';
			sProgMode <= '1';
			CPU_reset <= '1';
		elsif(En 'event and En = '1')then
			if(data = x"6B6C6363")then	-- recv: "klcc" (cclk)
				clkout <= '1';
			elsif(data = x"6E454D49")then
				sProgMode <= not sProgMode;
			elsif(data = x"31545352")then		-- recv: "1TSR" (RST1)
				CPU_reset <= '1';
			elsif(data = x"30545352")then		-- recv: "0TSR" (RST0)
				CPU_reset <= '0';
			elsif(data = x"30303030")then
				clkout <= '0';
			end if;
		end if;
	end process;
	ProgMode <= sProgMode;
end;

-- SubModule: Instruction_Memory_Decoder --
library ieee;
use ieee.std_logic_1164.all;

entity Instruction_Memory_Decoder is
port(
	reset:		in		std_logic;
	clk:			in		std_logic;
	Data_in:		in		std_logic_vector(31 downto 0);
	ProgMode:	in		std_logic;
	Addr_out:	out	std_logic_vector(7 downto 0);
	Data_out:	out	std_logic_vector(31 downto 0));
end;

architecture one of Instruction_Memory_Decoder is
	signal state:	std_logic := '0';
begin
	process(reset,clk)begin
		if(reset = '1')then
			state <= '0';
			Addr_out <= (others=>'0');
			Data_out <= (others=>'0');
		elsif(clk 'event and clk = '1')then
			if(ProgMode = '0')then
				if(Data_in = x"6E454D49")then
					Addr_out <= (others=>'0');
					Data_out <= (others=>'0');
				elsif(Data_in = x"6B6C6363" nor Data_in = x"30303030")then
					if(state = '0')then
						Addr_out <= Data_in(7 downto 0);
						state <= not state;
					else
						Data_out <= Data_in;
						state <= not state;
					end if;
				end if;
			else	-- ProgMode = '1'
				Addr_out <= (others => '0');
				Data_out <= (others => '0');
				state <= '0';
			end if;
		end if;
	end process;
end;
