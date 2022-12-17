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
rst,clk: in std_logic;
rx: in std_logic;
Data_out: out std_logic_vector(7 downto 0));
end;

architecture one of Receiver is
type state is (IDLE,STRT,D0,D1,D2,D3,D4,D5,D6,D7,STP);
signal ps,ns: state;
signal counter: integer range 0 to 5208 := 0;
begin
	process (clk,rst,rx,counter,ps)
	begin
		if (rst = '1') then
			ps <= IDLE;
			--Data_out <= (others => '0');
		elsif (clk 'event and clk = '1') then
			if (ps = IDLE) then
				counter <= 0;
				if (rx = '0') then
					ps <= STRT;
				else
					ps <= IDLE;
				end if;
			elsif (counter = 5208) then
				ps <= ns;
				counter <= 0;
			elsif (counter < 5208) then
				counter <= counter + 1;
			end if;
		end if;
	end process;
	
	process(ps,rx,counter)
	begin
		case (ps) is
			when IDLE	=>
			when STRT 	=> ns <= D0;
			when D0 	=> ns <= D1;  if (counter = 5208/2) then Data_out(0) <= rx; end if;
			when D1 	=> ns <= D2;  if (counter = 5208/2) then Data_out(1) <= rx; end if;
			when D2		=> ns <= D3;  if (counter = 5208/2) then Data_out(2) <= rx; end if;
			when D3 	=> ns <= D4;  if (counter = 5208/2) then Data_out(3) <= rx; end if;
			when D4 	=> ns <= D5;  if (counter = 5208/2) then Data_out(4) <= rx; end if;
			when D5 	=> ns <= D6;  if (counter = 5208/2) then Data_out(5) <= rx; end if;
			when D6 	=> ns <= D7;  if (counter = 5208/2) then Data_out(6) <= rx; end if;
			when D7		=> ns <= STP; if (counter = 5208/2) then Data_out(7) <= rx; end if;
			when STP	=> ns <= IDLE;
		end case;
	end process;
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
	EOF: out std_logic := '0'
);
end component;

component Receiver
port(
rst,clk: in std_logic;
rx: in std_logic;
Data_out: out std_logic_vector(7 downto 0));
end component;

signal Q: std_logic_vector(7 downto 0);
signal rst_receiver: std_logic;

begin
U1: Transmitter port map (rst,clk,Data_to_Send,tx,sendTrig,SendFlag);
U2: Receiver 	 port map (rst,clk,rx,Data_Receive);
end;
