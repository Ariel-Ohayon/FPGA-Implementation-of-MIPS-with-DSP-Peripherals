library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ShiftRegister is
port(
	inpt1:	in	std_logic_vector(4 downto 0);
	inpt2:	in	std_logic_vector(31 downto 0);
	AL:		in	std_logic;						--	AL - Arithmetic (1) / Logic (0)
	RL:		in	std_logic;						--	RL - Right (1) / Left (0)
	outpt:	out	std_logic_vector(31 downto 0));
end;

architecture one of ShiftRegister is

	signal zero:	std_logic_vector(31 downto 0);
	signal mode:	std_logic_vector(1  downto 0);

begin
	
	mode <= AL & RL;
	zero <= (others => '0');
	
	process(inpt1,inpt2,mode)begin
		outpt <= (others => '0');
		if(inpt1 = "00000")then
			outpt <= inpt2;
		else
			for i in 1 to 31 loop
				if(CONV_INTEGER(inpt1) = i)then
					case(mode)is
						when "00"	=> outpt <= inpt2(31-i downto 0)&zero(i-1 downto 0);			-- Logic Left
						when "01"	=> outpt <= zero(i-1 downto 0)&inpt2(31 downto i);				-- Logic Right
						when "10"	=> outpt <= inpt2(31)&inpt2(30-i downto 0)&zero(i-1 downto 0);	-- Arithmetic Left
						when others	=> outpt <= inpt2(31)&zero(i-2 downto 0)&inpt2(31 downto i);	-- Arithmetic Right
					end case;
				end if;
			end loop;
		end if;
	end process;
end;
