library ieee;
use ieee.std_logic_1164.all;

entity Debugger is
port(
	reset:		in	std_logic;
	clk:			in	std_logic;
	rx:			in	std_logic;
	ProgMode:	out	std_logic;
	Addr_Prog:	out	std_logic_vector(7 downto 0);
	Data_Prog:	out	std_logic_vector(31 downto 0);
	CPU_clk:		out	std_logic:='0';
	CPU_reset:	out	std_logic:='0';
	Read_IM:		out	std_logic;
	reg_sel:		out	std_logic_vector(7 downto 0);
	Read_Reg:	out	std_logic;
	HEX_sel:		out	std_logic_vector(2 downto 0));
end;

architecture one of Debugger is
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
			if(sProgMode = '0')then
				packet_count <= packet_count+1;
				if(packet_count = 4)then
					packet_count <= 1;
				end if;
			end if;
		end if;
	end process;
	
	process(sProgMode,reset,clk_packet)begin
		if(reset = '1')then
			HEX_sel <= (others=>'0');
			Addr_Prog <= (others=>'0');
			Data_Prog <= (others=>'0');
		elsif(clk_packet 'event and clk_packet = '0')then
			if(sProgMode = '0')then
				if(packet_count = 1)then 		Addr_Prog <= packet_Data_out(7 downto 0); Hex_sel <= "001";
				elsif(packet_count = 2)then	Data_Prog <= packet_Data_out; Hex_sel <= "010";
				end if;
			else
				Hex_sel <= (others => '0');
			end if;
		end if;
	end process;
	ProgMode <= sProgMode;
end;