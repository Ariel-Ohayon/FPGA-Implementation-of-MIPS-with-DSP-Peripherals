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
