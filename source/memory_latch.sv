`include "cpu_types_pkg.vh"
`include "memory_latch_if.vh"

module memory_latch (
	input logic CLK, nRST,
	memory_latch_if.fl mlif
);

	import cpu_types_pkg::*;

	word_t internal_dload;

	always_ff @(posedge CLK, negedge nRST) begin
		if(!nRST) begin
			mlif.out_pc_plus_4 <= 0;
			mlif.out_portout <= 0;
			mlif.out_regWEN <= 0;
			mlif.out_halt <= 0;
			mlif.out_Jump <= 0;
			mlif.out_JAL <= 0;
			mlif.out_MemtoReg <= 0;
			mlif.out_wsel <= 0;
			mlif.out_jaddr <= 0;
			mlif.out_dload <= 0;
			internal_dload <= '0;
			mlif.out_datomic <= 0;
		end
		else begin
			if (mlif.dhit)
				internal_dload <= mlif.dload;
			else
				internal_dload <= internal_dload;

			if(mlif.flush) begin
				mlif.out_pc_plus_4 <= 0;
				mlif.out_portout <= 0;
				mlif.out_regWEN <= 0;
				mlif.out_halt <= 0;
				mlif.out_Jump <= 0;
				mlif.out_JAL <= 0;
				mlif.out_MemtoReg <= 0;
				mlif.out_wsel <= 0;
				mlif.out_jaddr <= 0;
				mlif.out_dload <= 0;
				mlif.out_datomic <= 0;
				// internal_dload is not flushed here!!!!
			end
			else if(mlif.en) begin
				mlif.out_pc_plus_4 <= mlif.pc_plus_4;
				mlif.out_portout <= mlif.portout;
				mlif.out_regWEN <= mlif.regWEN;
				mlif.out_halt <= mlif.halt;
				mlif.out_Jump <= mlif.Jump;
				mlif.out_JAL <= mlif.JAL;
				mlif.out_MemtoReg <= mlif.MemtoReg;
				mlif.out_wsel <= mlif.wsel;
				mlif.out_jaddr <= mlif.jaddr;
				//mlif.out_dload <= mlif.dload;
				mlif.out_dload <= internal_dload;
				mlif.out_datomic <= mlif.datomic;
			end
			else begin
				mlif.out_pc_plus_4 <= mlif.out_pc_plus_4;
				mlif.out_portout <= mlif.out_portout;
				mlif.out_regWEN <= mlif.out_regWEN;
				mlif.out_halt <= mlif.out_halt;
				mlif.out_Jump <= mlif.out_Jump;
				mlif.out_JAL <= mlif.out_JAL;
				mlif.out_MemtoReg <= mlif.out_MemtoReg;
				mlif.out_wsel <= mlif.out_wsel;
				mlif.out_jaddr <= mlif.out_jaddr;
				mlif.out_dload <= mlif.out_dload;
				mlif.out_datomic <= mlif.out_datomic;
			end
		end
	end

endmodule
