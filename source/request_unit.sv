/*
	Jordan Huffaker
	jhuffak@purdue.edu

	request unit code
*/

// interface
`include "request_unit_if.vh"

module request_unit (
	input wire clk,
	input wire n_rst,
	request_unit_if.ru R
);

	typedef enum bit [1:0] {
		get_instr,
		get_data,
		write_data
	} StateType;

	StateType state;
	StateType nextState;

	always_comb begin
		 nextState = state;
		 case(state)
			get_instr : begin
				if ( R.ihit && R.MemRd && !R.MemWr )
					nextState = get_data;
				else if ( R.ihit && R.MemWr )
					nextState = write_data;
			end

			get_data : begin
				if ( R.dhit )
					nextState = get_instr;
			end

			write_data : begin
				if ( R.dhit && !R.MemRd )
					nextState = get_instr;
				else if ( R.dhit && R.MemRd )
					nextState = get_data;
			end

		endcase
	end

	always_ff @(posedge clk, negedge n_rst) begin
		if (n_rst == '0)
			state <= get_instr;
		else
			state <= nextState;
	end

	always_comb begin
		R.store = R.rw;
		R.daddr = R.aluDaddr;
		R.wren = '0;
		R.dren = '0;
		R.iaddr = R.PC;
		R.iren = '0;
		R.out_instr = R.ihit || R.dhit ?  R.instr : '0;
		R.out_ddata = R.ddata;
		R.Adv = nextState != get_instr ? '0 : R.ihit || R.dhit;

		case(state)
			get_instr: begin
				R.iren = '1;
			end

			get_data: begin
				R.dren = '1;
			end

			write_data: begin
				R.wren = '1;
			end

		endcase
	end

endmodule
