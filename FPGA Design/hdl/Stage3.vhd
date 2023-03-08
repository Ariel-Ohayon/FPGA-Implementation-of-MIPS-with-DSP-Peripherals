library ieee;
use ieee.std_logic_1164.all;

entity Stage3 is
port(
	clk:	in	std_logic;
	reset:	in	std_logic;
	SP_Data:	in	std_logic_vector(11 downto 0);
	ALU_Op_Code:	in	std_logic_vector(5 downto 0);
	ALU_src:	in	std_logic;
	En_Integer:	in	std_logic;
	En_Float:	in	std_logic;
	Memory_Read_in:	in	std_logic;
	Memory_Write_in:	in	std_logic;
	Reg_Write_En_in:	in	std_logic;
	WB_Mux_sel_in:	in	std_logic;
	CALL_flag_in:	in	std_logic;
	RET_flag_in:	in	std_logic;
	BR_flag_in:	in	std_logic;
	Addr_Write_Reg_in:	in	std_logic_vector(4 downto 0);
	data1_in:	in	std_logic_vector(31 downto 0);
	data2_in:	in	std_logic_vector(31 downto 0);
	imm_in:	in	std_logic_vector(15 downto 0);
	Result_out:	out	std_logic_vector(31 downto 0);
	Memory_Read_out:	out	std_logic;
	Memory_Write_out:	out	std_logic;
	Reg_Write_En_out:	out	std_logic;
	WB_Mux_sel_out:	out	std_logic;
	Addr_Write_Reg_out:	out	std_logic_vector(4 downto 0);
	imm_out:	out	std_logic_vector(15 downto 0);
	BR_Ex_out:	out	std_logic;
	CALL_flag_out:	out	std_logic;
	RET_flag_out:	out	std_logic;
	SP_Data_out:	out	std_logic_vector(11 downto 0);
	data1_out:	out	std_logic_vector(31 downto 0);
	JMP_flag_in:	in	std_logic;
	JMP_flag_out:	out	std_logic;
	Result_out_no_Pipeline:	out	std_logic_vector(31 downto 0));
end;

architecture one of Stage3 is

	-- / Components \ --
	component ALU
	port(
		inpt1:	in	std_logic_vector(31 downto 0);
		inpt2:	in	std_logic_vector(31 downto 0);
		outpt:	out	std_logic_vector(31 downto 0);
		Op_Code:	in	std_logic_vector(5 downto 0);
		En:	in	std_logic);
	end component;
	component FPU
	port(
		inpt1:	in	std_logic_vector(31 downto 0);
		inpt2:	in	std_logic_vector(31 downto 0);
		outpt:	out	std_logic_vector(31 downto 0);
		Op_Code:	in	std_logic_vector(5 downto 0);
		En:	in	std_logic);
	end component;
	component ALU_MUX
	port(
		in0:	in	std_logic_vector(31 downto 0);
		in1:	in	std_logic_vector(15 downto 0);
		selector:	in	std_logic;
		outpt:	out	std_logic_vector(31 downto 0));
	end component;
	component Result_Module
	port(
		in0:	in	std_logic_vector(31 downto 0);
		in1:	in	std_logic_vector(31 downto 0);
		selector:	in	std_logic_vector(1 downto 0);
		outpt:	out	std_logic_vector(31 downto 0));
	end component;
	component EX_MEM_Pipeline_Register
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		Memory_Read_in:	in	std_logic;
		Memory_Write_in:	in	std_logic;
		Reg_Write_En_in:	in	std_logic;
		WB_Mux_sel_in:	in	std_logic;
		Memory_Read_out:	out	std_logic;
		Memory_Write_out:	out	std_logic;
		Reg_Write_En_out:	out	std_logic;
		WB_Mux_sel_out:	out	std_logic;
		Result_in:	in	std_logic_vector(31 downto 0);
		Result_out:	out	std_logic_vector(31 downto 0);
		Addr_Write_Reg_in:	in	std_logic_vector(4 downto 0);
		Addr_Write_Reg_out:	out	std_logic_vector(4 downto 0);
		imm_in:	in	std_logic_vector(15 downto 0);
		imm_out:	out	std_logic_vector(15 downto 0);
		BR_Ex_in:	in	std_logic;
		BR_Ex_out:	out	std_logic;
		CALL_flag_in:	in	std_logic;
		RET_flag_in:	in	std_logic;
		CALL_flag_out:	out	std_logic;
		RET_flag_out:	out	std_logic;
		JMP_flag_in:	in	std_logic;
		JMP_flag_out:	out	std_logic;
		SP_Data_in:	in	std_logic_vector(11 downto 0);
		SP_Data_out:	out	std_logic_vector(11 downto 0);
		data1_in:	in	std_logic_vector(31 downto 0);
		data1_out:	out	std_logic_vector(31 downto 0));
	end component;
	component JMP_BR_Tester
	port(
		BR_flag:	in	std_logic;
		data1:	in	std_logic_vector(31 downto 0);
		data2:	in	std_logic_vector(31 downto 0);
		BR_Ex:	out	std_logic;
		Op_Code:	in	std_logic_vector(5 downto 0));
	end component;
	-- / Components \ --

	-- / Signals\ --
	signal ALU_inpt:	std_logic_vector(31 downto 0);
	signal Result:	std_logic_vector(31 downto 0);
	signal ALU_out:	std_logic_vector(31 downto 0);
	signal FPU_out:	std_logic_vector(31 downto 0);
	signal BR_Ex:	std_logic;
	-- / Signals \ --

