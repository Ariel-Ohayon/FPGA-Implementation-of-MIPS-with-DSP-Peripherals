library ieee;
use ieee.std_logic_1164.all;

entity Stage1 is
port(
	clk:	in	std_logic;
	reset:	in	std_logic;
	ProgMode:	in	std_logic;
	Instruction_Data:	in	std_logic_vector(31 downto 0);
	Instruction_addr:	in	std_logic_vector(11 downto 0);
	En_Pipeline:	in	std_logic;
	Instruction_out:	out	std_logic_vector(31 downto 0);
	addr_BR_JMP:	in	std_logic_vector(11 downto 0);
	PC_sel:	in	std_logic);
end;

architecture one of Stage1 is

	-- / Components \ --
	component PC_Register
	port(
		reset:	in	std_logic;
		En:	in	std_logic;
		inpt:	in	std_logic_vector(11 downto 0);
		outpt:	out	std_logic_vector(11 downto 0));
	end component;
	component PC_MUX
	port(
		addr_BR_JMP:	in	std_logic_vector(11 downto 0);
		addr_next:	in	std_logic_vector(11 downto 0);
		selector:	in	std_logic;
		outpt:	out	std_logic_vector(11 downto 0));
	end component;
	component Instruction_Memory
	port(
		address:	in	std_logic_vector(11 downto 0);
		clk:	in	std_logic;
		data_in:	in	std_logic_vector(31 downto 0);
		data_out:	out	std_logic_vector(31 downto 0);
		R_nW:	in	std_logic;
		reset:	in	std_logic);
	end component;
	component IF_ID_Pipeline_Register
	port(
		clk:	in	std_logic;
		reset:	in	std_logic;
		Instruction_in:	in	std_logic_vector(31 downto 0);
		Instruction_out:	out	std_logic_vector(31 downto 0);
		En:	in	std_logic;
		PC_Adder_in:	in	std_logic_vector(11 downto 0);
		PC_Adder_out:	out	std_logic_vector(11 downto 0));
	end component;
	component PC_Adder
	port(
		inpt:	in	std_logic_vector(11 downto 0);
		outpt:	out	std_logic_vector(11 downto 0));
	end component;
	component Instruction_Memory_MUX
	port(
		in0:	in	std_logic_vector(11 downto 0);
		in1:	in	std_logic_vector(11 downto 0);
		selector:	in	std_logic;
		outpt:	out	std_logic_vector(11 downto 0));
	end component;
	-- / Components \ --

	-- / Signals\ --
	signal PC_in:	std_logic_vector(11 downto 0);
	signal PC_out:	std_logic_vector(11 downto 0);
	signal PC_Adder_out:	std_logic_vector(11 downto 0);
	signal Addr_inpt:	std_logic_vector(11 downto 0);
	signal Instruction:	std_logic_vector(31 downto 0);
	signal PC_next:	std_logic_vector(11 downto 0);
	signal n_clk: std_logic;
	-- / Signals \ --

begin
	n_clk <= not clk;
	U1: PC_Register port map(
			reset	=>	reset,
			En	=>	En_Pipeline,
			inpt	=>	PC_in,
			outpt	=>	PC_out);

	U2: PC_MUX port map(
			addr_BR_JMP	=>	addr_BR_JMP,
			addr_next	=>	PC_next,
			selector	=>	PC_sel,
			outpt	=>	PC_in);

	U3: Instruction_Memory port map(
			clk	=>	n_clk,
			address	=>	Addr_inpt,
			data_in	=>	Instruction_Data,
			data_out	=>	Instruction,
			R_nW	=>	ProgMode,
			reset	=>	reset);

	U4: IF_ID_Pipeline_Register port map(
			clk	=>	clk,
			reset	=>	reset,
			Instruction_in	=>	Instruction,
			Instruction_out	=>	Instruction_out,
			En	=>	En_Pipeline,
			PC_Adder_in	=>	PC_Adder_out,
			PC_Adder_out	=>	PC_next);

	U5: PC_Adder port map(
			inpt	=>	PC_out,
			outpt	=>	PC_Adder_out);

	U6: Instruction_Memory_MUX port map(
			in0	=>	Instruction_addr,
			in1	=>	PC_out,
			selector	=>	ProgMode,
			outpt	=>	Addr_inpt);

