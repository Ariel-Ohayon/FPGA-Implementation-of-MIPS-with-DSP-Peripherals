library ieee;
use ieee.std_logic_1164.all;

entity IIR_Filter_Peripheral is
port(
	reset:		in	std_logic;
	clk:		in	std_logic;
	En_a:		in	std_logic;
	En_b:		in	std_logic;
	in_a:		in	std_logic_vector(31 downto 0);
	in_b:		in	std_logic_vector(31 downto 0);
	out_a:		out	std_logic_vector(31 downto 0);
	out_b:		out	std_logic_vector(31 downto 0);
	DAC_out:	out	std_logic_vector(13 downto 0));
end;

architecture one of IIR_Filter_Peripheral is
	
	-- / Components \ --
	component IIR_Filter_Peripheral_Register
	generic(N:integer:=32);
	port(
		reset:		in	std_logic;
		clk:		in	std_logic;
		En:			in	std_logic;
		Data_in:	in	std_logic_vector(N-1 downto 0);
		Data_out:	out	std_logic_vector(N-1 downto 0));
	end component;
	
	component IIR_Filter
	port(
		reset:	in	std_logic;
		clk:	in	std_logic;
		inpt:	in	std_logic_vector(31 downto 0);
		a:		in	std_logic_vector(31 downto 0);
		b:		in	std_logic_vector(31 downto 0);
		outpt:	out	std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --
	
begin
	U1: IIR_Filter port map(
		reset	=>	reset,
		clk		=>	clk,
		inpt	=>	inpt_filter,
		a		=>	reg_a_out,
		b		=>	reg_b_out,
		output	=>	DAC_out);
	
	U2:	IIR_Filter_Peripheral_Register generic map(32)port map(
		reset		=>	reset,
		clk			=>	clk,
		En			=>	En_a,
		Data_in		=>	in_a,
		Data_out	=>	reg_a_out);
		
	U3:	IIR_Filter_Peripheral_Register generic map(32)port map(
		reset		=>	reset,
		clk			=>	clk,
		En			=>	En_b,
		Data_in		=>	in_b,
		Data_out	=>	reg_b_out);
end;

-- SubMpdule: IIR_Filter

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity IIR_Filter is
port(
	reset:	in	std_logic;
	clk:	in	std_logic;
	inpt:	in	std_logic_vector(31 downto 0);
	a:		in	std_logic_vector(31 downto 0);
	b:		in	std_logic_vector(31 downto 0);
	outpt:	out	std_logic_vector(31 downto 0));
end;

architecture one of IIR_Filter is
	
	signal x1:		std_logic_vector(31 downto 0);
	signal y1:		std_logic_vector(31 downto 0);
	signal sig_out:	std_logic_vector(63 downto 0);
	
begin
	outpt <= sig_out(47 downto 16);
	process(reset,clk)begin
		if(reset = '1')then
			x1 <= (others=>'0');
			y1 <= (others=>'0');
		elsif(clk 'event and clk = '1')then
			x1 <= inpt;
			y1 <= sig_out(47 downto 16);
		end if;
	end process;
	sig_out <= (inpt*a)+(x1*a)-(y1*b);
end;

-- SubModule: IIR_Filter_Peripheral_Register --

library ieee;
use ieee.std_logic_1164.all;

entity IIR_Filter_Peripheral_Register is
generic(N:integer:=32);
port(
	reset:		in	std_logic;
	clk:		in	std_logic;
	En:			in	std_logic;
	Data_in:	in	std_logic_vector(N-1 downto 0);
	Data_out:	out	std_logic_vector(N-1 downto 0));
end;

architecture one of IIR_Filter_Peripheral_Register is
begin
	process(reset,clk)begin
		if(reset = '1')then
			Data_out <= (others=>'0');
		elsif(clk 'event and clk = '1')then
			if(En = '1')then
				Data_out <= Data_in;
			end if;
		end if;
	end process;
end;