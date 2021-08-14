`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:48:26 10/01/2019
// Design Name:   Control
// Module Name:   C:/Users/Kamil/Desktop/Xilinx Projects/LAB_3/Control_test.v
// Project Name:  LAB_3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Control_test;

	// Inputs
	reg [5:0] Op;

	// Outputs
	wire RegDst;
	wire ALUSrc;
	wire MemtoReg;
	wire RegWrite;
	wire MemRead;
	wire MemWrite;
	wire Branch;
	wire [1:0] ALUOp;

	// Instantiate the Unit Under Test (UUT)
	Control uut (
		.RegDst(RegDst), 
		.ALUSrc(ALUSrc), 
		.MemtoReg(MemtoReg), 
		.RegWrite(RegWrite), 
		.MemRead(MemRead), 
		.MemWrite(MemWrite), 
		.Branch(Branch), 
		.ALUOp(ALUOp), 
		.Op(Op)
	);

	initial begin
		// Initialize Inputs
		Op = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		Op = 6'b000000;
		#100;
		Op = 6'b100011;
		#100;
		Op = 6'b101011;
		#100;
		Op = 6'b000100;
		
		
	end
      
endmodule

