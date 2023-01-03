-- Designed by: Ariel Ohayon
--
-- IF/ID Register Module (MIPS Architecture) Design in VHDL

library ieee;
use ieee.std_logic_1164.all;

entity IF_ID is
port(
	clk: 			in	std_logic;						--	Clock input signal: Active in RISING Edge
	reset:			in	std_logic;						--	Reset input signal: Active HIGH
	Inst_in:		in	std_logic_vector(31 downto 0);	--	Instruction get from the "Intruction Memory"
	Inst_out:		out	std_logic_vector(31 downto 0));	--	Instruction get from the "Intruction Memory"
end;

architecture one of IF_ID is
begin
	process(reset,clk)
	begin
		if (reset = '1') then
			Inst_out 		<= (others => '0');
		elsif (clk 'event and clk = '1') then
			Inst_out 		<=	Inst_in;
		end if;
	end process;
end;