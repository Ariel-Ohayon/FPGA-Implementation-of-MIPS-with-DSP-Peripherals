library ieee;
use ieee.std_logic_1164.all;

entity SevenSeg_Decoder is
port(
	inpt:  in  std_logic_vector(3 downto 0);
	outpt: out std_logic_vector (6 downto 0));
end;

architecture one of SevenSeg_Decoder is
begin
	process(inpt)begin
		case inpt is
			when "0000" => outpt <= "1000000";	--	0
			when "0001" => outpt <= "1111001";	--	1
			when "0010" => outpt <= "0100100";	--	2
			when "0011" => outpt <= "0110000";	--	3
			when "0100" => outpt <= "0011001";	--	4
			when "0101" => outpt <= "0010010";	--	5
			when "0110" => outpt <= "0000010";	--	6
			when "0111" => outpt <= "1111000";	--	7
			when "1000" => outpt <= "0000000";	--	8
			when "1001" => outpt <= "0010000";	--	9
			when "1010" => outpt <= "0001000";	--	10 (A)
			when "1011" => outpt <= "0000011";	--	11 (B)
			when "1100" => outpt <= "1000110";	--	12 (C)
			when "1101" => outpt <= "0100001";	--	13 (D)
			when "1110" => outpt <= "0000110";	--	14 (E)
			when others => outpt <= "0001110";	--	15 (F)
		end case;
	end process;
end;