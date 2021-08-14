`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:46:01 09/30/2019 
// Design Name: 
// Module Name:    ProgramCounter 
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
module ProgramCounter
#(parameter bPC=7)
(
	output reg [bPC-1:0] PCout,
	input [bPC-1:0] PCin,
	input clock, reset
);

	always @ (posedge clock) begin
		PCout <= PCin;
	end
	
	// Program Counter goes to address 0 upon reset
	always @ (posedge reset) begin
		PCout <= 0;
	end

endmodule
