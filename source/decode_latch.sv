`include "cpu_types_pkg.vh"
`include "decode_latch_if.vh"

module decode_latch (
	input logic CLK, nRST,
	decode_latch_if.fl dlif
);

	import cpu_types_pkg::*;

	always_ff @(posedge CLK, negedge nRST) begin
		if(!nRST) begin
			out_pc_plus_4 <= 0;
			out_porta <= 0;
			out_rdat2 <= 0;
			out_extout <= 0;
			out_ALUSrc <= 0;
			out_Branch <= 0;
			out_bne <= 0;
			out_regWEN <= 0;
			out_halt <= 0;
			out_Jump <= 0;
			out_MemtoReg <= 0;
			out_dREN <= 0;
			out_dWEN <= 0;
			out_ALUop <= ALU_SLTU;
			out_regDst <= 0;
			out_jaddr <= 0;
			out_JAL <= 0;
		end
		else begin
			if(flush) begin
				out_pc_plus_4 <= 0;
				out_porta <= 0;
				out_rdat2 <= 0;
				out_extout <= 0;
				out_ALUSrc <= 0;
				out_Branch <= 0;
				out_bne <= 0;
				out_regWEN <= 0;
				out_halt <= 0;
				out_Jump <= 0;
				out_MemtoReg <= 0;
				out_dREN <= 0;
				out_dWEN <= 0;
				out_ALUop <= ALU_SLTU;
				out_regDst <= 0;
				out_jaddr <= 0;
				out_JAL <= 0;
			end
			else if(en) begin
				out_pc_plus_4 <= pc_plus_4;
				out_porta <= rdat1;
				out_rdat2 <= rdat2;
				out_extout <= extout;
				out_ALUSrc <= ALUSrc;
				out_Branch <= Branch;
				out_bne <= bne;
				out_regWEN <= regWEN;
				out_halt <= halt;
				out_Jump <= Jump;
				out_MemtoReg <= MemtoReg;
				out_dREN <= dREN;
				out_dWEN <= dWEN;
				out_ALUop <= ALUop;
				out_regDst <= regDst;
				out_jaddr <= jaddr;
				out_JAL <= JAL;
			end
			else begin
				out_pc_plus_4 <= out_pc_plus_4;
				out_porta <= out_porta;
				out_rdat2 <= out_rdat2;
				out_extout <= out_extout;
				out_ALUSrc <= out_ALUSrc;
				out_Branch <= out_Branch;
				out_bne <= out_bne;
				out_regWEN <= out_regWEN;
				out_halt <= out_halt;
				out_Jump <= out_Jump;
				out_MemtoReg <= out_MemtoReg;
				out_dREN <= out_dREN;
				out_dWEN <= out_dWEN;
				out_ALUop <= out_ALUop;
				out_regDst <= out_regDST;
				out_jaddr <= out_jaddr;
				out_JAL <= out_JAL;
			end
		end

endmodule