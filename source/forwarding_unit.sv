// interface
`include "forwarding_unit_if.vh"
`include "cpu_types_pkg.vh"

module forwarding_unit (
	forwarding_unit_if.fu fuif
);
	import cpu_types_pkg::*;

	always_comb begin
		if(fuif.regWEN_ex && (fuif.Rd_ex !== 0) && (fuif.Rd_ex == fuif.Rs_dec)) begin
			fuif.forwardA = 2'b10;
		end
		else if(fuif.regWEN_mem && (fuif.Rd_mem !== 0) && (fuif.Rd_mem == fuif.Rs_dec)) begin
			fuif.forwardA = 2'b01;
		end
		else begin
			fuif.forwardA = 2'b00;
		end
		if(fuif.regWEN_ex && (fuif.Rd_ex !== 0) && (fuif.Rd_ex == fuif.Rt_dec)) begin
			fuif.forwardB = 2'b10;
		end
		else if(fuif.regWEN_mem && (fuif.Rd_mem !== 0) && (fuif.Rd_mem == fuif.Rt_dec)) begin
			fuif.forwardB = 2'b01;
		end
		else begin
			fuif.forwardB = 2'b00;
		end
	end

endmodule
