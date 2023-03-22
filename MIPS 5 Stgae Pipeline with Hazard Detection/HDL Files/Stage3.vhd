library ieee;
use ieee.std_logic_1164.all;

entity Stage3 is
port(
	reset:						in	std_logic;
	clk:						in	std_logic;
	En_Pipeline:				in	std_logic;
	operand1:					in	std_logic_vector(31 downto 0);
	operand2:					in	std_logic_vector(31 downto 0);
	Op_Code:					in	std_logic_vector(5  downto 0);
	Addr_Write_Reg_in:			in	std_logic_vector(4 downto 0);
	En_Write_Reg_in:			in	std_logic;
	Mem_Read_in:				in	std_logic;
	Mem_Write_in:				in	std_logic;
	Data_Mem_Write_Data_in:		in	std_logic_vector(31 downto 0);
	BR_JMP_flag_in:			in	std_logic;
	BR_JMP_Addr_in:			in	std_logic_vector(7 downto 0);
	ALU_result:					out	std_logic_vector(31 downto 0);
	Addr_Write_Reg_out:			out	std_logic_vector(4  downto 0);
	En_Write_Reg_out:			out	std_logic;
	Mem_Read_out:				out	std_logic;
	Mem_Write_out:				out	std_logic;
	Data_Mem_Write_Data_out:	out	std_logic_vector(31 downto 0);
	BR_JMP_flag_out:			out	std_logic;
	BR_JMP_Addr_out:			out	std_logic_vector(7 downto 0));
end;

