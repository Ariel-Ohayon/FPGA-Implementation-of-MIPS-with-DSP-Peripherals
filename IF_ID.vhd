-- Designed by: Ariel Ohayon
--
-- IF/ID Register Module (MIPS Architecture) Design in VHDL

library ieee;
use ieee.std_logic_1164.all;

entity IF_ID is
port(
	clk: 			in	std_logic;						--	Clock input signal: Active in RISING Edge
	reset:			in	std_logic;						--	Reset input signal: Active HIGH
	
	Inst_in:		in	std_logic_vector(31 downto 0);	--	Instruction get from the "Intruction Memory"
	R_Type:			out	std_logic;
	I_Type:			out	std_logic;
	J_Type:			out	std_logic;
	BUS_Type:		out	std_logic;
	
	ReadReg1:		out std_logic_vector(4 downto 0);
	ReadReg2:		out std_logic_vector(4 downto 0);
	WriteReg:		out std_logic_vector(4 downto 0);
	
	Op_Code:		out std_logic_vector(1 downto 0);	-- Output for ALU
	Op_Shift:		out std_logic;						-- Output for ALU
	Op_Arith:		out std_logic;						-- Output for ALU
	Op_Logic:		out std_logic;						-- Output for ALU
	Op_Branch:		out std_logic;						-- Output for ALU
	Op_Mem:			out	std_logic;
	Sig_nUnsig:		out std_logic;						-- Output for ALU	(if the bit '1' the op is with sign bit else the operation unsigned)
	Hi_nLo:			out std_logic);						-- Output for ALU	(if the bit '1' the op is with high bits else the op low bits)
	
end;

architecture one of IF_ID is

signal Instruction:	std_logic_vector(31 downto 0);

signal Funct: std_logic_vector(5 downto 0);
signal intern_Op_Code:	std_logic_vector(5 downto 0);

begin
	
	intern_Op_Code <= Instruction(31 downto 26);
	process(reset,clk)
	begin
		if (reset = '1') then
			Instruction 		<= (others => '0');
			ReadReg1 <= (others => '0');
			ReadReg2 <= (others => '0');
			WriteReg <= (others => '0');
		elsif (clk 'event and clk = '1') then
			Instruction		<=	Inst_in;
			ReadReg1 <= Inst_in(25 downto 21);
			ReadReg2 <= Inst_in(20 downto 16);
			WriteReg <= Inst_in(15 downto 11);
		end if;
	end process;
	
	process(intern_Op_Code)
	begin
		Op_Mem		<= '0';
		Op_Logic	<= '0';
		Op_Arith	<= '0';
		Op_Branch	<= '0';
		Op_Shift	<= '0';
		
		R_Type		<= '0';
		I_Type		<= '0';
		J_Type 		<= '0';
		BUS_Type	<= '0';
		
		Hi_nLo <= '0';
		Sig_nUnsig <= '0';
		
		Funct <= (others => '0');
		Op_Code <= (others => '0');
		
		if		(intern_Op_Code = "000000") then	-- R-tpye Instruction
			R_Type		<= '1';
			
			Funct <= Instruction(5 downto 0);
			if (Funct(2) = '1') then
				Op_Arith  <= '1';
				Op_Code  <= Funct(1 downto 0);
				Sig_nUnsig <= not Funct(4);
			else
				if (Funct(4) = '1') then
					Op_Shift  <= '1';
					Op_Code  <= Funct(1 downto 0);
				else
					Op_Logic  <= '1';
					Op_Code  <= Funct(1 downto 0);
				end if;
			end if;

		elsif	(intern_Op_Code(5 downto 2) = "1111") then
			J_Type 		<= '1';
			
		elsif (intern_Op_Code(5 downto 3) = "111") then
			BUS_Type	<= '1';
			
		else
			I_Type		<= '1';
			
			if (intern_Op_Code(2) = '1') then
				if (intern_Op_Code(3) = '1') then
					Op_Branch <= '1';
					--Op_Code <= intern_Op_Code(1 downto 0);
				else
					Op_Arith  <= '1';
					Sig_nUnsig <= not intern_Op_Code(4);
					Hi_nLo <= intern_Op_Code(5);
					Op_Code <= intern_Op_Code(1 downto 0);
				end if;
				
			else
				if (intern_Op_Code(3) = '1') then
					Op_Logic  <= '1';
					Hi_nLo <= intern_Op_Code(5);
					Op_Code <= intern_Op_Code(1 downto 0);
				else
					Op_Mem    <= '1';
				end if;
			end if;
		end if;
	end process;
	
end;
