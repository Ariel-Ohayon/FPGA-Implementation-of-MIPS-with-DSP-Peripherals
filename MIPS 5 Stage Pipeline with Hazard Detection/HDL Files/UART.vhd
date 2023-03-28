-- UART Module
-- Designed by: Ariel Ohayon
-- This module work on 50[MHz] clk input and the baud rate 9600[BPS] witout parity bit

-- Trasmitter module

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Transmitter is
port(
	rst,clk: in std_logic;							-- 50[MHz] CLK signal
	Data_in: in std_logic_vector(7 downto 0);
	Data_out: out std_logic := '1';
	Send: in std_logic;
	EOF: out std_logic := '0');						-- EOF - End Of Frame
end;

architecture one of Transmitter is

type state is (IDLE, STRT,D0,D1,D2,D3,D4,D5,D6,D7,STP);
signal ns,ps: state;
signal counter: integer range 0 to 5208 := 0;					-- Baud Rate = 9600[BPS]
signal UARTclk: std_logic;

begin
	P1:process(rst,clk)
	begin
		if (rst = '1') then
			UARTclk <= '0';
			counter <= 0;
		elsif (clk 'event and clk = '1') then
			if (counter = 5208) then
				counter <= 0;
				UARTclk <= '0';
			elsif (counter < 5208/2) then
				UARTclk <= '0';
				counter <= counter+1;
			else
				UARTclk <= '1';
				counter <= counter+1;
			end if;
		end if;
	end process;

	P2:process(UARTclk,rst)
	begin
		if (rst = '1') then
			ps <= IDLE;
		elsif (UARTclk 'event and UARTclk = '1') then
			ps <= ns;
		end if;
	end process;
	
	P3:process(ps,Send,Data_in)
	begin
		case (ps) is
		when IDLE => 
			if (Send = '1') then 
				ns <= STRT; 
			else
				ns <= IDLE;
			end if;
			Data_out <= '1';
			EOF <= '0';
		when STRT =>
			ns <= D0;
			Data_out <= '0';			-- Start bit of UART Frame is '0'
			EOF <= '0';
		when D0 =>
			ns <= D1;
			Data_out <= Data_in(0);
			EOF <= '0';
		when D1 =>
			ns <= D2;
			Data_out <= Data_in(1);
			EOF <= '0';
		when D2 =>
			ns <= D3;
			Data_out <= Data_in(2);
			EOF <= '0';
		when D3 =>
			ns <= D4;
			Data_out <= Data_in(3);
			EOF <= '0';
		when D4 =>
			ns <= D5;
			Data_out <= Data_in(4);
			EOF <= '0';
		when D5 =>
			ns <= D6;
			Data_out <= Data_in(5);
			EOF <= '0';
		when D6 =>
			ns <= D7;
			Data_out <= Data_in(6);
			EOF <= '0';
		when D7 =>
			Data_out <= Data_in(7);
			ns <= STP;
			EOF <= '0';
		when STP =>
			ns <= IDLE;
			Data_out <= '1';
			EOF <= '1';
		end case;
	end process;
end;

-- Receiver Module

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Receiver is
port(
	rst,clk:	in	std_logic;
	rx:			in	std_logic;
	Data_out:	out std_logic_vector(7 downto 0);
	recv_flag:	out	std_logic);
end;

architecture one of Receiver is
	type state is (IDLE,STRT,D0,D1,D2,D3,D4,D5,D6,D7,STP);
	signal ps,ns: state;
	
	signal counter: integer range 0 to 5208 := 0;
	signal clk_Reciever:	std_logic;
	signal sData_out:	std_logic_vector(7 downto 0);
	signal srx:			std_logic;
begin
	process (clk,rst,rx,counter,ps)
	begin
		if (rst = '1') then
			ps <= IDLE;
		elsif (clk 'event and clk = '1') then
			if (ps = IDLE) then
				counter <= 0;
				if (rx = '0') then
					ps <= ns;
				else
					ps <= ns;
				end if;
			elsif (counter = 5208) then
				ps <= ns;
				counter <= 0;
			elsif (counter < 5208) then
				if(srx = not rx)then
					counter <= 0;
					ps <= ns;
				else
					counter <= counter + 1;
				end if;
			end if;
		end if;
	end process;
	
	process(rst,clk)begin
		if(rst='1')then
			srx <= '0';
		elsif(clk 'event and clk = '1')then
			srx <= rx;
		end if;
	end process;
	
	process(ps,rx,counter)
	begin
		case (ps) is
			when IDLE	=> recv_flag <= '0'; clk_Reciever <= '0'; if (rx = '0') then ns <= STRT; else ns <= IDLE; end if;
			when STRT 	=> recv_flag <= '0'; ns <= D0;	clk_Reciever <= '0';
			when D0 	=> recv_flag <= '0'; ns <= D1;  if (counter = 5208/2) then clk_Reciever <= '1'; else clk_Reciever <= '0'; end if;
			when D1 	=> recv_flag <= '0'; ns <= D2;  if (counter = 5208/2) then clk_Reciever <= '1'; else clk_Reciever <= '0'; end if;
			when D2		=> recv_flag <= '0'; ns <= D3;  if (counter = 5208/2) then clk_Reciever <= '1'; else clk_Reciever <= '0'; end if;
			when D3 	=> recv_flag <= '0'; ns <= D4;  if (counter = 5208/2) then clk_Reciever <= '1'; else clk_Reciever <= '0'; end if;
			when D4 	=> recv_flag <= '0'; ns <= D5;  if (counter = 5208/2) then clk_Reciever <= '1'; else clk_Reciever <= '0'; end if;
			when D5 	=> recv_flag <= '0'; ns <= D6;  if (counter = 5208/2) then clk_Reciever <= '1'; else clk_Reciever <= '0'; end if;
			when D6 	=> recv_flag <= '0'; ns <= D7;  if (counter = 5208/2) then clk_Reciever <= '1'; else clk_Reciever <= '0'; end if;
			when D7		=> recv_flag <= '0'; ns <= STP; if (counter = 5208/2) then clk_Reciever <= '1'; else clk_Reciever <= '0'; end if;
			when STP	=> recv_flag <= '1'; if(rx = '1')then ns <= IDLE; else ns <= STRT; end if; clk_Reciever <= '0';
		end case;
	end process;
	process(rst,clk_Reciever)begin
		if(rst='1')then
			sData_out <= (others => '0');
		elsif(clk_Reciever 'event and clk_Reciever = '1')then
			sData_out <= rx & sData_out(7 downto 1);
		end if;
	end process;
	Data_out <= sData_out;
end;


-- UART Module
library ieee;
use ieee.std_logic_1164.all;

entity UART is
port(
	rst,clk: in std_logic;							-- 50[MHz] clk Signal
	rx: in std_logic;
	tx: out std_logic;
	sendTrig: in std_logic;							-- When sendTrig rising edge the transmitter start working
	SendFlag: buffer std_logic;			-- when SendFlag rising edge the transmitter finish send the data (1[Byte])
	recv_flag:	out	std_logic;
	Data_to_Send: in  std_logic_vector(7 downto 0);
	Data_Receive: out std_logic_vector(7 downto 0));
end;

architecture one of UART is

component Transmitter
port(
	rst,clk: in std_logic;							-- 50[MHz] CLK signal
	Data_in: in std_logic_vector(7 downto 0);
	Data_out: out std_logic := '1';
	Send: in std_logic;
	EOF: out std_logic := '0');
end component;

component Receiver
port(
	rst,clk:	in	std_logic;
	rx:			in	std_logic;
	Data_out:	out std_logic_vector(7 downto 0);
	recv_flag:	out	std_logic);
end component;

begin

	U1: Transmitter port map(
		rst			=> rst,
		clk			=>	clk,
		Data_in		=>	Data_to_Send,
		Data_out	=>	tx,
		Send		=> sendTrig,
		EOF			=>	SendFlag);
		
	U2:	Receiver	port map(
		rst			=>	rst,
		clk			=>	clk,
		rx			=>	rx,
		Data_out	=>	Data_Receive,
		recv_flag	=>	recv_flag);

end;
