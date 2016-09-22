`include "cpu_types_pkg.vh"
`include "execute_latch_if.vh"

module execute_latch (
	input logic CLK, nRST,
	execute_latch_if.fl elif
);

	import cpu_types_pkg::*;

	always_ff @(posedge CLK, negedge nRST) begin
		if(!nRST) begin
			out_pc_plus_4 <= 0;
			out_baddr <= 0;
			out_zero <= 0;
			out_portout <= 0;
			out_rdat2 <= 0;
			out_Branch <= 0;
			out_bne <= 0;
			out_regWEN <= 0;
			out_halt <= 0;
			out_Jump <= 0;
			out_JAL <= 0;
			out_MemtoReg <= 0;
			out_dREN <= 0;
			out_dWEN <= 0;
			out_wsel <= 0;
			out_jaddr <= 0;
			out_Rd <= 0;
			out_Rt <= 0;
		end
		else begin
			if(flush) begin
				out_pc_plus_4 <= 0;
				out_baddr <= 0;
				out_zero <= 0;
				out_portout <= 0;
				out_rdat2 <= 0;
				out_Branch <= 0;
				out_bne <= 0;
				out_regWEN <= 0;
				out_halt <= 0;
				out_Jump <= 0;
				out_JAL <= 0;
				out_MemtoReg <= 0;
				out_dREN <= 0;
				out_dWEN <= 0;
				out_wsel <= 0;
				out_jaddr <= 0;
				out_Rd <= 0;
				out_Rt <= 0;
			end
			else if(en) begin
				out_pc_plus_4 <= pc_plus_4;
				out_baddr <= baddr;
				out_zero <= zero;
				out_portout <= portout;
				out_rdat2 <= rdat2;
				out_Branch <= Branch;
				out_bne <= bne;
				out_regWEN <= regWEN;
				out_halt <= halt;
				out_Jump <= Jump;
				out_JAL <= JAL;
				out_MemtoReg <= MemtoReg;
				out_dREN <= dREN;
				out_dWEN <= dWEN;
				out_wsel <= wsel;
				out_jaddr <= jaddr;
				out_Rd <= Rd;
				out_Rt <= Rt;
			end
			else begin
				out_pc_plus_4 <= out_pc_plus_4;
				out_baddr <= out_baddr;
				out_zero <= out_zero;
				out_portout <= out_portout;
				out_rdat2 <= out_rdat2;
				out_Branch <= out_Branch;
				out_bne <= out_bne;
				out_regWEN <= out_regWEN;
				out_halt <= out_halt;
				out_Jump <= out_Jump;
				out_JAL <= out_JAL;
				out_MemtoReg <= out_MemtoReg;
				out_dREN <= out_dREN;
				out_dWEN <= out_dWEN;
				out_wsel <= out_wsel;
				out_jaddr <= out_jaddr;
				out_Rd <= out_Rd;
				out_Rt <= out_Rt;
			end
		end

endmodule