/*
	Jordan Huffaker
	jhuffak@purdue.edu

	control unit test bench
*/

// mapped needs this
`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module control_unit_tb;

	import cpu_types_pkg::*;

	parameter PERIOD = 10;

	logic CLK = 0, nRST;

	// test vars
	int v1 = 1;
	int v2 = 4721;
	int v3 = 25119;

	// clock
	always #(PERIOD/2) CLK++;

	// interface
	control_unit_if cuif ();
	// test program
	test PROG ();
	// DUT
`ifndef MAPPED
	control_unit DUT(CLK, nRST, cuif);
`else
	control_unit DUT(
		.\cuif.Zero (cuif.Zero),
		.\cuif.Instr (cuif.Instr),
		.\cuif.MemtoReg (cuif.MemtoReg),
		.\cuif.ALUCtr (cuif.ALUCtr),
		.\cuif.Rd (cuif.Rd),
		.\cuif.Rt (cuif.Rt),
		.\cuif.Rs (cuif.Rs),
		.\cuif.PCSrc (cuif.PCSrc),
		.\cuif.Jmp (cuif.Jmp),
		.\cuif.imm26 (cuif.imm26),
		.\cuif.RegDst (cuif.RegDst),
		.\cuif.RegWr (cuif.RegWr),
		.\cuif.JAL (cuif.JAL),
		.\cuif.imm16 (cuif.imm16),
		.\cuif.Upper (cuif.Upper),
		.\cuif.ExtOp (cuif.ExtOp),
		.\cuif.ALUSrc (cuif.ALUSrc),
		.\cuif.MemRd (cuif.MemRd),
		.\cuif.MemWr (cuif.MemWr),
		.\cuif.Halt (cuif.Halt),
		.\cuif.JR (cuif.JR),
		.\cuif.branch (cuif.branch),
		.\cuif.bne (cuif.bne),
		.\nRST (nRST),
		.\CLK (CLK)
	);
`endif

	initial begin
	nRST = 1'b0;
	cuif.Zero = '0;
	cuif.Instr = {ADDIU, 5'd2, 5'd3, 16'd4};

	#PERIOD;

	nRST = 1'b1;

	#PERIOD;

	// i type
	assert (cuif.Rs == 5'd2) else
		$display("1 DIDNT SET INITIAL dren CORRECTLY");
	assert (cuif.Rt == 5'd3) else
		$display("1 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("1 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("1 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("1 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '1) else
		$display("1 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '1) else
		$display("1 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_ADD) else
		$display("1 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '1) else
		$display("1 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '0) else
		$display("1 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("1 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("1 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("1 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("1 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("1 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("1 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("1 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("1 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("1 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {ADDI, 5'd2, 5'd3, 16'd4};

	#PERIOD;

	// i type
	assert (cuif.Rs == 5'd2) else
		$display("2 DIDNT SET INITIAL dren CORRECTLY");
	assert (cuif.Rt == 5'd3) else
		$display("2 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("2 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("2 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("2 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '1) else
		$display("2 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '1) else
		$display("2 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_ADD) else
		$display("2 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '1) else
		$display("2 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '0) else
		$display("2 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("2 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("2 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("2 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("2 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("2 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("2 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("2 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("2 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("2 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {ANDI, 5'd2, 5'd3, 16'd4};

	#PERIOD;

	// i type
	assert (cuif.Rs == 5'd2) else
		$display("3 DIDNT SET INITIAL dren CORRECTLY");
	assert (cuif.Rt == 5'd3) else
		$display("3 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("3 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("3 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("3 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '1) else
		$display("3 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '1) else
		$display("3 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_AND) else
		$display("3 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '0) else
		$display("3 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '0) else
		$display("3 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("3 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("3 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("3 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("3 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("3 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("3 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("3 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("3 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("3 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '1;
	cuif.Instr = {BEQ, 5'd2, 5'd2, 16'd4};

	#PERIOD;

	// i type
	assert (cuif.Rs == 5'd2) else
		$display("4 DIDNT SET INITIAL dren CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("4 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("4 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("4 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("4 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '1) else
		$display("4 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '0) else
		$display("4 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_SUB) else
		$display("4 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '1) else
		$display("4 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '0) else
		$display("4 DIDNT SET Upper CORRECTLY");
	//assert (cuif.MemtoReg == '0) else
	//	$display("4 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("4 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '0) else
		$display("4 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("4 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("4 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("4 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("4 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("4 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '1) else
		$display("4 DIDNT SET PCSrc CORRECTLY");
	assert (cuif.branch == '1) else
		$display("4 DIDNT SET branch CORRECTLY");
	assert (cuif.bne == '0) else
		$display("4 DIDNT SET bne CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {BNE, 5'd2, 5'd2, 16'd4};

	#PERIOD;

	// i type
	assert (cuif.Rs == 5'd2) else
		$display("5 DIDNT SET INITIAL dren CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("5 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("5 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("5 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("5 DIDNT SET imm26 CORRECTLY");
	//assert (cuif.RegDst == '0) else
	//	$display("5 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '0) else
		$display("5 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_SUB) else
		$display("5 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '1) else
		$display("5 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '0) else
		$display("5 DIDNT SET Upper CORRECTLY");
	//assert (cuif.MemtoReg == '0) else
	//	$display("5 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("5 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '0) else
		$display("5 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("5 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("5 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("5 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("5 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("5 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '1) else
		$display("5 DIDNT SET PCSrc CORRECTLY");
	assert (cuif.branch == '0) else
		$display("4 DIDNT SET branch CORRECTLY");
	assert (cuif.bne == '1) else
		$display("4 DIDNT SET bne CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {LUI, 5'd2, 5'd2, 16'd4};

	#PERIOD;

	// i type
	assert (cuif.Rs == 5'd0) else
		$display("6 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("6 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("6 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("6 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("6 DIDNT SET imm26 CORRECTLY");
	//assert (cuif.RegDst == '0) else
	//	$display("6 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '1) else
		$display("6 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_ADD) else
		$display("6 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '0) else
		$display("6 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '1) else
		$display("6 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("6 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("6 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("6 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("6 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("6 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("6 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("6 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("6 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("6 DIDNT SET PCSrc CORRECTLY");
	assert (cuif.branch == '0) else
		$display("4 DIDNT SET branch CORRECTLY");
	assert (cuif.bne == '0) else
		$display("4 DIDNT SET bne CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {LW, 5'd2, 5'd2, 16'd4};

	#PERIOD;

	// i type
	//assert (cuif.Rs == 5'd0) else
	//	$display("7 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("7 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("7 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("7 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '1) else
		$display("7 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '1) else
		$display("7 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_ADD) else
		$display("7 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '1) else
		$display("7 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '0) else
		$display("7 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '1) else
		$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("7 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("7 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '1) else
		$display("7 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("7 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("7 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("7 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("7 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("7 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {ORI, 5'd2, 5'd2, 16'd4};

	#PERIOD;

	// i type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("8 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("7 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '1) else
		$display("8 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '1) else
		$display("8 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_OR) else
		$display("8 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '0) else
		$display("8 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '0) else
		$display("8 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("8 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {SLTI, 5'd2, 5'd2, 16'd4};

	#PERIOD;

	// i type
	assert (cuif.Rs == 5'd2) else
		$display("9 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("9 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("7 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("9 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '1) else
		$display("9 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '1) else
		$display("9 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_SLT) else
		$display("9 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '1) else
		$display("9 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '0) else
		$display("9 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("9 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("9 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("9 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("9 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("9 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("9 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("9 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("9 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("9 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {SLTIU, 5'd2, 5'd2, 16'd4};

	#PERIOD;

	// i type
	assert (cuif.Rs == 5'd2) else
		$display("1 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("1 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("7 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("1 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '1) else
		$display("1 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '1) else
		$display("1 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_SLT) else
		$display("1 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '1) else
		$display("1 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '0) else
		$display("1 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("1 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("1 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("1 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("1 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("1 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("1 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("1 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("1 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("1 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {SW, 5'd2, 5'd2, 16'd4};

	#PERIOD;

	// i type
	assert (cuif.Rs == 5'd2) else
		$display("2 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("2 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("2 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("2 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '1) else
		$display("2 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '1) else
		$display("2 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_ADD) else
		$display("2 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '1) else
		$display("2 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '0) else
		$display("2 DIDNT SET Upper CORRECTLY");
	//assert (cuif.MemtoReg == '0) else
	//	$display("2 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("2 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '0) else
		$display("2 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("2 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '1) else
		$display("2 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("2 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("2 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("2 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("2 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {XORI, 5'd2, 5'd2, 16'd4};

	#PERIOD;

	// i type
	assert (cuif.Rs == 5'd2) else
		$display("3 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("3 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("3 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("3 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("3 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '1) else
		$display("3 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '1) else
		$display("3 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_XOR) else
		$display("3 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '0) else
		$display("3 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '0) else
		$display("3 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("3 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("3 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("3 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("3 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("3 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("3 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("3 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("3 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("3 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {J, 26'd4};

	#PERIOD;

	// i type
	//assert (cuif.Rs == 5'd2) else
	//	$display("7 DIDNT SET Rs CORRECTLY");
	//assert (cuif.Rt == 5'd2) else
	//	$display("7 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("7 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("7 DIDNT SET imm16 CORRECTLY");
	assert (cuif.imm26 == 26'd4) else
		$display("4 DIDNT SET imm26 CORRECTLY");
	//assert (cuif.RegDst == '1) else
	//	$display("7 DIDNT SET RegDst CORRECTLY");
	//assert (cuif.ALUSrc == '1) else
	//	$display("7 DIDNT SET ALUSrc CORRECTLY");
	//assert (cuif.ALUCtr == ALU_XOR) else
	//	$display("7 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("7 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("7 DIDNT SET Upper CORRECTLY");
	//assert (cuif.MemtoReg == '0) else
	//	$display("7 DIDNT SET MemtoReg CORRECTLY");
	//assert (cuif.JAL == '0) else
	//	$display("7 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '0) else
		$display("4 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("4 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("4 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("4 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '1) else
		$display("4 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("4 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("4 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {JAL, 5'd2, 5'd2, 16'd4};

	#PERIOD;

	// i type
	//assert (cuif.Rs == 5'd2) else
	//	$display("7 DIDNT SET Rs CORRECTLY");
	//assert (cuif.Rt == 5'd2) else
	//	$display("7 DIDNT SET Rt CORRECTLY");
	assert (cuif.Rd == 5'd31) else
		$display("6 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("7 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '0) else
		$display("6 DIDNT SET RegDst CORRECTLY");
	//assert (cuif.ALUSrc == '0) else
	//	$display("6 DIDNT SET ALUSrc CORRECTLY");
	//assert (cuif.ALUCtr == ALU_XOR) else
	//	$display("7 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("7 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("7 DIDNT SET Upper CORRECTLY");
	//assert (cuif.MemtoReg == '0) else
	//	$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '1) else
		$display("6 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("6 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("6 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("6 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("6 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("6 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("6 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("6 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {HALT, 5'd2, 5'd2, 16'd4};

	#PERIOD;

	// i type
	//assert (cuif.Rs == 5'd2) else
	//	$display("7 DIDNT SET Rs CORRECTLY");
	//assert (cuif.Rt == 5'd2) else
	//	$display("7 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd3) else
	//	$display("7 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("7 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	//assert (cuif.RegDst == '1) else
	//	$display("7 DIDNT SET RegDst CORRECTLY");
	//assert (cuif.ALUSrc == '1) else
	//	$display("7 DIDNT SET ALUSrc CORRECTLY");
	//assert (cuif.ALUCtr == ALU_XOR) else
	//	$display("7 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("7 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("7 DIDNT SET Upper CORRECTLY");
	//assert (cuif.MemtoReg == '0) else
	//	$display("7 DIDNT SET MemtoReg CORRECTLY");
	//assert (cuif.JAL == '0) else
	//	$display("7 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '0) else
		$display("7 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("7 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("7 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '1) else
		$display("7 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("7 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("7 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("7 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {RTYPE, 5'd2, 5'd2, 5'd2, 5'd4, ADDU};

	#PERIOD;

	// r type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("8 DIDNT SET Rt CORRECTLY");
	assert (cuif.Rd == 5'd2) else
		$display("8 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '0) else
		$display("8 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '0) else
		$display("8 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_ADD) else
		$display("8 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("8 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("8 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {RTYPE, 5'd2, 5'd2, 5'd2, 5'd4, ADD};

	#PERIOD;

	// r type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("8 DIDNT SET Rt CORRECTLY");
	assert (cuif.Rd == 5'd2) else
		$display("8 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '0) else
		$display("8 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '0) else
		$display("8 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_ADD) else
		$display("8 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("8 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("8 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {RTYPE, 5'd2, 5'd2, 5'd2, 5'd4, AND};

	#PERIOD;

	// r type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("8 DIDNT SET Rt CORRECTLY");
	assert (cuif.Rd == 5'd2) else
		$display("8 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '0) else
		$display("8 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '0) else
		$display("8 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_AND) else
		$display("8 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("8 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("8 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {RTYPE, 5'd2, 5'd2, 5'd2, 5'd4, JR};

	#PERIOD;

	// r type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	//assert (cuif.Rt == 5'd2) else
	//	$display("8 DIDNT SET Rt CORRECTLY");
	//assert (cuif.Rd == 5'd2) else
	//	$display("8 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	//assert (cuif.RegDst == '0) else
	//	$display("8 DIDNT SET RegDst CORRECTLY");
	//assert (cuif.ALUSrc == '0) else
	//	$display("8 DIDNT SET ALUSrc CORRECTLY");
	//assert (cuif.ALUCtr == ALU_AND) else
	//	$display("8 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("8 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("8 DIDNT SET Upper CORRECTLY");
	//assert (cuif.MemtoReg == '0) else
	//	$display("7 DIDNT SET MemtoReg CORRECTLY");
	//assert (cuif.JAL == '0) else
	//	$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '0) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '1) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {RTYPE, 5'd2, 5'd2, 5'd2, 5'd4, NOR};

	#PERIOD;

	// r type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("8 DIDNT SET Rt CORRECTLY");
	assert (cuif.Rd == 5'd2) else
		$display("8 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '0) else
		$display("8 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '0) else
		$display("8 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_NOR) else
		$display("8 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("8 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("8 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {RTYPE, 5'd2, 5'd2, 5'd2, 5'd4, OR};

	#PERIOD;

	// r type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("8 DIDNT SET Rt CORRECTLY");
	assert (cuif.Rd == 5'd2) else
		$display("8 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '0) else
		$display("8 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '0) else
		$display("8 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_OR) else
		$display("8 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("8 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("8 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {RTYPE, 5'd2, 5'd2, 5'd2, 5'd4, SLT};

	#PERIOD;

	// r type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("8 DIDNT SET Rt CORRECTLY");
	assert (cuif.Rd == 5'd2) else
		$display("8 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '0) else
		$display("8 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '0) else
		$display("8 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_SLT) else
		$display("8 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("8 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("8 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {RTYPE, 5'd2, 5'd2, 5'd2, 5'd4, SLTU};

	#PERIOD;

	// r type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("8 DIDNT SET Rt CORRECTLY");
	assert (cuif.Rd == 5'd2) else
		$display("8 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '0) else
		$display("8 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '0) else
		$display("8 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_SLTU) else
		$display("8 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("8 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("8 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {RTYPE, 5'd2, 5'd2, 5'd2, 5'd4, SLL};

	#PERIOD;

	// r type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	//assert (cuif.Rt == 5'd4) else
	//	$display("8 DIDNT SET Rt CORRECTLY");
	assert (cuif.Rd == 5'd2) else
		$display("8 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '0) else
		$display("8 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '1) else
		$display("8 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_SLL) else
		$display("8 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '0) else
		$display("8 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '0) else
		$display("8 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {RTYPE, 5'd2, 5'd2, 5'd2, 5'd4, SRL};

	#PERIOD;

	// r type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	//assert (cuif.Rt == 5'd4) else
	//	$display("8 DIDNT SET Rt CORRECTLY");
	assert (cuif.Rd == 5'd2) else
		$display("8 DIDNT SET Rd CORRECTLY");
	assert (cuif.imm16 == 16'd4) else
		$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '0) else
		$display("8 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '1) else
		$display("8 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_SRL) else
		$display("8 DIDNT SET ALUCtr CORRECTLY");
	assert (cuif.ExtOp == '0) else
		$display("8 DIDNT SET ExtOp CORRECTLY");
	assert (cuif.Upper == '0) else
		$display("8 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {RTYPE, 5'd2, 5'd2, 5'd2, 5'd4, SUBU};

	#PERIOD;

	// r type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("8 DIDNT SET Rt CORRECTLY");
	assert (cuif.Rd == 5'd2) else
		$display("8 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '0) else
		$display("8 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '0) else
		$display("8 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_SUB) else
		$display("8 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("8 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("8 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {RTYPE, 5'd2, 5'd2, 5'd2, 5'd4, SUB};

	#PERIOD;

	// r type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("8 DIDNT SET Rt CORRECTLY");
	assert (cuif.Rd == 5'd2) else
		$display("8 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '0) else
		$display("8 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '0) else
		$display("8 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_SUB) else
		$display("8 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("8 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("8 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");

	cuif.Zero = '0;
	cuif.Instr = {RTYPE, 5'd2, 5'd2, 5'd2, 5'd4, XOR};

	#PERIOD;

	// r type
	assert (cuif.Rs == 5'd2) else
		$display("8 DIDNT SET Rs CORRECTLY");
	assert (cuif.Rt == 5'd2) else
		$display("8 DIDNT SET Rt CORRECTLY");
	assert (cuif.Rd == 5'd2) else
		$display("8 DIDNT SET Rd CORRECTLY");
	//assert (cuif.imm16 == 16'd4) else
	//	$display("8 DIDNT SET imm16 CORRECTLY");
	//assert (cuif.imm26 == 26'd4) else
	//	$display("7 DIDNT SET imm26 CORRECTLY");
	assert (cuif.RegDst == '0) else
		$display("8 DIDNT SET RegDst CORRECTLY");
	assert (cuif.ALUSrc == '0) else
		$display("8 DIDNT SET ALUSrc CORRECTLY");
	assert (cuif.ALUCtr == ALU_XOR) else
		$display("8 DIDNT SET ALUCtr CORRECTLY");
	//assert (cuif.ExtOp == '0) else
	//	$display("8 DIDNT SET ExtOp CORRECTLY");
	//assert (cuif.Upper == '0) else
	//	$display("8 DIDNT SET Upper CORRECTLY");
	assert (cuif.MemtoReg == '0) else
		$display("7 DIDNT SET MemtoReg CORRECTLY");
	assert (cuif.JAL == '0) else
		$display("8 DIDNT SET JAL CORRECTLY");
	assert (cuif.RegWr == '1) else
		$display("8 DIDNT SET RegWr CORRECTLY");
	assert (cuif.MemRd == '0) else
		$display("8 DIDNT SET MemRd CORRECTLY");
	assert (cuif.MemWr == '0) else
		$display("8 DIDNT SET MemWr CORRECTLY");
	assert (cuif.Halt == '0) else
		$display("8 DIDNT SET Halt CORRECTLY");
	assert (cuif.Jmp == '0) else
		$display("8 DIDNT SET Jmp CORRECTLY");
	assert (cuif.JR == '0) else
		$display("8 DIDNT SET JR CORRECTLY");
	assert (cuif.PCSrc == '0) else
		$display("8 DIDNT SET PCSrc CORRECTLY");


	$display("ALL TESTS FINISHED!");

	end

endmodule

program test;
endprogram
