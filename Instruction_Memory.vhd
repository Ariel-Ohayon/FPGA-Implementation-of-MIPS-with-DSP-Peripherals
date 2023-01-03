library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Instruction_Memory is
port (
	clk, rd_nwr :	in	std_logic;	-- rd_nwr = '1' - Read	|	rd_nwr = '0' - Write
	addr:			in	std_Logic_vector (31 downto 0);
	data_in:		in	std_logic_vector (7  downto 0);
	data_out:		out	std_logic_vector (31 downto 0));
end;

architecture one of Instruction_Memory is
	type vector_array is Array (0 to 31) of std_logic_vector (7 downto 0);
	signal memory: vector_array;
	
	signal Byte0:	std_logic_vector(7 downto 0);
	signal Byte1:	std_logic_vector(7 downto 0);
	signal Byte2:	std_logic_vector(7 downto 0);
	signal Byte3:	std_logic_vector(7 downto 0);
	
begin
	process (clk,rd_nwr)
	begin
		if (rd_nwr = '1') then			-- Read State
			Byte0 <= memory (CONV_INTEGER(addr));
			Byte1 <= memory (CONV_INTEGER(addr+1));
			Byte2 <= memory (CONV_INTEGER(addr+2));
			Byte3 <= memory (CONV_INTEGER(addr+3));
		else
			Byte0 <= (others => 'Z'); -- Write State
			Byte1 <= (others => 'Z');
			Byte2 <= (others => 'Z');
			Byte3 <= (others => 'Z');
			if (clk'event and clk = '1') then
				memory (CONV_INTEGER(addr)) <= data_in; 
			end if;
		end if; 
	end process;
	data_out <= Byte3 & Byte2 & Byte1 & Byte0;
end;