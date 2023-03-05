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
--use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity ALU is
port(
	inpt1:in	std_logic_vector(31 downto 0);
	inpt2:in	std_logic_vector(31 downto 0);
	outpt:out	std_logic_vector(31 downto 0);
	Op_Code:in	std_logic_vector(5 downto 0);
	En:in	std_logic);
end;

architecture one of ALU is
	signal zero:	std_logic_vector(15 downto 0);
	signal mul:		std_logic_vector(63 downto 0);
	signal mulh:	std_logic_vector(63 downto 0);
begin
	process(inpt1,inpt2,En,Op_Code)begin
		
--		mul	 <= inpt1 * inpt2;
--		mulh <= (inpt1(15 downto 0)&zero) * inpt2;
		outpt <= (others => '0');
		
		if(En = '1')then
			case(Op_Code)is
--				when "000100" => outpt <= inpt1 + inpt2;												-- ADD
--				when "000101" => outpt <= inpt2 - inpt1;												-- SUB
--				when "000110" => outpt <= mul(31 downto 0);												-- MUL
				when "000111" => outpt <= inpt2 / inpt1;											-- DIV
				when "001000" => outpt <= inpt1 and inpt2;												-- AND
				when "001001" => outpt <= inpt1 or  inpt2;												-- OR
				when "001010" => outpt <= inpt1 nor inpt2;												-- NOR
				when "001011" => outpt <= inpt1 xor inpt2;												-- XOR
--				when "011000" => outpt <= std_logic_vector(unsigned(inpt2) sll unsigned(inpt1));	-- SLL
--				when "011001" => outpt <= std_logic_vector(unsigned(inpt2) srl unsigned(inpt1));	-- SRL
--				when "011010" => outpt <= std_logic_vector(unsigned(inpt2) sla unsigned(inpt1));	-- SLA
--				when "011011" => outpt <= std_logic_vector(unsigned(inpt2) sra unsigned(inpt1));	-- SRA
--				when "100100" => outpt <= (inpt1(15 downto 0)&zero) + inpt2;							-- ADDHI
--				when "100101" => outpt <= inpt2 - (inpt1(15 downto 0)&zero);							-- SUBHI
--				when "100110" => outpt <= mulh(31 downto 0);											-- MULHI
				when "100111" => outpt <= inpt2 / (inpt1&zero);										-- DIVHI
				when "101000" => outpt <= inpt1(15 downto 0)&zero and inpt2;							-- ANDHI
				when "101001" => outpt <= inpt1(15 downto 0)&zero or  inpt2;							-- ORHI
				when "101010" => outpt <= inpt1(15 downto 0)&zero nor inpt2;							-- NORHI
				when "101011" => outpt <= inpt1(15 downto 0)&zero xor inpt2;							-- XORHI
				when others=> outpt <= (others => '0');
			end case;
		else
			outpt <= (others => '0');
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

