library ieee;
use ieee.std_logic_1164.all;

entity Stage5 is
port(
	clk:	in	std_logic;	-- No need to use right now
	reset:	in	std_logic;	-- No need to use right now
	-- Inputs from stage 4:
	stage4_WB_FPU_result:		in	std_logic_vector(31 downto 0);
	stage4_WB_ALU_result:		in	std_logic_vector(31 downto 0);
	stage4_WB_Data_Memory:		in	std_logic_vector(31 downto 0);
	stage4_WB_Register_addr:	in	std_logic_vector(4  downto 0);
	stage4_WB_Write_Register:	in	std_logic;
	stage4_WB_MUX:				in	std_logic_vector(1  downto 0);
	
	-- Output for stage2:
	stage2_WB_Write_Register:	out	std_logic;						-- To Enable Write function to Register
	stage2_Register_data:		out	std_logic_vector(31 downto 0);	-- Send the data to the Register
	stage2_Register_addr:		out	std_logic_vector(4  downto 0));	-- Send the address of the Register.
end;

architecture one of Stage5 is

	-- / Components \ --
	component WB_Reg_MUX
	port(
		ALU_in:	in	std_logic_vector(31 downto 0);
		FPU_in:	in	std_logic_vector(31 downto 0);
		MEM_in:	in	std_logic_vector(31 downto 0);
		sel:	in	std_logic_vector(1  downto 0);
		WB_out:	out	std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --

begin
	
	stage2_Register_addr 		<=	stage4_WB_Register_addr;
	stage2_WB_Write_Register	<=	stage4_WB_Write_Register;
	
	U1:	WB_Reg_MUX port map (
		ALU_in	=>	stage4_WB_ALU_result,
		FPU_in	=>	stage4_WB_FPU_result,
		MEM_in	=>	stage4_WB_Data_Memory,
		sel		=>	stage4_WB_MUX,
		WB_out	=>	stage2_Register_data);
end;

--

library ieee;
use ieee.std_logic_1164.all;

entity WB_Reg_MUX is
port(
	ALU_in:	in	std_logic_vector(31 downto 0);
	FPU_in:	in	std_logic_vector(31 downto 0);
	MEM_in:	in	std_logic_vector(31 downto 0);
	sel:	in	std_logic_vector(1  downto 0);
	WB_out:	out	std_logic_vector(31 downto 0));
end;

architecture one of WB_Reg_MUX is
begin
end;