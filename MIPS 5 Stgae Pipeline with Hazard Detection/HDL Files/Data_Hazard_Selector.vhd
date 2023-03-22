library ieee;
use ieee.std_logic_1164.all;

entity Data_Hazard_Selector is
port(
	Forward_Read_Addr1:	in		std_logic_vector(4 downto 0);
	Forward_Read_Addr2:	in		std_logic_vector(4 downto 0);
	
	Frwd_Wr_Addr_STG3:	in		std_logic_vector(4 downto 0);
	Frwd_Wr_Addr_STG4:	in		std_logic_vector(4 downto 0);
	
	Mem_Read_STG3:			in		std_logic;
	Mem_Read_STG4:			in		std_logic;
	
	frwd_sel_mem_op1:		out	std_logic;
	frwd_sel_alu4_op1:	out	std_logic;
	frwd_sel_alu3_op1:	out	std_logic;
	
	frwd_sel_mem_op2:		out	std_logic;
	frwd_sel_alu4_op2:	out	std_logic;
	frwd_sel_alu3_op2:	out	std_logic);
end;

architecture one of Data_Hazard_Selector is
	signal input:	std_logic_vector(19 downto 0);
begin
	input <= Forward_Read_Addr1 & Forward_Read_Addr2 & Frwd_Wr_Addr_STG3 & Frwd_Wr_Addr_STG4;
	process(input)begin
		
		frwd_sel_mem_op1	<=	'0';
		frwd_sel_alu4_op1	<=	'0';
		frwd_sel_alu3_op1	<=	'0';
		frwd_sel_mem_op2	<=	'0';
		frwd_sel_alu4_op2	<=	'0';
		frwd_sel_alu3_op2	<=	'0';
		
		if((Frwd_Wr_Addr_STG3 = Forward_Read_Addr1)and(not (Forward_Read_Addr1 = "00000")))then
			if(Mem_Read_STG3 = '1')then
				
			else
				frwd_sel_alu3_op1 <= '1';
			end if;
		elsif((Frwd_Wr_Addr_STG4 = Forward_Read_Addr1)and(not (Forward_Read_Addr1 = "00000")))then
			if(Mem_Read_STG4 = '1')then
				
			else
				frwd_sel_alu4_op1 <= '1';
			end if;
		end if;
		if((Frwd_Wr_Addr_STG3 = Forward_Read_Addr2)and(not (Forward_Read_Addr2 = "00000")))then
			if(Mem_Read_STG3 = '1')then
				
			else
				frwd_sel_alu3_op2 <= '1';
			end if;
		elsif((Frwd_Wr_Addr_STG4 = Forward_Read_Addr2)and(not (Forward_Read_Addr2 = "00000")))then
			if(Mem_Read_STG4 = '1')then
				
			else
				frwd_sel_alu4_op2 <= '1';
			end if;
		end if;
	end process;
end;