library ieee;
use ieee.std_logic_1164.all;

entity FIR_Filter_Peripheral is
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
end;

architecture one of FIR_Filter_Peripheral is
	
	-- / Components \ --
	component FIR_Peripheral
	port(
		reset:			in	std_logic;
		clk:			in	std_logic;
		addr_conv:		in	std_logic_vector(5 downto 0);
		data_conv:		in	std_logic_vector(31 downto 0);
		addr:			in	std_logic_vector(5 downto 0);
		Threshold:		in	std_logic_vector(5 downto 0);
		Run:			in	std_logic;
		En_Prog_H:		in	std_logic;
		conv_in:		in	std_logic_vector(31 downto 0);
		RAM_out:		out	std_logic_vector(31 downto 0);
		Run_conv_out:	out	std_logic);
	end component;
	
	component FIR_Filter_Peripheral_Register
	generic(N:integer:=32);
	port(
		reset:		in	std_logic;
		clk:		in	std_logic;
		En:			in	std_logic;
		Data_in:	in	std_logic_vector(N-1 downto 0);
		Data_out:	out	std_logic_vector(N-1 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal Control_Register:	std_logic_vector(1 downto 0);
	signal addr_conv:	std_logic_vector(5 downto 0);
	signal data_conv:	std_logic_vector(31 downto 0);
	signal addr:	std_logic_vector(5 downto 0);
	signal Threshold:	std_logic_vector(5 downto 0);
	-- / Signals \ --
	
begin
	
	Control_Reg_out <= Control_Register;
	Addr_conv_Reg_out <= addr_conv;
	Data_conv_Reg_out <= data_conv;
	Addr_Reg_out <= addr;
	Theshold_Reg_out <= Threshold;
	
	FIR_Control_Register: FIR_Filter_Peripheral_Register generic map(2)port map(	-- Address 0x3
		reset		=>	reset,
		clk			=>	clk,
		En			=>	En_Control,
		Data_in		=>	Data_in(1 downto 0),
		Data_out	=>	Control_Register);
	
	FIR_addr_conv_Reg:	FIR_Filter_Peripheral_Register generic map(6)port map(		-- Address 0x4
		reset		=>	reset,
		clk			=>	clk,
		En			=>	En_addr_conv,
		Data_in		=>	Data_in(5 downto 0),
		Data_out	=>	addr_conv);
	
	FIR_data_conv_Reg:	FIR_Filter_Peripheral_Register generic map(32)port map(		-- Address 0x5
		reset		=>	reset,
		clk			=>	clk,
		En			=>	En_data_conv,
		Data_in		=>	Data_in,
		Data_out	=>	data_conv);
	
	FIR_addr_Reg:	FIR_Filter_Peripheral_Register generic map(6)port map(			-- Address 0x6
		reset		=>	reset,
		clk			=>	clk,
		En			=>	En_addr,
		Data_in		=>	Data_in(5 downto 0),
		Data_out	=>	addr);
	
	FIR_Threshold_Reg:	FIR_Filter_Peripheral_Register generic map(6)port map(		-- Address 0x7
		reset		=>	reset,
		clk			=>	clk,
		En			=>	En_Threshold,
		Data_in		=>	Data_in(5 downto 0),
		Data_out	=>	Threshold);
	
	U: FIR_Peripheral port map(
		reset			=>	reset,
		clk				=>	clk,
		addr_conv		=>	addr_conv,
		data_conv		=>	data_conv,
		addr			=>	addr,
		Threshold		=>	Threshold,
		Run				=>	Control_Register(0),
		En_Prog_H		=>	Control_Register(1),
		conv_in			=>	input_signal,
		RAM_out			=>	Data_out,																		-- Address 0x8 (Data_out)
		Run_conv_out	=>	Run_conv_out);
end;


-- SubModule: Peripheral Hardware --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FIR_Peripheral is
port(
	reset:			in	std_logic;
	clk:			in	std_logic;
	addr_conv:		in	std_logic_vector(5 downto 0);
	data_conv:		in	std_logic_vector(31 downto 0);
	addr:			in	std_logic_vector(5 downto 0);
	Threshold:		in	std_logic_vector(5 downto 0);
	Run:			in	std_logic;
	En_Prog_H:		in	std_logic;
	conv_in:		in	std_logic_vector(31 downto 0);
	RAM_out:		out	std_logic_vector(31 downto 0);
	Run_conv_out:	out	std_logic);
end;

architecture one of FIR_Peripheral is
	-- / Components \ --
	component FIR_Filter_Peripheral_RAM_Recorder
	port(
		reset:		in	std_logic;
		clk:		in	std_logic;
		Record_En:	in	std_logic;
		address:	in	std_logic_vector(5 downto 0);
		data_in:	in	std_logic_vector(31 downto 0);
		data_out:	out	std_logic_vector(31 downto 0));
	end component;
	
	component FIR_Filter
	port(
		reset:			in	std_logic;
		clk:			in	std_logic;
		En_Run:			in	std_logic;
		En_Program_H:	in	std_logic;
		addr:			in	std_logic_vector(5  downto 0);
		Program_Data:	in	std_logic_vector(31 downto 0);
		x:				in	std_logic_vector(31 downto 0);
		y:				out	std_logic_vector(31 downto 0));
	end component;
	-- / Components \ --
	
	-- / Signals \ --
	signal Run_count:	std_logic;
	signal address:	std_logic_vector(5 downto 0);
	signal count:	std_logic_vector(5 downto 0);
	signal conv_out:	std_logic_vector(31 downto 0);
	signal Run_conv:	std_logic;
	-- / Signals \ --
	
begin
	
	address <= count when(Run_count = '1')else addr;
	
	Run_conv_out <= Run_conv;
	
	U1:	FIR_Filter_Peripheral_RAM_Recorder port map(
		reset		=>	reset,
		clk			=>	clk,
		Record_En	=>	Run_count,
		address		=>	address,
		data_in		=>	conv_out,
		data_out	=>	RAM_out);
	
	U2:	FIR_Filter port map(
		reset			=>	reset,
		clk				=>	clk,
		En_Run			=>	Run_conv,
		En_Program_H	=>	En_Prog_H,
		addr			=>	addr_conv,
		Program_Data	=>	data_conv,
		x				=>	conv_in,
		y				=>	conv_out);
	
	process(reset,clk)begin
		if(reset = '1')then
			Run_count <= '0';
		elsif(clk 'event and clk = '0')then
			if(Run = '1')then
				Run_count <= '1';
			elsif(count = Threshold)then
				Run_count <= '0';
			end if;
		end if;
	end process;
	
	process(reset,clk)begin
		if(reset = '1')then
			count <= (others=>'0');
		elsif(clk 'event and clk = '0')then
			if(Run_count = '1')then
				count <= count + 1;
			else
				count <= (others=>'0');
			end if;
		end if;
	end process;
	
	process(reset,clk)begin
		if(reset = '1')then
			Run_conv <= '0';
		elsif(clk 'event and clk = '1')then
			if(Run = '1')then
				Run_conv <= '1';
			elsif(count = Threshold)then
				Run_conv <= '0';
			end if;
		end if;
	end process;
end;

-- SubModule: FIR_Filter_Peripheral_RAM_Recorder --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FIR_Filter_Peripheral_RAM_Recorder is
port(
	reset:		in	std_logic;
	clk:		in	std_logic;
	Record_En:	in	std_logic;
	address:	in	std_logic_vector(5 downto 0);
	data_in:	in	std_logic_vector(31 downto 0);
	data_out:	out	std_logic_vector(31 downto 0));
end;

architecture one of FIR_Filter_Peripheral_RAM_Recorder is
	type ram_arr is array (0 to 63) of std_logic_vector(31 downto 0);
	signal ram: ram_arr;
begin
	process(reset,clk,Record_En)begin
		data_out <= (others=>'Z');
		if(reset = '1')then
			for i in 0 to 63 loop
				ram(i) <= (others=>'0');
			end loop;
		elsif(Record_En = '1')then
			if(clk 'event and clk = '0')then
				ram(conv_integer(address)) <= data_in;
			end if;
		else
			data_out <= ram(conv_integer(address));
		end if;
	end process;
end;

-- SubModule: FIR_Filter --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FIR_Filter is
port(
	reset:			in	std_logic;
	clk:			in	std_logic;
	En_Run:			in	std_logic;
	En_Program_H:	in	std_logic;
	addr:			in	std_logic_vector(5  downto 0);
	Program_Data:	in	std_logic_vector(31 downto 0);
	x:				in	std_logic_vector(31 downto 0);
	y:				out	std_logic_vector(31 downto 0));
end;

architecture one of FIR_Filter is
	
	type q_arr is array (0 to 63) of std_logic_vector(31 downto 0);

	signal q:	q_arr;
	signal h:	q_arr;
	
	shared variable v_y:	std_logic_vector(63 downto 0);
	
begin
	process(reset,clk,x,En_Program_H)begin
		if(reset = '1')then
			for i in q'range loop
				h(i) <= (others => '0');
				q(i) <= (others => '0');
			end loop;
		elsif(clk 'event and clk = '0')then
			if(En_Program_H = '1')then
				h(conv_integer(addr)) <= Program_Data;
			elsif(En_Run = '1')then
				q(0) <= x;
				for i in 1 to 63 loop
					q(i) <= q(i-1);
				end loop;
			else
				for i in 0 to 63 loop
					q(i) <= (others => '0');
				end loop;
			end if;
		end if;
	end process;
	
	process(h,q,reset)begin
		if(reset = '1')then
			v_y := (others=>'0');
			y <= v_y(31 downto 0);
		else
			v_y := (others=>'0');
			for i in 0 to 63 loop
				v_y := v_y + (h(i) * q(i));
			end loop;
			y <= v_y(31 downto 0);
		end if;
	end process;
	
end;

-- SubModule: FIR_Filter_Peripheral_Register --

library ieee;
use ieee.std_logic_1164.all;

entity FIR_Filter_Peripheral_Register is
generic(N:integer:=32);
port(
	reset:		in	std_logic;
	clk:		in	std_logic;
	En:			in	std_logic;
	Data_in:	in	std_logic_vector(N-1 downto 0);
	Data_out:	out	std_logic_vector(N-1 downto 0));
end;

architecture one of FIR_Filter_Peripheral_Register is
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