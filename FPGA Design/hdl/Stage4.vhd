library ieee;
use ieee.std_logic_1164.all;

entity Stage4 is
port(
	clk:	in	std_logic;
	reset:	in	std_logic;
	Memory_Read:	in	std_logic;
	Memory_Write:	in	std_logic;
	SP_Data:	in	std_logic_vector(7 downto 0);
	data1:	in	std_logic_vector(31 downto 0);
	Result:	in	std_logic_vector(31 downto 0);
	CALL_flag:	in	std_logic;
	RET_flag:	in	std_logic;
	Reg_Write_En_in:	in	std_logic;
	WB_Mux_sel_in:	in	std_logic;
	Addr_Write_Reg_in:	in	std_logic_vector(4 downto 0);
	imm:	in	std_logic_vector(15 downto 0);
	BR_Ex:	in	std_logic;
	next_PC:	out	std_logic_vector(7 downto 0);
	Memory_Data:	out	std_logic_vector(31 downto 0);
	Result_out:	out	std_logic_vector(31 downto 0);
	Reg_Write_En_out:	out	std_logic;
	WB_Mux_sel_out:	out	std_logic;
	Addr_Write_Reg_out:	out	std_logic_vector(4 downto 0);
	JMP_flag:	in	std_logic;
	BR_JMP_Ex:	out	std_logic;
	Mem_out_no_Pipeline:	out	std_logic_vector(31 downto 0);
	ALU_out_no_Pipeline:	out	std_logic_vector(31 downto 0);
	En_Prog_data_MEM:	in	std_logic;
	data_MEM_in:	in	std_logic_vector(31 downto 0);
	addr_MEM_in:	in	std_logic_vector(7 downto 0));
end;

architecture one of Stage4 is

	-- / Components \ --
	component Data_Memory
	port(
		clk:	in	std_logic;
		address:	in	std_logic_vector(7 downto 0);
		data_in:	in	std_logic_vector(31 downto 0);
		reset:	in	std_logic;
		data_out:	out	std_logic_vector(31 downto 0);
		En_Read:	in	std_logic;
		En_Write:	in	std_logic);
	end component;
	component MEM_Addr_MUX
	port(
		in0:	in	std_logic_vector(31 downto 0);
		in1:	in	std_logic_vector(7 downto 0);
		selector:	in	std_logic;
		outpt:	out	std_logic_vector(7 downto 0));
	end component;
	component Trans_BR
	port(
		BR_Ex_in:	in	std_logic;
		JMP_flag:	in	std_logic;
		CALL_flag:	in	std_logic;
		RET_flag:	in	std_logic;
		imm:	in	std_logic_vector(15 downto 0);
		StackMemory_in:	in	std_logic_vector(15 downto 0);
		flag:	out	std_logic;
		next_PC:	out	std_logic_vector(7 downto 0));
	end component;
	component MEM_WB_Pipeline_Register
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		Memory_in:	in	std_logic_vector(31 downto 0);
		Memory_out:	out	std_logic_vector(31 downto 0);
		ALU_in:	in	std_logic_vector(31 downto 0);
		ALU_out:	out	std_logic_vector(31 downto 0);
		Reg_Write_En_in:	in	std_logic;
		WB_Mux_sel_in:	in	std_logic;
		Addr_Write_Reg_in:	in	std_logic_vector(4 downto 0);
		Reg_Write_En_out:	out	std_logic;
		WB_Mux_sel_out:	out	std_logic;
		Addr_Write_Reg_out:	out	std_logic_vector(4 downto 0));
	end component;
	component ProgMUX_Data_MEM
	port(
		selector:	in	std_logic;
		inpt0_data:	in	std_logic_vector(31 downto 0);
		inpt1_data:	in	std_logic_vector(31 downto 0);
		outpt_data:	out	std_logic_vector(31 downto 0);
		inpt0_addr:	in	std_logic_vector(7 downto 0);
		inpt1_addr:	in	std_logic_vector(7 downto 0);
		outpt_addr:	out	std_logic_vector(7 downto 0));
	end component;
	-- / Components \ --

	-- / Signals\ --
	signal MUX_out:	std_logic_vector(7 downto 0);
	signal Memory_out:	std_logic_vector(31 downto 0);
	signal n_clk:	std_logic;
	signal sflag:	std_logic;
	signal data_memory_inpt:	std_logic_vector(31 downto 0);
	signal addr_memory_inpt:	std_logic_vector(7 downto 0);
	-- / Signals \ --

