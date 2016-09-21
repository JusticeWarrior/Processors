`include "cpu_types_pkg.vh"
`include "fetch_latch_if.vh"

module fetch_latch (
	input logic CLK, nRST,
	fetch_latch_if.fl flif
);

	import cpu_types_pkg::*;

	always_ff @(posedge CLK, negedge nRST) begin
		if(!nRST) begin
			instr <= 0;
			out_pc_plus_4 <= 0;
		end
		else begin
			if(flush) begin
				instr <= 0;
				out_pc_plus_4 <= 0;
			end
			else if(en) begin
				instr <= imemload;
				out_pc_plus_4 <= pc_plus_4;
			end
			else begin
				instr <= instr;
				out_pc_plus_4 <= out_pc_plus_4;
			end
		end
	end

endmodule