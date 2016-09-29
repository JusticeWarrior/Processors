/*
  Jordan Huffaker
  jhuffak@purdue.edu

  ALU code
*/

// interface
`include "ALU_if.vh"
`include "cpu_types_pkg.vh"

module ALU (
  ALU_if.rf A
);

	import cpu_types_pkg::*;

	always_comb begin
		A.neg = '0;
		A.zero = '0;
		A.overflow = '0;
		A.portOut = '0;

		if (A.ALUOP == ALU_SLL)
			A.portOut = A.portA << A.portB;
		if (A.ALUOP == ALU_SRL)
			A.portOut = A.portA >> A.portB;
		if (A.ALUOP == ALU_ADD)
			A.portOut = A.portA + A.portB;
		if (A.ALUOP == ALU_SUB)
			A.portOut = A.portA - A.portB;
		if (A.ALUOP == ALU_AND)
			A.portOut = A.portA & A.portB;
		if (A.ALUOP == ALU_OR)
			A.portOut = A.portA | A.portB;
		if (A.ALUOP == ALU_XOR)
			A.portOut = A.portA ^ A.portB;
		if (A.ALUOP == ALU_NOR)
			A.portOut = ~(A.portA | A.portB);
		if (A.ALUOP == ALU_SLT)
			A.portOut = ($signed(A.portA) < $signed(A.portB) ? 1'b1 : 1'b0);
		if (A.ALUOP == ALU_SLTU)
			A.portOut = ((A.portA) < (A.portB) ? 1'b1 : 1'b0);

		// CREDIT: Martin Zabel - http://stackoverflow.com/questions/34534304/calculating-the-overflow-flag-in-an-alu
		if (A.ALUOP == ALU_ADD || A.ALUOP == ALU_SUB)
			A.overflow = (!A.portA[31] && !A.portB[31] && A.portOut[31]) || (A.portA[31] && A.portB[31] && !A.portOut[31]);
		if (A.portOut == '0)
			A.zero = 1'b1;
		if (A.portOut[31] == 1'b1)
			A.neg = 1'b1;
	end

endmodule
