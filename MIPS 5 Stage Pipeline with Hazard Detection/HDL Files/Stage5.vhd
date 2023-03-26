library ieee;
use ieee.std_logic_1164.all;

entity Stage5 is
port(
	selector:			in	std_logic;
	Addr_Write_Reg_in:	in	std_logic_vector(4  downto 0);
	En_Write_Reg_in:	in	std_logic;
	ALU_Data:			in	std_logic_vector(31 downto 0);
	Memory_Data:		in	std_logic_vector(31 downto 0);
	Data_out:			out	std_logic_vector(31 downto 0);
	Addr_Write_Reg_out:	out	std_logic_vector(4  downto 0);
	En_Write_Reg_out:	out	std_logic);
end;

architecture one of Stage5 is
begin
	Data_out			<= Memory_Data when(selector = '1')else ALU_Data;
	En_Write_Reg_out	<= En_Write_Reg_in;
	Addr_Write_Reg_out	<= Addr_Write_Reg_in;
end;
