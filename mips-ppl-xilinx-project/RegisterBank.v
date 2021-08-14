`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:43 09/25/2019 
// Design Name: 
// Module Name:    RegisterBank 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

// read is not clock dependent
// write is clock dependent

module RegisterBank
#(parameter bREG=32, nREG=32, bSEL=5)
(
	output reg [bREG-1:0] ReadData1, ReadData2,
	input [bSEL-1:0] selReadReg1, selReadReg2, selWriteReg,
	input [bREG-1:0] WriteData,
	input enWriteReg, clock, reset
);

	reg [bREG-1:0] Registers [nREG-1:0];
	integer i;
	
	always @ (posedge clock) begin
		if (reset) begin
			for (i=0; i<nREG; i=i+1) begin
				Registers[i] <= {bREG{1'b0}};
			end
		end
		else if (enWriteReg && selWriteReg != 0) Registers[selWriteReg] <= WriteData;
	end

	always @ (*) begin
		if (enWriteReg && (selReadReg1 == selWriteReg))
			assign ReadData1 = WriteData;
		else
			assign ReadData1 = Registers[selReadReg1];
	end

	always @ (*) begin
		if (enWriteReg && (selReadReg2 == selWriteReg))
			assign ReadData2 = WriteData;
		else
			assign ReadData2 = Registers[selReadReg2];
	end

	initial begin: init
		// Registers[0] is always 0	
		// Registers[30] is return-address register
		// Registers[31] is sp register
	end

endmodule
