library ieee;
use ieee.std_logic_1164.all;

entity TB_Receiver is end;

architecture one of TB_Receiver is

component Receiver
port(
	rst,clk: in std_logic;
	rx: in std_logic;
	Data_out: out std_logic_vector(7 downto 0);
	recv_flag:	out	std_logic);
end component;

signal T_rst,T_clk:  std_logic;
signal T_rx:  std_logic;
signal T_Data_out:  std_logic_vector(7 downto 0);
signal T_recv_flag:	std_logic;

begin

DUT: Receiver port map (T_rst,T_clk,T_rx,T_Data_out,T_recv_flag);

	process
	begin
		T_clk <= '0';
		wait for 10ns;
		T_clk <= '1';
		wait for 10ns;
	end process;

	process
	begin
		T_rst <= '1';
		T_rx <= '1';
		wait for 100us;
		T_rst <= '0';
		wait for 80us;
		T_rx <= '0';		-- Send START Bit
		wait for 104.1666666us;
		T_rx <= '1';		-- Send the LSB ('1')
		wait for 104.1666666us;		-- 104.16666666us -> wait for one bit period
		T_rx <= '0';
		wait for 312.5us;			-- 3Bits
		T_rx <= '1';
		wait for 208.3333333us;
		T_rx <= '0';
		wait for 208.3333333us;
		T_rx <= '1';
		wait for 104.1666666us;
		-- / 1221.6666667us \ --
		wait for 50us;
		T_rx <= '0';
		wait for 520.8333333us;
		T_rx <= '1';
		wait for 208.3333333us;
		T_rx <= '0';
		wait for 208.3333333us;
		T_rx <= '1';
		wait for 104.1666666us;
		-- / 2367.5us \ --
	end process;

end;
