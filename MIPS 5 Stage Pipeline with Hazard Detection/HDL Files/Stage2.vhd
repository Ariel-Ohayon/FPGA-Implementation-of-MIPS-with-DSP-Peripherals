library ieee;
use ieee.std_logic_1164.all;

entity Stage2 is
port(
	reset:						in	std_logic;
	clk:						in	std_logic;
	En_Pipeline:				in	std_logic;
	instruction:				in	std_logic_vector(31 downto 0);
	STG25_data_in:				in	std_logic_vector(31 downto 0);
	STG25_addr_Write_Reg:		in	std_logic_vector(4  downto 0);
	STG25_En_Write_Reg:			in	std_logic;
	next_PC:					in	std_logic_vector(7  downto 0);
	ALU_operand1:				out	std_logic_vector(31 downto 0);
	ALU_operand2:				out	std_logic_vector(31 downto 0);
	opcode:						out	std_logic_vector(5  downto 0);
	En_ALU:						out	std_logic;
	En_FPU:						out	std_logic;
	Addr_Write_Reg:				out	std_logic_vector(4  downto 0);
	En_Write_Reg:				out	std_logic;
	JMP_BR_flag:				out	std_Logic;
	Mem_Read:					out	std_logic;
	Mem_Write:					out	std_logic;
	Data_Mem_Write_Data:		out	std_logic_vector(31 downto 0);
	BR_JMP_Addr:				out	std_logic_vector(7  downto 0);
	BR_JMP_flag_no_Pipeline:	out	std_logic;
	Hazard_Read_Addr1:			out	std_Logic_vector(4 downto 0);
	Hazard_Read_Addr2:			out	std_Logic_vector(4 downto 0));
end;

