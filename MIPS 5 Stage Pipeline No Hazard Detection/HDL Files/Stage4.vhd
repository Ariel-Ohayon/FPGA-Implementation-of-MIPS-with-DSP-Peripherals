library ieee;
use ieee.std_logic_1164.all;

entity Stage4 is
port(
	reset:					in	std_logic;
	clk:					in	std_logic;
	En_Pipeline:			in	std_logic;
	ALU_Result_in:			in	std_logic_vector(31 downto 0);
	Addr_Write_Reg_in:		in	std_logic_vector(4  downto 0);
	En_Write_Reg_in:		in	std_logic;
	Mem_Read:				in	std_logic;
	Mem_Write:				in	std_logic;
	Data_Mem_Write_Data:	in	std_logic_vector(31 downto 0);
	ALU_Result_out:			out	std_logic_vector(31 downto 0);
	Mem_Result_out:			out	std_logic_vector(31 downto 0);
	Addr_Write_Reg_out:		out	std_logic_vector(4  downto 0);
	En_Write_Reg_out:		out	std_logic;
	selector_out:			out	std_logic);
end;

architecture one of Stage4 is
	-- / Components \ --
	component Data_Memory
	port(
		clk:		in	std_logic;
		Mem_Read:		in	std_logic;
		Mem_Write:		in	std_logic;
		addr:		in	std_logic_vector(7 downto 0);
		Data_in:	in	std_logic_vector(31 downto 0);
		Data_out:	out	std_logic_vector(31 downto 0));
	end component;
	
	component MEM_WB
	port(
		reset:				in	std_logic;
		clk:				in	std_logic;
		En:					in	std_logic;
		Mem_Data_in:		in	std_logic_vector(31 downto 0);
		ALU_Data_in:		in	std_logic_vector(31 downto 0);
		En_Write_Reg_in:	in	std_logic;
		Addr_Write_Reg_in:	in	std_logic_vector(4  downto 0);
		Mem_Read:			in	std_logic;
		Mem_Data_out:		out	std_logic_vector(31 downto 0);
		ALU_Data_out:		out	std_logic_vector(31 downto 0);
		En_Write_Reg_out:	out	std_logic;
		Addr_Write_Reg_out:	out	std_logic_vector(4  downto 0);
		selector_out:		out	std_logic);
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal Mem_Data_out:	std_logic_vector(31 downto 0);
	-- / Signals \ --
	
begin
	U1:	Data_Memory port map(
		clk			=>	clk,
		Mem_Read	=>	Mem_Read,
		Mem_Write	=>	Mem_Write,
		addr		=>	ALU_Result_in(7 downto 0),
		Data_in		=>	Data_Mem_Write_Data,
		Data_out	=>	Mem_Data_out);
		
	U2:	MEM_WB port map(
		reset				=>	reset,
		clk					=>	clk,
		En					=>	En_Pipeline,
		Mem_Data_in			=>	Mem_Data_out,
		ALU_Data_in			=>	ALU_Result_in,
		En_Write_Reg_in		=>	En_Write_Reg_in,
		Addr_Write_Reg_in	=>	Addr_Write_Reg_in,
		Mem_Read			=>	Mem_Read,
		Mem_Data_out		=>	Mem_Result_out,
		ALU_Data_out		=>	ALU_Result_out,
		En_Write_Reg_out	=>	En_Write_Reg_out,
		Addr_Write_Reg_out	=>	Addr_Write_Reg_out,
		selector_out		=>	selector_out);
end;

-- SubModule: Data_Memory

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Data_Memory is
port(
	clk:		in	std_logic;
	Mem_Read:		in	std_logic;
	Mem_Write:		in	std_logic;
	addr:		in	std_logic_vector(7 downto 0);
	Data_in:	in	std_logic_vector(31 downto 0);
	Data_out:	out	std_logic_vector(31 downto 0));
end;

architecture one of Data_Memory is
	type Memory_Block is array (0 to 255) of std_logic_vector(31 downto 0);
	signal Memory: Memory_Block;
begin
	process(clk,Mem_Read,Mem_Write,addr)begin
		Data_out <= (others => 'Z');
		if(Mem_Read = '1')then	-- Read Operation
			Data_out <= Memory(CONV_INTEGER(addr));
		elsif(clk 'event and clk = '0')then
			if(Mem_Write = '1')then
				Memory(CONV_INTEGER(addr)) <= Data_in;
			end if;
		end if;
	end process;
end;

-- SubModule: MEM_WB --

library ieee;
use ieee.std_logic_1164.all;

entity MEM_WB is
port(
	reset:				in	std_logic;
	clk:				in	std_logic;
	En:					in	std_logic;
	Mem_Data_in:		in	std_logic_vector(31 downto 0);
	ALU_Data_in:		in	std_logic_vector(31 downto 0);
	En_Write_Reg_in:	in	std_logic;
	Addr_Write_Reg_in:	in	std_logic_vector(4  downto 0);
	Mem_Read:			in	std_logic;
	Mem_Data_out:		out	std_logic_vector(31 downto 0);
	ALU_Data_out:		out	std_logic_vector(31 downto 0);
	En_Write_Reg_out:	out	std_logic;
	Addr_Write_Reg_out:	out	std_logic_vector(4  downto 0);
	selector_out:		out	std_logic);
end;

architecture one of MEM_WB is
begin
	process(reset,clk)begin
		if(reset = '1')then
			Mem_Data_out		<=	(others => '0');
			ALU_Data_out		<=	(others => '0');
			En_Write_Reg_out	<=	'0';
			Addr_Write_Reg_out	<=	(others => '0');
			selector_out		<=	'0';
		elsif(clk 'event and clk = '1')then
			if(En = '1')then
				Mem_Data_out		<=	Mem_Data_in;
				ALU_Data_out		<=	ALU_Data_in;
				En_Write_Reg_out	<=	En_Write_Reg_in;
				Addr_Write_Reg_out	<=	Addr_Write_Reg_in;
				selector_out		<=	Mem_Read;
			end if;
		end if;
	end process;
end;