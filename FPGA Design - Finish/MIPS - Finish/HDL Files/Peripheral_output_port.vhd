library ieee;
use ieee.std_logic_1164.all;

entity Peripheral_output_port is
port(
	reset:		in	std_logic;
	clk:			in	std_logic;
	En:			in	std_logic;
	Data_in:		in	std_logic_vector(7 downto 0);
	Data_out:	out	std_logic_vector(7 downto 0));
end;

architecture one of Peripheral_output_port is
	
	-- / Components \ --
	component Peripheral_Register_output_port
	port(
		reset:	in		std_logic;
		clk:		in		std_logic;
		En:		in		std_logic;
		Din:		in		std_logic_vector(7 downto 0);
		Dout:		out	std_logic_vector(7 downto 0));
	end component;
	-- / Components \ --
	
begin
	U1: Peripheral_Register_output_port port map(
		reset	=>	reset,
		clk	=>	clk,
		En		=>	En,
		Din	=>	Data_in,
		Dout	=>	Data_out);
end;

-- SubModule: Peripheral_Register_output_port --

library ieee;
use ieee.std_logic_1164.all;

entity Peripheral_Register_output_port is
port(
	reset:	in		std_logic;
	clk:		in		std_logic;
	En:		in		std_logic;
	Din:		in		std_logic_vector(7 downto 0);
	Dout:		out	std_logic_vector(7 downto 0));
end;

architecture one of Peripheral_Register_output_port is
begin
	process(reset,clk)begin
		if(reset = '1')then
			Dout <= (others=>'0');
		elsif(clk 'event and clk = '1')then
			if(En = '1')then
				Dout <= Din;
			end if;
		end if;
	end process;
end;