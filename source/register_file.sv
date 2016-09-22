/*
  Jordan Huffaker
  jhuffak@purdue.edu

  register file code
*/

// interface
`include "register_file_if.vh"

module register_file (
  input wire clk,
  input wire n_rst,
  register_file_if.rf R
);

  logic [31:0] mem [31:0];

  always_ff @ (negedge clk, negedge n_rst) begin
    if (n_rst == '0) begin
		for (int i = 0; i < 32; i += 1) begin
        	mem[i] <= 32'b0;
		end
    end
    else if (R.WEN) begin
      mem[R.wsel] <= R.wdat;
    end
  end

  always_comb begin
    if (R.rsel1 == '0)
      R.rdat1 = '0;
    else
      R.rdat1 = mem[R.rsel1];

    if (R.rsel2 == '0)
      R.rdat2 = '0;
    else
      R.rdat2 = mem[R.rsel2];
  end

endmodule
