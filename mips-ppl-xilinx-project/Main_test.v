`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:20:13 10/01/2019
// Design Name:   Main
// Module Name:   C:/Users/Kamil/Desktop/Xilinx Projects/LAB_3/Main_test.v
// Project Name:  LAB_3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Main_test;

	// Inputs
	reg clock;
	reg reset;

	// Outputs
	wire [31:0] ALUout;

	// Instantiate the Unit Under Test (UUT)
	Main uut (
		.ALUout(ALUout), 
		.clock(clock),
		.reset(reset)
	);

	initial begin
		clock = 0;
		forever #5 clock = ~clock;
	end
	
	initial begin
		
		// Initialize Inputs
		clock = 0;
		reset = 1;
      
		// Finish Reset
		#10;
		reset = 0;

	end
      
endmodule

