library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Adder is
port(
	input:	in	std_logic_vector(31 downto 0);
	output:	out	std_logic_vector(31 downto 0));
end;

architecture one of Adder is
begin
	output <= input + 4;
end;