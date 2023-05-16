library ieee;
use ieee.std_logic_1164.all;

entity CPU is
port(
	reset:			in		std_logic;
	clk:				in		std_logic;
	rx:				in		std_logic;
	tx:				out	std_logic;
	CPU_clk_out:	out	std_logic;
	CPU_reset_out:	out	std_logic;
	ProgMode_out:	out	std_logic;
	output_port:	out	std_logic_vector(7 downto 0);
	input_port:		in		std_logic_vector(7 downto 0);
	input_signal_conv:	in	std_logic_vector(7 downto 0);
	Run_conv_out:		out	std_logic;
	DAC_MODE:		out	std_logic;
	DAC_WRT_A:		out	std_logic;
	DAC_WRT_B:		out	std_logic;
	DAC_CLK_A:		out	std_logic;
	DAC_CLK_B:		out	std_logic;
	DAC_DA:			out	std_logic_vector(13 downto 0);
	DAC_DB:			out	std_logic_vector(13 downto 0));
end;

architecture one of CPU is
	
	-- / Components \ --
	component CPU_Core_MIPS
	port(
		reset:						in		std_logic;
		clk:							in		std_logic;
		rx:							in		std_logic;
		tx:							out	std_logic;
		CPU_reset_out:				out	std_logic;
		CPU_clk_out:				out	std_logic;
		ProgMode_out:				out	std_logic;
		Peripheral_Address:	out	std_logic_vector(15 downto 0);
		Peripheral_WData:		out	std_logic_vector(31 downto 0);
		Peripheral_RData:		in		std_logic_vector(31 downto 0);
		Peripheral_Control_Enable:	out	std_logic;
		Peripheral_Control_Write:	out	std_logic);
	end component;
	
	component Peripheral_Bridge
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
	end component;
	
	component Peripheral_output_port
	port(
		reset:		in	std_logic;
		clk:			in	std_logic;
		En:			in	std_logic;
		Data_in:		in	std_logic_vector(7 downto 0);
		Data_out:	out	std_logic_vector(7 downto 0));
	end component;
	
	component Peripheral_input_port
	port(
		reset:		in		std_logic;
		clk:			in		std_logic;
		Data_in:		in		std_logic_vector(7 downto 0);
		Data_out:	out	std_logic_vector(7 downto 0));
	end component;
	
	component FIR_Filter_Peripheral
	port(
		reset:			in	std_logic;
		clk:			in	std_logic;
		input_signal:	in	std_logic_vector(31 downto 0);
		Data_in:		in	std_logic_vector(31 downto 0);
		Data_out:		out	std_logic_vector(31 downto 0);
		En_Control:		in	std_logic;
		En_addr_conv:	in	std_logic;
		En_data_conv:	in	std_logic;
		En_addr:		in	std_logic;
		En_Threshold:	in	std_logic;
		
		Control_Reg_out:	out	std_logic_vector(1 downto 0);
		Addr_conv_Reg_out:	out	std_logic_vector(5 downto 0);
		Data_conv_Reg_out:	out	std_logic_vector(31 downto 0);
		Addr_Reg_out:		out	std_logic_vector(5 downto 0);
		Theshold_Reg_out:	out	std_logic_vector(5 downto 0);
		
		Run_conv_out:		out	std_logic);
	end component;
	
	component Sin_Gen_Peripheral
	port(
		CPU_reset:	in	std_logic;
		CPU_clk:	in	std_logic;
		clk_50:		in	std_logic;
		
		En_Amp1:		in	std_logic;
		input_Amp1:		in	std_logic_vector(13 downto 0);
		output_Amp1:	out	std_logic_vector(13 downto 0);
		
		En_Amp2:		in	std_logic;
		input_Amp2:		in	std_logic_vector(13 downto 0);
		output_Amp2:	out	std_logic_vector(13 downto 0);
		
		En_phase1:		in	std_logic;
		input_phase1:	in	std_logic_vector(12 downto 0);
		output_phase1:	out	std_logic_vector(12 downto 0);
		
		En_phase2:		in	std_logic;
		input_phase2:	in	std_logic_vector(12 downto 0);
		output_phase2:	out	std_logic_vector(12 downto 0);
		
		DAC_MODE:		out	std_logic;
		DAC_WRT_A:		out	std_logic;
		DAC_WRT_B:		out	std_logic;
		DAC_CLK_A:		out	std_logic;
		DAC_CLK_B:		out	std_logic;
		DAC_DA:			out	std_logic_vector(13 downto 0);
		DAC_DB:			out	std_logic_vector(13 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal CPU_clk:	std_logic;
	signal CPU_reset:	std_logic;
	
	signal zero:	std_logic_vector(7 downto 0);
	
	signal Peripheral_Addr:			std_logic_vector(15 downto 0);
	signal Peripheral_WData:		std_logic_vector(31 downto 0);
	signal Peripheral_RData:		std_logic_vector(31 downto 0);
	signal Peripheral_Enable:		std_logic;
	signal Peripheral_Write:		std_logic;
	signal output_port_Data_out:	std_logic_vector(7 downto 0);
	signal output_port_Data_in:	std_logic_vector(7 downto 0);
	signal output_port_En:			std_logic;
	
	signal input_port_Data_out:	std_logic_vector(7 downto 0);
	
	signal En_Control_FIR:	std_logic;
	signal En_addr_conv_FIR:	std_logic;
	signal En_data_conv_FIR:	std_logic;
	signal En_addr_FIR:	std_logic;
	signal En_Threshold_FIR:	std_logic;
	signal FIR_Data_out:	std_logic_vector(31 downto 0);
	signal FIR_Data_in:	std_logic_vector(31 downto 0);
	
	signal FIR_control_reg:	std_logic_vector(1 downto 0);
	signal FIR_addr_conv_reg:	std_logic_vector(5 downto 0);
	signal FIR_data_conv_reg:	std_logic_vector(31 downto 0);
	signal FIR_addr_reg:			std_logic_vector(5 downto 0);
	signal FIR_Threshold_reg:	std_logic_vector(5 downto 0);
	
	signal En_Amp1:	std_logic;
	signal En_Amp2:	std_logic;
	signal En_phase1:	std_logic;
	signal En_phase2:	std_logic;
	
	signal input_Amp1:	std_logic_vector(13 downto 0);
	signal input_Amp2:	std_logic_vector(13 downto 0);
	signal output_Amp1:	std_logic_vector(13 downto 0);
	signal output_Amp2:	std_logic_vector(13 downto 0);
	
	signal input_phase1:		std_logic_vector(12 downto 0);
	signal input_phase2:		std_logic_vector(12 downto 0);
	signal output_phase1:	std_logic_vector(12 downto 0);
	signal output_phase2:	std_logic_vector(12 downto 0);
	
	-- / Signals \ --
	
begin
	
	zero <= (others=>'0');
	
	CPU_clk_out		<=	CPU_clk;
	CPU_reset_out	<=	CPU_reset;
	
	U1:	CPU_Core_MIPS port map(
		reset								=>	reset,
		clk								=>	clk,
		rx									=>	rx,
		tx									=>	tx,
		CPU_reset_out					=>	CPU_reset,
		CPU_clk_out						=>	CPU_clk,
		ProgMode_out					=>	ProgMode_out,
		Peripheral_Address			=>	Peripheral_Addr,
		Peripheral_WData				=>	Peripheral_WData,
		Peripheral_RData				=>	Peripheral_RData,
		Peripheral_Control_Enable	=>	Peripheral_Enable,
		Peripheral_Control_Write	=>	Peripheral_Write);
		
	U2:	Peripheral_Bridge port map(
		reset						=>	CPU_reset,
		clk						=>	not CPU_clk,
		Peripheral_Addr		=>	Peripheral_Addr,
		Peripheral_WData		=>	Peripheral_WData,
		Peripheral_RData		=>	Peripheral_RData,
		Peripheral_Enable		=>	Peripheral_Enable,
		Peripheral_write		=>	Peripheral_Write,
		
		output_port_Data_in	=>	output_port_Data_out,
		output_port_Data_out	=>	output_port_Data_in,
		output_port_En			=>	output_port_En,
		
		input_port_Data_in	=>	input_port_Data_out,
		
		En_Control				=>	En_Control_FIR,
		En_addr_conv			=>	En_addr_conv_FIR,
		En_data_conv			=>	En_data_conv_FIR,
		En_addr					=>	En_addr_FIR,
		En_Threshold			=>	En_Threshold_FIR,
		FIR_Filter_Data_out	=>	FIR_Data_out,
		FIR_Filter_Data_in	=>	FIR_Data_in,
		
		FIR_Control_Reg		=>	FIR_control_reg,
		FIR_addr_conv_Reg		=>	FIR_addr_conv_reg,
		FIR_data_conv_Reg		=>	FIR_data_conv_reg,
		FIR_addr_Reg			=>	FIR_addr_reg,
		FIR_threshold_Reg		=>	FIR_Threshold_reg,
		
		En_Amp1					=>	En_Amp1,
		En_Amp2					=>	En_Amp2,
		En_phase1				=>	En_phase1,
		En_phase2				=>	En_phase2,
		
		input_Amp1				=>	input_Amp1,
		input_Amp2				=>	input_Amp2,
		input_phase1			=>	input_phase1,
		input_phase2			=>	input_phase2,
		
		output_Amp1				=>	output_Amp1,
		output_Amp2				=>	output_Amp2,
		output_phase1			=>	output_phase1,
		output_phase2			=>	output_phase2);
	
	U3:	Peripheral_output_port port map(
		reset		=>	CPU_reset,
		clk		=>	CPU_clk,
		En			=>	output_port_En,
		Data_in	=>	output_port_Data_in,
		Data_out	=>	output_port_Data_out);
		
	U4:	Peripheral_input_port port map(
		reset		=>	CPU_reset,
		clk		=>	CPU_clk,
		Data_in	=>	input_port,
		Data_out	=>	input_port_Data_out);
	
	U5:	FIR_Filter_Peripheral port map(
		reset				=>	CPU_reset,
		clk				=>	CPU_clk,
		input_signal	=>	zero & zero & zero & input_Signal_conv,
		Data_in			=>	FIR_Data_out,
		Data_out			=>	FIR_Data_in,
		En_Control		=>	En_Control_FIR,
		En_addr_conv	=>	En_addr_conv_FIR,
		En_data_conv	=>	En_data_conv_FIR,
		En_addr			=>	En_addr_FIR,
		En_Threshold	=>	En_Threshold_FIR,
		
		Control_Reg_out	=>	FIR_control_reg,
		Addr_conv_Reg_out	=>	FIR_addr_conv_reg,
		Data_conv_Reg_out	=>	FIR_data_conv_reg,
		Addr_Reg_out		=>	FIR_addr_reg,
		Theshold_Reg_out	=>	FIR_Threshold_reg,
		
		Run_conv_out		=>	Run_conv_out);
		
	U6:	Sin_Gen_Peripheral port map(
		CPU_reset		=>	CPU_reset,
		CPU_clk			=>	CPU_clk,
		clk_50			=>	clk,
		
		En_Amp1			=>	En_Amp1,
		input_Amp1		=>	output_Amp1,
		output_Amp1		=>	input_Amp1,
		
		En_Amp2			=>	En_Amp2,
		input_Amp2		=>	output_Amp2,
		output_Amp2		=>	input_Amp2,
		
		En_phase1		=>	En_phase1,
		input_phase1	=>	output_phase1,
		output_phase1	=>	input_phase1,
		
		En_phase2		=>	En_phase2,
		input_phase2	=>	output_phase2,
		output_phase2	=>	input_phase2,
		
		DAC_MODE			=>	DAC_MODE,
		DAC_WRT_A		=>	DAC_WRT_A,
		DAC_WRT_B		=>	DAC_WRT_B,
		DAC_CLK_A		=>	DAC_CLK_A,
		DAC_CLK_B		=>	DAC_CLK_B,
		DAC_DA			=>	DAC_DA,
		DAC_DB			=>	DAC_DB);
	
	output_port <= output_port_Data_out;
end;