library ieee;
use ieee.std_logic_1164.all;

entity Peripheral_input_port is
port(
	reset:	in	std_logic;
	clk:		in	std_logic;
	Data_in:		in		std_logic_vector(7 downto 0);
	Data_out:	out	std_logic_vector(7 downto 0));
end;

architecture one of Peripheral_input_port is
begin
	process(reset,clk)begin
		if(reset = '1')then
			Data_out <= (others => '0');
		elsif(clk 'event and clk = '1')then
			Data_out <= Data_in;
		end if;
	end process;
end;