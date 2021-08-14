`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:33 09/29/2019 
// Design Name: 
// Module Name:    Main 
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

module Main
#(parameter bDataUnit=32)
(
	output [bDataUnit-1:0] ALUout,
	input clock, reset
);

	// data-path parameters
	localparam bPC  = 7;
	localparam bINS = 32;
	localparam bDU  = bDataUnit;
	// Register Set Control Block parameters
	localparam bFL  = 5;
	localparam bWB  = 2;
	localparam bM   = 6;
	localparam bEX  = 4;
	
	wire [bINS-1:0] instruction;
	
	//	Control Lines - from Control Unit
	wire RegWrite, RegDst, MemtoReg,  MemRead, MemWrite;
	wire [2:0] Branch;
	wire Jump;
	wire ALUSrc;
	wire [1:0] ALUOp;	
	// ALU Operation Control Bits - from ALU Control Unit
	wire [3:0] OperationALU;	
	// Flags - from ALU
	wire Zero, LessT, LessTE, GreaterT, GreaterTE;

	// Register Set IF/ID Data wires
	wire [bPC-1:0]  rsdata_IF_ID__PCplus4;
	wire [bINS-1:0] rsdata_IF_ID__Instruction;
	// Register Set ID/EX Data wires
	wire [bWB-1:0]  rsdata_ID_EX__WB;
	wire [bM-1:0]   rsdata_ID_EX__M;
	wire [bEX-1:0]  rsdata_ID_EX__EX;
	wire [bPC-1:0]  rsdata_ID_EX__PCplus4;
	wire [bDU-1:0]  rsdata_ID_EX__RBread1dat;
	wire [bDU-1:0]  rsdata_ID_EX__RBread2dat;
	wire [bDU-1:0]  rsdata_ID_EX__Ins_imm32;
	wire [bDU-1:0]  rsdata_ID_EX__Ins_immj32;
	wire [4:0]      rsdata_ID_EX__Ins_rd;
	wire [4:0]      rsdata_ID_EX__Ins_rt;
	wire [4:0]      rsdata_ID_EX__Ins_rs;
	// Register Set EX/MEM Data wires
	wire [bWB-1:0]  rsdata_EX_MEM__WB;
	wire [bM-1:0]   rsdata_EX_MEM__M;
	wire [bDU-1:0]  rsdata_EX_MEM__PCplus4plusImm;
	wire [bFL-1:0]  rsdata_EX_MEM__Flags;
	wire [bDU-1:0]  rsdata_EX_MEM__ALUout;
	wire [bDU-1:0]  rsdata_EX_MEM__RBread2dat_IME;
	wire [4:0]      rsdata_EX_MEM__WriteReg;
	// Register Set MEM/WB Data wires
	wire [bWB-1:0]  rsdata_MEM_WB__WB;
	wire [bDU-1:0]  rsdata_MEM_WB__MEMreaddat;
	wire [bDU-1:0]  rsdata_MEM_WB__ALUout;
	wire [4:0]      rsdata_MEM_WB__WriteReg;
	
	// Register Set Total Bit-Count
	localparam bRS__IF_ID  = bPC + bINS;
	localparam bRS__ID_EX  = bWB + bM + bEX + bPC + 4*bDU + 3*5;
	localparam bRS__EX_MEM = bWB + bM + bDU + bFL + 2*bDU + 5;
	localparam bRS__MEM_WB = bWB + 2*bDU + 5;
	
	// Register Set Enables (for Write)
	wire enRegSet__IF_ID;
	wire enRegSet__ID_EX;
	wire enRegSet__EX_MEM;
	wire enRegSet__MEM_WB;
	assign enRegSet__ID_EX  = 1'b1;
	assign enRegSet__EX_MEM = 1'b1;
	assign enRegSet__MEM_WB = 1'b1;
	
	// Register set Flush Signals
	wire flush__IF_ID;
	wire flush__ID_EX;
	wire flush__EX_MEM;
	wire flush__MEM_WB;
	assign flush__MEM_WB	= 1'b0;
	
	// wires for decoded instruction from IF/ID Register Set
	wire [5:0]  rsd_Ins__opcode;
	wire [4:0]  rsd_Ins__rs, rsd_Ins__rt, rsd_Ins__rd;
	wire [4:0]  rsd_Ins__shamt;
	wire [5:0]  rsd_Ins__funct;
	wire [15:0] rsd_Ins__immediate16;
	wire [31:0] rsd_Ins__immediate32;
	wire [25:0] rsd_Ins__immjump26;
	wire [31:0] rsd_Ins__immjump32;
	wire [31:0] rsd_Ins__immpc32;
	assign rsd_Ins__opcode      = rsdata_IF_ID__Instruction[31:26];
	assign rsd_Ins__rs          = rsdata_IF_ID__Instruction[25:21];
	assign rsd_Ins__rt          = rsdata_IF_ID__Instruction[20:16];
	assign rsd_Ins__rd          = rsdata_IF_ID__Instruction[15:11];
	assign rsd_Ins__shamt       = rsdata_IF_ID__Instruction[10:6];
	assign rsd_Ins__funct       = rsdata_IF_ID__Instruction[5:0];
	assign rsd_Ins__immediate16 = rsdata_IF_ID__Instruction[15:0];
	assign rsd_Ins__immjump26   = rsdata_IF_ID__Instruction[25:0];
	// wires for using stored Control Data and Flags
	wire rsd_EX__RegDst;
	wire [1:0] rsd_EX__ALUOp;	
	wire rsd_EX__ALUSrc;
	wire [2:0] rsd_M__Branch;
	wire rsd_M__Jump, rsd_M__MemRead, rsd_M__MemWrite;
	wire rsd_WB__RegWrite, rsd_WB__MemtoReg;
	wire rsd_FL__Zero, rsd_FL__LessT, rsd_FL__LessTE, rsd_FL__GreaterT, rsd_FL__GreaterTE;
	assign rsd_EX__RegDst    = rsdata_ID_EX__EX[3];
	assign rsd_EX__ALUOp     = rsdata_ID_EX__EX[2:1];	
	assign rsd_EX__ALUSrc    = rsdata_ID_EX__EX[0];
	assign rsd_M__Branch     = rsdata_EX_MEM__M[5:3];
	assign rsd_M__Jump       = rsdata_EX_MEM__M[2];
	assign rsd_M__MemRead    = rsdata_EX_MEM__M[1];
	assign rsd_M__MemWrite   = rsdata_EX_MEM__M[0];
	assign rsd_WB__RegWrite  = rsdata_MEM_WB__WB[1];
	assign rsd_WB__MemtoReg  = rsdata_MEM_WB__WB[0];
	assign rsd_FL__Zero      = rsdata_EX_MEM__Flags[4];
	assign rsd_FL__LessT     = rsdata_EX_MEM__Flags[3];
	assign rsd_FL__LessTE    = rsdata_EX_MEM__Flags[2];
	assign rsd_FL__GreaterT  = rsdata_EX_MEM__Flags[1];
	assign rsd_FL__GreaterTE = rsdata_EX_MEM__Flags[0];

	// data-path wires
	wire [6:0]  pc, pc_next;
	wire [4:0]  rWR;
	wire [31:0] dataRD_rs, dataRD_rt, dataWR_rWR, ALUin1, ALUin2;
	wire [31:0] dataRD_mem;
	// Wires for PC (Regular/Branch/Jump) Circuit
	wire CarryOut_PC_1, CarryOut_PC_2, beq, bne, blt, bge, BranchTestResult;
	wire [1:0] PCSrc;
	wire [6:0]  pc_plus_4;
	wire [31:0] pc_plus_4_plus_imm;
	
	// Hazard Signals
	wire [1:0] ForwA, ForwB;
	wire Stall, PCWrite;
	// Hazard DataPath-Wires
	wire [bDU-1:0] ALUin2_IME;
	wire [bWB-1:0] WB;
	wire [bM-1:0]  MEM;
	wire [bEX-1:0] EX;
	
	// Control Units - Main & ALU
	Control ctrl (RegWrite, RegDst, MemtoReg, MemRead, MemWrite, Branch, ALUSrc, ALUOp, rsd_Ins__opcode);
	ControlALU ctrl_alu (OperationALU, rsd_EX__ALUOp, rsdata_ID_EX__Ins_imm32[5:0]);
	
	
	// Register Sets - for each Pipeline Stage
	
		// IF/ID Register Set
		Register #(bRS__IF_ID)  rset__IF_ID  (	{rsdata_IF_ID__PCplus4,	rsdata_IF_ID__Instruction}, 
															{pc_plus_4,					instruction}, 
															enRegSet__IF_ID, clock, reset	| flush__IF_ID	);
		// ID/EX Register Set
		Register #(bRS__ID_EX)  rset__ID_EX  (	{rsdata_ID_EX__WB,	rsdata_ID_EX__M,	rsdata_ID_EX__EX,			rsdata_ID_EX__PCplus4,	rsdata_ID_EX__RBread1dat,	rsdata_ID_EX__RBread2dat,	rsdata_ID_EX__Ins_imm32,	rsdata_ID_EX__Ins_immj32,	rsdata_ID_EX__Ins_rt,	rsdata_ID_EX__Ins_rd,	rsdata_ID_EX__Ins_rs}, 
															{WB,						MEM,					EX,							rsdata_IF_ID__PCplus4,	dataRD_rs,						dataRD_rt,						rsd_Ins__immediate32,		rsd_Ins__immjump32,			rsd_Ins__rt,				rsd_Ins__rd,				rsd_Ins__rs}, 
															enRegSet__ID_EX, clock, reset	| flush__ID_EX	);
		// EX/MEM Register Set
		Register #(bRS__EX_MEM) rset__EX_MEM (	{rsdata_EX_MEM__WB,	rsdata_EX_MEM__M,	rsdata_EX_MEM__PCplus4plusImm,	rsdata_EX_MEM__Flags,							rsdata_EX_MEM__ALUout,	rsdata_EX_MEM__RBread2dat_IME,		rsdata_EX_MEM__WriteReg}, 
															{rsdata_ID_EX__WB,	rsdata_ID_EX__M,	pc_plus_4_plus_imm,					Zero,	LessT, LessTE, GreaterT, GreaterTE,	ALUout,						ALUin2_IME,									rWR}, 
															enRegSet__EX_MEM, clock, reset | flush__EX_MEM	);	           
		// MEM/WB Register Set
		Register #(bRS__MEM_WB) rset__MEM_WB (	{rsdata_MEM_WB__WB,	rsdata_MEM_WB__MEMreaddat,	rsdata_MEM_WB__ALUout,	rsdata_MEM_WB__WriteReg}, 
															{rsdata_EX_MEM__WB,	dataRD_mem,						rsdata_EX_MEM__ALUout, 	rsdata_EX_MEM__WriteReg}, 
															enRegSet__MEM_WB, clock, reset | flush__MEM_WB	);	           
	
	// Single Registers 
		
		// Program Counter
		Register #(bPC) reg_ProgramCounter (pc, pc_next, PCWrite, clock, reset);
		
	// Main Components
	InstructionMemory #(8, 128, 7, 4) i_m (instruction, pc);
	RegisterBank #(32, 32, 5) r_b (dataRD_rs, dataRD_rt, rsd_Ins__rs, rsd_Ins__rt, rsdata_MEM_WB__WriteReg, dataWR_rWR, rsd_WB__RegWrite, clock, reset);
	ALU #(32, 4) alu (ALUout, Zero, LessT, LessTE, GreaterT, GreaterTE, ALUin1, ALUin2, OperationALU, clock);
	DataMemory #(8, 256, 8, 4) d_m (dataRD_mem, rsdata_EX_MEM__ALUout[7:0], rsdata_EX_MEM__RBread2dat_IME, rsd_M__MemRead, rsd_M__MemWrite, clock);
	
	// Other Components (Sign-Extension and Adder Units)
	
		// Sign Extension of Immediate Value for I-type & Branch Instructions
		SignExtension #(16, 32) s_e1 (rsd_Ins__immediate32, rsd_Ins__immediate16);
	
		// Sign Extension of Immediate Value for Jump Instruction
		SignExtension #(26, 32) s_e2 (rsd_Ins__immjump32, rsd_Ins__immjump26);
	
		// Adder for Incrementing PC
		Adder #(7) adder_pc_1 (pc_plus_4, CarryOut_PC_1, pc, 7'b0000100, 1'b0);
	
		// Adder for Branch/Jump Address Calculation
		Adder #(32) adder_pc_2 (pc_plus_4_plus_imm, CarryOut_PC_2, {{(32-7){1'b0}}, rsdata_ID_EX__PCplus4}, {rsdata_ID_EX__Ins_imm32[(31-2):0], {2{1'b0}}}, 1'b0);
	
	// Multiplexors {sel-(n-1), ... sel-0}
	
		// Selection: RegisterBank Write-Register
		Multiplexor #(2, 5, 1) muxRD (rWR, {rsdata_ID_EX__Ins_rd,	rsdata_ID_EX__Ins_rt}, rsd_EX__RegDst);
	
		// Selection: ALU input 1
		Multiplexor #(4, bDU, 2) muxFA (ALUin1, {{bDU{1'b0}}, rsdata_EX_MEM__ALUout, dataWR_rWR, rsdata_ID_EX__RBread1dat}, ForwA);
		
		// Selection: ALU input 2
		Multiplexor #(4, bDU, 2) muxFB (ALUin2_IME, {{bDU{1'b0}}, rsdata_EX_MEM__ALUout, dataWR_rWR, rsdata_ID_EX__RBread2dat}, ForwB);
		Multiplexor #(2, bDU, 1) muxAS (ALUin2, {rsdata_ID_EX__Ins_imm32, ALUin2_IME}, rsd_EX__ALUSrc);
		
		// Selection: RegisterBank WriteData
		Multiplexor #(2, 32, 1) muxMR (dataWR_rWR, {rsdata_MEM_WB__MEMreaddat, rsdata_MEM_WB__ALUout}, rsd_WB__MemtoReg);

		// Selection: Immediate for Branch/Jump
		// Multiplexor #(2, 32, 1) muxJ (rsd_Ins__immpc32, {rsdata_ID_EX__Ins_immj32, rsdata_ID_EX__Ins_imm32}, rsd_M__Jump);

		// Selection: Next PC Value (PC+4 or PC+4+Immediate) using PCSrc
		Multiplexor #(4, bPC, 2) muxPC (pc_next, {rsdata_EX_MEM__PCplus4plusImm[6:0], rsdata_EX_MEM__PCplus4plusImm[6:0], {instruction[bPC-2-1:0], {2{1'b0}}}, pc_plus_4}, PCSrc);
		
		// Selection: Control Pass or Stall (Control Zero)
		Multiplexor #(2, (bWB+bM+bEX), 1) muxSTL ({WB, MEM, EX}, {{(bWB+bM+bEX){1'b0}}, {RegWrite, MemtoReg,	Branch, Jump, MemRead, MemWrite,	RegDst, ALUOp, ALUSrc}}, Stall);
		
	// Hazard Handling Units
		
		// Forwarding Unit
		ForwardU #(5) haz_forw (
		 .ForwA					(ForwA), 
		 .ForwB					(ForwB), 
		 .EX_MEM__RegWrite	(rsdata_EX_MEM__WB[1]), 
		 .MEM_WB__RegWrite	(rsdata_MEM_WB__WB[1]), 
		 .EX_MEM__rWR			(rsdata_EX_MEM__WriteReg), 
		 .MEM_WB__rWR			(rsdata_MEM_WB__WriteReg), 
		 .ID_EX__rs				(rsdata_ID_EX__Ins_rs), 
		 .ID_EX__rt				(rsdata_ID_EX__Ins_rt)
		);	
		
		// Hazard Detection Unit
		HazardDU haz_det (
		 .IF_ID_Write			(enRegSet__IF_ID), 
		 .Stall					(Stall), 
		 .ID_EX__MemRead		(rsdata_ID_EX__M[1]), 
		 .ID_EX__rt				(rsdata_ID_EX__Ins_rt), 
		 .IF_ID__rs				(rsd_Ins__rs), 
		 .IF_ID__rt				(rsd_Ins__rt)
		);
		 
	// Jump/Branch Enable (PCSrc) Circuit
	and and1 (beq,  rsd_M__Branch[2], ~rsd_M__Branch[1], ~rsd_M__Branch[0],  rsd_FL__Zero);		// beq
	and and2 (bne,  rsd_M__Branch[2], ~rsd_M__Branch[1],  rsd_M__Branch[0], ~rsd_FL__Zero);		// bne
	and and3 (blt,  rsd_M__Branch[2],  rsd_M__Branch[1], ~rsd_M__Branch[0],  rsd_FL__LessT);		// blt
	and and4 (bge,  rsd_M__Branch[2],  rsd_M__Branch[1],  rsd_M__Branch[0],  rsd_FL__GreaterTE);	// bge
	or or1 (BranchTestResult, beq, bne, blt, bge);
	assign Jump = ~instruction[31] & ~instruction[30] & ~instruction[29] & instruction[28] & instruction[27] & ~instruction[26];
	assign PCSrc[1] = BranchTestResult;
	assign PCSrc[0] = Jump;
	
	// Flushing Register Sets for Branch Taken
	assign flush__IF_ID 	= BranchTestResult;
	assign flush__ID_EX 	= BranchTestResult;
	assign flush__EX_MEM	= BranchTestResult;
	
	// Writing to the PC
	assign PCWrite = ~Stall;
	
endmodule



// Gate Implementation of Main Control Unit
module Control
(
	output RegWrite, RegDst, MemtoReg, MemRead, MemWrite, 
	output [2:0] Branch,
	output ALUSrc,
	output [1:0] ALUOp,
	input [5:0] Op
);
	
	wire w1, w2, w3, w4, w5, w6, w7, w8, w9;
	
	and and1(w1, ~Op[5], ~Op[4], ~Op[3], ~Op[2], ~Op[1], ~Op[0]);	// R-format
	and and2(w2, ~Op[5], ~Op[4], ~Op[3], ~Op[2], ~Op[1],  Op[0]);	// addi
	and and3(w3,  Op[5], ~Op[4], ~Op[3], ~Op[2],  Op[1],  Op[0]);	// lw
	and and4(w4,  Op[5], ~Op[4],  Op[3], ~Op[2],  Op[1],  Op[0]);	// sw
	and and5(w5, ~Op[5], ~Op[4], ~Op[3],  Op[2], ~Op[1], ~Op[0]);	// beq
	and and6(w6, ~Op[5], ~Op[4], ~Op[3],  Op[2], ~Op[1],  Op[0]);	// bne
	and and7(w7, ~Op[5], ~Op[4],  Op[3], ~Op[2], ~Op[1], ~Op[0]);	// blt
	and and8(w8, ~Op[5], ~Op[4],  Op[3], ~Op[2], ~Op[1],  Op[0]);	// bge
	
	or or1 (RegWrite, w1, w2, w3);	
	assign RegDst = w1;	
	assign MemtoReg = w3;
	
	assign MemRead = w3; 
	assign MemWrite = w4;
	
	or or2 (Branch[2], w5, w6, w7, w8);
	or or3 (Branch[1], w7, w8);
	or or4 (Branch[0], w6, w8);
	
	or or5 (ALUOp[1], w1);
	or or6 (ALUOp[0], w5, w6, w7, w8);
	or or7 (ALUSrc, w2, w3, w4);

endmodule



// Combinational Control for ALU - generates 4 ALU control bits based on function-code and ALUOp bits
module ControlALU
(
	output [3:0] Operation,
	input [1:0] ALUOp,
	input [5:0] F
);

	wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12;
	
	and and1 (w1,  ~ALUOp[1], ~ALUOp[0]);										 // lw, sw, addi (Add)
	and and2 (w2,  ~ALUOp[1],  ALUOp[0]);										 // beq, bne (Subtract)
	and and3 (w3,   ALUOp[1], ~ALUOp[0], ~F[3], ~F[2], ~F[1], ~F[0]);	 // R-type (Add)
	and and4 (w4,   ALUOp[1], ~ALUOp[0], ~F[3], ~F[2],  F[1], ~F[0]);	 // R-type (Subtract)
	and and5 (w5,   ALUOp[1], ~ALUOp[0], ~F[3], ~F[2],  F[1],  F[0]);	 // R-type (Multiply)
	and and6 (w6,   ALUOp[1], ~ALUOp[0], ~F[3],  F[2], ~F[1], ~F[0]);	 // R-type (AND)
	and and7 (w7,   ALUOp[1], ~ALUOp[0], ~F[3],  F[2], ~F[1],  F[0]);	 // R-type (OR)
	and and8 (w8,   ALUOp[1], ~ALUOp[0],  F[3], ~F[2],  F[1], ~F[0]);	 // R-type (set less than)
	and and9 (w9,   ALUOp[1], ~ALUOp[0], ~F[3],  F[2],  F[1], ~F[0]);	 // R-type (NOR)
	and and10(w10,  ALUOp[1], ~ALUOp[0], ~F[3],  F[2],  F[1],  F[0]);	 // R-type (XOR)
	and and11(w11,  ALUOp[1], ~ALUOp[0],  F[3], ~F[2], ~F[1], ~F[0]);	 // R-type (Shift Left)
	and and12(w12,  ALUOp[1], ~ALUOp[0],  F[3], ~F[2], ~F[1],  F[0]);	 // R-type (Shift Right)
	
	or or1 (Operation[3], w9, w10, w11, w12);
	or or2 (Operation[2], w2, w4, w8, w9, w10, w11, w12);
	or or3 (Operation[1], w1, w2, w3, w4, w5, w8, w11, w12);
	or or4 (Operation[0], w5, w7, w8, w10, w12);

endmodule


// Handling DATA HAZARDS

// Forwarding Unit (EX and MEM Hazard)
module ForwardU
#(parameter bAddrREG=5)
(
	output [1:0] ForwA, ForwB,
	input EX_MEM__RegWrite, MEM_WB__RegWrite,
	input [bAddrREG-1:0] EX_MEM__rWR, MEM_WB__rWR,
	input [bAddrREG-1:0] ID_EX__rs, ID_EX__rt
);
	
	wire EX_MEM__bWrite, EX_MEM__bMatch_s, EX_MEM__bMatch_t, EX_MEM__bForw_s, EX_MEM__bForw_t;
	wire MEM_WB__bWrite, MEM_WB__bMatch_s, MEM_WB__bMatch_t, MEM_WB__bForw_s, MEM_WB__bForw_t;
	
	and aEM0 (EX_MEM__bWrite, EX_MEM__RegWrite, |EX_MEM__rWR);
	assign EX_MEM__bMatch_s = ~(|(EX_MEM__rWR^ID_EX__rs));
	assign EX_MEM__bMatch_t = ~(|(EX_MEM__rWR^ID_EX__rt));
	
	and aMW0 (MEM_WB__bWrite, MEM_WB__RegWrite, |MEM_WB__rWR);
	assign MEM_WB__bMatch_s = ~(|(MEM_WB__rWR^ID_EX__rs));
	assign MEM_WB__bMatch_t = ~(|(MEM_WB__rWR^ID_EX__rt));

	and aEMFs (EX_MEM__bForw_s, EX_MEM__bWrite, EX_MEM__bMatch_s);
	and aEMFt (EX_MEM__bForw_t, EX_MEM__bWrite, EX_MEM__bMatch_t);
	and aMWFs (MEM_WB__bForw_s, MEM_WB__bWrite, MEM_WB__bMatch_s); 
	and aMWFt (MEM_WB__bForw_t, MEM_WB__bWrite, MEM_WB__bMatch_t);
	
	assign ForwA[1] = EX_MEM__bForw_s;
	assign ForwA[0] = MEM_WB__bForw_s & (~EX_MEM__bForw_s);
	assign ForwB[1] = EX_MEM__bForw_t;
	assign ForwB[0] = MEM_WB__bForw_t & (~EX_MEM__bForw_t);
	
endmodule

// Hazard Detection Unit (Load-and-Read Hazard)
module HazardDU
#(parameter bAddrREG=5)
(
	output IF_ID_Write, Stall,
	input ID_EX__MemRead,
	input [bAddrREG-1:0] ID_EX__rt,
	input [bAddrREG-1:0] IF_ID__rs, IF_ID__rt
);
	
	wire IF_ID__bMatch_s, IF_ID__bMatch_t;
	
	assign IF_ID__bMatch_s = ~(|(ID_EX__rt^IF_ID__rs));
	assign IF_ID__bMatch_t = ~(|(ID_EX__rt^IF_ID__rt));
	
	assign Stall = ID_EX__MemRead & (IF_ID__bMatch_s | IF_ID__bMatch_t);
	
	assign IF_ID_Write = ~Stall;
	
endmodule
