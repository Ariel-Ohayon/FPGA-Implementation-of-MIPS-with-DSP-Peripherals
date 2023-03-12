-- SubModule: Forward_Unit --

library ieee;
use ieee.std_logic_1164.all;

entity Forward_Unit is
port(
	Addr_Reg1_STG2:in	std_logic_vector(4 downto 0);
	Addr_Reg2_STG2:in	std_logic_vector(4 downto 0);
	Addr_Reg_Wr_STG3:in	std_logic_vector(4 downto 0);
	Addr_Reg_Wr_STG4:in	std_logic_vector(4 downto 0);
	selector:out	std_logic_vector(1 downto 0);
	data_in_STG3:in	std_logic_vector(31 downto 0);
	data_in_ALU_STG4:in	std_logic_vector(31 downto 0);
	data_in_MEM_STG4:in	std_logic_vector(31 downto 0);
	data_out:out	std_logic_vector(31 downto 0);
	WB_Sel:	in	std_logic;
	En_IF_ID:	out	std_logic;
	En_ID_EX:	out	std_logic;
	En_EX_MEM:	out	std_logic);
end;

architecture one of Forward_Unit is
begin
	process(Addr_Reg1_STG2,Addr_Reg2_STG2,
			Addr_Reg_Wr_STG3,Addr_Reg_Wr_STG4,
			data_in_STG3,data_in_ALU_STG4,data_in_MEM_STG4,WB_Sel)begin
		
		En_IF_ID  <= '1';
		En_ID_EX  <= '1';
		En_EX_MEM <= '1';
		
		data_out <= (others => '0');
		selector <= (others => '0');
		if(Addr_Reg1_STG2 = "00000" and Addr_Reg2_STG2 = "00000")then
			En_IF_ID  <= '1';
			En_ID_EX  <= '1';
			En_EX_MEM <= '1';
			data_out <= (others => '0');
			selector <= (others => '0');
		elsif(not(Addr_Reg1_STG2 = "00000") and Addr_Reg1_STG2 = Addr_Reg_Wr_STG3)then
			En_IF_ID <= '0';
			En_ID_EX <= '1';
		elsif(not(Addr_Reg2_STG2 = "00000") and Addr_Reg2_STG2 = Addr_Reg_Wr_STG3)then
			En_IF_ID <= '0';
			En_ID_EX <= '1';
		elsif(not(Addr_Reg1_STG2 = "00000") and Addr_Reg1_STG2 = Addr_Reg_Wr_STG4)then
			En_IF_ID  <= '0';
			En_ID_EX  <= '1';
			En_EX_MEM <= '1';
		elsif(not(Addr_Reg2_STG2 = "00000") and Addr_Reg2_STG2 = Addr_Reg_Wr_STG4)then
			En_IF_ID  <= '0';
			En_ID_EX  <= '1';
			En_EX_MEM <= '1';
		else
			En_IF_ID  <= '1';
			En_ID_EX  <= '1';
			En_EX_MEM <= '1';
		end if;
	end process;
end;
