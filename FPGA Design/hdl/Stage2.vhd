library ieee;
use ieee.std_logic_1164.all;

entity Stage2 is
port(
	clk:	in	std_logic;
	reset:	in	std_logic;
	En_Pipeline:	in	std_logic;
	Instruction:	in	std_logic_vector(31 downto 0);
	Addr_Write_Reg:	in	std_logic_vector(4 downto 0);
	Reg_Write_En_in:	in	std_logic;
	SP_Data:	out	std_logic_vector(11 downto 0);
	ALU_Op_Code_out:	out	std_logic_vector(5 downto 0);
	ALU_src_out:	out	std_logic;
	En_Integer_out:	out	std_logic;
	En_Float_out:	out	std_logic;
	Memory_Read_out:	out	std_logic;
	Memory_Write_out:	out	std_logic;
	Reg_Write_En_out:	out	std_logic;
	WB_Mux_sel_out:	out	std_logic;
	CALL_flag_out:	out	std_logic;
	RET_flag_out:	out	std_logic;
	BR_flag_out:	out	std_logic;
	Addr_Write_Reg_out:	out	std_logic_vector(4 downto 0);
	data1_out:	out	std_logic_vector(31 downto 0);
	data2_out:	out	std_logic_vector(31 downto 0);
	imm_out:	out	std_logic_vector(15 downto 0);
	JMP_flag_out:	out	std_logic;
	data_in:	in	std_logic_vector(31 downto 0);
	F_Read_Reg_En:	out	std_logic;
	Forward_Data_in:	in	std_logic_vector(31 downto 0);
	Forward_Selector:	in	std_logic_vector(1 downto 0));
end;

architecture one of Stage2 is

	-- / Components \ --
	component Control_Unit
	port(
		Instruction:	in	std_logic_vector(31 downto 0);
		OP_Code:	out	std_logic_vector(5 downto 0);
		ALU_src:	out	std_logic;
		En_Integer:	out	std_logic;
		En_Float:	out	std_logic;
		Memory_Read:	out	std_logic;
		Memory_Write:	out	std_logic;
		Reg_Read_En:	out	std_logic;
		Reg_Write_En:	out	std_logic;
		WB_MUX_sel:	out	std_logic;
		JMP_flag:	out	std_logic;
		CALL_flag:	out	std_logic;
		RET_flag:	out	std_logic;
		BR_flag:	out	std_logic);
	end component;
	component Register_File
	port(
		reset:	in	std_logic;
		clk:	in	std_logic;
		Addr_Read_Reg1:	in	std_logic_vector(4 downto 0);
		Addr_Read_Reg2:	in	std_logic_vector(4 downto 0);
		En_Read:	in	std_logic;
		Addr_Write_Reg:	in	std_logic_vector(4 downto 0);
		En_Write:	in	std_logic;
		data_in:	in	std_logic_vector(31 downto 0);
		data1:	out	std_logic_vector(31 downto 0);
		data2:	out	std_logic_vector(31 downto 0));
	end component;
	component StackPointer
	port(
		reset:	in	std_logic;
		clk:	in	std_logic;
		pop:	in	std_logic;
		push:	in	std_logic;
		output:	out	std_logic_vector(11 downto 0);
		inpt:	in	std_logic_vector(11 downto 0));
	end component;
	component ID_EX_Pipeline_Register
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		En:	in	std_logic;
		ALU_Op_Code_in:	in	std_logic_vector(5 downto 0);
		ALU_src_in:	in	std_logic;
		En_Integer_in:	in	std_logic;
		En_Float_in:	in	std_logic;
		Memory_Read_in:	in	std_logic;
		Memory_Write_in:	in	std_logic;
		Reg_Write_En_in:	in	std_logic;
		WB_Mux_sel_in:	in	std_logic;
		CALL_flag_in:	in	std_logic;
		RET_flag_in:	in	std_logic;
		BR_flag_in:	in	std_logic;
		ALU_Op_Code_out:	out	std_logic_vector(5 downto 0);
		ALU_src_out:	out	std_logic;
		En_Integer_out:	out	std_logic;
		En_Float_out:	out	std_logic;
		Memory_Read_out:	out	std_logic;
		Memory_Write_out:	out	std_logic;
		Reg_Write_En_out:	out	std_logic;
		WB_Mux_sel_out:	out	std_logic;
		CALL_flag_out:	out	std_logic;
		RET_flag_out:	out	std_logic;
		BR_flag_out:	out	std_logic;
		JMP_flag_in:	in	std_logic;
		JMP_flag_out:	out	std_logic;
		Addr_Write_Reg_in:	in	std_logic_vector(4 downto 0);
		data1_in:	in	std_logic_vector(31 downto 0);
		data2_in:	in	std_logic_vector(31 downto 0);
		imm_in:	in	std_logic_vector(15 downto 0);
		Addr_Write_Reg_out:	out	std_logic_vector(4 downto 0);
		data1_out:	out	std_logic_vector(31 downto 0);
		data2_out:	out	std_logic_vector(31 downto 0);
		imm_out:	out	std_logic_vector(15 downto 0);
		SP_in:	in	std_logic_vector(11 downto 0);
		SP_out:	out	std_logic_vector(11 downto 0));
	end component;
	component Forward_MUX
	port(
		in0:	in	std_logic_vector(31 downto 0);
		in1:	in	std_logic_vector(31 downto 0);
		output:	out	std_logic_vector(31 downto 0);
		selector:	in	std_logic);
	end component;
	-- / Components \ --

	-- / Signals\ --
	signal ALU_Op_Code:	std_logic_vector(5 downto 0);
	signal ALU_src:	std_logic;
	signal En_Integer:	std_logic;
	signal En_Float:	std_logic;
	signal Memory_Read:	std_logic;
	signal Memory_Write:	std_logic;
	signal Reg_Read_En:	std_logic;
	signal Reg_Write_En:	std_logic;
	signal WB_MUX_sel:	std_logic;
	signal JMP_flag:	std_logic;
	signal CALL_flag:	std_logic;
	signal RET_flag:	std_logic;
	signal BR_flag:	std_logic;
	signal data1:	std_logic_vector(31 downto 0);
	signal data2:	std_logic_vector(31 downto 0);
	signal SP_out:	std_logic_vector(11 downto 0);
	signal Reg1_out:	std_logic_vector(31 downto 0);
	signal Reg2_out:	std_logic_vector(31 downto 0);
	signal nclk: std_logic;
	-- / Signals \ --

