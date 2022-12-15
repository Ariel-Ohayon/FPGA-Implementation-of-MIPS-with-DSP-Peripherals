-- TB UART Receavre--
-- Designed by: Lior Yadgarov--
library ieee;
use ieee.std_logic_1164.all;
entity TB_UART_Reciver is 
end;
architecture one of TB_UART_Reciver is
component Receiver 
port(
rst,clk: in std_logic;
Data_in: in std_logic;
Data_out: out std_logic_vector(7 downto 0);
Error: out std_logic := '0';
flag: out std_logic);
end component;
signal TB_rst,TB_clk,TB_Data_in,TB_flag:std_logic;
signal TB_Data_out:std_logic_vector(7 downto 0);
begin
uut:receiver port map (TB_rst,TB_clk,TB_Data_in,TB_Data_out,open,TB_flag);
process
begin
TB_clk<= '0';
wait for 10ns;
TB_clk<= '1';
wait for 10ns;
end process;
process 
begin
TB_rst<='1';
TB_Data_in<='1';
wait for 500us;
TB_rst<='0';
wait for 30us;
TB_Data_in<='0';
wait for 104.166us;
TB_Data_in<='1';
wait for 104.166us;
TB_Data_in<='0';
wait for 520.833us;
TB_Data_in<='1';
wait for 104.166us;
TB_Data_in<='0';
wait for 104.166us;
TB_Data_in<='1';
wait for 532.5us;
end process;
end;
-- force rst 		1,0 500us
-- force Data_in 	1,0 530us, 1 634.166us, 0 738.3333us, 1 1259.16666us, 0 1363.3333us, 1 1467.5us
-- define clk (50MHz)
-- run 2[msec]