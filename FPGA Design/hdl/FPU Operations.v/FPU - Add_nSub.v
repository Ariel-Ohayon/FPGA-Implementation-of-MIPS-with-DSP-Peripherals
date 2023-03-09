--	Designed By: Ariel Ohayon
--	FPU Floating Point Unit for real numbers calculations in microprocessor
--	Need to add an input to choose Add\Sub

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FPU is
port(
	Add_nSub:	in	std_logic;						-- Add_nSub = '0': Result = A+B | Add_nSub = '1': Result = A-B
	A:			in	std_logic_vector(31 downto 0);
	B:			in	std_logic_vector(31 downto 0);
	Result:		out	std_logic_vector(31 downto 0));
end;

architecture one of FPU is

	component Shift_reg
	port(
		input:	in	std_logic_vector(24 downto 0);
		sel:	in	std_logic_vector(7  downto 0);
		output:	out	std_logic_vector(24 downto 0));
	end component;

	signal Sig_A: std_logic;
	signal Exp_A: std_logic_vector(7 downto 0);
	signal Man_A: std_logic_vector(22 downto 0);
	
	signal intern_A:	std_logic_Vector(24 downto 0);

	signal Sig_B: std_logic;
	signal Exp_B: std_logic_vector(7 downto 0);
	signal Man_B: std_logic_vector(22 downto 0);
	
	signal intern_B:	std_logic_Vector(24 downto 0);

	signal vec2shift:	std_logic_vector(24 downto 0);
	signal shiftvec:	std_logic_vector(24 downto 0);
	signal shifts:		std_logic_vector(7 downto 0);
	
	signal Zero_Vec:	std_logic_vector(24 downto 0) := (others => '0');
	
	signal intern_Result:	std_logic_vector(24 downto 0);
begin
	
	Sig_A <= A(31);
	Exp_A <= A(30 downto 23);
	Man_A <= A(22 downto  0);
	
	Sig_B <= B(31) xor Add_nSub;
	Exp_B <= B(30 downto 23);
	Man_B <= B(22 downto  0);
	
	intern_A <= "01" & Man_A;
	intern_B <= "01" & Man_B;
	
	U1: Shift_reg port map (
		input	=> vec2shift,
		sel		=> shifts,
		output	=> shiftvec);
	
	process(Exp_A,Exp_B,Man_A,Man_B,A,B,shiftvec,intern_Result,Sig_A,Sig_B)
	begin
		if (Exp_A > Exp_B) then
			shifts <= Exp_A - Exp_B;
			vec2shift <= intern_B;
			if (Sig_A = '0') then
				if (Sig_B = '0') then
					Result(31) <= '0';
					intern_Result <= shiftvec + intern_A;
				else
					Result(31) <= '0';
					intern_Result <= intern_A - shiftvec;
				end if;
			else
				if (Sig_B = '0') then
					Result(31) <= '1';
					intern_Result <= intern_A - shiftvec;
				else
					Result(31) <= '1';
					intern_Result <= shiftvec + intern_A;
				end if;
			end if;
			if (intern_Result = Zero_Vec) then
				Result(30 downto 0) <= (others => '0');
			elsif (intern_Result(24) = '1') then
				Result(30 downto 23) <= Exp_A+1;
				Result(22 downto 0) <= intern_Result(23 downto 1);
			elsif (intern_Result(23) = '0') then
				Result(30 downto 23) <= Exp_A-1;
				Result(22 downto 0) <= intern_Result(21 downto 0) & "0";
			else
				Result(30 downto 23) <= Exp_A;
				Result(22 downto 0) <= intern_Result(22 downto 0);
			end if;
		else
			shifts <= Exp_B - Exp_A;
			vec2shift <= intern_A;
			if (Sig_B = '0') then
				if (Sig_A = '0') then
					Result(31) <= '0';
					intern_Result <= shiftvec + intern_B;
				else
					Result(31) <= '0';
					intern_Result <= intern_B - shiftvec;
				end if;
			else
				if (Sig_A = '0') then
					Result(31) <= '1';
					intern_Result <= intern_B - shiftvec;
				else
					Result(31) <= '1';
					intern_Result <= shiftvec + intern_B;
				end if;
			end if;
			if (intern_Result = Zero_Vec) then
				Result(30 downto 0) <= (others=>'0');
			elsif (intern_Result(24) = '1') then
				Result(30 downto 23) <= Exp_B+1;
				Result(22 downto 0) <= intern_Result(23 downto 1);
			elsif (intern_Result(23) = '0') then
				Result(30 downto 23) <= Exp_B-1;
				Result(22 downto 0) <= intern_Result(21 downto 0) & "0";
			else
				Result(30 downto 23) <= Exp_B;
				Result(22 downto 0) <= intern_Result(22 downto 0);
			end if;
		end if;
	end process;
end;

-- SubModule: Shift_reg

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Shift_reg is
port(
	input:	in	std_logic_vector(24 downto 0);
	sel:	in	std_logic_vector(7  downto 0);
	output:	out	std_logic_vector(24 downto 0));
end;

architecture one of Shift_reg is
	signal zero:	std_logic_vector(24 downto 0);
begin
	process(sel,input)
	begin
	
		zero	<= (others => '0');
		output	<= (others => '0');
		if(sel = x"00")then
			output <= input;
		else
			for i in 1 to 24 loop
				if(CONV_INTEGER(sel) = i)then
					output <= zero(i-1 downto 0) & input(24 downto i);
				end if;
			end loop;
		end if;
	end process;
end;
