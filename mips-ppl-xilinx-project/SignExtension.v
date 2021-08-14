`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:43:56 09/30/2019 
// Design Name: 
// Module Name:    SignExtension 
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
module SignExtension
#(parameter bOLD=16, bNEW=32)
(
	output [bNEW-1:0] Output,
	input [bOLD-1:0] Input
);

	assign Output = {{(bNEW-bOLD){Input[bOLD-1]}}, Input};

endmodule