begin
	nclk<=not clk;
	U1: Control_Unit port map(
			Instruction	=>	Instruction,
			OP_Code	=>	ALU_Op_Code,
			ALU_src	=>	ALU_src,
			En_Integer	=>	En_Integer,
			En_Float	=>	En_Float,
			Memory_Read	=>	Memory_Read,
			Memory_Write	=>	Memory_Write,
			Reg_Read_En	=>	Reg_Read_En,
			Reg_Write_En	=>	Reg_Write_En,
			WB_MUX_sel	=>	WB_MUX_sel,
			JMP_flag	=>	JMP_flag,
			CALL_flag	=>	CALL_flag,
			RET_flag	=>	RET_flag,
			BR_flag	=>	BR_flag);

	U2: Register_File port map(
			reset	=>	reset,
			clk	=>	nclk,	--notice problem number 1
			Addr_Read_Reg1	=>	Instruction(25 downto 21),
			Addr_Read_Reg2	=>	Instruction(20 downto 16),
			En_Read	=>	Reg_Read_En,
			Addr_Write_Reg	=>	Addr_Write_Reg,
			En_Write	=>	Reg_Write_En_in,
			data_in	=>	data_in,
			data1	=>	Reg1_out,
			data2	=>	Reg2_out);

	U3: StackPointer port map(
			reset	=>	reset,
			clk	=>	nclk, --notice problem number 1
			pop	=>	RET_flag,
			push	=>	CALL_flag,
			output	=>	SP_out,
			inpt	=>	Instruction(11 downto 0));

	U4: ID_EX_Pipeline_Register port map(
			clk	=>	clk,
			reset	=>	reset,
			En	=>	En_Pipeline,
			ALU_Op_Code_in	=>	ALU_Op_Code,
			ALU_src_in	=>	ALU_src,
			En_Integer_in	=>	En_Integer,
			En_Float_in	=>	En_Float,
			Memory_Read_in	=>	Memory_Read,
			Memory_Write_in	=>	Memory_Write,
			Reg_Write_En_in	=>	Reg_Write_En,
			WB_Mux_sel_in	=>	WB_MUX_sel,
			CALL_flag_in	=>	CALL_flag,
			RET_flag_in	=>	RET_flag,
			BR_flag_in	=>	BR_flag,
			ALU_Op_Code_out	=>	ALU_Op_Code_out,
			ALU_src_out	=>	ALU_src_out,
			En_Integer_out	=>	En_Integer_out,
			En_Float_out	=>	En_Float_out,
			Memory_Read_out	=>	Memory_Read_out,
			Memory_Write_out	=>	Memory_Write_out,
			Reg_Write_En_out	=>	Reg_Write_En_out,
			WB_Mux_sel_out	=>	WB_Mux_sel_out,
			CALL_flag_out	=>	CALL_flag_out,
			RET_flag_out	=>	RET_flag_out,
			BR_flag_out	=>	BR_flag_out,
			JMP_flag_in	=>	JMP_flag,
			JMP_flag_out	=>	JMP_flag_out,
			Addr_Write_Reg_in	=>	Instruction(15 downto 11),
			data1_in	=>	data1,
			data2_in	=>	data2,
			imm_in	=>	Instruction(15 downto 0),
			Addr_Write_Reg_out	=>	Addr_Write_Reg_out,
			data1_out	=>	data1_out,
			data2_out	=>	data2_out,
			imm_out	=>	imm_out,
			SP_in	=>	SP_out,
			SP_out	=>	SP_Data);

	U5: Forward_MUX port map(
			in0	=>	Reg1_out,
			in1	=>	Forward_Data_in,
			output	=>	data1,
			selector	=>	Forward_Selector(0));

	U6: Forward_MUX port map(
			in0	=>	Reg2_out,
			in1	=>	Forward_Data_in,
			output	=>	data2,
			selector	=>	Forward_Selector(1));

	F_Read_Reg_En <= Reg_Read_En;