begin
	U1: ALU_MUX port map(
			in0	=>	data2_in,
			in1	=>	imm_in,
			selector	=>	ALU_src,
			outpt	=>	ALU_inpt);

	U2: ALU port map(
			inpt1	=>	ALU_inpt,
			inpt2	=>	data1_in,
			outpt	=>	ALU_out,
			Op_Code	=>	ALU_Op_Code,
			En	=>	En_Integer);

	U3: FPU port map(
			inpt1	=>	data1_in,
			inpt2	=>	data2_in,
			outpt	=>	FPU_out,
			Op_Code	=>	ALU_Op_Code,
			En	=>	En_Float);

	U4: Result_Module port map(
			in0	=>	ALU_out,
			in1	=>	FPU_out,
			selector	=>	En_Integer & En_Float,
			outpt	=>	Result);

	U5: EX_MEM_Pipeline_Register port map(
			clk	=>	clk,
			reset	=>	reset,
			Result_in	=>	Result,
			Result_out	=>	Result_out,
			Memory_Read_in	=>	Memory_Read_in,
			Memory_Write_in	=>	Memory_Write_in,
			Reg_Write_En_in	=>	Reg_Write_En_in,
			WB_Mux_sel_in	=>	WB_Mux_sel_in,
			Memory_Read_out	=>	Memory_Read_out,
			Memory_Write_out	=>	Memory_Write_out,
			Reg_Write_En_out	=>	Reg_Write_En_out,
			WB_Mux_sel_out	=>	WB_Mux_sel_out,
			Addr_Write_Reg_in	=>	Addr_Write_Reg_in,
			Addr_Write_Reg_out	=>	Addr_Write_Reg_out,
			imm_in	=>	imm_in,
			imm_out	=>	imm_out,
			BR_Ex_in	=>	BR_Ex,
			BR_Ex_out	=>	BR_Ex_out,
			CALL_flag_in	=>	CALL_flag_in,
			RET_flag_in	=>	RET_flag_in,
			CALL_flag_out	=>	CALL_flag_out,
			RET_flag_out	=>	RET_flag_out,
			JMP_flag_in	=>	JMP_flag_in,
			JMP_flag_out	=>	JMP_flag_out,
			SP_Data_in	=>	SP_Data,
			SP_Data_out	=>	SP_Data_out,
			data1_in	=>	data1_in,
			data1_out	=>	data1_out);

	U6: JMP_BR_Tester port map(
			BR_flag	=>	BR_flag_in,
			data1	=>	data1_in,
			data2	=>	data2_in,
			BR_Ex	=>	BR_Ex,
			Op_Code	=>	ALU_Op_Code);

	Result_out_no_Pipeline <= Result;
end;

-- SubModule: ALU --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ALU is
port(
	inpt1:in	std_logic_vector(31 downto 0);
	inpt2:in	std_logic_vector(31 downto 0);
	outpt:out	std_logic_vector(31 downto 0);
	Op_Code:in	std_logic_vector(5 downto 0);
	En:in	std_logic);
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
	-- / Signals \ --
	
