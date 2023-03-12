-- SubModule: Hazard_Unit --

library ieee;
use ieee.std_logic_1164.all;

entity Hazard_Unit is
port(
	clk:in	std_logic;
	reset:in	std_logic;
	STG2_flag:in	std_logic;
	En_IF_ID:out	std_logic;
	En_ID_EX:out	std_logic;
	En_EX_MEM:out	std_logic;
	Pipeline_reset:out	std_logic);
end;

architecture one of Hazard_Unit is
	type state is(s0,s1,s2,s3);
	signal ps,ns:	state;
begin
	process(clk,reset)begin
		if(reset = '1')then
			ps <= s0;
		elsif(clk 'event and clk = '1')then
			ps <= ns;
		end if;
	end process;
	
	process(ps,STG2_flag)begin
		En_IF_ID <= '1';
		En_ID_EX <= '1';
		En_EX_MEM <= '1';
		Pipeline_reset <= '0';
		case(ps)is
			when s0 =>
				if (STG2_flag = '1')then
					En_IF_ID <= '0';
					ns <= s1;
				else
					ns <= s0;
				end if;
			when s1 =>
				ns <= s2;
				En_IF_ID <= '0';
				En_ID_EX <= '0';
			when s2 =>
				ns <= s3;
				En_IF_ID  <= '0';
				En_ID_EX  <= '0';
				En_EX_MEM <= '0';
			when s3 =>
				En_IF_ID  <= '1';
				En_ID_EX  <= '1';
				En_EX_MEM <= '1';
				ns <= s0;
		end case;
	end process;
end;
