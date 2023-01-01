library ieee;
use ieee.std_logic_1164.all;

entity Shift_reg is
port(
	input:	in	std_logic_vector(23 downto 0);
	sel:	in	std_logic_vector(4  downto 0);
	output:	out	std_logic_vector(23 downto 0));
end;

architecture one of Shift_reg is
begin
	process(sel,input)
	begin
	case (sel) is
		when "00000" => output <= input;
		when "00001" => output <= '0' & input(23 downto 1);
		when "00010" => output <= "00" & input(23 downto 2);
		when "00011" => output <= "000" & input(23 downto 3);
		when "00100" => output <= "0000" & input(23 downto 4);
		when "00101" => output <= "00000" & input(23 downto 5);
		when "00110" => output <= "000000" & input(23 downto 6);
		when "00111" => output <= "0000000" & input(23 downto 7);
		when "01000" => output <= "00000000" & input(23 downto 8);
		when "01001" => output <= "000000000" & input(23 downto 9);
		when "01010" => output <= "0000000000" & input(23 downto 10);
		when "01011" => output <= "00000000000" & input(23 downto 11);
		when "01100" => output <= "000000000000" & input(23 downto 12);
		when "01101" => output <= "0000000000000" & input(23 downto 13);
		when "01110" => output <= "00000000000000" & input(23 downto 14);
		when "01111" => output <= "000000000000000" & input(23 downto 15);
		when "10000" => output <= "0000000000000000" & input(23 downto 16);
		when "10001" => output <= "00000000000000000" & input(23 downto 17);
		when "10010" => output <= "000000000000000000" & input(23 downto 18);
		when "10011" => output <= "0000000000000000000" & input(23 downto 19);
		when "10100" => output <= "00000000000000000000" & input(23 downto 20);
		when "10101" => output <= "000000000000000000000" & input(23 downto 21);
		when "10110" => output <= "0000000000000000000000" & input(23 downto 22);
		when "10111" => output <= "00000000000000000000000" & input (23);
		when others => output <= (others => '0');
	end case;
	end process;
end;