architecture one of Stage2 is
	-- / Components \ --
	component Control_Unit
	port(
		instruction:	in	std_logic_vector(31 downto 0);
		Addr_Read_Reg1:	out	std_logic_vector(4  downto 0);
		Addr_Read_Reg2:	out	std_logic_vector(4  downto 0);
		Addr_Write_Reg:	out	std_logic_vector(4  downto 0);
		En_Read_Reg:	out	std_logic;
		En_Write_Reg:	out	std_logic;
		ALU_Op_Code:	out	std_logic_vector(5  downto 0);
		ALU_src:		out	std_logic;
		En_ALU:			out	std_logic;
		En_FPU:			out	std_logic;
		JMP_BR_flag:	out	std_logic;
		Mem_Read:		out	std_logic;
		Mem_Write:		out	std_logic;
		BR_JMP_Addr:	out	std_logic_vector(7 downto 0);
		Call_flag:		out	std_logic;
		Ret_flag:		out	std_logic);
	end component;
	
	component Register_File
	port(
		reset:			in	std_logic;
		clk:			in	std_logic;
		En_Read:		in	std_logic;
		En_Write:		in	std_logic;
		Addr_Read_Reg1:	in	std_logic_vector(4  downto 0);
		Addr_Read_Reg2:	in	std_logic_vector(4  downto 0);
		Addr_Write_Reg:	in	std_logic_vector(4  downto 0);
		data1:			out	std_logic_vector(31 downto 0);
		data2:			out	std_logic_vector(31 downto 0);
		datain:			in	std_logic_vector(31 downto 0));
	end component;
	
	component Stack_Memory
	port(
		reset:	in	std_logic;
		clk:	in	std_logic;
		push:	in	std_logic;
		pop:	in	std_logic;
		input:	in	std_Logic_vector(7 downto 0);
		outpt:	out	std_logic_vector(7 downto 0));
	end component;
	
	component ID_EX
	port(
		reset:						in	std_logic;
		clk:						in	std_logic;
		En:							in	std_logic;
		in_data1:					in	std_logic_vector(31 downto 0);
		in_data2:					in	std_logic_vector(31 downto 0);
		in_En_ALU:					in	std_logic;
		in_En_FPU:					in	std_logic;
		in_Addr_Write_Reg:			in	std_logic_vector(4  downto 0);
		in_En_Write_Reg:			in	std_logic;
		in_ALU_Op_Code:				in	std_logic_vector(5  downto 0);
		in_JMP_BR_flag:				in	std_logic;
		in_Mem_Read:				in	std_logic;
		in_Mem_Write:				in	std_logic;
		in_Data_Mem_Write_Data:		in	std_logic_vector(31 downto 0);
		in_BR_JMP_Addr:				in	std_Logic_vector(7 downto 0);
		in_Hazard_Read_Reg1:		in	std_logic_vector(4 downto 0);
		in_Hazard_Read_Reg2:		in	std_logic_vector(4 downto 0);
		out_data1:					out	std_logic_vector(31 downto 0);
		out_data2:					out	std_logic_vector(31 downto 0);
		out_En_ALU:					out	std_logic;
		out_En_FPU:					out	std_logic;
		out_Addr_Write_Reg:			out	std_logic_vector(4  downto 0);
		out_En_Write_Reg:			out	std_logic;
		out_ALU_Op_Code:			out	std_logic_vector(5  downto 0);
		out_JMP_BR_flag:			out	std_logic;
		out_Mem_Read:				out	std_logic;
		out_Mem_Write:				out	std_logic;
		out_Data_Mem_Write_Data:	out	std_logic_vector(31 downto 0);
		out_BR_JMP_Addr:			out	std_Logic_vector(7 downto 0);
		out_Hazard_Read_Reg1:		out	std_logic_vector(4 downto 0);
		out_Hazard_Read_Reg2:		out	std_logic_vector(4 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal Addr_Read_Reg1:				std_logic_vector(4  downto 0);
	signal Addr_Read_Reg2:				std_logic_vector(4  downto 0);
	signal pipeline_Addr_Write_Reg:		std_logic_vector(4  downto 0);
	signal pipeline_En_Write_Reg:		std_logic;
	signal pipeline_ALU_Op_Code:		std_logic_vector(5  downto 0);
	signal pipeline_JMP_BR_flag:		std_logic;
	signal pipeline_Mem_Read:			std_logic;
	signal pipeline_Mem_Write:			std_logic;
	signal En_Read_Reg:					std_logic;
	signal ALU_src:						std_logic;
	signal Reg1_data:					std_logic_vector(31 downto 0);
	signal Reg2_data:					std_logic_vector(31 downto 0);
	signal pipeline_in_data2:			std_logic_vector(31 downto 0);
	signal zero_16bit:					std_logic_vector(15 downto 0);
	signal pipeline_BR_JMP_Addr:		std_logic_vector(7  downto 0);
	signal BR_JMP_Addr_Control_Unit:	std_logic_vector(7  downto 0);
	signal pipeline_En_ALU:	std_logic;
	signal pipeline_En_FPU:	std_logic;
	
	signal push:			std_logic;
	signal pop:				std_logic;
	signal Stack_Mem_out:	std_logic_vector(7 downto 0);
	signal Stack_flag:		std_logic;
	-- / Signals \ --
	
begin
	U1:	Control_Unit port map(
		instruction		=>	instruction,
		Addr_Read_Reg1	=>	Addr_Read_Reg1,
		Addr_Read_Reg2	=>	Addr_Read_Reg2,
		Addr_Write_Reg	=>	pipeline_Addr_Write_Reg,
		En_Read_Reg		=>	En_Read_Reg,
		En_Write_Reg	=>	pipeline_En_Write_Reg,
		ALU_Op_Code		=>	pipeline_ALU_Op_Code,
		ALU_src			=>	ALU_src,
		En_ALU			=>	pipeline_En_ALU,
		En_FPU			=>	pipeline_En_FPU,
		JMP_BR_flag		=>	pipeline_JMP_BR_flag,
		Mem_Read		=>	pipeline_Mem_Read,
		Mem_Write		=>	pipeline_Mem_Write,
		BR_JMP_Addr		=>	BR_JMP_Addr_Control_Unit,
		Call_flag		=>	push,
		Ret_flag		=>	pop);
		
	U2:	Register_File port map(
		reset			=>	reset,
		clk				=>	clk,
		En_Read			=>	En_Read_Reg,
		En_Write		=>	STG25_En_Write_Reg,
		Addr_Read_Reg1	=>	Addr_Read_Reg1,
		Addr_Read_Reg2	=>	Addr_Read_Reg2,
		Addr_Write_Reg	=>	STG25_addr_Write_Reg,
		data1			=>	Reg1_data,
		data2			=>	Reg2_data,
		datain			=>	STG25_data_in);
	
	U3: Stack_Memory port map(
		reset	=>	reset,
		clk		=>	clk,
		push	=>	push,
		pop		=>	pop,
		input	=>	next_PC,
		outpt	=>	Stack_Mem_out);
	
	Stack_flag <= pop;
	pipeline_BR_JMP_Addr <= Stack_Mem_out when(Stack_flag = '1')else BR_JMP_Addr_Control_Unit;
	
	U4:	ID_EX port map(
		reset					=>	reset,
		clk						=>	clk,
		En						=>	En_Pipeline,
		in_data1				=>	Reg1_data,
		in_data2				=>	pipeline_in_data2,
		in_En_ALU				=>	pipeline_En_ALU,
		in_En_FPU				=>	pipeline_En_FPU,
		in_Addr_Write_Reg		=>	pipeline_Addr_Write_Reg,
		in_En_Write_Reg			=>	pipeline_En_Write_Reg,
		in_ALU_Op_Code			=>	pipeline_ALU_Op_Code,
		in_JMP_BR_flag			=>	pipeline_JMP_BR_flag,
		in_Mem_Read				=>	pipeline_Mem_Read,
		in_Mem_Write			=>	pipeline_Mem_Write,
		in_Data_Mem_Write_Data	=>	Reg2_data,
		in_BR_JMP_Addr			=>	pipeline_BR_JMP_Addr,
		in_Hazard_Read_Reg1		=>	Addr_Read_Reg1,
		in_Hazard_Read_Reg2		=>	Addr_Read_Reg2,
		out_data1				=>	ALU_operand1,
		out_data2				=>	ALU_operand2,
		out_En_ALU				=>	En_ALU,
		out_En_FPU				=>	En_FPU,
		out_Addr_Write_Reg		=>	Addr_Write_Reg,
		out_En_Write_Reg		=>	En_Write_Reg,
		out_ALU_Op_Code			=>	opcode,
		out_JMP_BR_flag			=>	JMP_BR_flag,
		out_Mem_Read			=>	Mem_Read,
		out_Mem_Write			=>	Mem_Write,
		out_Data_Mem_Write_Data	=>	Data_Mem_Write_Data,
		out_BR_JMP_Addr			=>	BR_JMP_Addr,
		out_Hazard_Read_Reg1	=>	Hazard_Read_Addr1,
		out_Hazard_Read_Reg2	=>	Hazard_Read_Addr2);
		
		
	pipeline_in_data2 <= Reg2_data when(ALU_src  = '1')else zero_16bit & instruction(15 downto 0);
	zero_16bit <= (others => '0');
	
	BR_JMP_flag_no_Pipeline <= pipeline_JMP_BR_flag;
	
end;

-- SubModule: Register_File

library ieee;
use ieee.std_logic_1164.all;

entity Register_File is
port(
	reset:			in	std_logic;
	clk:			in	std_logic;
	En_Read:		in	std_logic;
	En_Write:		in	std_logic;
	Addr_Read_Reg1:	in	std_logic_vector(4  downto 0);
	Addr_Read_Reg2:	in	std_logic_vector(4  downto 0);
	Addr_Write_Reg:	in	std_logic_vector(4  downto 0);
	data1:			out	std_logic_vector(31 downto 0);
	data2:			out	std_logic_vector(31 downto 0);
	datain:			in	std_logic_vector(31 downto 0));
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
	
	signal Reg_En:		std_logic_vector(31 downto 0);
	-- / Signals \ --

begin
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
	
	Gen:for i in 0 to 31 Generate
		Reg_En(i) <= En_Write and En_Reg(i);
	end Generate;
	
	Reg0:	Register_File_Register port map(clk,reset,Reg_En(0),(others => '0'),Mux_in0);
	Reg1:	Register_File_Register port map(clk,reset,Reg_En(1),datain,Mux_in1);
	Reg2:	Register_File_Register port map(clk,reset,Reg_En(2),datain,Mux_in2);
	Reg3:	Register_File_Register port map(clk,reset,Reg_En(3),datain,Mux_in3);
	Reg4:	Register_File_Register port map(clk,reset,Reg_En(4),datain,Mux_in4);
	Reg5:	Register_File_Register port map(clk,reset,Reg_En(5),datain,Mux_in5);
	Reg6:	Register_File_Register port map(clk,reset,Reg_En(6),datain,Mux_in6);
	Reg7:	Register_File_Register port map(clk,reset,Reg_En(7),datain,Mux_in7);
	Reg8:	Register_File_Register port map(clk,reset,Reg_En(8),datain,Mux_in8);
	Reg9:	Register_File_Register port map(clk,reset,Reg_En(9),datain,Mux_in9);
	Reg10:	Register_File_Register port map(clk,reset,Reg_En(10),datain,Mux_in10);
	Reg11:	Register_File_Register port map(clk,reset,Reg_En(11),datain,Mux_in11);
	Reg12:	Register_File_Register port map(clk,reset,Reg_En(12),datain,Mux_in12);
	Reg13:	Register_File_Register port map(clk,reset,Reg_En(13),datain,Mux_in13);
	Reg14:	Register_File_Register port map(clk,reset,Reg_En(14),datain,Mux_in14);
	Reg15:	Register_File_Register port map(clk,reset,Reg_En(15),datain,Mux_in15);
	Reg16:	Register_File_Register port map(clk,reset,Reg_En(16),datain,Mux_in16);
	Reg17:	Register_File_Register port map(clk,reset,Reg_En(17),datain,Mux_in17);
	Reg18:	Register_File_Register port map(clk,reset,Reg_En(18),datain,Mux_in18);
	Reg19:	Register_File_Register port map(clk,reset,Reg_En(19),datain,Mux_in19);
	Reg20:	Register_File_Register port map(clk,reset,Reg_En(20),datain,Mux_in20);
	Reg21:	Register_File_Register port map(clk,reset,Reg_En(21),datain,Mux_in21);
	Reg22:	Register_File_Register port map(clk,reset,Reg_En(22),datain,Mux_in22);
	Reg23:	Register_File_Register port map(clk,reset,Reg_En(23),datain,Mux_in23);
	Reg24:	Register_File_Register port map(clk,reset,Reg_En(24),datain,Mux_in24);
	Reg25:	Register_File_Register port map(clk,reset,Reg_En(25),datain,Mux_in25);
	Reg26:	Register_File_Register port map(clk,reset,Reg_En(26),datain,Mux_in26);
	Reg27:	Register_File_Register port map(clk,reset,Reg_En(27),datain,Mux_in27);
	Reg28:	Register_File_Register port map(clk,reset,Reg_En(28),datain,Mux_in28);
	Reg29:	Register_File_Register port map(clk,reset,Reg_En(29),datain,Mux_in29);
	Reg30:	Register_File_Register port map(clk,reset,Reg_En(30),datain,Mux_in30);
	Reg31:	Register_File_Register port map(clk,reset,Reg_En(31),datain,Mux_in31);
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
	Reg31	when	others;	-- 31
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
		elsif (clk 'event and clk = '0')then
			if(En = '1')then
				outpt <= inpt;
			end if;
		end if;
	end process;
end;

-- SubModule: Control_Unit

library ieee;
use ieee.std_logic_1164.all;

entity Control_Unit is
port(
	instruction:	in	std_logic_vector(31 downto 0);
	Addr_Read_Reg1:	out	std_logic_vector(4  downto 0);
	Addr_Read_Reg2:	out	std_logic_vector(4  downto 0);
	Addr_Write_Reg:	out	std_logic_vector(4  downto 0);
	En_Read_Reg:	out	std_logic;
	En_Write_Reg:	out	std_logic;
	ALU_Op_Code:	out	std_logic_vector(5  downto 0);
	ALU_src:		out	std_logic;
	En_ALU:			out	std_logic;
	En_FPU:			out	std_logic;
	JMP_BR_flag:	out	std_logic;
	Mem_Read:		out	std_logic;
	Mem_Write:		out	std_logic;
	BR_JMP_Addr:	out	std_Logic_vector(7 downto 0);
	Call_flag:		out	std_logic;
	Ret_flag:		out	std_logic);
end;

architecture one of Control_Unit is
	-- / Components\ --
	component Control_Unit_Decoder
	port(
		input:	in	std_Logic_vector(5 downto 0);
		output:	out	std_Logic_vector(63 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal opcode:				std_logic_vector(5  downto 0);
	signal instruction_opcode:	std_logic_vector(5  downto 0);
	signal operation_opcode:	std_logic_vector(5  downto 0);
	signal R_Type:				std_logic;
	signal decode_opcode:		std_logic_vector(63 downto 0);
	signal ALU_src2:			std_logic;
	signal BR_JMP_indicator:	std_logic;
	signal sEn_FPU:			std_logic;
	-- / Signals \ --
	
begin

	instruction_opcode	<= instruction(31 downto 26);
	
	operation_opcode	<= instruction_opcode when(R_Type = '0')else instruction(5 downto 0);
	
	U:	Control_Unit_Decoder port map(
		input	=>	operation_opcode,
		output	=>	decode_opcode);
	
	En_ALU <= not sEn_FPU;
	En_FPU <= sEn_FPU;
	sEn_FPU <= R_Type and (decode_opcode(0) or decode_opcode(1) or decode_opcode(2) or decode_opcode(3));
	
	R_Type <= not (instruction_opcode(0) or instruction_opcode(1) or instruction_opcode(2) or
				   instruction_opcode(3) or instruction_opcode(4) or instruction_opcode(5));
	
	ALU_Op_Code <= operation_opcode;
	ALU_src  <= R_Type or decode_opcode(12) or decode_opcode(13) or decode_opcode(14) or decode_opcode(15);
	ALU_src2 <= decode_opcode(12) or decode_opcode(13) or decode_opcode(14) or decode_opcode(15);
	
	Addr_Read_Reg1 <= instruction(20 downto 16); -- rs
	
	Addr_Read_Reg2 <= instruction(15 downto 11)when(R_Type = '1')else
					  instruction(25 downto 21)when(ALU_src2='1')else
					  instruction(25 downto 21)when(decode_opcode(2) = '1')else
					  (others=>'0');
	
	Addr_Write_Reg <= instruction(25 downto 21) when(BR_JMP_indicator = '0')else "00000";
	
	BR_JMP_indicator <= decode_opcode(12) or decode_opcode(13) or decode_opcode(14) or decode_opcode(15) or
						decode_opcode(63) or decode_opcode(62) or decode_opcode(61);
	
	En_Read_Reg  <= '0' when (operation_opcode = "111111")else '1';
	En_Write_Reg <= not (decode_opcode(2) or BR_JMP_indicator);
	Mem_Read	<= decode_opcode(1) and (not R_Type);
	Mem_Write	<= decode_opcode(2) and (not R_Type);
	
	BR_JMP_Addr <= instruction(7 downto 0)when(BR_JMP_indicator = '1')else(others => '0');
	
	JMP_BR_flag <= BR_JMP_indicator;
	Call_flag <= decode_opcode(62);
	Ret_flag  <= decode_opcode(61);
end;

-- SubModule: Control_Unit_Decoder:
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_Logic_unsigned.all;

entity Control_Unit_Decoder is
port(
	input:	in	std_Logic_vector(5 downto 0);
	output:	out	std_Logic_vector(63 downto 0));
end;

architecture one of Control_Unit_Decoder is
begin
	process(input)begin
		output <= (others => '0');
		output(CONV_INTEGER(input)) <= '1';
	end process;
end;

-- SubModule: Stack_Memory --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Stack_Memory is
port(
	reset:	in	std_logic;
	clk:	in	std_logic;
	push:	in	std_logic;
	pop:	in	std_logic;
	input:	in	std_Logic_vector(7 downto 0);
	outpt:	out	std_logic_vector(7 downto 0));
end;

architecture one of Stack_Memory is
	
	component Stack_Pointer
	port(
		reset:	in	std_logic;
		clk:	in	std_logic;
		push:	in	std_logic;
		pop:	in	std_logic;
		outpt:	out	std_logic_vector(7 downto 0));
	end component;
	
	type t_Mem is array(0 to 255) of std_Logic_vector(7 downto 0);
	signal memory: t_Mem;
	signal address:	std_logic_vector(7 downto 0);
	
begin
	
	U:	Stack_Pointer port map(
		reset	=>	reset,
		clk		=>	clk,
		push	=>	push,
		pop		=>	pop,
		outpt	=>	address);
	
	process(push,pop,clk,address)begin
		outpt <= (others=>'Z');
		if(pop = '1')then -- Read_from Memory
			outpt <= memory(conv_integer(address));
		elsif(clk 'event and clk = '1')then
			if(push = '1')then
				memory(conv_integer(address)) <= input;
			end if;
		end if;
	end process;
end;

-- SubModule: Stack_Pointer --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Stack_Pointer is
port(
	reset:	in	std_logic;
	clk:	in	std_logic;
	push:	in	std_logic;
	pop:	in	std_logic;
	outpt:	out	std_logic_vector(7 downto 0));
end;

architecture one of Stack_Pointer is
	signal sout:	std_logic_vector(7 downto 0);
begin
	outpt <= sout;
	process(reset,clk)begin
		if(reset = '1')then
			sout <= (others => '0');
		elsif(clk 'event and clk = '0')then
			if(pop = '1')then
				sout <= sout - 1;
			elsif(push = '1')then
				sout <= sout + 1;
			end if;
		end if;
	end process;
end;

-- SubModule: ID_EX
library ieee;
use ieee.std_Logic_1164.all;

entity ID_EX is
port(
	reset:						in	std_logic;
	clk:						in	std_logic;
	En:							in	std_logic;
	in_data1:					in	std_logic_vector(31 downto 0);
	in_data2:					in	std_logic_vector(31 downto 0);
	in_En_ALU:					in	std_logic;
	in_En_FPU:					in	std_logic;
	in_Addr_Write_Reg:			in	std_logic_vector(4  downto 0);
	in_En_Write_Reg:			in	std_logic;
	in_ALU_Op_Code:				in	std_logic_vector(5  downto 0);
	in_JMP_BR_flag:				in	std_logic;
	in_Mem_Read:				in	std_logic;
	in_Mem_Write:				in	std_logic;
	in_Data_Mem_Write_Data:		in	std_logic_vector(31 downto 0);
	in_BR_JMP_Addr:				in	std_Logic_vector(7 downto 0);
	in_Hazard_Read_Reg1:		in	std_logic_vector(4 downto 0);
	in_Hazard_Read_Reg2:		in	std_logic_vector(4 downto 0);
	out_data1:					out	std_logic_vector(31 downto 0);
	out_data2:					out	std_logic_vector(31 downto 0);
	out_En_ALU:					out	std_logic;
	out_En_FPU:					out	std_logic;
	out_Addr_Write_Reg:			out	std_logic_vector(4  downto 0);
	out_En_Write_Reg:			out	std_logic;
	out_ALU_Op_Code:			out	std_logic_vector(5  downto 0);
	out_JMP_BR_flag:			out	std_logic;
	out_Mem_Read:				out	std_logic;
	out_Mem_Write:				out	std_logic;
	out_Data_Mem_Write_Data:	out	std_logic_vector(31 downto 0);
	out_BR_JMP_Addr:			out	std_Logic_vector(7 downto 0);
	out_Hazard_Read_Reg1:		out	std_logic_vector(4 downto 0);
	out_Hazard_Read_Reg2:		out	std_logic_vector(4 downto 0));
end;

architecture one of ID_EX is
begin
	process(reset,clk)begin
		if(reset = '1')then
			out_data1				<=	(others=>'0');
			out_data2				<=	(others=>'0');
			out_Addr_Write_Reg		<=	(others=>'0');
			out_En_Write_Reg		<=	'0';
			out_ALU_Op_Code			<=	(others=>'0');
			out_JMP_BR_flag			<=	'0';
			out_Mem_Read			<=	'0';
			out_Mem_Write			<=	'0';
			out_Data_Mem_Write_Data	<=	(others => '0');
			out_BR_JMP_Addr			<=	(others => '0');
			out_Hazard_Read_Reg1	<=	(others=>'0');
			out_Hazard_Read_Reg2	<=	(others=>'0');
			out_En_ALU				<=	'0';
			out_En_FPU				<=	'0';
		elsif(clk 'event and clk = '1')then
			if(En = '1')then
				out_data1				<=	in_data1;
				out_data2				<=	in_data2;
				out_Addr_Write_Reg		<=	in_Addr_Write_Reg;
				out_En_Write_Reg		<=	in_En_Write_Reg;
				out_ALU_Op_Code			<=	in_ALU_Op_Code;
				out_JMP_BR_flag			<=	in_JMP_BR_flag;
				out_Mem_Read			<=	in_Mem_Read;
				out_Mem_Write			<=	in_Mem_Write;
				out_Data_Mem_Write_Data	<=	in_Data_Mem_Write_Data;
				out_BR_JMP_Addr			<=	in_BR_JMP_Addr;
				out_Hazard_Read_Reg1	<=	in_Hazard_Read_Reg1;
				out_Hazard_Read_Reg2	<=	in_Hazard_Read_Reg2;
				out_En_ALU				<=	in_En_ALU;
				out_En_FPU				<=	in_En_FPU;
			end if;
		end if;
	end process;
end;