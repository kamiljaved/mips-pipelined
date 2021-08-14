`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:36:57 09/29/2019 
// Design Name: 
// Module Name:    ALU 
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
module ALU
#(parameter bNUM = 32, bSEL = 4)
(
	output reg [bNUM-1:0] F,
	output reg Zero, LessT, LessTE, GreaterT, GreaterTE,
	input [bNUM-1:0] A,
	input [bNUM-1:0] B,
	input [bSEL-1:0] Operation,
	input clock
);

	always @ (A, B, Operation) begin

		case (Operation)
			
			// Arithmrtic operations
			4'b0010: begin F = A + B;  	end	// add
			4'b0110: begin F = A - B;		end	// subtract
			4'b0011: begin F = A * B; 		end	//	multiply
			
			// Logical (bitwise) operations
			4'b0000: begin F = A & B; 		end	// AND
			4'b0001: begin F = A | B; 		end	// OR
			4'b1100: begin F = ~(A | B); 	end	// NOR
			4'b1101: begin F = A ^ B; 		end	// XOR
			
			// Shift Operations
			4'b1110: begin F = A << B; 	end	// Shift A left  by B times
			4'b1111: begin F = A >> B; 	end	// Shift A right by B times
			
			// Set on Less Than (SLT)
			4'b0111: begin if ($signed(A) < $signed(B)) F <= 1; else F <= 0; end

		endcase
		
		// set flags
		begin
			if (F=={32{1'b0}})					Zero <= 1;			else	Zero <= 0;
			if ($signed(B) < $signed(A)) 		LessT <= 1;			else	LessT <= 0;
			if ($signed(B) <= $signed(A)) 	LessTE <= 1;		else	LessTE <= 0;
			if ($signed(B) > $signed(A)) 		GreaterT <= 1;		else	GreaterT <= 0;
			if ($signed(B) >= $signed(A))		GreaterTE <= 1;	else	GreaterTE <= 0;
		end
		
	end	

endmodule
