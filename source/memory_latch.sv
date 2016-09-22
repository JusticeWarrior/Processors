`include "cpu_types_pkg.vh"
`include "memory_latch_if.vh"

module memory_latch (
	input logic CLK, nRST,
	memory_latch_if.fl mlif
);

	import cpu_types_pkg::*;

	always_ff @(posedge CLK, negedge nRST) begin
		if(!nRST) begin
			out_pc_plus_4 <= 0;
			out_portout <= 0;
			out_regWEN <= 0;
			out_halt <= 0;
			out_Jump <= 0;
			out_JAL <= 0;
			out_MemtoReg <= 0;
			out_wsel <= 0;
			out_jaddr <= 0;
			out_dload <= 0;
		end
		else begin
			if(flush) begin
				out_pc_plus_4 <= 0;
				out_portout <= 0;
				out_regWEN <= 0;
				out_halt <= 0;
				out_Jump <= 0;
				out_JAL <= 0;
				out_MemtoReg <= 0;
				out_wsel <= 0;
				out_jaddr <= 0;
				out_dload <= 0;
			end
			else if(en) begin
				out_pc_plus_4 <= pc_plus_4;
				out_portout <= portout;
				out_regWEN <= regWEN;
				out_halt <= halt;
				out_Jump <= Jump;
				out_JAL <= JAL;
				out_MemtoReg <= MemtoReg;
				out_wsel <= wsel;
				out_jaddr <= jaddr;
				out_dload <= dload;
			end
			else begin
				out_pc_plus_4 <= out_pc_plus_4;
				out_portout <= out_portout;
				out_regWEN <= out_regWEN;
				out_halt <= out_halt;
				out_Jump <= out_Jump;
				out_JAL <= out_JAL;
				out_MemtoReg <= out_MemtoReg;
				out_wsel <= out_wsel;
				out_jaddr <= out_jaddr;
				out_dload <= out_dload;
			end
		end

endmodule