`include "cpu_types_pkg.vh"
`include "decode_latch_if.vh"

module decode_latch (
	input logic CLK, nRST,
	decode_latch_if.fl dlif
);

	import cpu_types_pkg::*;

	always_ff @(posedge CLK, negedge nRST) begin
		if(!nRST) begin
			dlif.out_pc_plus_4 <= 0;
			dlif.out_porta <= 0;
			dlif.out_rdat2 <= 0;
			dlif.out_extout <= 0;
			dlif.out_ALUSrc <= 0;
			dlif.out_Branch <= 0;
			dlif.out_bne <= 0;
			dlif.out_regWEN <= 0;
			dlif.out_halt <= 0;
			dlif.out_Jump <= 0;
			dlif.out_MemtoReg <= 0;
			dlif.out_dREN <= 0;
			dlif.out_dWEN <= 0;
			dlif.out_ALUop <= ALU_SLTU;
			dlif.out_Rd <= '0;
			dlif.out_Rt <= '0;
			dlif.out_regDst <= 0;
			dlif.out_jaddr <= 0;
			dlif.out_JAL <= 0;
		end
		else begin
			if(dlif.flush) begin
				dlif.out_pc_plus_4 <= 0;
				dlif.out_porta <= 0;
				dlif.out_rdat2 <= 0;
				dlif.out_extout <= 0;
				dlif.out_ALUSrc <= 0;
				dlif.out_Branch <= 0;
				dlif.out_bne <= 0;
				dlif.out_regWEN <= 0;
				dlif.out_halt <= 0;
				dlif.out_Jump <= 0;
				dlif.out_MemtoReg <= 0;
				dlif.out_dREN <= 0;
				dlif.out_dWEN <= 0;
				dlif.out_ALUop <= ALU_SLTU;
				dlif.out_Rd <= '0;
				dlif.out_Rt <= '0;
				dlif.out_regDst <= 0;
				dlif.out_jaddr <= 0;
				dlif.out_JAL <= 0;
			end
			else if(dlif.en) begin
				dlif.out_pc_plus_4 <= dlif.pc_plus_4;
				dlif.out_porta <= dlif.rdat1;
				dlif.out_rdat2 <= dlif.rdat2;
				dlif.out_extout <= dlif.extout;
				dlif.out_ALUSrc <= dlif.ALUSrc;
				dlif.out_Branch <= dlif.Branch;
				dlif.out_bne <= dlif.bne;
				dlif.out_regWEN <= dlif.regWEN;
				dlif.out_halt <= dlif.halt;
				dlif.out_Jump <= dlif.Jump;
				dlif.out_MemtoReg <= dlif.MemtoReg;
				dlif.out_dREN <= dlif.dREN;
				dlif.out_dWEN <= dlif.dWEN;
				dlif.out_ALUop <= dlif.ALUop;
				dlif.out_Rd <= dlif.Rd;
				dlif.out_Rt <= dlif.Rt;
				dlif.out_regDst <= dlif.regDst;
				dlif.out_jaddr <= dlif.jaddr;
				dlif.out_JAL <= dlif.JAL;
			end
			else begin
				dlif.out_pc_plus_4 <= dlif.out_pc_plus_4;
				dlif.out_porta <= dlif.out_porta;
				dlif.out_rdat2 <= dlif.out_rdat2;
				dlif.out_extout <= dlif.out_extout;
				dlif.out_ALUSrc <= dlif.out_ALUSrc;
				dlif.out_Branch <= dlif.out_Branch;
				dlif.out_bne <= dlif.out_bne;
				dlif.out_regWEN <= dlif.out_regWEN;
				dlif.out_halt <= dlif.out_halt;
				dlif.out_Jump <= dlif.out_Jump;
				dlif.out_MemtoReg <= dlif.out_MemtoReg;
				dlif.out_dREN <= dlif.out_dREN;
				dlif.out_dWEN <= dlif.out_dWEN;
				dlif.out_ALUop <= dlif.out_ALUop;
				dlif.out_Rd <= dlif.out_Rd;
				dlif.out_Rt <= dlif.out_Rt;
				dlif.out_regDst <= dlif.out_regDst;
				dlif.out_jaddr <= dlif.out_jaddr;
				dlif.out_JAL <= dlif.out_JAL;
			end
		end
	end

endmodule