architecture one of Stage3 is
	
	-- / Components \ --
	component ALU
	port(
		reset:	in	std_logic;
		clk:	in	std_logic;
		BR_JMP_flag:	in	std_logic;
		inpt1:in	std_logic_vector(31 downto 0);
		inpt2:in	std_logic_vector(31 downto 0);
		outpt:out	std_logic_vector(31 downto 0);
		Op_Code:in	std_logic_vector(5 downto 0);
		En:in	std_logic;
		BR_flag:	out	std_logic);
	end component;
	
	component EX_MEM
	port(
		reset:						in	std_logic;
		clk:						in	std_logic;
		En:							in	std_logic;
		ALU_Result_in:				in	std_logic_vector(31 downto 0);
		Addr_Write_Reg_in:			in	std_logic_vector(4  downto 0);
		En_Write_Reg_in:			in	std_logic;
		Mem_Read_in:				in	std_logic;
		Mem_Write_in:				in	std_logic;
		Data_Mem_Write_Data_in:		in	std_logic_vector(31 downto 0);
		BR_JMP_flag_in:		in	std_logic;
		BR_JMP_Addr_in:		in	std_logic_vector(7 downto 0);
		ALU_Result_out:				out	std_logic_vector(31 downto 0);
		Addr_Write_Reg_out:			out	std_logic_vector(4  downto 0);
		En_Write_Reg_out:			out	std_logic;
		Mem_Read_out:				out	std_logic;
		Mem_Write_out:				out	std_logic;
		Data_Mem_Write_Data_out:	out	std_logic_vector(31 downto 0);
		BR_JMP_flag_out:		out	std_logic;
		BR_JMP_Addr_out:		out	std_logic_vector(7 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal pipeline_ALU_Result:	std_logic_vector(31 downto 0);
	signal pipeline_BR_JMP_flag:	std_logic;
	-- / Signals \ --
	
begin
	U1:	ALU port map(
		reset	=>	reset,
		clk		=>	clk,
		BR_JMP_flag	=>	BR_JMP_flag_in,
		inpt1	=>	operand1,
		inpt2	=>	operand2,
		outpt	=>	pipeline_ALU_Result,
		Op_Code	=>	Op_Code,
		En		=>	'1',
		BR_flag	=>	pipeline_BR_JMP_flag);
	
	U2: EX_MEM port map(
		reset					=>	reset,
		clk						=>	clk,
		En						=>	En_Pipeline,
		ALU_Result_in			=>	pipeline_ALU_Result,
		Addr_Write_Reg_in		=>	Addr_Write_Reg_in,
		En_Write_Reg_in			=>	En_Write_Reg_in,
		Mem_Read_in				=>	Mem_Read_in,
		Mem_Write_in			=>	Mem_Write_in,
		Data_Mem_Write_Data_in	=>	Data_Mem_Write_Data_in,
		BR_JMP_flag_in			=>	pipeline_BR_JMP_flag,
		BR_JMP_Addr_in			=>	BR_JMP_Addr_in,
		ALU_Result_out			=>	ALU_result,
		Addr_Write_Reg_out		=>	Addr_Write_Reg_out,
		En_Write_Reg_out		=>	En_Write_Reg_out,
		Mem_Read_out			=>	Mem_Read_out,
		Mem_Write_out			=>	Mem_Write_out,
		Data_Mem_Write_Data_out	=>	Data_Mem_Write_Data_out,
		BR_JMP_flag_out		=>	BR_JMP_flag_out,
		BR_JMP_Addr_out		=>	BR_JMP_Addr_out);
end;

-- SubModule: ALU --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ALU is
port(
	reset:	in	std_logic;
	clk:	in	std_logic;
	BR_JMP_flag:	in	std_logic;
	inpt1:in	std_logic_vector(31 downto 0);
	inpt2:in	std_logic_vector(31 downto 0);
	outpt:out	std_logic_vector(31 downto 0);
	Op_Code:in	std_logic_vector(5 downto 0);
	En:in	std_logic;
	BR_flag:	out	std_logic);
end;

architecture one of ALU is
	
	-- / Components \ --
	component Division
	generic(Bits:integer:=32);
	port(
		dividend:	in	std_logic_vector(Bits-1 downto 0);
		divisor:	in	std_logic_vector(Bits-1 downto 0);
		Q:			out	std_logic_vector(Bits-1 downto 0);
		reminder:	out	std_logic_vector(Bits-1 downto 0));
	end component;
	
	component ShiftRegister
	port(
		inpt1:	in	std_logic_vector(4 downto 0);
		inpt2:	in	std_logic_vector(31 downto 0);
		AL:		in	std_logic;						--	AL - Arithmetic (1) / Logic (0)
		RL:		in	std_logic;						--	RL - Right (1) / Left (0)
		outpt:	out	std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal zero:			std_logic_vector(15 downto 0);
	signal mul:				std_logic_vector(63 downto 0);
	signal mulh:			std_logic_vector(63 downto 0);
	signal div_result:		std_logic_vector(31 downto 0);
	signal sel:				std_logic;
	signal divisor:			std_logic_vector(31 downto 0);
	signal ShiftReg_out:	std_logic_vector(31 downto 0);
	signal signal_AL:		std_logic;
	signal signal_RL:		std_logic;
	signal Shift_En:		std_logic;
	signal out_div:			std_logic;
	signal soutpt:			std_logic_vector(31 downto 0);
	signal mul_sel:			std_logic;
	signal mulh_sel:		std_logic;
	
	signal beq_flag:	std_logic;
	signal bne_flag:	std_logic;
	signal bgt_flag:	std_logic;
	signal ble_flag:	std_logic;
	-- / Signals \ --
	
begin

	U1: Division generic map(32) port map(
		dividend	=>	inpt2,
		divisor		=>	divisor,
		Q			=>	div_result,
		reminder	=>	open);
		
	U2:	ShiftRegister port map(
		inpt1	=>	inpt2(4 downto 0),
		inpt2	=>	inpt1,
		AL		=>	signal_AL,
		RL		=>	signal_RL,
		outpt	=>	ShiftReg_out);
	
	sel <= Op_Code(5);
	zero <= (others => '0');
	divisor <= inpt1(15 downto 0)&zero when(sel='1')else inpt1;
	
	mul	 <= inpt1 * inpt2;
	mulh <= (inpt1(15 downto 0)&zero) * inpt2;
	
	process(inpt1,inpt2,En,Op_Code)begin
		
		mul_sel <= '0';
		mulh_sel <= '0';
		out_div <= '0';
		Shift_En <= '0';
		soutpt <= (others => '0');
		signal_AL <= '0';
		signal_RL <= '0';
		
		if(En = '1')then
			case(Op_Code)is
				when "000100" => soutpt <= inpt1 + inpt2;									-- ADD
				when "000101" => soutpt <= inpt1 - inpt2;									-- SUB
				when "000110" => mul_sel <= '1';											-- MUL
				when "000111" => out_div <= '1';											-- DIV
				when "001000" => soutpt <= inpt1 and inpt2;									-- AND
				when "001001" => soutpt <= inpt1 or  inpt2;									-- OR
				when "001010" => soutpt <= inpt1 nor inpt2;									-- NOR
				when "001011" => soutpt <= inpt1 xor inpt2;									-- XOR
				when "011000" => Shift_En <= '1'; signal_AL <= '0'; signal_RL <= '0';		-- SLL
				when "011001" => Shift_En <= '1'; signal_AL <= '0'; signal_RL <= '1';		-- SRL
				when "011010" => Shift_En <= '1'; signal_AL <= '1'; signal_RL <= '0';		-- SLA
				when "011011" => Shift_En <= '1'; signal_AL <= '1'; signal_RL <= '1';		-- SRA
				when "100100" => soutpt <= (inpt1(15 downto 0)&zero) + inpt2;				-- ADDHI
				when "100101" => soutpt <= inpt2 - (inpt1(15 downto 0)&zero);				-- SUBHI
				when "100110" => mulh_sel <= '1';											-- MULHI
				when "100111" => out_div <= '1';											-- DIVHI
				when "101000" => soutpt <= inpt1(15 downto 0)&zero and inpt2;				-- ANDHI
				when "101001" => soutpt <= inpt1(15 downto 0)&zero or  inpt2;				-- ORHI
				when "101010" => soutpt <= inpt1(15 downto 0)&zero nor inpt2;				-- NORHI
				when "101011" => soutpt <= inpt1(15 downto 0)&zero xor inpt2;				-- XORHI
				when others=> soutpt <= (others => '0');
			end case;
		else
			soutpt <= (others => '0');
		end if;
		
		beq_flag <= '0';
		bne_flag <= '0';
		bgt_flag <= '0';
		ble_flag <= '0';
		
		case(Op_Code)is
			when "001100"	=>
				if(inpt1 = inpt2)then
					beq_flag <= '1';
				else
					beq_flag <= '0';
				end if;
			when "001101"	=>
				if(inpt1 /= inpt2)then
					bne_flag <= '1';
				else
					bne_flag <= '0';
				end if;
			when "001110"	=>
				if(inpt1 > inpt2)then
					bgt_flag <= '1';
				else
					bgt_flag <= '0';
				end if;
			when "001111"	=>
				if(inpt1 < inpt2)then
					bgt_flag <= '1';
				else
					bgt_flag <= '0';
				end if;
			when "111111"	=>	beq_flag <= '1'; bne_flag <= '1'; bgt_flag <= '1'; ble_flag <= '1';
			when others		=>	beq_flag <= '1'; bne_flag <= '1'; bgt_flag <= '1'; ble_flag <= '1';
		end case;
		
	end process;
	BR_flag <= (beq_flag or bne_flag or bgt_flag or ble_flag) and (BR_JMP_flag);
	
				
	outpt <= ShiftReg_out when(Shift_En = '1')else 
			 div_result when(out_div = '1')else
			 mul(31 downto 0)when(mul_sel = '1')else
			 mulh(31 downto 0)when(mulh_sel = '1')else
			 soutpt;
	
end;

-- SubModule: Division --

library ieee;
use ieee.std_logic_1164.all;

entity Division is
generic(Bits:integer:=32);
port(
	dividend:	in	std_logic_vector(Bits-1 downto 0);
	divisor:	in	std_logic_vector(Bits-1 downto 0);
	Q:			out	std_logic_vector(Bits-1 downto 0);
	reminder:	out	std_logic_vector(Bits-1 downto 0));
end;

architecture one of Division is
	
	type sigarr is array (0 to Bits) of std_logic_vector(Bits-1 downto 0);
	
	-- / Components \ --
	component Half_Divide
	generic(Bits:integer:=4);
	port(
		Xin:	in	std_logic_vector(Bits-1 downto 0);
		A:		in	std_logic;
		B:		in	std_logic_vector(Bits-1 downto 0);
		Xout:	out	std_logic_vector(Bits-1 downto 0);
		result:	out	std_logic);
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal sQ:			std_logic_vector(Bits-1 downto 0);
	signal Xout:	sigarr;
	-- / Signals \ --
	
begin
	Q <= not sQ;
	
	Xout(0) <= (others => '0');
	
	Gen:for i in 0 to Bits-1 Generate
		U:	Half_Divide generic map(Bits) port map(
			Xin		=>	Xout(i),
			A		=>	dividend(Bits-1-i),
			B		=>	divisor,
			Xout	=>	Xout(i+1),
			result	=>	sQ(Bits-1-i));
	end Generate;
	
	reminder <= Xout(Bits);
end;

-- SubModule: Half_Divide --

library ieee;
use ieee.std_logic_1164.all;

entity Half_Divide is
generic(Bits:integer:=4);
port(
	Xin:	in	std_logic_vector(Bits-1 downto 0);
	A:		in	std_logic;
	B:		in	std_logic_vector(Bits-1 downto 0);
	Xout:	out	std_logic_vector(Bits-1 downto 0);
	result:	out	std_logic);
end;

architecture one of Half_Divide is
	-- / Components \ --
	component Mux
	generic(Bits:integer:=4);
	port(
		in0:	in	std_logic_vector(Bits-1 downto 0);
		in1:	in	std_logic_vector(Bits-1 downto 0);
		sel:	in	std_logic;
		outpt:	out	std_logic_vector(Bits-1 downto 0));
	end component;
	
	component n_Bits_Subtractor	-- diff = A - B
	generic(Bits:integer:=4);
	port(
		A:		in	std_logic_vector(Bits-1 downto 0);
		B:		in	std_logic_vector(Bits-1 downto 0);
		Bin:	in	std_logic;
		diff:	out	std_logic_vector(Bits-1 downto 0);
		Bout:	out	std_logic);
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal Q:		std_logic;
	signal in0:		std_logic_vector(Bits-1 downto 0);
	signal concat:	std_logic_vector(Bits-1 downto 0);
	-- / Signals \ --
	
	
begin
	concat <= Xin(Bits-2 downto 0) & A;
	U1: Mux generic map(Bits) port map(
		in0		=>	in0,
		in1		=>	concat,
		sel		=>	Q,
		outpt	=>	Xout);
	U2:	n_Bits_Subtractor generic map(Bits) port map(
		A		=>	concat,
		B		=>	B,
		Bin		=>	'0',
		diff	=>	in0,
		Bout	=>	Q);
	result <= Q;
end;

-- SubModule: Mux --
library ieee;
use ieee.std_logic_1164.all;

entity Mux is
generic(Bits:integer:=3);
port(
	in0:	in	std_logic_vector(Bits-1 downto 0);
	in1:	in	std_logic_vector(Bits-1 downto 0);
	sel:	in	std_logic;
	outpt:	out	std_logic_vector(Bits-1 downto 0));
end;

architecture one of Mux is
begin
	outpt <= in1 when(sel = '1')else in0;
end;

-- SubModule: Subtractor --
library ieee;
use ieee.std_logic_1164.all;

entity Subtractor is	-- diff = A - B
port(
	A:		in	std_logic;
	B:		in	std_logic;
	Bin:	in	std_logic;	-- Borrow in
	diff:	out	std_logic;
	Bout:	out	std_logic);	-- Borrow out
end;

architecture one of Subtractor is
begin
	diff <= A xor B xor Bin;
	Bout <= ((not A)and B) or ((not A)and Bin) or (B and Bin);
end;

-- SubModule: n_Bits_Subtractor --

library ieee;
use ieee.std_logic_1164.all;

entity n_Bits_Subtractor is	-- diff = A - B
generic(Bits:integer:=4);
port(
	A:		in	std_logic_vector(Bits-1 downto 0);
	B:		in	std_logic_vector(Bits-1 downto 0);
	Bin:	in	std_logic;
	diff:	out	std_logic_vector(Bits-1 downto 0);
	Bout:	out	std_logic);
end;

architecture one of n_Bits_Subtractor is

	-- / Components \ --
	component Subtractor	-- diff = A - B
	port(
		A:		in	std_logic;
		B:		in	std_logic;
		Bin:	in	std_logic;	-- Borrow in
		diff:	out	std_logic;
		Bout:	out	std_logic);	-- Borrow out
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal Borrow:	std_logic_vector(Bits downto 0);
	-- / Signals \ --
begin
	Gen:for i in 0 to Bits-1 Generate
		Sub:	Subtractor port map(A(i),B(i),Borrow(i),diff(i),Borrow(i+1));
	end Generate;
	Borrow(0) <= Bin;
	Bout <= Borrow(Bits);
end;

-- SubModule: ShiftRegister --

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

-- SubModule: EX_MEM --

library ieee;
use ieee.std_logic_1164.all;

entity EX_MEM is
port(
	reset:						in	std_logic;
	clk:						in	std_logic;
	En:							in	std_logic;
	ALU_Result_in:				in	std_logic_vector(31 downto 0);
	Addr_Write_Reg_in:			in	std_logic_vector(4  downto 0);
	En_Write_Reg_in:			in	std_logic;
	Mem_Read_in:				in	std_logic;
	Mem_Write_in:				in	std_logic;
	Data_Mem_Write_Data_in:		in	std_logic_vector(31 downto 0);
	BR_JMP_flag_in:			in	std_logic;
	BR_JMP_Addr_in:			in	std_logic_vector(7 downto 0);
	ALU_Result_out:				out	std_logic_vector(31 downto 0);
	Addr_Write_Reg_out:			out	std_logic_vector(4  downto 0);
	En_Write_Reg_out:			out	std_logic;
	Mem_Read_out:				out	std_logic;
	Mem_Write_out:				out	std_logic;
	Data_Mem_Write_Data_out:	out	std_logic_vector(31 downto 0);
	BR_JMP_flag_out:		out	std_Logic;
	BR_JMP_Addr_out:			out std_logic_vector(7 downto 0));
end;

architecture one of EX_MEM is
begin
	process(reset,clk)begin
		if(reset = '1')then
			ALU_Result_out			<=	(others => '0');
			Addr_Write_Reg_out		<=	(others => '0');
			En_Write_Reg_out		<=	'0';
			Mem_Read_out			<=	'0';
			Mem_Write_out			<=	'0';
			Data_Mem_Write_Data_out	<=	(others => '0');
			BR_JMP_Addr_out 		<=	(others => '0');
			BR_JMP_flag_out 		<=	'0';
		elsif(clk 'event and clk  = '1')then
			if(En = '1')then
				ALU_Result_out			<=	ALU_Result_in;
				Addr_Write_Reg_out		<=	Addr_Write_Reg_in;
				En_Write_Reg_out		<=	En_Write_Reg_in;
				Mem_Read_out			<=	Mem_Read_in;
				Mem_Write_out			<=	Mem_Write_in;
				Data_Mem_Write_Data_out <= Data_Mem_Write_Data_in;
				BR_JMP_Addr_out <= BR_JMP_Addr_in;
				BR_JMP_flag_out 		<= BR_JMP_flag_in;
			end if;
		end if;
	end process;
	
end;