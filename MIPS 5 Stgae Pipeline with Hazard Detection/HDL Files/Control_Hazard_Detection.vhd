library ieee;
use ieee.std_logic_1164.all;

entity Control_Hazard_Detection is
port(
	clk:				in	std_Logic;
	reset:				in	std_Logic;
	BR_JMP_flag_STG2:	in	std_logic;
	mask:				out	std_logic;
	En_IF_ID:			out	std_Logic);
end;

architecture one of Control_Hazard_Detection is
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
	
	process(ps,BR_JMP_flag_STG2)begin
		En_IF_ID <= '1';
		mask <= '1';
		case(ps)is
			when s0 =>
				if(BR_JMP_flag_STG2 = '1')then
					En_IF_ID <= '0';
					ns <= s1;
				else
					ns <= s0;
				end if;
			when s1 =>
				En_IF_ID <= '0';
				ns <= s2;
			when s2 =>
				ns <= s3;
			when s3 => 
				mask <= '0';
				ns <= s0;
		end case;
	end process;
end;