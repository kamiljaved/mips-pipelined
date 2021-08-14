`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:55:50 10/01/2019
// Design Name:   DataMemory
// Module Name:   C:/Users/Kamil/Desktop/Xilinx Projects/LAB_3/DataMemory_test.v
// Project Name:  LAB_3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DataMemory
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DataMemory_test;

	// Inputs
	reg [7:0] Address;
	reg [31:0] WriteData;
	reg enReadMem;
	reg enWriteMem;
	reg clock;

	// Outputs
	wire [31:0] ReadData;

	// Instantiate the Unit Under Test (UUT)
	DataMemory uut (
		.ReadData(ReadData), 
		.Address(Address), 
		.WriteData(WriteData), 
		.enReadMem(enReadMem), 
		.enWriteMem(enWriteMem), 
		.clock(clock)
	);

	initial begin
		// Initialize Inputs
		Address = 0;
		WriteData = 0;
		enReadMem = 0;
		enWriteMem = 0;
		clock = 0;

		// Wait 100 ns for global reset to finish
		#100;

		// Add stimulus here
		Address = 0;
		WriteData = 32'b11110000111111111111111111111111;
		enReadMem = 0;
		enWriteMem = 1;
      
		#50;
		clock=1;
		#50;
		clock=0;
		
		#100;
		Address = 0;
		WriteData = 32'b11111111111111111111111111111111;
		enReadMem = 1;
		enWriteMem = 0;
		
		#50;
		clock=1;
	end
      
endmodule

