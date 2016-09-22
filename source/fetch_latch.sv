`include "cpu_types_pkg.vh"
`include "fetch_latch_if.vh"

module fetch_latch (
	input logic CLK, nRST,
	fetch_latch_if.fl flif
);

	import cpu_types_pkg::*;

	always_ff @(posedge CLK, negedge nRST) begin
		if(!nRST) begin
			flif.instr <= 0;
			flif.out_pc_plus_4 <= 0;
		end
		else begin
			if(flif.flush) begin
				flif.instr <= 0;
				flif.out_pc_plus_4 <= 0;
			end
			else if(flif.en) begin
				flif.instr <= flif.imemload;
				flif.out_pc_plus_4 <= flif.pc_plus_4;
			end
			else begin
				flif.instr <= flif.instr;
				flif.out_pc_plus_4 <= flif.out_pc_plus_4;
			end
		end
	end

endmodule
