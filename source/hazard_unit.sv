/*
	Jordan Huffaker
	jhuffak@purdue.edu

	hazard unit code
*/

// interface
`include "hazard_unit_if.vh"

module hazard_unit (
	input wire clk,
	input wire n_rst,
	hazard_unit_if.hu H
);

	always_comb begin
		H.stall = '0;

		if (H.wsel_ex != '0) begin
			if (H.wsel_ex == H.rsel1_dec)
				H.stall = '1;
			else if (H.wsel_ex == H.rsel2_dec)
				H.stall = '1;
		end
		if (H.wsel_mem != '0) begin
			if (H.wsel_mem == H.rsel1_dec)
				H.stall = '1;
			else if (H.wsel_mem == H.rsel2_dec)
				H.stall = '1;
		end
	end

endmodule
