`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:28:33 11/27/2019
// Design Name:   ForwardU
// Module Name:   C:/Users/Kamil/Desktop/Xilinx Projects/MIPS_pipeline/ForwardU_test.v
// Project Name:  MIPS_pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ForwardU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ForwardU_test;

	// Inputs
	reg EX_MEM__RegWrite;
	reg MEM_WB__RegWrite;
	reg [4:0] EX_MEM__rWR;
	reg [4:0] MEM_WB__rWR;
	reg [4:0] ID_EX__rs;
	reg [4:0] ID_EX__rt;

	// Outputs
	wire [1:0] ForwA;
	wire [1:0] ForwB;

	// Instantiate the Unit Under Test (UUT)
	ForwardU uut (
		.ForwA(ForwA), 
		.ForwB(ForwB), 
		.EX_MEM__RegWrite(EX_MEM__RegWrite), 
		.MEM_WB__RegWrite(MEM_WB__RegWrite), 
		.EX_MEM__rWR(EX_MEM__rWR), 
		.MEM_WB__rWR(MEM_WB__rWR), 
		.ID_EX__rs(ID_EX__rs), 
		.ID_EX__rt(ID_EX__rt)
	);

	initial begin
		// Initialize Inputs
		EX_MEM__RegWrite = 0;
		MEM_WB__RegWrite = 0;
		EX_MEM__rWR = 0;
		MEM_WB__rWR = 0;
		ID_EX__rs = 0;
		ID_EX__rt = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		EX_MEM__RegWrite = 1;
		MEM_WB__RegWrite = 1;
		EX_MEM__rWR = 5'b00000;
		MEM_WB__rWR = 5'b00000;
		ID_EX__rs = 5'b00000;
		ID_EX__rt = 0;
		
		#50;
		EX_MEM__rWR = 5'b10101;
		ID_EX__rs = 5'b00001;
		#50;
		EX_MEM__rWR = 5'b10000;
		ID_EX__rs = 5'b10000;
		MEM_WB__rWR = 5'b10000;
		ID_EX__rt = 5'b10000;
		#50;
		EX_MEM__rWR = 5'b00001;
		#50;
		EX_MEM__rWR = 5'b10001;
		ID_EX__rs = 5'b10001;
		#50;
		EX_MEM__rWR = 5'b00000;
		#50;
		EX_MEM__rWR = 5'b01000;
		
	end
      
endmodule

