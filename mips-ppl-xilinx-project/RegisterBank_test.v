`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:32:03 09/25/2019
// Design Name:   RegisterBank
// Module Name:   C:/Users/Kamil/Desktop/Xilinx Projects/LAB_3/RegisterBank_test.v
// Project Name:  LAB_3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RegisterBank
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module RegisterBank_test;

	// Inputs
	reg [4:0] selReadReg1;
	reg [4:0] selReadReg2;
	reg [4:0] selWriteReg;
	reg [31:0] WriteData;
	reg enWriteReg;
	reg clock;

	// Outputs
	wire [31:0] ReadData1;
	wire [31:0] ReadData2;

	// Instantiate the Unit Under Test (UUT)
	RegisterBank uut (
		.ReadData1(ReadData1), 
		.ReadData2(ReadData2), 
		.selReadReg1(selReadReg1), 
		.selReadReg2(selReadReg2), 
		.selWriteReg(selWriteReg), 
		.WriteData(WriteData), 
		.enWriteReg(enWriteReg), 
		.clock(clock)
	);

	integer i;
	
	initial begin
		clock = 0;
		forever #15 clock = ~clock;
	end
	
	initial begin
		// Initialize Inputs
		selReadReg1 = 1;
		selReadReg2 = 2;
		selWriteReg = 0;
		WriteData = 0;
		enWriteReg = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		selReadReg1 = 1;
		selReadReg2 = 2;
		selWriteReg = 2;
		WriteData = 25;
		enWriteReg = 1;

	end
      
endmodule