begin
	U1: Data_Memory port map(
			clk	=>	n_clk,
			address	=>	addr_memory_inpt,
			data_in	=>	data_memory_inpt,
			reset	=>	reset,
			data_out	=>	Memory_out,
			En_Read	=>	Memory_Read,
			En_Write	=>	Memory_Write);

	U2: MEM_Addr_MUX port map(
			in0	=>	Result,
			in1	=>	SP_Data,
			selector	=>	sflag,
			outpt	=>	MUX_out);

	U3: Trans_BR port map(
			BR_Ex_in	=>	BR_Ex,
			JMP_flag	=>	JMP_flag,
			CALL_flag	=>	CALL_flag,
			RET_flag	=>	RET_flag,
			imm	=>	imm,
			StackMemory_in	=>	Memory_out(15 downto 0),
			flag	=>	BR_JMP_Ex,
			next_PC	=>	next_PC);

	U4: MEM_WB_Pipeline_Register port map(
			clk	=>	clk,
			reset	=>	reset,
			Memory_in	=>	Memory_out,
			Memory_out	=>	Memory_Data,
			ALU_in	=>	Result,
			ALU_out	=>	Result_out,
			Reg_Write_En_in	=>	Reg_Write_En_in,
			WB_Mux_sel_in	=>	WB_Mux_sel_in,
			Addr_Write_Reg_in	=>	Addr_Write_Reg_in,
			Reg_Write_En_out	=>	Reg_Write_En_out,
			WB_Mux_sel_out	=>	WB_Mux_sel_out,
			Addr_Write_Reg_out	=>	Addr_Write_Reg_out);

	U5: ProgMUX_Data_MEM port map(
			selector	=>	En_Prog_data_MEM,
			inpt0_data	=>	data_MEM_in,
			inpt1_data	=>	data1,
			outpt_data	=>	data_memory_inpt,
			inpt0_addr	=>	addr_MEM_in,
			inpt1_addr	=>	MUX_out,
			outpt_addr	=>	addr_memory_inpt);

	Mem_out_no_Pipeline <= Memory_out;
	ALU_out_no_Pipeline <= Result;
	n_clk <= not clk;
	sflag <= CALL_flag or RET_flag;
end;

library ieee;
use ieee.std_logic_1164.all;

entity Trans_BR is
port(
	BR_Ex_in:in	std_logic;
	JMP_flag:in	std_logic;
	CALL_flag:in	std_logic;
	RET_flag:in	std_logic;
	imm:in	std_logic_vector(15 downto 0);
	StackMemory_in:in	std_logic_vector(15 downto 0);
	flag:out	std_logic;
	next_PC:out	std_logic_vector(7 downto 0));
end;

architecture one of Trans_BR is
begin
	next_PC <= imm(7 downto 0)when((BR_Ex_in or JMP_flag or CALL_flag) = '1')else
			   StackMemory_in(7 downto 0) when(RET_flag = '1')else
			   (others => '0');
	flag <= BR_Ex_in or JMP_flag or CALL_flag or RET_flag;
end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Data_Memory is
port(
	clk:in	std_logic;
	address:in	std_logic_vector(7	downto 0);
	data_in:in	std_logic_vector(31 downto 0);
	reset:in	std_logic;
	data_out:out	std_logic_vector(31 downto 0);
	En_Read:in	std_logic;
	En_Write:in	std_logic);
end;

architecture one of Data_Memory is
	type Memory_Block is array (0 to 255) of std_logic_vector(31 downto 0);
	signal memory: Memory_Block;
begin
	process(clk,En_Read,En_Write)begin
		data_out <= (others => 'Z');
		if(En_Read = '1')then
			data_out <= memory(CONV_INTEGER(address));
		elsif(En_Write = '1')then
			if(clk 'event and clk = '1')then
				memory(CONV_INTEGER(address)) <= data_in;
			end if;
		end if;
	end process;
end;

library ieee;
use ieee.std_logic_1164.all;

entity MEM_Addr_MUX is
port(
	in0:in	std_logic_vector(31 downto 0);
	in1:in	std_logic_vector(7 downto 0);
	selector:in	std_logic;
	outpt:out	std_logic_vector(7 downto 0));
end;

architecture one of MEM_Addr_MUX is
begin
	outpt <= in1 when(selector = '1') else
			 in0(7 downto 0);
end;

library ieee;
use ieee.std_logic_1164.all;

entity MEM_WB_Pipeline_Register is
port(
	clk:in	std_logic;
	reset:in	std_logic;
	Memory_in:in	std_logic_vector(31 downto 0);
	Memory_out:out	std_logic_vector(31 downto 0);
	ALU_in:in	std_logic_vector(31 downto 0);
	ALU_out:out	std_logic_vector(31 downto 0);
	Reg_Write_En_in:in	std_logic;
	WB_Mux_sel_in:in	std_logic;
	Addr_Write_Reg_in:in	std_logic_vector(4 downto 0);
	Reg_Write_En_out:out	std_logic;
	WB_Mux_sel_out:out	std_logic;
	Addr_Write_Reg_out:out	std_logic_vector(4 downto 0));
end;

architecture one of MEM_WB_Pipeline_Register is
begin
	process(clk,reset)begin
		if (reset = '1')then
			Memory_out <= (others => '0');
			ALU_out <= (others => '0');
			Reg_Write_En_out <= '0';
			WB_Mux_sel_out <= '0';
			Addr_Write_Reg_out <= (others => '0');
		elsif(clk 'event and clk = '1')then
			Memory_out <= Memory_in;
			ALU_out <= ALU_in;
			Reg_Write_En_out <= Reg_Write_En_in;
			WB_Mux_sel_out <= WB_Mux_sel_in;
			Addr_Write_Reg_out <= Addr_Write_Reg_in;
		end if;
	end process;
end;

-- SubModule: ProgMUX_Data_MEM --

library ieee;
use ieee.std_logic_1164.all;

entity ProgMUX_Data_MEM is
port(
	selector:in	std_logic;
	inpt0_data:in	std_logic_vector(31 downto 0);
	inpt1_data:in	std_logic_vector(31 downto 0);
	outpt_data:out	std_logic_vector(31 downto 0);
	inpt0_addr:in	std_logic_vector(7 downto 0);
	inpt1_addr:in	std_logic_vector(7 downto 0);
	outpt_addr:out	std_logic_vector(7 downto 0));
end;

architecture one of ProgMUX_Data_MEM is
begin
	outpt_data <= inpt1_data when(selector='1')else inpt0_data;
	outpt_addr <= inpt1_addr when(selector='1')else inpt0_addr;
end;

