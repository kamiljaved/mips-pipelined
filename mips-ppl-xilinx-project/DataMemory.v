`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:06:02 09/29/2019 
// Design Name: 
// Module Name:    DataMemory 
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
module DataMemory
#(parameter bPerAddress=8, nAddress=256, bAddress=8, blocksPerUnit=4)
(
	output reg [bPerAddress*blocksPerUnit-1:0] ReadData,	
	input [bAddress-1:0] Address,
	input [bPerAddress*blocksPerUnit-1:0] WriteData,
	input enReadMem, enWriteMem, clock
);

	reg [bPerAddress-1:0] mem [nAddress-1:0];
	wire [nAddress*bPerAddress-1:0] data_com;

	// combine memory into blocks
	genvar i;
	generate
		for(i=0; i<nAddress; i=i+1) begin: data_com_part
			assign data_com[i*bPerAddress +: bPerAddress] = mem[i];
		end
	endgenerate

	integer j;
	always @ (posedge clock) begin
		if (enWriteMem) begin
			for(j=0; j<blocksPerUnit; j=j+1) begin: data_write_part
				mem[j+Address] <= WriteData[j*bPerAddress +: bPerAddress];
			end	
		end
	end

	always @ (*) begin
		if (enReadMem) begin 
			assign ReadData = data_com[Address*bPerAddress +: bPerAddress*blocksPerUnit];
		end
	end

	initial begin: reset
		integer i;
		for (i=0; i<nAddress; i=i+1) begin
			mem[i] = {bPerAddress{1'b0}};
		end
		// set initial values
		{mem[3],   mem[2],   mem[1],   mem[0]}   = 32'hFFFFEEEE;
		{mem[7],   mem[6],   mem[5],   mem[4]}   = 32'h0000000E;
		{mem[255], mem[254], mem[253], mem[252]} = 32'hFFFFEEEE;
	end

endmodule
