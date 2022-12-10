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
Error: out std_logic := '0');
end;

architecture one of Reciever is

type state is (IDLE,STRT,D0,D1,D2,D3,D4,D5,D6,D7,STP);
signal ps,ns: state;
signal counter: integer range 0 to 5208 := 0;
--signal En: std_logic := '0';

signal UARTclk: std_logic;

begin

	P1:process(rst,clk)
	begin
		if (rst = '1') then
			counter <= 0;
			UARTclk <= '0';
		elsif (clk 'event and clk = '1') then
			if (not (ps = IDLE)) then
				if (counter = 5208) then
					counter <= 0;
					UARTclk <= '0';
				elsif (counter < 5208/2) then
					counter <= counter + 1;
					UARTclk <= '0';
				else
					counter <= counter + 1;
					UARTclk <= '1';
				end if;
			end if;
		end if;
	end process;
	
	P2:process(UARTclk,rst) -- need to be here multiplexing between two clk signals
	begin
	if (rst = '1') then
		ps <= IDLE;
	elsif (UARTclk 'event and UARTclk = '1') then
		ps <= ns;
	end if;
	end process;
	
	P3:process(ps,Data_in)
	begin
		case (ps) is
			when IDLE =>
				if (Data_in = '1') then
					ns <= IDLE;
				else
					ns <= STRT;
				end if;
				Error <= '0';
			when STRT =>
				if (data_in = '0') then
					Error <= '0';	-- There is no error
					ns <= D0;
				else
					Error <= '1';	-- There is error
					ns <= IDLE;		-- Have to check it (Simulation) -- line mesukan
				end if;
			when D0 => Data_out(0) <= Data_in; ns <= D1;  Error <= '0';		--	Latch in synthesis convert to shift register
			when D1 => Data_out(1) <= Data_in; ns <= D2;  Error <= '0';		--	Latch in synthesis convert to shift register
			when D2 => Data_out(2) <= Data_in; ns <= D3;  Error <= '0';		--	Latch in synthesis convert to shift register
			when D3 => Data_out(3) <= Data_in; ns <= D4;  Error <= '0';		--	Latch in synthesis convert to shift register
			when D4 => Data_out(4) <= Data_in; ns <= D5;  Error <= '0';		--	Latch in synthesis convert to shift register
			when D5 => Data_out(5) <= Data_in; ns <= D6;  Error <= '0';		--	Latch in synthesis convert to shift register
			when D6 => Data_out(6) <= Data_in; ns <= D7;  Error <= '0';		--	Latch in synthesis convert to shift register
			when D7 => Data_out(7) <= Data_in; ns <= STP; Error <= '0';		--	Latch in synthesis convert to shift register
			when STP =>
				if (Data_in = '1') then
					Error <= '0';	-- There is no error
				else
					Error <= '1';	-- There is error
				end if;
				ns <= IDLE;
		end case;
	end process;
end;

-- UART Module
library ieee;
use ieee.std_logic_1164.all;

entity UART is
port(
rst,clk: in std_logic;
rx: in std_logic;
tx: out std_logic;
sendTrig: in std_logic;
SendFlag,ErrorFlag: out std_logic;
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
rst,clk: in std_logic;
Data_in: in std_logic;
Data_out: out std_logic_vector(7 downto 0);
Error: out std_logic
);
end component;


begin
U1: Transmitter port map (rst,clk,Data_to_Send,tx,sendTrig,SendFlag);
U2: Reciever 	 port map (rst,clk,rx,Data_Recieve,ErrorFlag);
end;