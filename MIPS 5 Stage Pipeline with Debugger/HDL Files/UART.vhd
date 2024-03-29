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