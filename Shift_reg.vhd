-- Designed By: Ariel Ohayon
--
-- Shift Register for FPU Calculation

library ieee;
use ieee.std_logic_1164.all;

entity Shift_reg is
port(
	input:	in	std_logic_vector(24 downto 0);
	sel:	in	std_logic_vector(7  downto 0);
	output:	out	std_logic_vector(24 downto 0));
end;

architecture one of Shift_reg is
begin
	process(sel,input)
	begin
	case (sel) is
		when x"00" => output <= input;
		when x"01" => output <= '0' & input(24 downto 1);
		when x"02" => output <= "00" & input(24 downto 2);
		when x"03" => output <= "000" & input(24 downto 3);
		when x"04" => output <= "0000" & input(24 downto 4);
		when x"05" => output <= "00000" & input(24 downto 5);
		when x"06" => output <= "000000" & input(24 downto 6);
		when x"07" => output <= "0000000" & input(24 downto 7);
		when x"08" => output <= "00000000" & input(24 downto 8);
		when x"09" => output <= "000000000" & input(24 downto 9);
		when x"0A" => output <= "0000000000" & input(24 downto 10);
		when x"0B" => output <= "00000000000" & input(24 downto 11);
		when x"0C" => output <= "000000000000" & input(24 downto 12);
		when x"0D" => output <= "0000000000000" & input(24 downto 13);
		when x"0E" => output <= "00000000000000" & input(24 downto 14);
		when x"0F" => output <= "000000000000000" & input(24 downto 15);
		when x"10" => output <= "0000000000000000" & input(24 downto 16);
		when x"11" => output <= "00000000000000000" & input(24 downto 17);
		when x"12" => output <= "000000000000000000" & input(24 downto 18);
		when x"13" => output <= "0000000000000000000" & input(24 downto 19);
		when x"14" => output <= "00000000000000000000" & input(24 downto 20);
		when x"15" => output <= "000000000000000000000" & input(24 downto 21);
		when x"16" => output <= "0000000000000000000000" & input(24 downto 22);
		when x"17" => output <= "00000000000000000000000" & input (24 downto 23);
		when x"18" => output <= "000000000000000000000000" & input (24);
		when others => output <= (others => '0');
	end case;
	end process;
end;
