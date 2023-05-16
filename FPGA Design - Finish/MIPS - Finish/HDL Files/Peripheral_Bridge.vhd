library ieee;
use ieee.std_logic_1164.all;

entity Peripheral_Bridge is
port(
	reset:	in	std_logic;
	clk:		in	std_logic;
	Peripheral_Addr:	in	std_logic_vector(15 downto 0);
	Peripheral_WData:	in	std_logic_vector(31 downto 0);
	Peripheral_RData:	out	std_logic_vector(31 downto 0);
	Peripheral_Enable:	in	std_logic;
	Peripheral_write:		in	std_logic;
	
	-- Peripheral_Output Port
	output_port_Data_in:		in	std_logic_vector(7 downto 0);
	output_port_Data_out:	out	std_logic_vector(7 downto 0);
	output_port_En:			out	std_logic;
	
	-- Peripheral_input_port
	input_port_Data_in:		in	std_logic_vector(7 downto 0);
	
	-- FIR_Filter_Peripheral
	En_Control:					out	std_logic;
	En_addr_conv:				out	std_logic;
	En_data_conv:				out	std_logic;
	En_addr:						out	std_logic;
	En_Threshold:				out	std_logic;
	FIR_Filter_Data_out:		out	std_logic_vector(31 downto 0);
	FIR_Filter_Data_in:		in		std_logic_vector(31 downto 0);
	
	FIR_Control_Reg:			in		std_logic_vector(1 downto 0);
	FIR_addr_conv_Reg:		in		std_logic_vector(5 downto 0);
	FIR_data_conv_Reg:		in		std_logic_vector(31 downto 0);
	FIR_addr_Reg:				in		std_logic_vector(5 downto 0);
	FIR_threshold_Reg:		in		std_logic_vector(5 downto 0);
	
	-- Sin_Gen_Peripheral
	En_Amp1:						out	std_logic;
	En_phase1:					out	std_logic;
	En_Amp2:						out	std_logic;
	En_phase2:					out	std_logic;
	
	input_Amp1:					in		std_logic_vector(13 downto 0);
	output_Amp1:				out	std_logic_vector(13 downto 0);
	
	input_Amp2:					in		std_logic_vector(13 downto 0);
	output_Amp2:				out	std_logic_vector(13 downto 0);
	
	input_phase1:				in		std_logic_vector(12 downto 0);
	output_phase1:				out	std_logic_vector(12 downto 0);
	
	input_phase2:				in		std_logic_vector(12 downto 0);
	output_phase2:				out	std_logic_vector(12 downto 0));
end;

architecture one of Peripheral_Bridge is
	
	signal Addr:	std_logic_vector(15 downto 0);
	signal WData:	std_logic_vector(31 downto 0);
	
	signal zero:std_logic_vector(7 downto 0);
	
begin
	
	zero <= (others => '0');
	
	process(reset,clk)begin
		if(reset = '1')then
			Addr	<= (others => '0');
			WData	<= (others => '0');
		elsif(clk 'event and clk = '1')then
			if(Peripheral_Enable = '1')then
				Addr  <= Peripheral_Addr;
				if(Peripheral_write = '1')then
					WData <= Peripheral_WData;
				else
					WData <= (others => '0');
				end if;
			else
				Addr  <= (others => '0');
				WData <= (others => '0');
			end if;
		end if;
	end process;
	
	process(Addr,WData,input_port_Data_in,Peripheral_Enable)begin
		
		Peripheral_RData <= (others=>'0');
		output_port_En <= '0';
		output_port_Data_out	<= (others=>'0');
		
		FIR_Filter_Data_out <= (others=>'0');
		En_Threshold <= '0';
		En_addr	<=	'0';
		En_data_conv <= '0';
		En_addr_conv <= '0';
		En_Control <= '0';
		
		En_Amp1 <= '0';
		En_Amp2 <= '0';
		En_phase1 <= '0';
		En_phase2 <= '0';
		output_Amp1 <= (others=>'0');
		output_Amp2 <= (others=>'0');
		output_phase1 <= (others=>'0');
		output_phase2 <= (others=>'0');
		
		if(Peripheral_Enable = '1')then
			case(Addr)is
				when x"0001"	=>	-- Output port
					output_port_En <= '1';
					Peripheral_RData <= zero & zero & zero & output_port_Data_in;
					output_port_Data_out	<= WData(7 downto 0);
				when x"0002"	=>	-- Input port
					Peripheral_RData <= zero & zero & zero & input_port_Data_in;
				when x"0003"	=>	-- FIR Filter (Control Register)
					En_Control <= '1';
					FIR_Filter_Data_out <= WData;
					Peripheral_RData <= zero & zero & zero & "000000" & FIR_Control_Reg;
					
				when x"0004"	=>	-- FIR Filter (addr_conv)
					En_addr_conv <= '1';
					FIR_Filter_Data_out <= WData;
					Peripheral_RData <= zero & zero & zero & "00" & FIR_addr_conv_Reg;
					
				when x"0005"	=> -- FIR Filter (data_conv)
					En_data_conv <= '1';
					FIR_Filter_Data_out <= WData;
					Peripheral_RData <= FIR_data_conv_Reg;
					
				when x"0006"	=>	-- FIR Filter (addr)
					En_addr	<=	'1';
					FIR_Filter_Data_out <= WData;
					Peripheral_RData <= zero & zero & zero & "00" & FIR_addr_Reg;
					
				when x"0007"	=>	-- FIR Filter (Threshold)
					En_Threshold <= '1';
					FIR_Filter_Data_out <= WData;
					Peripheral_RData <= zero & zero & zero & "00" & FIR_threshold_Reg;
					
				when x"0008"	=>	-- FIR Filter (READ RAM)
					Peripheral_RData <= FIR_Filter_Data_in;
					
				when x"0009"	=>	-- Sin_Gen (Amp1 Register)
					En_Amp1	<= '1';
					output_Amp1 <= WData(13 downto 0);
					Peripheral_RData <= zero & zero & "00" & input_Amp1;
				
				when x"000A"	=>	-- Sin_Gen (Amp2 Register)
					En_Amp2	<= '1';
					output_Amp2 <= WData(13 downto 0);
					Peripheral_RData <= zero & zero & "00" & input_Amp2;
				
				when x"000B"	=>	-- Sin_Gen (phase1 Register)
					En_phase1 <= '1';
					output_phase1 <= WData(12 downto 0);
					Peripheral_RData <= zero & zero & "000" & input_phase1;
				
				when x"000C"	=>	--	Sin_Gen (phase2 Register)
					En_phase2 <= '1';
					output_phase2 <= WData(12 downto 0);
					Peripheral_RData <= zero & zero & "000" & input_phase2;
					
				when others =>	
					output_Amp1 <= (others=>'0');
					output_Amp2 <= (others=>'0');
					output_phase1 <= (others=>'0');
					output_phase2 <= (others=>'0');
					En_Amp1 <= '0';
					En_Amp2 <= '0';
					En_phase1 <= '0';
					En_phase2 <= '0';
					FIR_Filter_Data_out <= (others=>'0');
					En_Threshold <= '0';
					En_addr	<=	'0';
					En_data_conv <= '0';
					En_addr_conv <= '0';
					En_Control <= '0';
					Peripheral_RData <= (others=>'0');
					output_port_En <= '0';
					output_port_Data_out	<= (others=>'0');
			end case;
		else
			Peripheral_RData <= (others=>'0');
			output_port_En <= '0';
			output_port_Data_out	<= (others=>'0');
		end if;
	end process;
end;