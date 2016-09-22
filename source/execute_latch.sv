`include "cpu_types_pkg.vh"
`include "execute_latch_if.vh"

module execute_latch (
	input logic CLK, nRST,
	execute_latch_if.fl elif
);

	import cpu_types_pkg::*;

	always_ff @(posedge CLK, negedge nRST) begin
		if(!nRST) begin
			elif.out_pc_plus_4 <= 0;
			elif.out_baddr <= 0;
			elif.out_zero <= 0;
			elif.out_portout <= 0;
			elif.out_rdat2 <= 0;
			elif.out_Branch <= 0;
			elif.out_bne <= 0;
			elif.out_regWEN <= 0;
			elif.out_halt <= 0;
			elif.out_Jump <= 0;
			elif.out_JAL <= 0;
			elif.out_MemtoReg <= 0;
			elif.out_dREN <= 0;
			elif.out_dWEN <= 0;
			elif.out_wsel <= 0;
			elif.out_jaddr <= 0;
			elif.out_Rd <= 0;
			elif.out_Rt <= 0;
		end
		else begin
			if(elif.flush) begin
				elif.out_pc_plus_4 <= 0;
				elif.out_baddr <= 0;
				elif.out_zero <= 0;
				elif.out_portout <= 0;
				elif.out_rdat2 <= 0;
				elif.out_Branch <= 0;
				elif.out_bne <= 0;
				elif.out_regWEN <= 0;
				elif.out_halt <= 0;
				elif.out_Jump <= 0;
				elif.out_JAL <= 0;
				elif.out_MemtoReg <= 0;
				elif.out_dREN <= 0;
				elif.out_dWEN <= 0;
				elif.out_wsel <= 0;
				elif.out_jaddr <= 0;
				elif.out_Rd <= 0;
				elif.out_Rt <= 0;
			end
			else if(elif.en) begin
				elif.out_pc_plus_4 <= elif.pc_plus_4;
				elif.out_baddr <= elif.baddr;
				elif.out_zero <= elif.zero;
				elif.out_portout <= elif.portout;
				elif.out_rdat2 <= elif.rdat2;
				elif.out_Branch <= elif.Branch;
				elif.out_bne <= elif.bne;
				elif.out_regWEN <= elif.regWEN;
				elif.out_halt <= elif.halt;
				elif.out_Jump <= elif.Jump;
				elif.out_JAL <= elif.JAL;
				elif.out_MemtoReg <= elif.MemtoReg;
				elif.out_dREN <= elif.dREN;
				elif.out_dWEN <= elif.dWEN;
				elif.out_wsel <= elif.wsel;
				elif.out_jaddr <= elif.jaddr;
				elif.out_Rd <= elif.Rd;
				elif.out_Rt <= elif.Rt;
			end
			else begin
				elif.out_pc_plus_4 <= elif.out_pc_plus_4;
				elif.out_baddr <= elif.out_baddr;
				elif.out_zero <= elif.out_zero;
				elif.out_portout <= elif.out_portout;
				elif.out_rdat2 <= elif.out_rdat2;
				elif.out_Branch <= elif.out_Branch;
				elif.out_bne <= elif.out_bne;
				elif.out_regWEN <= elif.out_regWEN;
				elif.out_halt <= elif.out_halt;
				elif.out_Jump <= elif.out_Jump;
				elif.out_JAL <= elif.out_JAL;
				elif.out_MemtoReg <= elif.out_MemtoReg;
				elif.out_dREN <= elif.out_dREN;
				elif.out_dWEN <= elif.out_dWEN;
				elif.out_wsel <= elif.out_wsel;
				elif.out_jaddr <= elif.out_jaddr;
				elif.out_Rd <= elif.out_Rd;
				elif.out_Rt <= elif.out_Rt;
			end
		end

endmodule