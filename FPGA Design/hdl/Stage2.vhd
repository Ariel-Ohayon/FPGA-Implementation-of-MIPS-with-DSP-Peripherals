library ieee;
use ieee.std_logic_1164.all;

entity ID_Control_Unit is
port(
	Instruction:	in	std_logic_vector(31 downto 0);
	ALU_Op_Code:	out	std_logic_vector(5 downto 0);
	ALU_src:		out	std_logic;
	En_Integer:		out	std_logic;
	En_Float:		out	std_logic;
	Memory_Read:	out	std_logic;
	Memory_Write:	out	std_logic;
	Register_Read:	out std_logic;
	Register_Write:	out	std_logic;
	WB_MUX:			out	std_logic_vector(1 downto 0));
end;

architecture one of ID_Control_Unit is
begin
	
end;

--

library ieee;
use ieee.std_logic_1164.all;

entity ID_Register_File is
port(
	clk:		in	std_logic;
	reset:		in	std_logic;
	En_Read:	in	std_logic;
	En_Write:	in	std_logic;
	Read_Reg1:	in	std_logic_vector(4  downto 0);
	Read_Reg2:	in	std_logic_vector(4  downto 0);
	Write_Reg:	in	std_logic_vector(4  downto 0);
	data_in:	in	std_logic_vector(31 downto 0);
	data1:		out	std_logic_vector(31 downto 0);
	data2:		out	std_logic_vector(31 downto 0));
end;

