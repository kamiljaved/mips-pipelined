`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:34:02 09/30/2019
// Design Name:   InstructionMemory
// Module Name:   C:/Users/Kamil/Desktop/Xilinx Projects/LAB_3/InstructionMemory_test.v
// Project Name:  LAB_3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: InstructionMemory
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module InstructionMemory_test;

	// Inputs
	reg [6:0] Address;

	// Outputs
	wire [31:0] Instruction;

	// Instantiate the Unit Under Test (UUT)
	InstructionMemory uut (
		.Instruction(Instruction), 
		.Address(Address)
	);

	initial begin
		// Initialize Inputs
		Address = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		Address = 1;
		#50;
		Address = 2;
		#50;
		Address = 3;
		#50;
		Address = 4;
		#50;

	end
      
endmodule

