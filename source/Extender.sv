/*
	Jordan Huffaker
	jhuffak@purdue.edu

	Extender file
*/

module Extender (
	input logic CLK, nRST, ExtOp, Upper,
	input logic [15:0] imm16,
	output logic [32:0] out
);
	always_comb begin
		if (Upper)
			out = {imm16, 16'd0};
		else if (ExtOp)
			if (imm16[15])
				out = {16'd65535, imm16};
			else
				out = {16'd0, imm16};
		else
			out = {16'd0, imm16};
	end

endmodule
