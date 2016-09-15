/*
	Jordan Huffaker
	jhuffak@purdue.edu

	PC file
*/

`include "cpu_types_pkg.vh"

module datapath (
	input logic CLK, nRST, Adv, Halt,
	input word_t next_PC,
	output word_t PC
);
	// import types
	import cpu_types_pkg::*;

	// pc init
	parameter PC_INIT = 0;

	always_ff @(posedge clk, negedge n_rst) begin
		if (n_rst == '0)
			PC <= 'PC_INIT;
		else if (Adv && !Halt)
			PC <= next_PC;
	end

endmodule
