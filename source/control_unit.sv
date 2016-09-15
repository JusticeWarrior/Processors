/*
	Jordan Huffaker
	jhuffak@purdue.edu

	control unit code
*/

// interface
`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"

module control_unit (
	input wire clk,
	input wire n_rst,
	control_unit_if.cu C
);
	import cpu_types_pkg::*;


	logic [5:0] op, funct;
	logic [4:0] shamt;

	assign op = C.Instr[31:26];
	assign C.Rs = op == LUI ? '0 : C.Instr[25:21];
	assign C.Rd = C.JAL ? 5'd31 : C.Instr[15:11];
	assign C.Rt = op == RTYPE && (funct == SLL || funct == SRL) ? shamt : C.Instr[20:16];
	assign shamt = C.Instr[10:6];
	assign funct = C.Instr[5:0];
	assign C.imm26 = C.Instr[25:0];
	assign C.imm16 = C.Instr[15:0];

	always_comb begin
		C.PCSrc = op == BEQ || op == BNE ? '1 : '0;

		C.ALUSrc = op == RTYPE || op == BEQ || op == BNE ? '0 : '1;
		C.MemWr = op == SW ? '1 : '0;
		C.MemRd = op == LW ? '1 : '0;
		C.MemtoReg = op == LW ? '1 : '0;
		C.RegDst = op == RTYPE || op == JAL ? '0 : '1;
		C.Jmp = op == J ? '1 : '0;
		C.JAL = op == JAL ? '1 : '0;
		C.Halt = op == HALT ? '1 : '0;

		C.PCSrc = '0;
		if (op == BEQ && C.Zero)
			C.PCSrc = '1;
		else if (op == BNE && !C.Zero)
			C.PCSrc = '1;

		C.ALUCtr = ALU_SLL;
		C.JR = '0;
		C.RegWr = '0;
		if (op == RTYPE) begin
			// implement funct assignments here
			if (funct == SLL) begin
				C.ALUCtr = ALU_SLL;
				C.RegWr = '1;
			end else if (funct == SRL) begin
				C.ALUCtr = ALU_SRL;
				C.RegWr = '1;
			end else if (funct == JR) begin
				C.JR = '1;
			end else if (funct == ADD) begin
				C.ALUCtr = ALU_ADD;
				C.RegWr = '1;
			end else if (funct == ADDU) begin
				C.ALUCtr = ALU_ADD;
				C.RegWr = '1;
			end else if (funct == SUB) begin
				C.ALUCtr = ALU_SUB;
				C.RegWr = '1;
			end else if (funct == SUBU) begin
				C.ALUCtr = ALU_SUB;
				C.RegWr = '1;
			end else if (funct == AND) begin
				C.ALUCtr = ALU_AND;
				C.RegWr = '1;
			end else if (funct == OR) begin
				C.ALUCtr = ALU_OR;
				C.RegWr = '1;
			end else if (funct == XOR) begin
				C.ALUCtr = ALU_XOR;
				C.RegWr = '1;
			end else if (funct == NOR) begin
				C.ALUCtr = ALU_NOR;
				C.RegWr = '1;
			end else if (funct == SLT) begin
				C.ALUCtr = ALU_SLT;
				C.RegWr = '1;
			end else if (funct == SLTU) begin
				C.ALUCtr = ALU_SLTU;
				C.RegWr = '1;
			end
		end else if (op == ADDI) begin
			C.ALUCtr = ALU_ADD;
			C.RegWr = '1;
		end else if (op == ADDIU) begin
			C.ALUCtr = ALU_ADD;
			C.RegWr = '1;
		end else if (op == SLTI) begin
			C.ALUCtr = ALU_SLT;
			C.RegWr = '1;
		end else if (op == SLTIU) begin
			C.ALUCtr = ALU_SLT;
			C.RegWr = '1;
		end else if (op == ANDI) begin
			C.ALUCtr = ALU_AND;
			C.RegWr = '1;
		end else if (op == ORI) begin
			C.ALUCtr = ALU_OR;
			C.RegWr = '1;
		end else if (op == XORI) begin
			C.ALUCtr = ALU_XOR;
			C.RegWr = '1;
		end else if (op == LUI) begin
			C.ALUCtr = ALU_ADD;
			C.RegWr = '1;
		end else if (op == LW) begin
			C.ALUCtr = ALU_ADD;
			C.RegWr = '1;
		end else if (op == SW) begin
			C.ALUCtr = ALU_ADD;
		end else if (op == BEQ || op == BNE) begin
			C.ALUCtr = ALU_SUB;
		end else if (op == JAL) begin
			C.RegWr = '1;
		end

		C.ExtOp = '0;
		C.Upper = '0;
		if (op == ADDI)
			C.ExtOp = '1;
		else if (op == ADDIU)
			C.ExtOp = '1;
		else if (op == SLTI)
			C.ExtOp = '1;
		else if (op == SLTIU)
			C.ExtOp = '1;
		else if (op == ANDI)
			C.ExtOp = '0;
		else if (op == ORI)
			C.ExtOp = '0;
		else if (op == XORI)
			C.ExtOp = '0;
		else if (op == LUI)
			C.Upper = '1;
		else if (op == LW)
			C.ExtOp = '1;
		else if (op == SW)
			C.ExtOp = '1;
		else if (op == BEQ)
			C.ExtOp = '1;
		else if (op == BNE)
			C.ExtOp = '1;

	end

endmodule
