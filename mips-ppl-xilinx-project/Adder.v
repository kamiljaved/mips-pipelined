`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:52:10 10/03/2019 
// Design Name: 
// Module Name:    Adder 
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
module Adder
#(parameter bNUM=32)
(
	output [bNUM-1:0] Sum,
	output C_out,
	input [bNUM-1:0] A, B,
	input C_in
);

	wire [bNUM:0] carry;
	assign carry[0] = C_in;
	assign C_out = carry[bNUM];

	genvar i;
	generate
		for (i=0; i<bNUM; i=i+1) begin: bit_sum
			FullAdder_1bit fa (Sum[i], carry[i+1], A[i], B[i], carry[i]);
		end
	endgenerate

endmodule


module FullAdder_1bit
(
	output sum, c_out,
	input a, b, c_in
);

	wire s0, c0, c1;
	
	HalfAdder_1bit ha0(s0, c0, a, b);
	HalfAdder_1bit ha1(sum, c1, s0, c_in);
	or or1(c_out, c0, c1);
	
endmodule


module HalfAdder_1bit
(
	output sum, c_out,
	input a, b
);

	xor (sum, a, b);
	and (c_out, a, b);

endmodule