begin

	U1: Division generic map(32) port map(
		dividend	=>	inpt2,
		divisor		=>	divisor,
		Q			=>	div_result,
		reminder	=>	open);
		
	U2:	ShiftRegister port map(
		inpt1	=>	inpt1(4 downto 0),
		inpt2	=>	inpt2,
		AL		=>	signal_AL,
		RL		=>	signal_RL,
		outpt	=>	ShiftReg_out);
	
	sel <= Op_Code(5);
	
	divisor <= inpt1(15 downto 0)&zero when(sel='1')else inpt1;
	
	process(inpt1,inpt2,En,Op_Code)begin
		
		mul	 <= inpt1 * inpt2;
		mulh <= (inpt1(15 downto 0)&zero) * inpt2;
		outpt <= (others => '0');
		signal_AL <= '0';
		signal_RL <= '0';
		
		if(En = '1')then
			case(Op_Code)is
				when "000100" => outpt <= inpt1 + inpt2;									-- ADD
				when "000101" => outpt <= inpt2 - inpt1;									-- SUB
				when "000110" => outpt <= mul(31 downto 0);									-- MUL
				when "000111" => outpt <= div_result;										-- DIV
				when "001000" => outpt <= inpt1 and inpt2;									-- AND
				when "001001" => outpt <= inpt1 or  inpt2;									-- OR
				when "001010" => outpt <= inpt1 nor inpt2;									-- NOR
				when "001011" => outpt <= inpt1 xor inpt2;									-- XOR
				when "011000" => outpt <= ShiftReg_out; signal_AL <= '0'; signal_RL <= '0';	-- SLL
				when "011001" => outpt <= ShiftReg_out; signal_AL <= '0'; signal_RL <= '1';	-- SRL
				when "011010" => outpt <= ShiftReg_out; signal_AL <= '1'; signal_RL <= '0';	-- SLA
				when "011011" => outpt <= ShiftReg_out; signal_AL <= '1'; signal_RL <= '1';	-- SRA
				when "100100" => outpt <= (inpt1(15 downto 0)&zero) + inpt2;				-- ADDHI
				when "100101" => outpt <= inpt2 - (inpt1(15 downto 0)&zero);				-- SUBHI
				when "100110" => outpt <= mulh(31 downto 0);								-- MULHI
				when "100111" => outpt <= div_result;										-- DIVHI
				when "101000" => outpt <= inpt1(15 downto 0)&zero and inpt2;				-- ANDHI
				when "101001" => outpt <= inpt1(15 downto 0)&zero or  inpt2;				-- ORHI
				when "101010" => outpt <= inpt1(15 downto 0)&zero nor inpt2;				-- NORHI
				when "101011" => outpt <= inpt1(15 downto 0)&zero xor inpt2;				-- XORHI
				when others=> outpt <= (others => '0');
			end case;
		else
			outpt <= (others => '0');
		end if;
	end process;
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

-- SubModule: FPU --

library ieee;
use ieee.std_logic_1164.all;

entity FPU is
port(
	inpt1:in	std_logic_vector(31 downto 0);
	inpt2:in	std_logic_vector(31 downto 0);
	outpt:out	std_logic_vector(31 downto 0);
	Op_Code:in	std_logic_vector(5 downto 0);
	En:in	std_logic);
end;

architecture one of FPU is
begin

end;

-- SubModule: ALU_MUX --

library ieee;
use ieee.std_logic_1164.all;

entity ALU_MUX is
port(
	in0:in	std_logic_vector(31 downto 0);
	in1:in	std_logic_vector(15 downto 0);
	selector:in	std_logic;
	outpt:out	std_logic_vector(31 downto 0));
end;

architecture one of ALU_MUX is
	signal zeros:	std_logic_vector(15 downto 0):=(others=>'0');
begin
	outpt <= zeros&in1 when(selector='1')else in0;
end;

-- SubModule: Result_Module --

library ieee;
use ieee.std_logic_1164.all;

entity Result_Module is
port(
	in0:in	std_logic_vector(31 downto 0);
	in1:in	std_logic_vector(31 downto 0);
	selector:in	std_logic_vector(1 downto 0);	-- LSB En_Float
	outpt:out	std_logic_vector(31 downto 0));
end;

architecture one of Result_Module is
begin
	outpt <= in1 when(selector="01")else in0 when (selector="10")else(others=>'0');
end;

-- SubModule: EX_MEM_Pipeline_Register --

library ieee;
use ieee.std_logic_1164.all;