end;

-- SubModule: PC_Register --

library ieee;
use ieee.std_logic_1164.all;

entity PC_Register is
port(
	reset:in	std_logic;
	En:in	std_logic;
	inpt:in	std_logic_vector(11 downto 0);
	outpt:out	std_logic_vector(11 downto 0));
end;

architecture one of PC_Register is
begin
	process(En,inpt,reset)begin
		if(reset = '1')then
			outpt <= (others=>'0');
		else
			if(En = '1')then
				outpt <= inpt;
			end if;
		end if;
	end process;
end;

-- SubModule: PC_MUX --

library ieee;
use ieee.std_logic_1164.all;

entity PC_MUX is
port(
	addr_BR_JMP:in	std_logic_vector(11 downto 0);
	addr_next:in	std_logic_vector(11 downto 0);
	selector:in	std_logic;
	outpt:out	std_logic_vector(11 downto 0));
end;

architecture one of PC_MUX is
begin
	outpt <= addr_BR_JMP when (selector = '1')else
			 addr_next;
end;

-- SubModule: Instruction_Memory --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity Instruction_Memory is
port(
	address:in	std_logic_vector(11 downto 0);
	clk:in	std_logic;
	data_in:in	std_logic_vector(31 downto 0);
	data_out:out	std_logic_vector(31 downto 0);
	R_nW:in	std_logic;
	reset:in	std_logic);
end;

architecture one of Instruction_Memory is
	type Memory_Block is array (0 to 255) of std_logic_vector (31 downto 0);
	signal Memory:Memory_Block;
begin
	process(clk,R_nW)begin
		data_out <= (others => 'Z');
		if(R_nW = '1')then
			data_out <= Memory(CONV_INTEGER(address));
		elsif(clk 'event and clk = '1')then
			Memory(CONV_INTEGER(address)) <= data_in;
		end if;
	end process;
end;

-- SubModule: IF_ID_Pipeline_Register --

library ieee;
use ieee.std_logic_1164.all;

entity IF_ID_Pipeline_Register is
port(
	clk:in	std_logic;
	reset:in	std_logic;
	Instruction_in:in	std_logic_vector(31 downto 0);
	Instruction_out:out	std_logic_vector(31 downto 0);
	En:in	std_logic;
	PC_Adder_in:in	std_logic_vector(11 downto 0);
	PC_Adder_out:out	std_logic_vector(11 downto 0));
end;

architecture one of IF_ID_Pipeline_Register is
begin
	process(reset,clk)begin
		if(reset = '1')then
			PC_Adder_out <= (others=>'0');
			Instruction_out <= (others=>'0');
		elsif(clk 'event and clk = '1')then
			if (En = '1')then
				PC_Adder_out <= PC_Adder_in;
				Instruction_out <= Instruction_in;
			end if;
		end if;
	end process;
end;

-- SubModule: PC_Adder --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity PC_Adder is
port(
	inpt:in	std_logic_vector(11 downto 0);
	outpt:out	std_logic_vector(11 downto 0));
end;

architecture one of PC_Adder is
begin
	outpt <= inpt+1;
end;

-- SubModule: Instruction_Memory_MUX --

library ieee;
use ieee.std_logic_1164.all;

entity Instruction_Memory_MUX is
port(
	in0:in	std_logic_vector(11 downto 0);
	in1:in	std_logic_vector(11 downto 0);
	selector:in	std_logic;
	outpt:out	std_logic_vector(11 downto 0));
end;

architecture one of Instruction_Memory_MUX is
begin
	outpt <= in1 when (selector='1') else
			 in0;
end;
