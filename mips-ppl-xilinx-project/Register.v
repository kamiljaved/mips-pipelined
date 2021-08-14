`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:30:02 11/23/2019 
// Design Name: 
// Module Name:    Register 
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
module Register
#(parameter bREG=4)
(
	output reg [bREG-1:0] ReadData,
	input [bREG-1:0] WriteData,
	input enWriteReg, clock, reset
);

	always @ (posedge clock) begin
		if (reset) ReadData <= 0;
		else if (enWriteReg) ReadData <= WriteData;
	end

endmodule
