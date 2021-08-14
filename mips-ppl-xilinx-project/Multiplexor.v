`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:16:09 09/29/2019 
// Design Name: 
// Module Name:    Multiplexor 
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
module Multiplexor
#(parameter nINPUT=4, bINPUT=4, bSEL=2)
(
	output [bINPUT-1:0] Output,
	input [bINPUT*nINPUT-1:0] Input,
	input [bSEL-1:0] Select
);
	
	wire [bINPUT-1:0] inputs_sep [nINPUT-1:0];

	genvar i;
	generate
		for (i=0; i<nINPUT; i=i+1) begin: mux
			assign inputs_sep[i] = Input[(i+1)*bINPUT-1:i*bINPUT];
		end
	endgenerate

	assign Output = inputs_sep[Select];

endmodule
