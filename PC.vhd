library ieee;
use ieee.std_logic_1164.all;

entity PC is
port(
	reset:	in	std_logic;
	clk:	in	std_logic;
	input:	in	std_logic_vector(31 downto 0);
	output:	out	std_logic_vector(31 downto 0));
end;

architecture one of PC is
begin
	process(reset,clk)
	begin
		if (reset = '1') then
			output <= (others => '0');
		elsif (clk 'event and clk = '1') then
			output <= input;
		end if;
	end process;
end;