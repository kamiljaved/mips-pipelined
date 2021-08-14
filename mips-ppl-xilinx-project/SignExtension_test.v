`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:50:32 09/30/2019
// Design Name:   SignExtension
// Module Name:   C:/Users/Kamil/Desktop/Xilinx Projects/LAB_3/SignExtension_test.v
// Project Name:  LAB_3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SignExtension
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SignExtension_test;

	// Inputs
	reg [15:0] Input;

	// Outputs
	wire [31:0] Output;

	// Instantiate the Unit Under Test (UUT)
	SignExtension uut (
		.Output(Output), 
		.Input(Input)
	);

	initial begin
		// Initialize Inputs
		Input = 16'b0000000000000000;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		Input = 16'b0110010000100100;
		#50;
		Input = 16'b1000000111000000;
		#50;
		Input = 16'b0000000000000000;
	end
      
endmodule

