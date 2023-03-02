library ieee;
use ieee.std_logic_1164.all;

entity Stage5 is
port(
	clk:	in	std_logic;
	reset:	in	std_logic;
	Memory_Data:	in	std_logic_vector(31 downto 0);
	ALU_Data:	in	std_logic_vector(31 downto 0);
	Reg_Write_En_in:	in	std_logic;
	WB_Mux_sel:	in	std_logic;
	Addr_Write_Reg_in:	in	std_logic_vector(4 downto 0);
	Reg_Write_En_out:	out	std_logic;
	Addr_Write_Reg_out:	out	std_logic_vector(4 downto 0);
	Reg_Write_Data_out:	out	std_logic_vector(31 downto 0));
end;

architecture one of Stage5 is

	-- / Components \ --
	component WB_MUX_module
	port(
		Mem_Data:	in	std_logic_vector(31 downto 0);
		ALU_Data:	in	std_logic_vector(31 downto 0);
		REG_Data:	out	std_logic_vector(31 downto 0);
		selector:	in	std_logic);
	end component;
	-- / Components \ --

	-- / Signals\ --
	-- / Signals \ --

begin
	U1: WB_MUX_module port map(
			Mem_Data	=>	Memory_Data,
			ALU_Data	=>	ALU_Data,
			REG_Data	=>	Reg_Write_Data_out,
			selector	=>	WB_Mux_sel);

	Addr_Write_Reg_out <= Addr_Write_Reg_in;
	Reg_Write_En_out <= Reg_Write_En_in;
end;

-- SubModule: WB_MUX_module --

library ieee;
use ieee.std_logic_1164.all;

entity WB_MUX_module is
port(
	Mem_Data:in	std_logic_vector(31 downto 0);
	ALU_Data:in	std_logic_vector(31 downto 0);
	REG_Data:out	std_logic_vector(31 downto 0);
	selector:in	std_logic);
end;

architecture one of WB_MUX_module is
begin
	REG_Data <= Mem_Data when(selector = '1') else
				ALU_Data;
end;