entity EX_MEM_Pipeline_Register is
port(
	clk:in	std_logic;
	reset:in	std_logic;
	Memory_Read_in:in	std_logic;
	Memory_Write_in:in	std_logic;
	Reg_Write_En_in:in	std_logic;
	WB_Mux_sel_in:in	std_logic;
	Memory_Read_out:out	std_logic;
	Memory_Write_out:out	std_logic;
	Reg_Write_En_out:out	std_logic;
	WB_Mux_sel_out:out	std_logic;--
	Result_in:in	std_logic_vector(31 downto 0);
	Result_out:out	std_logic_vector(31 downto 0);--
	Addr_Write_Reg_in:in	std_logic_vector(4 downto 0);
	Addr_Write_Reg_out:out	std_logic_vector(4 downto 0);
	imm_in:in	std_logic_vector(15 downto 0);
	imm_out:out	std_logic_vector(15 downto 0);
	BR_Ex_in:in	std_logic;
	BR_Ex_out:out	std_logic;
	CALL_flag_in:in	std_logic;
	RET_flag_in:in	std_logic;
	CALL_flag_out:out	std_logic;
	RET_flag_out:out	std_logic;
	JMP_flag_in:in	std_logic;
	JMP_flag_out:out	std_logic;
	SP_Data_in:in	std_logic_vector(11 downto 0);
	SP_Data_out:out	std_logic_vector(11 downto 0);
	data1_in:in	std_logic_vector(31 downto 0);
	data1_out:out	std_logic_vector(31 downto 0));
end;

architecture one of EX_MEM_Pipeline_Register is
begin
	process(reset,clk)begin
		if(reset='1')then
			Memory_Read_out		<=	'0';
			Memory_Write_out	<=	'0';
			Reg_Write_En_out	<=	'0';
			WB_Mux_sel_out		<=	'0';
			Result_out			<=	(others=>'0');
			Addr_Write_Reg_out	<=	(others=>'0');
			imm_out				<=	(others=>'0');
			BR_Ex_out			<=	'0';
			CALL_flag_out		<=	'0';
			RET_flag_out		<=	'0';
			JMP_flag_out		<=	'0';
			SP_Data_out			<=	(others=>'0');
			data1_out			<=	(others=>'0');
		elsif(clk 'event and clk = '1')then
			Memory_Read_out		<=	Memory_Read_in;
			Memory_Write_out	<=	Memory_Write_in;
			Reg_Write_En_out	<=	Reg_Write_En_in;
			WB_Mux_sel_out		<=	WB_Mux_sel_in;
			Result_out			<=	Result_in;
			Addr_Write_Reg_out	<=	Addr_Write_Reg_in;
			imm_out				<=	imm_in;
			BR_Ex_out			<=	BR_Ex_in;
			CALL_flag_out		<=	CALL_flag_in;
			RET_flag_out		<=	RET_flag_in;
			JMP_flag_out		<=	JMP_flag_in;
			SP_Data_out			<=	SP_Data_in;
			data1_out			<=	data1_in;
		end if;
	end process;
end;

-- SubModule: JMP_BR_Tester --

library ieee;
use ieee.std_logic_1164.all;

entity JMP_BR_Tester is
port(
	BR_flag:in	std_logic;
	data1:in	std_logic_vector(31 downto 0);
	data2:in	std_logic_vector(31 downto 0);
	BR_Ex:out	std_logic;
	Op_Code:in	std_logic_vector(5 downto 0));
end;

architecture one of JMP_BR_Tester is
begin
	process(BR_flag,data1,data2,Op_Code)begin
		BR_Ex <= '0';
		if(BR_flag = '1')then
			case(Op_Code)is
				when "001100"	=>	-- BEQ
					if(data1 = data2)then
						BR_Ex <= '1';
					else
						BR_Ex <= '0';
					end if;
				when "001101"	=>	-- BNE
					if(data1 = data2)then
						BR_Ex <= '0';
					else
						BR_Ex <= '1';
					end if;
				when "001110"	=>	-- BGT
					if(data1 > data2)then
						BR_Ex <= '1';
					else
						BR_Ex <= '0';
					end if;
				when "001111"	=>	-- BLE
					if(data1 < data2)then
						BR_Ex <= '1';
					else
						BR_Ex <= '0';
					end if;
				when others => BR_Ex <= '0';
			end case;
		else
			BR_Ex <= '0';
		end if;
	end process;
end;

