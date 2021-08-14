`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:33:20 09/29/2019 
// Design Name: 
// Module Name:    InstructionMemory 
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
module InstructionMemory
#(parameter bPerAddress=8, nAddress=128, bAddress=7, blocksPerInstruction=4)
(
	output [blocksPerInstruction*bPerAddress-1:0] Instruction,
	input [bAddress-1:0] Address
);

	reg [bPerAddress-1:0] mem [nAddress-1:0];
	wire [nAddress*bPerAddress-1:0] ins_com;

	// combine memory into blocks
	genvar i;
	generate
		for(i=0; i<nAddress; i=i+1) begin: ins_com_part
			assign ins_com[i*bPerAddress +: bPerAddress] = mem[i];
		end
	endgenerate

	assign Instruction = ins_com[Address*bPerAddress +: blocksPerInstruction*bPerAddress];


	initial begin: init
		
		// addi x1, x0, 7 
		{mem[3], mem[2], mem[1], mem[0]} = {6'b000001, 5'b00000, 5'b00001, 16'b0000000000000111};
		// addi x2, x0, 3 
		{mem[7], mem[6], mem[5], mem[4]} = {6'b000001, 5'b00000, 5'b00010, 16'b0000000000000011};
		// addi x4, x0, 0 
		{mem[11], mem[10], mem[9], mem[8]} = {6'b000001, 5'b00000, 5'b00100, 16'b0000000000000000};
		// R_type: add x3, x1, x2 
		{mem[15], mem[14], mem[13], mem[12]} = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b100000};
		// sub x3, x1, x2 
		{mem[19], mem[18], mem[17], mem[16]} = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b100010};
		// mul x3, x1, x2 
		{mem[23], mem[22], mem[21], mem[20]} = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b100011};
		// and x3, x1, x2 
		{mem[27], mem[26], mem[25], mem[24]} = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b100100};
		// or  x3, x1, x2 
		{mem[31], mem[30], mem[29], mem[28]} = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b100101};
		// slt x3, x1, x2 
		{mem[35], mem[34], mem[33], mem[32]} = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b101010};
		// nor x3, x1, x2 
		{mem[39], mem[38], mem[37], mem[36]} = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b100110};
		// xor x3, x1, x2 
		{mem[43], mem[42], mem[41], mem[40]} = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b100111};
		// sll x3, x1, x2 
		{mem[47], mem[46], mem[45], mem[44]} = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b101000};
		// srl x3, x1, x2 
		{mem[51], mem[50], mem[49], mem[48]} = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b101001};
		// I_type: addi x3, x1, 5 
		{mem[55], mem[54], mem[53], mem[52]} = {6'b000001, 5'b00001, 5'b00011, 16'b0000000000000101};
		// Load: lw x3, 0(x4) 
		{mem[59], mem[58], mem[57], mem[56]} = {6'b100011, 5'b00100, 5'b00011, 16'b0000000000000000};
		// Store: sw x1, 4(x4) 
		{mem[63], mem[62], mem[61], mem[60]} = {6'b101011, 5'b00100, 5'b00001, 16'b0000000000000100};

		// lw x3, 4(x4) 
		{mem[67], mem[66], mem[65], mem[64]} = {6'b100011, 5'b00100, 5'b00011, 16'b0000000000000100};
		// add x3, x1, x3 
		{mem[71], mem[70], mem[69], mem[68]} = {6'b000000, 5'b00001, 5'b00011, 5'b00011, 5'b00000, 6'b100000};
		
		// Br: beq x0, x0, Br
		{mem[75],  mem[74],  mem[73],  mem[72]}  = {6'b000100, 5'b00000, 5'b00000, 16'b1111111111111111};
		// Endprog: j Endprog
		{mem[79],  mem[78],  mem[77],  mem[76]}  = 32'b00000000000000010001000000100000; // {6'b000110, 26'b00000000000000000000010011};
		
		{mem[83],  mem[82],  mem[81],  mem[80]}  = 32'b00000000000000010001000000100000;
		{mem[87],  mem[86],  mem[85],  mem[84]}  = 32'b00000000000000010001000000100000;
		{mem[91],  mem[90],  mem[89],  mem[88]}  = 32'b00000000000000010001000000100000;
		{mem[95],  mem[94],  mem[93],  mem[92]}  = 32'b00000000000000010001000000100000;
		{mem[99],  mem[98],  mem[97],  mem[96]}  = 32'b00000000000000010001000000100000;
		{mem[103], mem[102], mem[101], mem[100]} = 32'b00000000000000010001000000100000;
		{mem[107], mem[106], mem[105], mem[104]} = 32'b00000000000000010001000000100000;
		{mem[111], mem[110], mem[109], mem[108]} = 32'b00000000000000010001000000100000;
		{mem[115], mem[114], mem[113], mem[112]} = 32'b00000000000000010001000000100000;
		{mem[119], mem[118], mem[117], mem[116]} = 32'b00000000000000010001000000100000;
		{mem[123], mem[122], mem[121], mem[120]} = 32'b00000000000000010001000000100000;
		{mem[127], mem[126], mem[125], mem[124]} = 32'b00000000000000010001000000100000;
		
	end

endmodule

