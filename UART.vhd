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

-- Reciever module
library ieee;
use ieee.std_Logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Reciever is
port(
rst,clk: in std_logic;
Data_in: in std_logic;
Data_out: out std_logic_vector(7 downto 0);
Error: out std_logic := '0';
flag: out std_logic);
end;

architecture one of Reciever is

-- Component --
component Reciever_sync
port(
rst,clk: in  	 std_logic;		-- clk is 50[MHz]
rx:		in  	 std_logic;
UARTclk:	out 	 std_logic;
En:		buffer std_logic);
end component;

component Reciever_Shift_Register
generic (N: integer := 10);
port(
rst,clk: in std_logic;
D: in std_logic;
Q: buffer std_logic_vector(N-1 downto 0));
end component;

-- Component --

signal UARTclk: std_logic;
signal Q: std_logic_vector(9 downto 0);

begin
	U1: Reciever_Sync port map (rst,clk,Data_in,UARTclk,flag);
	U2: Reciever_Shift_Register generic map (10) port map (rst,UARTclk,Data_in,Q);
	Data_out <= Q(8 downto 1);
end;

-- Reciever Shift Register Module
library ieee;
use ieee.std_logic_1164.all;

entity Reciever_Shift_Register is
generic (N: integer := 10);
port(
rst,clk: in std_logic;
D: in std_logic;
Q: buffer std_logic_vector(N-1 downto 0));
end;

architecture one of Reciever_Shift_Register is
begin
	process(rst,clk)
	begin
		if (rst = '1') then
			Q <= (others => '0');
		elsif (clk 'event and clk = '1') then
			Q <= D & Q(N-1 downto 1);
		end if;
	end process;
end;

-- Reciever_Sync Module
library ieee;
use ieee.std_logic_1164.all;

entity Reciever_sync is
port(
rst,clk: in  	 std_logic;		-- clk is 50[MHz]
rx:		in  	 std_logic;
UARTclk:	out 	 std_logic;
En:		buffer std_logic);
end;

architecture one of Reciever_Sync is

-- Components --
component Recieve_En_Sync
port(
rst:	in  	 std_logic;
clk:	in  	 std_logic;
rx:	in 	 std_logic;
flag:	buffer std_logic);
end component;

component Reciever_clk_Sync
port (
rst,clk: in  std_logic;
En:		in  std_logic;
UARTclk: out std_logic);
end component;
-- Components --

signal sUARTclk: std_logic;
signal flag: std_logic;

begin
UARTclk <= sUARTclk;
U1: Recieve_En_Sync  port map (rst,sUARTclk,rx,flag);
U2: Reciever_clk_Sync port map (rst,clk,flag,sUARTclk);
En <= flag;
end;


-- Reciever_En_Sync Module
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Recieve_En_Sync is
port(
rst:	in  	 std_logic;
clk:	in  	 std_logic;
rx:	in 	 std_logic;
flag:	buffer std_logic);
end;

architecture one of Recieve_En_Sync is
signal counter: integer range 0 to 11 := 0;
begin
	process(rx,rst,clk)
	begin
		if (rst = '1') then
			flag <= '0';
		elsif (rx 'event and rx = '0') then
			if (flag = '0') then
				flag <= '1';
			end if;
		end if;
		
		if (rst = '1') then
			counter <= 0;
		elsif (clk 'event and clk = '1') then
			if (flag = '1') then
				counter <= counter + 1;
			else
				counter <= 0;
			end if;
		end if;
		if (counter = 11) then
			counter <= 0;
			flag <= '0';
		end if;
	end process;
end;

-- Reciever_clk_sync Module
library ieee;
use ieee.std_logic_1164.all;

entity Reciever_clk_Sync is
port (
rst,clk: in  std_logic; -- clk - 50[MHz]
En:		in  std_logic;
UARTclk: out std_logic);
end;

architecture one of Reciever_clk_Sync is
signal clkdiv: integer range 0 to 5208 := 0;
begin
process(rst,En,clk)
begin
	if (rst = '1') then
		UARTclk <= '0';
		clkdiv <= 0;
	elsif (En = '1') then
		if (clk 'event and clk = '1') then
			if ((clkdiv < 2604) or (clkdiv = 2604)) then
				clkdiv <= clkdiv+1;
				UARTclk <= '0';
			elsif ((clkdiv < 5208) and (clkdiv > 2604)) then
				clkdiv <= clkdiv + 1;
				UARTclk <= '1';
			else
				clkdiv <= 0;
				UARTclk <= '0';
			end if;
		end if;
	else
		UARTclk <= '0';
	end if;
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
SendFlag,ErrorFlag: out std_logic;			-- when SendFlag rising edge the transmitter finish send the data (1[Byte])
Data_to_Send: in  std_logic_vector(7 downto 0);
Data_Recieve: out std_logic_vector(7 downto 0));
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

component Reciever
port(
rst,clk: in std_logic;							-- 50[MHz] clk Signal
Data_in: in std_logic;
Data_out: out std_logic_vector(7 downto 0);
Error: out std_logic
);
end component;


begin
U1: Transmitter port map (rst,clk,Data_to_Send,tx,sendTrig,SendFlag);
U2: Reciever 	 port map (rst,clk,rx,Data_Recieve,ErrorFlag);
end;
