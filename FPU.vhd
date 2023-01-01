--	Designed By: Ariel Ohayon
--
--	Not Finished

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FPU is
port(
	A:		in	std_logic_vector(31 downto 0);
	B:		in	std_logic_vector(31 downto 0);
	Result:	out	std_logic_vector(31 downto 0));
end;

architecture one of FPU is

	component Shift_reg
	port(
		input:	in	std_logic_vector(23 downto 0);
		sel:	in	std_logic_vector(7  downto 0);
		output:	out	std_logic_vector(23 downto 0));
	end component;

	signal Sig_A: std_logic;
	signal Exp_A: std_logic_vector(7 downto 0);
	signal Man_A: std_logic_vector(22 downto 0);
	
	signal intern_A:	std_logic_Vector(23 downto 0);

	signal Sig_B: std_logic;
	signal Exp_B: std_logic_vector(7 downto 0);
	signal Man_B: std_logic_vector(22 downto 0);
	
	signal intern_B:	std_logic_Vector(23 downto 0);

	signal vec2shift:	std_logic_vector(23 downto 0);
	signal shiftvec:	std_logic_vector(23 downto 0);
	signal shifts:		std_logic_vector(7 downto 0);
	
	signal intern_Result:	std_logic_vector(24 downto 0);
begin

	Result(31) <= Sig_A xor Sig_B;
	
	Sig_A <= A(31);
	Exp_A <= A(30 downto 23);
	Man_A <= A(22 downto  0);
	
	Sig_B <= B(31);
	Exp_B <= B(30 downto 23);
	Man_B <= B(22 downto  0);
	
	intern_A <= '1' & Man_A;
	intern_B <= '1' & Man_B;
	
	U1: Shift_reg port map (
		input => vec2shift,
		sel => shifts,
		output => shiftvec);
	
	process(Exp_A,Exp_B,Man_A,Man_B,A,B,shiftvec,intern_Result)
	begin
		if (Exp_A > Exp_B) then
			Result(30 downto 23) <= Exp_A;
			shifts <= Exp_A - Exp_B;
			vec2shift <= intern_B;
			intern_Result <= ('0' & shiftvec) + ('0' & intern_A);
			Result(22 downto 0) <= intern_Result(22 downto 0);
		else
			shifts <= Exp_B - Exp_A;
			vec2shift <= intern_A;
			intern_Result <= ('0' & shiftvec) + ('0' & intern_B);
			if (intern_Result(24) = '1') then
				Result(30 downto 23) <= Exp_B+1;
				Result(22 downto 0) <= intern_Result(23 downto 1);
			else
				Result(30 downto 23) <= Exp_B;
				Result(22 downto 0) <= intern_Result(22 downto 0);
			end if;
		end if;
	end process;
	
end;
