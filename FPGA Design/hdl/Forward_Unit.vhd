library ieee;
use ieee.std_logic_1164.all;

entity Forward_Unit is
port(
	clk:	in	std_logic;
	reset:	in	std_logic;
	Addr_Reg1_STG2:in	std_logic_vector(4 downto 0);
	Addr_Reg2_STG2:in	std_logic_vector(4 downto 0);
	Addr_Reg_Wr_STG3:in	std_logic_vector(4 downto 0);
	En_IF_ID:	out	std_logic;
	En_ID_EX:	out	std_logic;
	En_EX_MEM:	out	std_logic);
end;

architecture one of Forward_Unit is
	type state is(s0,s1,s2,s3);
	signal ps,ns:	state;
begin
	process(reset,clk)begin
		if(reset = '1')then
			ps <= s0;
		elsif(clk 'event and clk = '1')then
			ps <= ns;
		end if;
	end process;
	process(ps,Addr_Reg1_STG2,Addr_Reg2_STG2,Addr_Reg_Wr_STG3)begin
		case(ps)is
			when s0 =>
				En_IF_ID <= '1';
				En_ID_EX <= '1';
				En_EX_MEM <= '1';
				if((Addr_Reg1_STG2 = Addr_Reg_Wr_STG3) or (Addr_Reg2_STG2 = Addr_Reg_Wr_STG3))then
					ns <= s1;
				else
					ns <= s0;
				end if;
			when s1 =>
				En_IF_ID <= '0';
				En_ID_EX <= '1';
				En_EX_MEM <= '1';
				ns <= s2;
			when s2 =>
				En_IF_ID <= '0';
				En_ID_EX <= '0';
				En_EX_MEM <= '1';
				ns <= s3;
			when s3 =>
				En_IF_ID <= '0';
				En_ID_EX <= '0';
				En_EX_MEM <= '0';
				ns <= s0;
		end case;
	end process;
end;