end;

-- SubModule: Control_Unit --

library ieee;
use ieee.std_logic_1164.all;

entity Control_Unit is
port(
	Instruction:in	std_logic_vector(31 downto 0);
	OP_Code:out	std_logic_vector(5 downto 0);
	ALU_src:out	std_logic;						-- ALU_src = '0' => Register, ALU_src = '1' => imm
	En_Integer:out	std_logic;
	En_Float:out	std_logic;
	Memory_Read:out	std_logic;
	Memory_Write:out	std_logic;
	Reg_Read_En:out	std_logic;
	Reg_Write_En:out	std_logic;
	WB_MUX_sel:out	std_logic;
	JMP_flag:out	std_logic;
	CALL_flag:out	std_logic;
	RET_flag:out	std_logic;
	BR_flag:out	std_logic);
end;

architecture one of Control_Unit is
	
	-- / Components \ --
	component Control_Unit_Decoder
	generic(Bits:integer:=2);
	port(
		inpt:	in	std_logic_vector(Bits-1 downto 0);
		outpt:	out	std_logic_vector((2**Bits)-1 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal R_Type:			std_logic;
	signal sOp_Code:		std_logic_vector(5 downto 0);
	signal real_Op_Code:	std_logic_vector(5 downto 0);
	signal Dec_out:			std_logic_vector(63 downto 0);
	-- / Signals \ --
	
	signal sMemory_Read:	std_logic;
	signal sMemory_Write:	std_logic;
	signal sBR_flag,sJMP_flag,sCALL_flag,sRET_flag:	std_logic;
	signal sEn_Float:	std_logic;
	
begin
	
	sOp_Code <= Instruction(31 downto 26);
	R_Type		<= not (sOp_Code(0) or sOp_Code(1) or sOp_Code(2) or sOp_Code(3) or sOp_Code(4) or sOp_Code(5));
	
	real_Op_Code <= Instruction(5 downto 0) when(R_Type = '1') else sOp_Code;
	OP_Code <= real_Op_Code;
	
	U1: Control_Unit_Decoder generic map(6) port map(real_Op_Code,Dec_out);
	
	sEn_Float <= Dec_out(0) or Dec_out(1) or Dec_out(2) or Dec_out(3);
	En_Float  <= sEn_Float;
	En_Integer <= not sEn_Float;
	
	ALU_src <= Dec_out(4)  or Dec_out(5)  or Dec_out(6)  or Dec_out(7)  or	--	ADDI   - DIVI
			   Dec_out(20) or Dec_out(21) or Dec_out(22) or Dec_out(23) or	--	ADDUI  - DIVUI
			   Dec_out(36) or Dec_out(37) or Dec_out(38) or Dec_out(39) or	--	ADDHI  - DIVHI
			   Dec_out(52) or Dec_out(53) or Dec_out(54) or Dec_out(55) or	--	ADDUHI - DIVUHI
			   Dec_out(8)  or Dec_out(9)  or Dec_out(10) or Dec_out(11) or	--	ANDI   - XORI
			   Dec_out(40) or Dec_out(41) or Dec_out(42) or Dec_out(43);	--	ANDHI - XORHI
	
	sMemory_Read  <= Dec_out(1) and (not R_Type);
	sMemory_Write <= Dec_out(2) and (not R_Type);
	Memory_Read   <= sMemory_Read;
	Memory_Write  <= sMemory_Write;
	
	Reg_Read_En  <= not (Dec_out(63) or Dec_out(62) or Dec_out(61) or Dec_out(56) or Dec_out(57) or sMemory_Read);
	Reg_Write_En <= not (sBR_flag or sMemory_Write or sJMP_flag or sCALL_flag or sRET_flag or Dec_out(56) or Dec_out(57));
	
	WB_MUX_sel <= Dec_out(1) and (not R_Type);
	
	sJMP_flag  <= Dec_out(63);
	sRET_flag  <= Dec_out(61);
	sCALL_flag <= Dec_out(62);
	JMP_flag   <= sJMP_flag;
	RET_flag   <= sRET_flag;
	CALL_flag  <= sCALL_flag;
	
	BR_flag  <= sBR_flag;
	sBR_flag <= Dec_out(12) or Dec_out(13) or Dec_out(14) or Dec_out(15);
	
end;

-- SubModule: Control_Unit_Decoder --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Control_Unit_Decoder is
generic(Bits:integer:=2);
port(
	inpt:	in	std_logic_vector(Bits-1 downto 0);
	outpt:	out	std_logic_vector((2**Bits)-1 downto 0));
end;

architecture one of Control_Unit_Decoder is
begin
	process(inpt)begin
		outpt <= (others=>'0');
		outpt(CONV_INTEGER(inpt)) <= '1';
	end process;
end;

-- SubModule: Register_File --

library ieee;
use ieee.std_logic_1164.all;

entity Register_File is
port(
	reset:in	std_logic;
	clk:in	std_logic;
	Addr_Read_Reg1:in	std_logic_vector(4 downto 0);
	Addr_Read_Reg2:in	std_logic_vector(4 downto 0);
	En_Read:in	std_logic;
	Addr_Write_Reg:in	std_logic_vector(4 downto 0);
	En_Write:in	std_logic;
	data_in:in	std_logic_vector(31 downto 0);
	data1:out	std_logic_vector(31 downto 0);
	data2:out	std_logic_vector(31 downto 0));
end;

architecture one of Register_File is

	-- / Components \ --
	component Register_File_Multiplexer
	port(
		selector:	in	std_logic_vector(4  downto 0);
		Reg0:		in	std_logic_vector(31 downto 0);
		Reg1:		in	std_logic_vector(31 downto 0);
		Reg2:		in	std_logic_vector(31 downto 0);
		Reg3:		in	std_logic_vector(31 downto 0);
		Reg4:		in	std_logic_vector(31 downto 0);
		Reg5:		in	std_logic_vector(31 downto 0);
		Reg6:		in	std_logic_vector(31 downto 0);
		Reg7:		in	std_logic_vector(31 downto 0);
		Reg8:		in	std_logic_vector(31 downto 0);
		Reg9:		in	std_logic_vector(31 downto 0);
		Reg10:		in	std_logic_vector(31 downto 0);
		Reg11:		in	std_logic_vector(31 downto 0);
		Reg12:		in	std_logic_vector(31 downto 0);
		Reg13:		in	std_logic_vector(31 downto 0);
		Reg14:		in	std_logic_vector(31 downto 0);
		Reg15:		in	std_logic_vector(31 downto 0);
		Reg16:		in	std_logic_vector(31 downto 0);
		Reg17:		in	std_logic_vector(31 downto 0);
		Reg18:		in	std_logic_vector(31 downto 0);
		Reg19:		in	std_logic_vector(31 downto 0);
		Reg20:		in	std_logic_vector(31 downto 0);
		Reg21:		in	std_logic_vector(31 downto 0);
		Reg22:		in	std_logic_vector(31 downto 0);
		Reg23:		in	std_logic_vector(31 downto 0);
		Reg24:		in	std_logic_vector(31 downto 0);
		Reg25:		in	std_logic_vector(31 downto 0);
		Reg26:		in	std_logic_vector(31 downto 0);
		Reg27:		in	std_logic_vector(31 downto 0);
		Reg28:		in	std_logic_vector(31 downto 0);
		Reg29:		in	std_logic_vector(31 downto 0);
		Reg30:		in	std_logic_vector(31 downto 0);
		Reg31:		in	std_logic_vector(31 downto 0);
		outpt:		out	std_logic_vector(31 downto 0));
	end component;
	
	component Rgister_File_Decoder
	generic(N:	integer := 2);
	port(
		inpt:	in	std_logic_vector(N-1 downto 0);
		outpt:	out	std_logic_vector((2**N)-1 downto 0));
	end component;
	
	component Register_File_Register
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		En:		in	std_logic;
		inpt:	in	std_logic_vector(31 downto 0);
		outpt:	out	std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --

	-- / Signals \ --
	signal Mux_in0:		std_logic_vector(31 downto 0);
	signal Mux_in1:		std_logic_vector(31 downto 0);
	signal Mux_in2:		std_logic_vector(31 downto 0);
	signal Mux_in3:		std_logic_vector(31 downto 0);
	signal Mux_in4:		std_logic_vector(31 downto 0);
	signal Mux_in5:		std_logic_vector(31 downto 0);
	signal Mux_in6:		std_logic_vector(31 downto 0);
	signal Mux_in7:		std_logic_vector(31 downto 0);
	signal Mux_in8:		std_logic_vector(31 downto 0);
	signal Mux_in9:		std_logic_vector(31 downto 0);
	signal Mux_in10:	std_logic_vector(31 downto 0);
	signal Mux_in11:	std_logic_vector(31 downto 0);
	signal Mux_in12:	std_logic_vector(31 downto 0);
	signal Mux_in13:	std_logic_vector(31 downto 0);
	signal Mux_in14:	std_logic_vector(31 downto 0);
	signal Mux_in15:	std_logic_vector(31 downto 0);
	signal Mux_in16:	std_logic_vector(31 downto 0);
	signal Mux_in17:	std_logic_vector(31 downto 0);
	signal Mux_in18:	std_logic_vector(31 downto 0);
	signal Mux_in19:	std_logic_vector(31 downto 0);
	signal Mux_in20:	std_logic_vector(31 downto 0);
	signal Mux_in21:	std_logic_vector(31 downto 0);
	signal Mux_in22:	std_logic_vector(31 downto 0);
	signal Mux_in23:	std_logic_vector(31 downto 0);
	signal Mux_in24:	std_logic_vector(31 downto 0);
	signal Mux_in25:	std_logic_vector(31 downto 0);
	signal Mux_in26:	std_logic_vector(31 downto 0);
	signal Mux_in27:	std_logic_vector(31 downto 0);
	signal Mux_in28:	std_logic_vector(31 downto 0);
	signal Mux_in29:	std_logic_vector(31 downto 0);
	signal Mux_in30:	std_logic_vector(31 downto 0);
	signal Mux_in31:	std_logic_vector(31 downto 0);
	signal En_Reg:		std_logic_vector(31 downto 0);
	signal sEn_Read:	std_logic_vector(31 downto 0);
	signal sdata1:		std_logic_vector(31 downto 0);
	signal sdata2:		std_logic_vector(31 downto 0);
	signal and_en0: std_logic;
	signal and_en1: std_logic;
	signal and_en2: std_logic;
	signal and_en3: std_logic;
	signal and_en4: std_logic;
	signal and_en5: std_logic;
	signal and_en6: std_logic;
	signal and_en7: std_logic;
	signal and_en8: std_logic;
	signal and_en9: std_logic;
	signal and_en10: std_logic;
	signal and_en11: std_logic;
	signal and_en12: std_logic;
	signal and_en13: std_logic;
	signal and_en14: std_logic;
	signal and_en15: std_logic;
	signal and_en16: std_logic;
	signal and_en17: std_logic;
	signal and_en18: std_logic;
	signal and_en19: std_logic;
	signal and_en20: std_logic;
	signal and_en21: std_logic;
	signal and_en22: std_logic;
	signal and_en23: std_logic;
	signal and_en24: std_logic;
	signal and_en25: std_logic;
	signal and_en26: std_logic;
	signal and_en27: std_logic;
	signal and_en28: std_logic;
	signal and_en29: std_logic;
	signal and_en30: std_logic;
	signal and_en31: std_logic;
	-- / Signals \ --

begin
and_en0<=En_Write and En_Reg(0);--notice problem number 1
and_en1<=En_Write and En_Reg(1);
and_en2<=En_Write and En_Reg(2);
and_en3<=En_Write and En_Reg(3);
and_en4<=En_Write and En_Reg(4);
and_en5<=En_Write and En_Reg(5);
and_en6<=En_Write and En_Reg(6);
and_en7<=En_Write and En_Reg(7);
and_en8<=En_Write and En_Reg(8);
and_en9<=En_Write and En_Reg(9);
and_en10<=En_Write and En_Reg(10);
and_en11<=En_Write and En_Reg(11);
and_en12<=En_Write and En_Reg(12);
and_en13<=En_Write and En_Reg(13);
and_en14<=En_Write and En_Reg(14);
and_en15<=En_Write and En_Reg(15);
and_en16<=En_Write and En_Reg(16);
and_en17<=En_Write and En_Reg(17);
and_en18<=En_Write and En_Reg(18);
and_en19<=En_Write and En_Reg(19);
and_en20<=En_Write and En_Reg(20);
and_en21<=En_Write and En_Reg(21);
and_en22<=En_Write and En_Reg(22);
and_en23<=En_Write and En_Reg(23);
and_en24<=En_Write and En_Reg(24);
and_en25<=En_Write and En_Reg(25);
and_en26<=En_Write and En_Reg(26);
and_en27<=En_Write and En_Reg(27);
and_en28<=En_Write and En_Reg(28);
and_en29<=En_Write and En_Reg(29);
and_en30<=En_Write and En_Reg(30);
and_en31<=En_Write and En_Reg(31);--notice problem number 1

	sEn_Read <= (others => En_Read);
	U1:	Rgister_File_Decoder generic map(5) port map(Addr_Write_Reg,En_Reg);
	
	U2:	Register_File_Multiplexer port map(
		Addr_Read_Reg1,
		Mux_in0,Mux_in1,Mux_in2,Mux_in3,Mux_in4,
		Mux_in5,Mux_in6,Mux_in7,Mux_in8,Mux_in9,
		
		Mux_in10,Mux_in11,Mux_in12,Mux_in13,Mux_in14,
		Mux_in15,Mux_in16,Mux_in17,Mux_in18,Mux_in19,
		
		Mux_in20,Mux_in21,Mux_in22,Mux_in23,Mux_in24,
		Mux_in25,Mux_in26,Mux_in27,Mux_in28,Mux_in29,
		
		Mux_in30,Mux_in31,
		
		sdata1);
	
	U3:	Register_File_Multiplexer port map(
		Addr_Read_Reg2,
		Mux_in0,Mux_in1,Mux_in2,Mux_in3,Mux_in4,
		Mux_in5,Mux_in6,Mux_in7,Mux_in8,Mux_in9,
		
		Mux_in10,Mux_in11,Mux_in12,Mux_in13,Mux_in14,
		Mux_in15,Mux_in16,Mux_in17,Mux_in18,Mux_in19,
		
		Mux_in20,Mux_in21,Mux_in22,Mux_in23,Mux_in24,
		Mux_in25,Mux_in26,Mux_in27,Mux_in28,Mux_in29,
		
		Mux_in30,Mux_in31,
		
		sdata2);
	
	data1 <= sEn_Read and sdata1;
	data2 <= sEn_Read and sdata2;
	
	Reg0:	Register_File_Register port map(clk,reset,and_en0,data_in,Mux_in0);--notice problem number 1
	Reg1:	Register_File_Register port map(clk,reset,and_en1,data_in,Mux_in1);
	Reg2:	Register_File_Register port map(clk,reset,and_en2,data_in,Mux_in2);
	Reg3:	Register_File_Register port map(clk,reset,and_en3,data_in,Mux_in3);
	Reg4:	Register_File_Register port map(clk,reset,and_en4,data_in,Mux_in4);
	Reg5:	Register_File_Register port map(clk,reset,and_en5,data_in,Mux_in5);
	Reg6:	Register_File_Register port map(clk,reset,and_en6,data_in,Mux_in6);
	Reg7:	Register_File_Register port map(clk,reset,and_en7,data_in,Mux_in7);
	Reg8:	Register_File_Register port map(clk,reset,and_en8,data_in,Mux_in8);
	Reg9:	Register_File_Register port map(clk,reset,and_en9,data_in,Mux_in9);
	Reg10:	Register_File_Register port map(clk,reset,and_en10,data_in,Mux_in10);
	Reg11:	Register_File_Register port map(clk,reset,and_en11,data_in,Mux_in11);
	Reg12:	Register_File_Register port map(clk,reset,and_en12,data_in,Mux_in12);
	Reg13:	Register_File_Register port map(clk,reset,and_en13,data_in,Mux_in13);
	Reg14:	Register_File_Register port map(clk,reset,and_en14,data_in,Mux_in14);
	Reg15:	Register_File_Register port map(clk,reset,and_en15,data_in,Mux_in15);
	Reg16:	Register_File_Register port map(clk,reset,and_en16,data_in,Mux_in16);
	Reg17:	Register_File_Register port map(clk,reset,and_en17,data_in,Mux_in17);
	Reg18:	Register_File_Register port map(clk,reset,and_en18,data_in,Mux_in18);
	Reg19:	Register_File_Register port map(clk,reset,and_en19,data_in,Mux_in19);
	Reg20:	Register_File_Register port map(clk,reset,and_en20,data_in,Mux_in20);
	Reg21:	Register_File_Register port map(clk,reset,and_en21,data_in,Mux_in21);
	Reg22:	Register_File_Register port map(clk,reset,and_en22,data_in,Mux_in22);
	Reg23:	Register_File_Register port map(clk,reset,and_en23,data_in,Mux_in23);
	Reg24:	Register_File_Register port map(clk,reset,and_en24,data_in,Mux_in24);
	Reg25:	Register_File_Register port map(clk,reset,and_en25,data_in,Mux_in25);
	Reg26:	Register_File_Register port map(clk,reset,and_en26,data_in,Mux_in26);
	Reg27:	Register_File_Register port map(clk,reset,and_en27,data_in,Mux_in27);
	Reg28:	Register_File_Register port map(clk,reset,and_en28,data_in,Mux_in28);
	Reg29:	Register_File_Register port map(clk,reset,and_en29,data_in,Mux_in29);
	Reg30:	Register_File_Register port map(clk,reset,and_en30,data_in,Mux_in30);
	Reg31:	Register_File_Register port map(clk,reset,and_en31,data_in,Mux_in31);--notice problem number 1
end;

-- SubModule: Rgister_File_Decoder --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Rgister_File_Decoder is
generic(N:	integer := 2);
port(
	inpt:	in	std_logic_vector(N-1 downto 0);
	outpt:	out	std_logic_vector((2**N)-1 downto 0));
end;

architecture one of Rgister_File_Decoder is
begin
	process(inpt)begin
		outpt <= (others=>'0');
		outpt(CONV_INTEGER(inpt)) <= '1';
	end process;
end;

-- SubModule: Register_File_Multiplexer --

library ieee;
use ieee.std_logic_1164.all;

entity Register_File_Multiplexer is
port(
	selector:	in	std_logic_vector(4  downto 0);
	Reg0:		in	std_logic_vector(31 downto 0);
	Reg1:		in	std_logic_vector(31 downto 0);
	Reg2:		in	std_logic_vector(31 downto 0);
	Reg3:		in	std_logic_vector(31 downto 0);
	Reg4:		in	std_logic_vector(31 downto 0);
	Reg5:		in	std_logic_vector(31 downto 0);
	Reg6:		in	std_logic_vector(31 downto 0);
	Reg7:		in	std_logic_vector(31 downto 0);
	Reg8:		in	std_logic_vector(31 downto 0);
	Reg9:		in	std_logic_vector(31 downto 0);
	Reg10:		in	std_logic_vector(31 downto 0);
	Reg11:		in	std_logic_vector(31 downto 0);
	Reg12:		in	std_logic_vector(31 downto 0);
	Reg13:		in	std_logic_vector(31 downto 0);
	Reg14:		in	std_logic_vector(31 downto 0);
	Reg15:		in	std_logic_vector(31 downto 0);
	Reg16:		in	std_logic_vector(31 downto 0);
	Reg17:		in	std_logic_vector(31 downto 0);
	Reg18:		in	std_logic_vector(31 downto 0);
	Reg19:		in	std_logic_vector(31 downto 0);
	Reg20:		in	std_logic_vector(31 downto 0);
	Reg21:		in	std_logic_vector(31 downto 0);
	Reg22:		in	std_logic_vector(31 downto 0);
	Reg23:		in	std_logic_vector(31 downto 0);
	Reg24:		in	std_logic_vector(31 downto 0);
	Reg25:		in	std_logic_vector(31 downto 0);
	Reg26:		in	std_logic_vector(31 downto 0);
	Reg27:		in	std_logic_vector(31 downto 0);
	Reg28:		in	std_logic_vector(31 downto 0);
	Reg29:		in	std_logic_vector(31 downto 0);
	Reg30:		in	std_logic_vector(31 downto 0);
	Reg31:		in	std_logic_vector(31 downto 0);
	outpt:		out	std_logic_vector(31 downto 0));
end;

architecture one of Register_File_Multiplexer is
begin
	with selector select outpt <= 
	Reg0	when	"00000",	-- 0
	Reg1	when	"00001",	-- 1
	Reg2	when	"00010",	-- 2
	Reg3	when	"00011",	-- 3
	Reg4	when	"00100",	-- 4
	Reg5	when	"00101",	-- 5
	Reg6	when	"00110",	-- 6
	Reg7	when	"00111",	-- 7
	Reg8	when	"01000",	-- 8
	Reg9	when	"01001",	-- 9
	Reg10	when	"01010",	-- 10
	Reg11	when	"01011",	-- 11
	Reg12	when	"01100",	-- 12
	Reg13	when	"01101",	-- 13
	Reg14	when	"01110",	-- 14
	Reg15	when	"01111",	-- 15
	Reg16	when	"10000",	-- 16
	Reg17	when	"10001",	-- 17
	Reg18	when	"10010",	-- 18
	Reg19	when	"10011",	-- 19
	Reg20	when	"10100",	-- 20
	Reg21	when	"10101",	-- 21
	Reg22	when	"10110",	-- 22
	Reg23	when	"10111",	-- 23
	Reg24	when	"11000",	-- 24
	Reg25	when	"11001",	-- 25
	Reg26	when	"11010",	-- 26
	Reg27	when	"11011",	-- 27
	Reg28	when	"11100",	-- 28
	Reg29	when	"11101",	-- 29
	Reg30	when	"11110",	-- 30
	Reg31	when	others;	-- 31 (problem number 2)
end;

-- Submodule: Register_File_Register --

library ieee;
use ieee.std_logic_1164.all;

entity Register_File_Register is
port(
	clk:	in	std_logic;
	reset:	in	std_logic;
	En:		in	std_logic;
	inpt:	in	std_logic_vector(31 downto 0);
	outpt:	out	std_logic_vector(31 downto 0));
end;

architecture one of Register_File_Register is
begin
	process(clk,reset)begin
		if (reset = '1') then
			outpt <= (others => '0');
		elsif (clk 'event and clk = '1')then
			if(En = '1')then
				outpt <= inpt;
			end if;
		end if;
	end process;
end;

-- SubModule: StackPointer --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity StackPointer is
port(
	reset:in	std_logic;
	clk:in	std_logic;
	pop:in	std_logic;
	push:in	std_logic;
	output:out	std_logic_vector(11 downto 0);
	inpt:in	std_logic_vector(11 downto 0));
end;

architecture one of StackPointer is
	signal	Q:	std_logic_vector(11 downto 0):=x"F00";	-- Note: see Commit
begin
	output <= Q;
	process(reset,clk)begin
		if(reset = '1')then
			Q <= x"F00";	-- Initial Value
		elsif(clk 'event and clk = '1')then
			if(pop = '1' and Q > x"F00")then
				Q <= Q - 1;
			elsif(push = '1' and Q < x"FFF")then
				Q <= Q + 1;
			end if;
		end if;
	end process;
end;

-- SubModule: ID_EX_Pipeline_Register --

library ieee;
use ieee.std_logic_1164.all;

entity ID_EX_Pipeline_Register is
port(
	clk:in	std_logic;
	reset:in	std_logic;
	En:in	std_logic;
	ALU_Op_Code_in:in	std_logic_vector(5 downto 0);
	ALU_src_in:in	std_logic;
	En_Integer_in:in	std_logic;
	En_Float_in:in	std_logic;
	Memory_Read_in:in	std_logic;
	Memory_Write_in:in	std_logic;
	Reg_Write_En_in:in	std_logic;
	WB_Mux_sel_in:in	std_logic;
	CALL_flag_in:in	std_logic;
	RET_flag_in:in	std_logic;
	BR_flag_in:in	std_logic; --
	ALU_Op_Code_out:out	std_logic_vector(5 downto 0);
	ALU_src_out:out	std_logic;
	En_Integer_out:out	std_logic;
	En_Float_out:out	std_logic;
	Memory_Read_out:out	std_logic;
	Memory_Write_out:out	std_logic;
	Reg_Write_En_out:out	std_logic;
	WB_Mux_sel_out:out	std_logic;
	CALL_flag_out:out	std_logic;
	RET_flag_out:out	std_logic;
	BR_flag_out:out	std_logic;
	JMP_flag_in:in	std_logic;--
	JMP_flag_out:out	std_logic;
	Addr_Write_Reg_in:in	std_logic_vector(4 downto 0);
	data1_in:in	std_logic_vector(31 downto 0);
	data2_in:in	std_logic_vector(31 downto 0);
	imm_in:in	std_logic_vector(15 downto 0);--
	Addr_Write_Reg_out:out	std_logic_vector(4 downto 0);
	data1_out:out	std_logic_vector(31 downto 0);
	data2_out:out	std_logic_vector(31 downto 0);
	imm_out:out	std_logic_vector(15 downto 0);
	SP_in:in	std_logic_vector(11 downto 0);
	SP_out:out	std_logic_vector(11 downto 0));
end;

architecture one of ID_EX_Pipeline_Register is
begin
	process(clk,reset)begin
		if(reset = '1')then
			ALU_Op_Code_out<=(others=>'0');
			ALU_src_out<='0';
			En_Integer_out<='0';
			En_Float_out<='0';
			Memory_Read_out<='0';
			Memory_Write_out<='0';
			Reg_Write_En_out<='0';
			WB_Mux_sel_out<='0';
			CALL_flag_out<='0';
			RET_flag_out<='0';
			BR_flag_out<='0';
			JMP_flag_out<='0';
			Addr_Write_Reg_out<=(others=>'0');
			data1_out<=(others=>'0');
			data2_out<=(others=>'0');
			imm_out<=(others=>'0');
			SP_out <= (others=>'0');
		elsif(clk 'event and clk = '1')then
			if(En = '1')then
				ALU_Op_Code_out<=ALU_Op_Code_in;
				ALU_src_out<=ALU_src_in;
				En_Integer_out<=En_Integer_in;
				En_Float_out<=En_Float_in;
				Memory_Read_out<=Memory_Read_in;
				Memory_Write_out<=Memory_Write_in;
				Reg_Write_En_out<=Reg_Write_En_in;
				WB_Mux_sel_out<=WB_Mux_sel_in;
				CALL_flag_out<=CALL_flag_in;
				RET_flag_out<=RET_flag_in;
				BR_flag_out<=BR_flag_in;
				JMP_flag_out<=JMP_flag_in;
				Addr_Write_Reg_out<=Addr_Write_Reg_in;
				data1_out<=data1_in;
				data2_out<=data2_in;
				imm_out<=imm_in;
				SP_out<=SP_in;
			end if;
		end if;
	end process;
end;

-- SubModule: Forward_MUX --

library ieee;
use ieee.std_logic_1164.all;

entity Forward_MUX is
port(
	in0:in	std_logic_vector(31 downto 0);
	in1:in	std_logic_vector(31 downto 0);
	output:out	std_logic_vector(31 downto 0);
	selector:in	std_logic);
end;

architecture one of Forward_MUX is
begin
	output <= in1 when(selector = '1')else in0;
end;
