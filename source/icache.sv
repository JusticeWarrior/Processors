// interface include
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module icache (
	input logic CLK, nRST,
	datapath_cache_if dcif,
	caches_if cif
);
	
	import cpu_types_pkg::*;
	
	parameter CPUS = 1;
	
	typedef enum bit {FETCH, CHECK} state_t;
	state_t state;
	state_t next_state;

	word_t data[15:0];
	word_t next_data;

	logic [15:0] valid;
	logic next_valid;

	logic [25:0] tag[15:0];
	logic [25:0] next_tag;
	
	icachef_t iaddr;
	assign iaddr = dcif.imemaddr;

	assign dcif.ihit = valid[iaddr.idx] && dcif.imemREN && (tag[iaddr.idx] == iaddr.tag) && !(dcif.dmemREN || dcif.dmemWEN);
	assign dcif.imemload = data[iaddr.idx];
	
	assign cif.iREN = dcif.imemREN && !dcif.ihit;
	assign cif.iaddr = dcif.imemaddr;

	always_ff @ (posedge CLK, negedge nRST) begin
		if (!nRST) begin
			state <= CHECK;
			valid <= '0;
		end
		else begin
			state <= next_state;	
			if (!cif.iwait) begin
				valid[iaddr.idx] <= next_valid;
				data[iaddr.idx] <= next_data;
				tag[iaddr.idx] <= next_tag;
			end
		end
	end

	always_comb begin
		next_state = state;
		next_valid = 1'b0;	
		next_data = '0;
		next_tag = '0;
		casez (state)
			CHECK: begin
				if(!cif.iwait) begin
					next_valid = 1'b1;	
					next_data = cif.iload;
					next_tag = iaddr.tag;
					next_state = FETCH;
				end
				else begin
					next_state = CHECK;	
				end
			end
			FETCH: begin
				if (dcif.ihit) begin
					next_state = FETCH;
				end
				else begin
					next_state = CHECK;
				end
			end
		endcase
	end
endmodule