architecture one of ID_Register_File is
	
	-- / Components \ --
	component Reg
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		En:		in	std_logic;
		D:		in	std_logic_vector(31 downto 0);
		Q:		out	std_logic_vector(31 downto 0));
	end component;
	
	component Decoder
	generic(input_Bit:	integer := 3);
	port(
		inpt:	in	std_logic_vector(input_Bit-1 downto 0);
		outpt:	out	std_logic_vector((2**input_Bit)-1 downto 0));
	end component;
	
	component Mux_Register
	port(
		Mux_in_0:	in	std_logic_vector(31 downto 0);
		Mux_in_1:	in	std_logic_vector(31 downto 0);
		Mux_in_2:	in	std_logic_vector(31 downto 0);
		Mux_in_3:	in	std_logic_vector(31 downto 0);
		Mux_in_4:	in	std_logic_vector(31 downto 0);
		Mux_in_5:	in	std_logic_vector(31 downto 0);
		Mux_in_6:	in	std_logic_vector(31 downto 0);
		Mux_in_7:	in	std_logic_vector(31 downto 0);
		Mux_in_8:	in	std_logic_vector(31 downto 0);
		Mux_in_9:	in	std_logic_vector(31 downto 0);
		Mux_in_10:	in	std_logic_vector(31 downto 0);
		Mux_in_11:	in	std_logic_vector(31 downto 0);
		Mux_in_12:	in	std_logic_vector(31 downto 0);
		Mux_in_13:	in	std_logic_vector(31 downto 0);
		Mux_in_14:	in	std_logic_vector(31 downto 0);
		Mux_in_15:	in	std_logic_vector(31 downto 0);
		Mux_in_16:	in	std_logic_vector(31 downto 0);
		Mux_in_17:	in	std_logic_vector(31 downto 0);
		Mux_in_18:	in	std_logic_vector(31 downto 0);
		Mux_in_19:	in	std_logic_vector(31 downto 0);
		Mux_in_20:	in	std_logic_vector(31 downto 0);
		Mux_in_21:	in	std_logic_vector(31 downto 0);
		Mux_in_22:	in	std_logic_vector(31 downto 0);
		Mux_in_23:	in	std_logic_vector(31 downto 0);
		Mux_in_24:	in	std_logic_vector(31 downto 0);
		Mux_in_25:	in	std_logic_vector(31 downto 0);
		Mux_in_26:	in	std_logic_vector(31 downto 0);
		Mux_in_27:	in	std_logic_vector(31 downto 0);
		Mux_in_28:	in	std_logic_vector(31 downto 0);
		Mux_in_29:	in	std_logic_vector(31 downto 0);
		Mux_in_30:	in	std_logic_vector(31 downto 0);
		Mux_in_31:	in	std_logic_vector(31 downto 0);
	
		selector:	in	std_logic_vector(4 downto 0);
	
		outpt:		out	std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal Decoder_out:	std_logic_vector(31 downto 0);
	
	signal Mux_in_0:	std_logic_vector(31 downto 0);
	signal Mux_in_1:	std_logic_vector(31 downto 0);
	signal Mux_in_2:	std_logic_vector(31 downto 0);
	signal Mux_in_3:	std_logic_vector(31 downto 0);
	signal Mux_in_4:	std_logic_vector(31 downto 0);
	signal Mux_in_5:	std_logic_vector(31 downto 0);
	signal Mux_in_6:	std_logic_vector(31 downto 0);
	signal Mux_in_7:	std_logic_vector(31 downto 0);
	signal Mux_in_8:	std_logic_vector(31 downto 0);
	signal Mux_in_9:	std_logic_vector(31 downto 0);
	signal Mux_in_10:	std_logic_vector(31 downto 0);
	signal Mux_in_11:	std_logic_vector(31 downto 0);
	signal Mux_in_12:	std_logic_vector(31 downto 0);
	signal Mux_in_13:	std_logic_vector(31 downto 0);
	signal Mux_in_14:	std_logic_vector(31 downto 0);
	signal Mux_in_15:	std_logic_vector(31 downto 0);
	signal Mux_in_16:	std_logic_vector(31 downto 0);
	signal Mux_in_17:	std_logic_vector(31 downto 0);
	signal Mux_in_18:	std_logic_vector(31 downto 0);
	signal Mux_in_19:	std_logic_vector(31 downto 0);
	signal Mux_in_20:	std_logic_vector(31 downto 0);
	signal Mux_in_21:	std_logic_vector(31 downto 0);
	signal Mux_in_22:	std_logic_vector(31 downto 0);
	signal Mux_in_23:	std_logic_vector(31 downto 0);
	signal Mux_in_24:	std_logic_vector(31 downto 0);
	signal Mux_in_25:	std_logic_vector(31 downto 0);
	signal Mux_in_26:	std_logic_vector(31 downto 0);
	signal Mux_in_27:	std_logic_vector(31 downto 0);
	signal Mux_in_28:	std_logic_vector(31 downto 0);
	signal Mux_in_29:	std_logic_vector(31 downto 0);
	signal Mux_in_30:	std_logic_vector(31 downto 0);
	signal Mux_in_31:	std_logic_vector(31 downto 0);
	-- / Signals \ --
	
begin
	R0:	Reg port map(clk, reset, Decoder_out(0), (others => '0') , Mux_in_0);
	
	R1:		Reg port map(clk, reset, Decoder_out(1),  data_in , Mux_in_1);
	R2:		Reg port map(clk, reset, Decoder_out(2),  data_in , Mux_in_2);
	R3:		Reg port map(clk, reset, Decoder_out(3),  data_in , Mux_in_3);
	R4:		Reg port map(clk, reset, Decoder_out(4),  data_in , Mux_in_4);
	R5:		Reg port map(clk, reset, Decoder_out(5),  data_in , Mux_in_5);
	R6:		Reg port map(clk, reset, Decoder_out(6),  data_in , Mux_in_6);
	R7:		Reg port map(clk, reset, Decoder_out(7),  data_in , Mux_in_7);
	R8:		Reg port map(clk, reset, Decoder_out(8),  data_in , Mux_in_8);
	R9:		Reg port map(clk, reset, Decoder_out(9),  data_in , Mux_in_9);
	R10:	Reg port map(clk, reset, Decoder_out(10), data_in , Mux_in_10);
	R11:	Reg port map(clk, reset, Decoder_out(11), data_in , Mux_in_11);
	R12:	Reg port map(clk, reset, Decoder_out(12), data_in , Mux_in_12);
	R13:	Reg port map(clk, reset, Decoder_out(13), data_in , Mux_in_13);
	R14:	Reg port map(clk, reset, Decoder_out(14), data_in , Mux_in_14);
	R15:	Reg port map(clk, reset, Decoder_out(15), data_in , Mux_in_15);
	R16:	Reg port map(clk, reset, Decoder_out(16), data_in , Mux_in_16);
	R17:	Reg port map(clk, reset, Decoder_out(17), data_in , Mux_in_17);
	R18:	Reg port map(clk, reset, Decoder_out(18), data_in , Mux_in_18);
	R19:	Reg port map(clk, reset, Decoder_out(19), data_in , Mux_in_19);
	R20:	Reg port map(clk, reset, Decoder_out(20), data_in , Mux_in_20);
	R21:	Reg port map(clk, reset, Decoder_out(21), data_in , Mux_in_21);
	R22:	Reg port map(clk, reset, Decoder_out(22), data_in , Mux_in_22);
	R23:	Reg port map(clk, reset, Decoder_out(23), data_in , Mux_in_23);
	R24:	Reg port map(clk, reset, Decoder_out(24), data_in , Mux_in_24);
	R25:	Reg port map(clk, reset, Decoder_out(25), data_in , Mux_in_25);
	R26:	Reg port map(clk, reset, Decoder_out(26), data_in , Mux_in_26);
	R27:	Reg port map(clk, reset, Decoder_out(27), data_in , Mux_in_27);
	R28:	Reg port map(clk, reset, Decoder_out(28), data_in , Mux_in_28);
	R29:	Reg port map(clk, reset, Decoder_out(29), data_in , Mux_in_29);
	R30:	Reg port map(clk, reset, Decoder_out(30), data_in , Mux_in_30);
	R31:	Reg port map(clk, reset, Decoder_out(31), data_in , Mux_in_31);
	
	U1: Decoder generic map(5) port map(Write_Reg, Decoder_out);
	
	U2:	Mux_Register	port map(
		Mux_in_0,	Mux_in_1,	Mux_in_2,	Mux_in_3,
		Mux_in_4,	Mux_in_5,	Mux_in_6,	Mux_in_7,
		Mux_in_8,	Mux_in_9,	Mux_in_10,	Mux_in_11,
		Mux_in_12,	Mux_in_13,	Mux_in_14,	Mux_in_15,
		Mux_in_16,	Mux_in_17,	Mux_in_18,	Mux_in_19,
		Mux_in_20,	Mux_in_21,	Mux_in_22,	Mux_in_23,
		Mux_in_24,	Mux_in_25,	Mux_in_26,	Mux_in_27,
		Mux_in_28,	Mux_in_29,	Mux_in_30,	Mux_in_31,
		
		Read_Reg1,
		
		data1);
	
	U3:	Mux_Register	port map(
		Mux_in_0,	Mux_in_1,	Mux_in_2,	Mux_in_3,
		Mux_in_4,	Mux_in_5,	Mux_in_6,	Mux_in_7,
		Mux_in_8,	Mux_in_9,	Mux_in_10,	Mux_in_11,
		Mux_in_12,	Mux_in_13,	Mux_in_14,	Mux_in_15,
		Mux_in_16,	Mux_in_17,	Mux_in_18,	Mux_in_19,
		Mux_in_20,	Mux_in_21,	Mux_in_22,	Mux_in_23,
		Mux_in_24,	Mux_in_25,	Mux_in_26,	Mux_in_27,
		Mux_in_28,	Mux_in_29,	Mux_in_30,	Mux_in_31,
		
		Read_Reg2,
		
		data2);
	
end;

--

library ieee;
use ieee.std_logic_1164.all;

entity Mux_Register is
port(
	Mux_in_0:	in	std_logic_vector(31 downto 0);
	Mux_in_1:	in	std_logic_vector(31 downto 0);
	Mux_in_2:	in	std_logic_vector(31 downto 0);
	Mux_in_3:	in	std_logic_vector(31 downto 0);
	Mux_in_4:	in	std_logic_vector(31 downto 0);
	Mux_in_5:	in	std_logic_vector(31 downto 0);
	Mux_in_6:	in	std_logic_vector(31 downto 0);
	Mux_in_7:	in	std_logic_vector(31 downto 0);
	Mux_in_8:	in	std_logic_vector(31 downto 0);
	Mux_in_9:	in	std_logic_vector(31 downto 0);
	Mux_in_10:	in	std_logic_vector(31 downto 0);
	Mux_in_11:	in	std_logic_vector(31 downto 0);
	Mux_in_12:	in	std_logic_vector(31 downto 0);
	Mux_in_13:	in	std_logic_vector(31 downto 0);
	Mux_in_14:	in	std_logic_vector(31 downto 0);
	Mux_in_15:	in	std_logic_vector(31 downto 0);
	Mux_in_16:	in	std_logic_vector(31 downto 0);
	Mux_in_17:	in	std_logic_vector(31 downto 0);
	Mux_in_18:	in	std_logic_vector(31 downto 0);
	Mux_in_19:	in	std_logic_vector(31 downto 0);
	Mux_in_20:	in	std_logic_vector(31 downto 0);
	Mux_in_21:	in	std_logic_vector(31 downto 0);
	Mux_in_22:	in	std_logic_vector(31 downto 0);
	Mux_in_23:	in	std_logic_vector(31 downto 0);
	Mux_in_24:	in	std_logic_vector(31 downto 0);
	Mux_in_25:	in	std_logic_vector(31 downto 0);
	Mux_in_26:	in	std_logic_vector(31 downto 0);
	Mux_in_27:	in	std_logic_vector(31 downto 0);
	Mux_in_28:	in	std_logic_vector(31 downto 0);
	Mux_in_29:	in	std_logic_vector(31 downto 0);
	Mux_in_30:	in	std_logic_vector(31 downto 0);
	Mux_in_31:	in	std_logic_vector(31 downto 0);
	
	selector:	in	std_logic_vector(4 downto 0);
	
	outpt:		out	std_logic_vector(31 downto 0));
end;

architecture one of Mux_Register is
begin
	with selector select outpt <= 
		Mux_in_0  when "00000",	-- 0
		Mux_in_1  when "00001",	-- 1
		Mux_in_2  when "00010",	-- 2
		Mux_in_3  when "00011",	-- 3
		Mux_in_4  when "00100",	-- 4
		Mux_in_5  when "00101",	-- 5
		Mux_in_6  when "00110",	-- 6
		Mux_in_7  when "00111",	-- 7
		Mux_in_8  when "01000",	-- 8
		Mux_in_9  when "01001",	-- 9
		Mux_in_10 when "01010",	-- 10
		Mux_in_11 when "01011",	-- 11
		Mux_in_12 when "01100",	-- 12
		Mux_in_13 when "01101",	-- 13
		Mux_in_14 when "01110",	-- 14
		Mux_in_15 when "01111",	-- 15
		Mux_in_16 when "10000",	-- 16
		Mux_in_17 when "10001",	-- 17
		Mux_in_18 when "10010",	-- 18
		Mux_in_19 when "10011",	-- 19
		Mux_in_20 when "10100",	-- 20
		Mux_in_21 when "10101",	-- 21
		Mux_in_22 when "10110",	-- 22
		Mux_in_23 when "10111",	-- 23
		Mux_in_24 when "11000",	-- 24
		Mux_in_25 when "11001",	-- 25
		Mux_in_26 when "11010",	-- 26
		Mux_in_27 when "11011",	-- 27
		Mux_in_28 when "11100",	-- 28
		Mux_in_29 when "11101",	-- 29
		Mux_in_30 when "11110",	-- 30
		Mux_in_31 when "11111";	-- 31
end;

--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Decoder is
generic(input_Bit:	integer := 3);
port(
	inpt:	in	std_logic_vector(input_Bit-1 downto 0);
	outpt:	out	std_logic_vector((2**input_Bit)-1 downto 0));
end;

architecture one of Decoder is
begin
	process(inpt)begin
		outpt	<= (others => '0');
		outpt(conv_integer(unsigned(inpt))) <= '1';
	end process;
end;

--

library ieee;
use ieee.std_logic_1164.all;

entity Reg is
port(
	clk:	in	std_logic;
	reset:	in	std_logic;
	En:		in	std_logic;
	D:		in	std_logic_vector(31 downto 0);
	Q:		out	std_logic_vector(31 downto 0));
end;

architecture one of Reg is
	signal  sQ:	std_Logic_vector(31 downto 0);
begin
	Q <= sQ;
	process(reset,clk)begin
		if (reset = '1')then
			sQ <= (others => '0');
		elsif(clk 'event and clk = '1')then
			if (En = '1')then
				sQ <= D;
			end if;
		end if;
	end process;
end;

--

library ieee;
use ieee.std_logic_1164.all;

entity ID_EX_Pipeline_Register is
port(

	-- Inputs:
	clk:						in	std_logic;
	En:							in	std_logic;
	reset:						in	std_logic;
	Register_Write_addr_in:		in	std_logic_vector(4  downto 0);
	data1_in:					in	std_logic_vector(31 downto 0);
	data2_in:					in	std_logic_vector(31 downto 0);
	imm_in:						in	std_Logic_vector(15 downto 0);
	next_addr_in:				in	std_logic_vector(31 downto 0);
	
	-- Input Control Signals:
	ALU_Op_Code_in:				in	std_logic_vector(5 downto 0);
	ALU_src_in:					in	std_logic;
	En_Integer_in:				in	std_logic;
	En_Float_in:				in	std_logic;
	Memory_Read_in:				in	std_logic;
	Memory_Write_in:			in	std_logic;
	Write_Register_in:			in	std_logic;
	WB_MUX_in:					in	std_logic_vector(1 downto 0);
	
	-- Outputs:
	Register_Write_addr_out:	out	std_logic_vector(4  downto 0);
	data1_out:					out	std_logic_vector(31 downto 0);
	data2_out:					out	std_logic_vector(31 downto 0);
	imm_out:					out	std_logic_vector(15 downto 0);
	next_addr_out:				out	std_logic_vector(31 downto 0);
	
	-- Output Control Signals:
	ALU_Op_Code_out:			out	std_logic_vector(5  downto 0);
	ALU_src_out:				out	std_logic;
	En_Integer_out:				out	std_logic;
	En_Float_out:				out	std_logic;
	Memory_Read_out:			out	std_logic;
	Memory_Write_out:			out	std_logic;
	Write_Register_out:			out	std_logic;
	WB_MUX_out:					out	std_logic_vector(1 downto 0));
end;

architecture one of ID_EX_Pipeline_Register is
begin
	process(reset,clk)begin
		if (reset = '1') then
			Register_Write_addr_out	<=	(others => '0');
			data1_out				<=	(others => '0');
			data2_out				<=	(others => '0');
			imm_out					<=	(others => '0');
			next_addr_out			<=	(others => '0');
			ALU_Op_Code_out			<=	(others => '0');
			ALU_src_out				<=	'0';
			En_Integer_out			<=	'0';
			En_Float_out			<=	'0';
			Memory_Read_out			<=	'0';
			Memory_Write_out		<=	'0';
			Write_Register_out		<=	'0';
			WB_MUX_out				<=	(others => '0');
			
		elsif (clk 'event and clk = '1')then
			if (En = '1')then
				Register_Write_addr_out	<=	Register_Write_addr_in;
				data1_out				<=	data1_in;
				data2_out				<=	data2_in;
				imm_out					<=	imm_in;
				next_addr_out			<=	next_addr_in;
				ALU_Op_Code_out			<=	ALU_Op_Code_in;
				ALU_src_out				<=	ALU_src_in;
				En_Integer_out			<=	En_Integer_in;
				En_Float_out			<=	En_Float_in;
				Memory_Read_out			<=	Memory_Read_in;
				Memory_Write_out		<=	Memory_Write_in;
				Write_Register_out		<=	Write_Register_in;
				WB_MUX_out				<=	WB_MUX_in;
			end if;
		end if;
	end process;
end;

--

library ieee;
use ieee.std_logic_1164.all;

entity Stage2 is
port(
	clk:							in	std_logic;
	reset:							in	std_logic;
	
	-- Interface with the Prev Stage:
	Inst_in_stage1:					in	std_logic_vector(31 downto 0);
	next_addr_in_stage1:			in	std_logic_vector(31 downto 0);
	
	-- Interface with the next Stage:
	En_Write_stage5:				in	std_logic;
	Write_Reg_stage5:				in	std_logic_vector(4  downto 0);
	data_in_stage5:					in	std_logic_vector(31 downto 0);
	
	Register_Write_addr_out_stage3:	out	std_logic_vector(4  downto 0);
	data1_out_stage3:				out	std_logic_vector(31 downto 0);
	data2_out_stage3:				out	std_logic_vector(31 downto 0);
	imm_out_stage3:					out	std_logic_vector(15 downto 0);
	next_addr_out_stage3:			out	std_logic_vector(31 downto 0);
	
	-- Control signals goes to the next stage:
	ALU_Op_Code_out_stage3:			out	std_logic_vector(5 downto 0);
	ALU_src_out_stage3:				out	std_logic;
	En_Integer_out_stage3:			out	std_logic;
	En_Float_out_stage3:			out	std_logic;
	Memory_Read_out_stage3:			out	std_logic;
	Memory_Write_out_stage3:		out	std_logic;
	Write_Register_out_stage3:		out	std_logic;
	WB_MUX_out_stage3:				out	std_logic_vector(1 downto 0));
end;

architecture one of Stage2 is
	
	-- / Components \ --
	component ID_Control_Unit
	port(
		Instruction:	in	std_logic_vector(31 downto 0);
		ALU_Op_Code:	out	std_logic_vector(5 downto 0);
		ALU_src:		out	std_logic;
		En_Integer:		out	std_logic;
		En_Float:		out	std_logic;
		Memory_Read:	out	std_logic;
		Memory_Write:	out	std_logic;
		Register_Read:	out std_logic;
		Register_Write:	out	std_logic;
		WB_MUX:			out	std_logic_vector(1 downto 0));
	end component;
	
	component ID_Register_File
	port(
		clk:		in	std_logic;
		reset:		in	std_logic;
		En_Read:	in	std_logic;
		En_Write:	in	std_logic;
		Read_Reg1:	in	std_logic_vector(4  downto 0);
		Read_Reg2:	in	std_logic_vector(4  downto 0);
		Write_Reg:	in	std_logic_vector(4  downto 0);
		data_in:	in	std_logic_vector(31 downto 0);
		data1:		out	std_logic_vector(31 downto 0);
		data2:		out	std_logic_vector(31 downto 0));
	end component;
	
	component ID_EX_Pipeline_Register
	port(

		-- Inputs:
		clk:						in	std_logic;
		En:							in	std_logic;
		reset:						in	std_logic;
		Register_Write_addr_in:		in	std_logic_vector(4  downto 0);
		data1_in:					in	std_logic_vector(31 downto 0);
		data2_in:					in	std_logic_vector(31 downto 0);
		imm_in:						in	std_Logic_vector(15 downto 0);
		next_addr_in:				in	std_logic_vector(31 downto 0);
	
		-- Input Control Signals:
		ALU_Op_Code_in:				in	std_logic_vector(5 downto 0);
		ALU_src_in:					in	std_logic;
		En_Integer_in:				in	std_logic;
		En_Float_in:				in	std_logic;
		Memory_Read_in:				in	std_logic;
		Memory_Write_in:			in	std_logic;
		Write_Register_in:			in	std_logic;
		WB_MUX_in:					in	std_logic_vector(1 downto 0);
	
		-- Outputs:
		Register_Write_addr_out:	out	std_logic_vector(4  downto 0);
		data1_out:					out	std_logic_vector(31 downto 0);
		data2_out:					out	std_logic_vector(31 downto 0);
		imm_out:					out	std_logic_vector(15 downto 0);
		next_addr_out:				out	std_logic_vector(31 downto 0);
	
		-- Output Control Signals:
		ALU_Op_Code_out:			out	std_logic_vector(5  downto 0);
		ALU_src_out:				out	std_logic;
		En_Integer_out:				out	std_logic;
		En_Float_out:				out	std_logic;
		Memory_Read_out:			out	std_logic;
		Memory_Write_out:			out	std_logic;
		Write_Register_out:			out	std_logic;
		WB_MUX_out:					out	std_logic_vector(1 downto 0));
	end component;
	-- / Components \ --

	 -- / Signals \ --
	 signal Instruction:		std_logic_vector(31 downto 0);
	 signal ID_next_addr:		std_logic_vector(31 downto 0);
	 signal ID_ALU_Op_Code:		std_logic_vector(5  downto 0);
	 signal ID_ALU_src:			std_logic;
	 signal ID_En_Integer:		std_logic;
	 signal ID_En_Float:		std_logic;
	 signal ID_Memory_Read:		std_logic;
	 signal ID_Memory_Write:	std_logic;
	 signal ID_Register_Read:	std_logic;
	 signal ID_Register_Write:	std_logic;
	 signal ID_WB_MUX:			std_logic_vector(1  downto 0);
	 signal ID_data1:			std_logic_vector(31 downto 0);
	 signal ID_data2:			std_logic_vector(31 downto 0);
	 -- / Signals \ --

begin
	
	Instruction  <= Inst_in_stage1;
	ID_next_addr <= next_addr_in_stage1;
	
	U1:	ID_Control_Unit port map(
		Instruction		=>	Instruction,
		
		ALU_Op_Code		=>	ID_ALU_Op_Code,
		ALU_src			=>	ID_ALU_src,
		En_Integer		=>	ID_En_Integer,
		En_Float		=>	ID_En_Float,
		Memory_Read		=>	ID_Memory_Read,
		Memory_Write	=>	ID_Memory_Write,
		Register_Read	=>	ID_Register_Read,
		Register_Write	=>	ID_Register_Write,
		WB_MUX			=>	ID_WB_MUX);
		
	U2:	ID_Register_File port map(
		clk			=>	(not clk),
		reset		=>	reset,
		En_Read		=>	ID_Register_Read,
		En_Write	=>	En_Write_stage5,
		Read_Reg1	=>	Instruction(25 downto 21),
		Read_Reg2	=>	Instruction(20 downto 16),
		Write_Reg	=>	Write_Reg_stage5,
		data_in		=>	data_in_stage5,
		data1		=>	ID_data1,
		data2		=>	ID_data2);
	
	U3:	ID_EX_Pipeline_Register port map(
		clk						=>	clk,
		En						=>	'1',
		reset					=>	reset,
		Register_Write_addr_in	=>	Instruction(15 downto 11),
		data1_in				=>	ID_data1,
		data2_in				=>	ID_data2,
		imm_in					=>	Instruction(15 downto 0),
		next_addr_in			=>	ID_next_addr,
		ALU_Op_Code_in			=>	ID_ALU_Op_Code,
		ALU_src_in				=>	ID_ALU_src,
		En_Integer_in			=>	ID_En_Integer,
		En_Float_in				=>	ID_En_Float,
		Memory_Read_in			=>	ID_Memory_Read,
		Memory_Write_in			=>	ID_Memory_Write,
		Write_Register_in		=>	ID_Register_Write,
		WB_MUX_in				=>	ID_WB_MUX,
		
		Register_Write_addr_out	=>	Register_Write_addr_out_stage3,
		data1_out				=>	data1_out_stage3,
		data2_out				=>	data2_out_stage3,
		imm_out					=>	imm_out_stage3,
		next_addr_out			=>	next_addr_out_stage3,
		ALU_Op_Code_out			=>	ALU_Op_Code_out_stage3,
		ALU_src_out				=>	ALU_src_out_stage3,
		En_Integer_out			=>	En_Integer_out_stage3,
		En_Float_out			=>	En_Float_out_stage3,
		Memory_Read_out			=>	Memory_Read_out_stage3,
		Memory_Write_out		=>	Memory_Write_out_stage3,
		Write_Register_out		=>	Write_Register_out_stage3,
		WB_MUX_out				=>	WB_MUX_out_stage3);
end;