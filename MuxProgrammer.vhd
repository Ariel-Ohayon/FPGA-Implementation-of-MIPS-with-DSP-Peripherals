library ieee;
use ieee.std_logic_1164.all;

entity MuxProgrammer is
port(
	sel:	in	std_logic;
	input0:	in	std_logic_vector(31 downto 0);
	input1:	in	std_logic_vector(31 downto 0);
	output:	out	std_logic_vector(31 downto 0));
end;

architecture one of MuxProgrammer is
begin
	process(sel,input0,input1)
	begin
		if (sel = '1') then
			output <= input1;
		else
			output <= input0;
		end if;
	end process;
end;