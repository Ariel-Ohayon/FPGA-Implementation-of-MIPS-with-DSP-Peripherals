`timescale 1ns/1ns
module TB;

	integer i;

	reg		T_reset;
	reg		T_clk;
	reg		T_rx;
	
	wire	T_CPU_clk;
	wire	T_CPU_reset;
	wire	T_tx;

	CPU	DUT(
		.reset		(T_reset),
		.clk		(T_clk),
		.CPU_clk	(T_CPU_clk),
		.CPU_reset	(T_CPU_reset),
		.rx			(T_rx),
		.tx			(T_tx));
	
	always
	begin
		T_clk = 1'b1;
		#10;
		T_clk = 1'b0;
		#10;
	end
	
	initial
	begin
		
		// Debugger Reset
		T_reset = 1'b0;
		T_rx = 1'b1;
		#20;
		T_reset = 1'b1;
		// CPU reset
		Read_Packet_UART(32'h31545352); // CPU_reset = '1'
		Read_Packet_UART(32'h30545352); // CPU_reset = '0'
		
		// Program the Instruction Memory //
		Read_Packet_UART(32'h6E454D49); // send IMEn
		
		Read_Packet_UART(32'h00000000);	// Send Address (0)
		Read_Packet_UART(32'h00430804); // Send Data (ADD R1,R2,R3)
		// send Pulse
		Read_Packet_UART(32'h6B6C6363); // Rise edge
		Read_Packet_UART(32'h30303030); // Fall edge
		
		Read_Packet_UART(32'h00000001); // Send Address (1)
		Read_Packet_UART(32'h00432005); // Send Data (SUB R4,R2,R3)
		// send Pulse
		Read_Packet_UART(32'h6B6C6363); // Rise edge
		Read_Packet_UART(32'h30303030); // Fall edge
		
		Read_Packet_UART(32'h00000002); // Send Address (2)
		Read_Packet_UART(32'h00432806); // Send Data (MUL R5,R2,R3)
		// send Pulse
		Read_Packet_UART(32'h6B6C6363); // Rise edge
		Read_Packet_UART(32'h30303030); // Fall edge
		
		Read_Packet_UART(32'h00000003); // Send Address (3)
		Read_Packet_UART(32'h00433007); // Send Data (DIV R6,R2,R3)
		// send Pulse
		Read_Packet_UART(32'h6B6C6363); // Rise edge
		Read_Packet_UART(32'h30303030); // Fall edge
		
		// End burn operation
		Read_Packet_UART(32'h6E454D49); // send IMEn
		
		for(i = 0; i < 4; i = i + 1)begin
			Read_Packet_UART(32'h6B6C6363);
			Read_Packet_UART(32'h30303030);
		end
		
		#100000;
		T_reset = 1'b0;
		#100000;
	end

	task Read_Byte_UART;
		input	[7:0]	data;
		integer i;
	begin
		T_rx = 1'b0; // Start Bit
		#104166.6667;
		for (i = 0; i < 8; i = i + 1)begin
			T_rx = data[i];
			#104166.6667;
		end
		T_rx = 1'b1; // Stop Bit
		#104166.6667;
	end
	endtask // run time = 1.041666666666666667[msec]
	
	task Read_Packet_UART;
		input	[31:0]	data;
	begin
		Read_Byte_UART(data[7:0]);
		Read_Byte_UART(data[15:8]);
		Read_Byte_UART(data[23:16]);
		Read_Byte_UART(data[31:24]);
	end
	endtask // run time = 4.166666666666666668[msec]
	
endmodule

// run 110[msec]
