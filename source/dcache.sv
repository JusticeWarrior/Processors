// interface include
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// memory types
`include "cpu_types_pkg.vh"
//todo: flushing - write dirty entries to memory and invalidate
module dcache (
	input logic CLK, nRST,
	datapath_cache_if dcif,
	caches_if cif
);
	import cpu_types_pkg::*;

	typedef enum bit [4:0] {IDLE, RHIT, WHIT, LOAD1, LOAD2, STORE1, STORE2, WCACHE, WCOUNT, HALT, WAIT1, WAIT2, INV, SSTORE} state_t;
	state_t state, next_state;

	word_t [7:0] block1[1:0];
	word_t [7:0] block2[1:0];
	word_t next_data11, next_data12, next_data21, next_data22;
	//word_t b1w1[7:0], b1w2[7:0], b2w1[7:0], b2w2[7:0];

	word_t hitcount, next_hitcount;

	logic [7:0] valid1;
	logic [7:0] valid2;
	logic next_valid1, next_valid2;
	logic [7:0] dirty1;
	logic [7:0] dirty2;
	logic next_dirty1, next_dirty2;
	logic [7:0] lru1;
	logic [7:0] lru2;
	logic next_lru1, next_lru2;

	logic force_write1, force_write2;

	logic [25:0] tag1[7:0];
	logic [25:0] tag2[7:0];
	logic [25:0] next_tag1, next_tag2;

	logic block1_flushed, block2_flushed, next_block1_flushed, next_block2_flushed;
	logic [2:0] flush_index, next_flush_index;
	logic next_dirty;
	logic ihit_wait;
	logic next_ihit_wait;

	word_t link_reg;
	logic link_valid;
	word_t next_link_reg;
	logic next_link_valid;
	logic link_fail;
	logic last_read;
	logic next_last_read;

	logic shit;

	logic link_out;
	logic next_link_out;

	dcachef_t sdaddr;

	dcachef_t daddr;
	assign daddr = dcachef_t'(dcif.dmemaddr);

	assign sdaddr = dcachef_t'(cif.ccsnoopaddr);
	assign shit = cif.ccwait && (((tag1[sdaddr.idx] == sdaddr.tag) && valid1[sdaddr.idx]) || ((tag2[sdaddr.idx] == sdaddr.tag) && valid2[sdaddr.idx])) && !cif.ccinv;
	assign inv = cif.ccwait && (((tag1[sdaddr.idx] == sdaddr.tag) && valid1[sdaddr.idx]) || ((tag2[sdaddr.idx] == sdaddr.tag) && valid2[sdaddr.idx]) || sdaddr == link_reg) && cif.ccinv;

	assign link_fail = (state == WHIT && dcif.datomic && (dcif.dmemaddr != link_reg || !link_valid) && !cif.ccwait);

	assign link_success = ((state == WHIT || state == INV || ((state == LOAD1 || state == LOAD2) && dcif.dmemWEN)) && (dcif.dmemaddr == link_reg && link_valid) && !cif.ccwait);

	assign dcif.dhit = ((((tag1[daddr.idx] == daddr.tag) && valid1[daddr.idx]) || ((tag2[daddr.idx] == daddr.tag) && valid2[daddr.idx])) && !cif.ccwait) || link_fail;

	assign cif.cctrans = (state != HALT && dcif.halt && !cif.ccwait) || (!dcif.halt && state != IDLE && !(state == RHIT && dcif.dhit)) || shit;
	assign cif.ccwrite = (state != HALT && dcif.halt && !cif.ccwait) || (!dcif.halt && state != IDLE && (dcif.dmemWEN || ((state == WHIT || state == INV) && dcif.dhit))) || shit;

	always_ff @ (posedge CLK, negedge nRST) begin
		if (nRST == 0) begin
			state <= IDLE;
			valid1 <= '0;
			valid2 <= '0;
			dirty1 <= '0;
			dirty2 <= '0;
			lru1 <= '1;
			lru2 <= '0;
			hitcount <= '0;
			flush_index <= '0;
			block1_flushed <= 0;
			block2_flushed <= 0;
			ihit_wait <= '0;
			link_reg <= '0;
			link_valid <= 0;
			link_out <= 0;
			last_read <= 0;
			for (int i = 0; i < 8; i = i + 1) begin
				block1[0][i] <= '0;
				block1[1][i] <= '0;
				block2[0][i] <= '0;
				block2[1][i] <= '0;
			end
			for (int i = 0; i < 8; i = i + 1) begin
				tag1[i] <= '0;
				tag2[i] <= '0;
			end
		end
		else begin
			state <= next_state;
			tag1[daddr.idx] <= next_tag1;
			tag2[daddr.idx] <= next_tag2;
			if (inv) begin
				valid1[sdaddr.idx] <= next_valid1;
				valid2[sdaddr.idx] <= next_valid2;
			end
			else begin
				valid1[daddr.idx] <= next_valid1;
				valid2[daddr.idx] <= next_valid2;
			end
			if (shit) begin
				dirty1[sdaddr.idx] <= next_dirty1;
				dirty2[sdaddr.idx] <= next_dirty2;
			end
			else begin
				dirty1[daddr.idx] <= next_dirty1;
				dirty2[daddr.idx] <= next_dirty2;
			end
			lru1[daddr.idx] <= next_lru1;
			lru2[daddr.idx] <= next_lru2;
			hitcount <= next_hitcount;
			flush_index <= next_flush_index;
			block1_flushed <= next_block1_flushed;
			block2_flushed <= next_block2_flushed;
			block1[0][daddr.idx] <= next_data11;
			block1[1][daddr.idx] <= next_data12;
			block2[0][daddr.idx] <= next_data21;
			block2[1][daddr.idx] <= next_data22;
			ihit_wait <= next_ihit_wait;
			link_reg <= next_link_reg;
			link_valid <= next_link_valid;
			link_out <= next_link_out;
			last_read <= next_last_read;
		end
	end

	always_comb begin
		next_ihit_wait = ihit_wait;
		next_flush_index = flush_index;
		casez (state)
			IDLE: begin
				if (dcif.ihit)
					next_ihit_wait = '0;
				if (dcif.halt) begin
					next_state = STORE1;
				end
				else if (shit) begin
					next_state = SSTORE;
				end
				else if (cif.ccwait) begin
					next_state = IDLE;
				end
				else if (dcif.dmemREN && !ihit_wait) begin
					next_state = RHIT;
				end
				else if (dcif.dmemWEN && !ihit_wait) begin
					next_state = WHIT;
				end
				else begin
					next_state = IDLE;
				end
			end
			RHIT: begin
				if (cif.ccwait) begin
					next_state = IDLE;
				end
				else if (dcif.dhit) begin
					next_state = IDLE;
					next_ihit_wait = '1;
				end
				else if (!dcif.dhit && ((lru1[daddr.idx] && dirty1[daddr.idx]) || (lru2[daddr.idx] && dirty2[daddr.idx]))) begin
					next_state = STORE1;
				end
				else if (!dcif.dhit && ((lru1[daddr.idx] && !dirty1[daddr.idx]) || (lru2[daddr.idx] && !dirty2[daddr.idx]))) begin
					next_state = LOAD1;
				end
				else begin
					next_state = RHIT;
				end
			end
			WHIT: begin
				if (cif.ccwait) begin
					next_state = IDLE;
				end
				else if (dcif.dhit) begin
					if (link_fail) begin
						next_state = IDLE;
						next_ihit_wait = '1;
					end else begin
						next_state = INV;
						next_ihit_wait = '1;
					end
				end
				else if (!dcif.dhit && ((lru1[daddr.idx] && dirty1[daddr.idx]) || (lru2[daddr.idx] && dirty2[daddr.idx]))) begin
					next_state = STORE1;
				end
				else if (!dcif.dhit && ((lru1[daddr.idx] && !dirty1[daddr.idx]) || (lru2[daddr.idx] && !dirty2[daddr.idx]))) begin
					next_state = WCACHE;
				end
				else begin
					next_state = WHIT;
				end
			end
			INV: begin
				next_state = IDLE;
			end
			LOAD1: begin
				if (!cif.dwait) begin
					if (dcif.dmemWEN) begin
						next_state = IDLE;
						next_ihit_wait = '1;
					end
					else begin
						next_state = LOAD2;
					end
				end
				else begin
					next_state = LOAD1;
				end
			end
			LOAD2: begin
				if (!cif.dwait) begin
					next_state = IDLE;
					next_ihit_wait = '1;
				end
				else begin
					next_state = LOAD2;
				end
			end
			STORE1: begin//todo: FLUSHING
				if (dcif.halt) begin
					if (cif.ccwait) begin
						next_state = IDLE;
					end
					else if(block1_flushed && block2_flushed) begin
						next_state = WCOUNT;
					end
					else if (!cif.dwait || next_dirty) begin
						next_state = WAIT1;
					end
					else begin
						next_state = STORE1;
					end
				end
				else begin
					if (!cif.dwait) begin
						next_state = WAIT1;
					end
					else begin
						next_state = STORE1;
					end
				end
			end
			SSTORE: begin
				if (!cif.dwait) begin
					next_state = IDLE;
				end
				else begin
					next_state = SSTORE;
				end
			end
			WAIT1: begin//todo: FLUSHING
				next_state = STORE2;
			end
			STORE2: begin//todo: FLUSHING
				if (dcif.halt) begin
					if (!cif.dwait || next_dirty) begin
						next_state = WAIT2;
						next_flush_index = flush_index + 1;
					end
					else begin
						next_state = STORE2;
					end
				end
				else begin
					if (!cif.dwait && dcif.dmemWEN) begin
						next_state = WCACHE;
					end
					else if (!cif.dwait && dcif.dmemREN) begin
						next_state = LOAD1;
					end
					else begin
						next_state = STORE2;
					end
				end
			end
			WAIT2: begin//todo: FLUSHING
				next_state = STORE1;
			end
			WCACHE: begin
				if (daddr.blkoff) begin
					next_state = LOAD1;
				end
				else begin
					next_state = LOAD2;
				end
			end
			WCOUNT: begin
				if (!cif.dwait) begin
					next_state = HALT;
				end
				else begin
					next_state = WCOUNT;
				end
			end
			HALT: begin
				next_state = HALT;
			end
		endcase
	end

	always_comb begin
		next_valid1 = valid1[daddr.idx];
		next_valid2 = valid2[daddr.idx];
		next_dirty1 = dirty1[daddr.idx];
		next_dirty2 = dirty2[daddr.idx];
		next_lru1 = lru1[daddr.idx];
		next_lru2 = lru2[daddr.idx];
		next_tag1 = tag1[daddr.idx];
		next_tag2 =  tag2[daddr.idx];
		next_hitcount = hitcount;
		next_block1_flushed = block1_flushed;
		next_block2_flushed = block2_flushed;
		dcif.flushed = 0;
		next_data11 = block1[0][daddr.idx];
		next_data12 = block1[1][daddr.idx];
		next_data21 = block2[0][daddr.idx];
		next_data22 = block2[1][daddr.idx];
		next_dirty = 0;
		cif.dREN = 0;
		cif.dWEN = 0;
		dcif.dmemload = cif.dload;
		cif.daddr = '0;
		cif.dstore = '0;
		next_link_reg = link_reg;
		next_link_valid = link_valid;
		next_link_out = link_out;
		next_last_read = last_read;
		casez(state)
			IDLE: begin
				cif.dREN = 0;
				cif.dWEN = 0;
				if (inv) begin
					if (sdaddr == link_reg) begin
						next_link_valid = 0;
					end
					if((tag1[sdaddr.idx] == sdaddr.tag) && valid1[sdaddr.idx]) begin
						next_valid1 = 0;
					end
					else if ((tag2[sdaddr.idx] == sdaddr.tag) && valid2[sdaddr.idx]) begin
						next_valid2 = 0;
					end
				end
				if ((tag1[daddr.idx] == daddr.tag) && valid1[daddr.idx]) begin
					dcif.dmemload = block1[daddr.blkoff][daddr.idx];
				end
				else begin
					dcif.dmemload = block2[daddr.blkoff][daddr.idx];
				end
				if (dcif.datomic && !last_read) begin
					dcif.dmemload = {31'b0, link_out};
				end
			end
			INV: begin
				cif.dREN = 0;
				cif.dWEN = 0;
				if (tag1[daddr.idx] == daddr.tag) begin
					dcif.dmemload = block1[daddr.blkoff][daddr.idx];
				end
				else begin
					dcif.dmemload = block2[daddr.blkoff][daddr.idx];
				end
				if (link_success) begin
					if (dcif.datomic) begin
						dcif.dmemload = 1;
						next_link_out = 1;
					end
					next_link_valid = 0;
				end
			end
			RHIT: begin
				next_last_read = 1;
				if (dcif.datomic) begin
					next_link_reg = dcif.dmemaddr;
					next_link_valid = 1;
				end
				if(dcif.dhit) begin
					next_hitcount = hitcount + 1;
					if ((tag1[daddr.idx] == daddr.tag) && valid1[daddr.idx]) begin
						dcif.dmemload = block1[daddr.blkoff][daddr.idx];
						next_lru1 = 0;
						next_lru2 = 1;
					end
					else begin
						dcif.dmemload = block2[daddr.blkoff][daddr.idx];
						next_lru1 = 1;
						next_lru2 = 0;
					end
				end
				if (inv) begin
					if (sdaddr == link_reg) begin
						next_link_valid = 0;
					end
					if((tag1[sdaddr.idx] == sdaddr.tag) && valid1[sdaddr.idx]) begin
						next_valid1 = 0;
					end
					else if ((tag2[sdaddr.idx] == sdaddr.tag) && valid2[sdaddr.idx]) begin
						next_valid2 = 0;
					end
				end
			end
			WHIT: begin
				next_last_read = 0;
				if(dcif.dhit) begin
					if (link_fail) begin
						dcif.dmemload = '0;
						next_link_out = 0;
					end
					else begin
						if (link_success) begin
							if (dcif.datomic) begin
								dcif.dmemload = 1;
								next_link_out = 1;
							end
						end
						next_hitcount = hitcount + 1;
						if ((tag1[daddr.idx] == daddr.tag) && valid1[daddr.idx]) begin
							next_lru1 = 0;
							next_lru2 = 1;
							next_dirty1 = 1;
							if(!daddr.blkoff)
								next_data11 = dcif.dmemstore;
							else
								next_data12 = dcif.dmemstore;
						end
						else begin
							next_lru1 = 1;
							next_lru2 = 0;
							next_dirty2 = 1;
							if(!daddr.blkoff)
								next_data21 = dcif.dmemstore;
							else
								next_data22 = dcif.dmemstore;
						end
					end
				end
				if (inv) begin
					if (sdaddr == link_reg) begin
						next_link_valid = 0;
					end
					if((tag1[sdaddr.idx] == sdaddr.tag) && valid1[sdaddr.idx]) begin
						next_valid1 = 0;
					end
					else if ((tag2[sdaddr.idx] == sdaddr.tag) && valid2[sdaddr.idx]) begin
						next_valid2 = 0;
					end
				end
			end
			LOAD1: begin
				cif.dREN = 1;
				cif.dWEN = 0;
				if(!daddr.blkoff) begin
					cif.daddr = dcif.dmemaddr;
					dcif.dmemload = cif.dload;
				end
				else begin
					cif.daddr = dcif.dmemaddr - 4;
				end
				if(lru1[daddr.idx]) begin
					next_tag1 = daddr.tag;
					if (!cif.dwait) begin
						next_data11 = cif.dload;
						if (dcif.dmemWEN) begin
							next_valid1 = 1;
							next_lru1 = 0;
							next_lru2 = 1;
						end
						else
							next_valid1 = 0;
					end
				end
				else begin
					next_tag2 = daddr.tag;
					if (!cif.dwait) begin
						next_data21 = cif.dload;
						if (dcif.dmemWEN) begin
							next_valid2 = 1;
							next_lru1 = 1;
							next_lru2 = 0;
						end
						else
							next_valid2 = 0;
					end
				end
				if (link_success) begin
					if (dcif.datomic) begin
						dcif.dmemload = 1;
						next_link_out = 1;
					end
					next_link_valid = 0;
				end
			end
			LOAD2: begin
				cif.dREN = 1;
				cif.dWEN = 0;
				if(!daddr.blkoff) begin
					cif.daddr = dcif.dmemaddr + 4;
				end
				else begin
					cif.daddr = dcif.dmemaddr;
					dcif.dmemload = cif.dload;
				end
				if(lru1[daddr.idx]) begin
					next_tag1 = daddr.tag;
					if (!cif.dwait) begin
						next_lru1 = 0;
						next_lru2 = 1;
						next_data12 = cif.dload;
						next_valid1 = 1;
					end
				end
				else begin
					next_tag2 = daddr.tag;
					if (!cif.dwait) begin
						next_lru1 = 1;
						next_lru2 = 0;
						next_data22 = cif.dload;
						next_valid2 = 1;
					end
				end
				if (link_success) begin
					if (dcif.datomic) begin
						dcif.dmemload = 1;
						next_link_out = 1;
					end
					next_link_valid = 0;
				end
			end
			STORE1:	begin//todo: FLUSHING
				cif.dREN = 0;
				if(dcif.halt) begin
					if (!cif.ccwait) begin
						if (!block1_flushed) begin
							if(valid1[flush_index] && dirty1[flush_index]) begin
								cif.dWEN = 1;
								cif.dstore = block1[0][flush_index];
								cif.daddr = {tag1[flush_index], flush_index, 1'b0, 2'b00};
							end
							else
								next_dirty = '1;
						end
						else if (!block2_flushed) begin
							if(valid2[flush_index] && dirty2[flush_index]) begin
								cif.dWEN = 1;
								cif.dstore = block2[0][flush_index];
								cif.daddr = {tag2[flush_index], flush_index, 1'b0, 2'b00};
							end
							else
								next_dirty = '1;
						end
					end
					else begin
						if (inv) begin
							if (sdaddr == link_reg) begin
								next_link_valid = 0;
							end
							if((tag1[sdaddr.idx] == sdaddr.tag) && valid1[sdaddr.idx]) begin
								next_valid1 = 0;
							end
							else if ((tag2[sdaddr.idx] == sdaddr.tag) && valid2[sdaddr.idx]) begin
								next_valid2 = 0;
							end
						end
					end
				end
				else begin
					cif.dWEN = 1;
					if(lru1[daddr.idx]) begin
						cif.dstore = block1[0][daddr.idx];
						cif.daddr = {tag1[daddr.idx], daddr.idx, 1'b0, 2'b00};
					end
					else begin
						cif.dstore = block2[0][daddr.idx];
						cif.daddr = {tag2[daddr.idx], daddr.idx, 1'b0, 2'b00};
					end
				end
			end
			SSTORE: begin
				cif.dWEN = 1;
				cif.daddr = cif.ccsnoopaddr;
				if((tag1[sdaddr.idx] == sdaddr.tag) && valid1[sdaddr.idx]) begin
					cif.dstore = block1[sdaddr.blkoff][sdaddr.idx];
					next_dirty1 = 0;
				end
				else begin
					cif.dstore = block2[sdaddr.blkoff][sdaddr.idx];
					next_dirty2 = 0;
				end
			end
			WAIT1: begin
				cif.dWEN = 0;
			end
			STORE2: begin//todo: FLUSHING
				cif.dREN = 0;
				if(dcif.halt) begin
					if (!block1_flushed) begin
						if(valid1[flush_index] && dirty1[flush_index]) begin
							cif.dWEN = 1;
							cif.dstore = block1[1][flush_index];
							cif.daddr = {tag1[flush_index], flush_index, 1'b1, 2'b00};
						end
						else
							next_dirty = '1;
						if (flush_index == 7 && next_state == WAIT2) begin
							next_block1_flushed = 1;
						end
					end
					else if (!block2_flushed) begin
						if(valid2[flush_index] && dirty2[flush_index]) begin
							cif.dWEN = 1;
							cif.dstore = block2[1][flush_index];
							cif.daddr = {tag2[flush_index], flush_index, 1'b1, 2'b00};
						end
						else
							next_dirty = '1;
						if (flush_index == 7 && next_state == WAIT2) begin
							next_block2_flushed = 1;
						end
					end
				end
				else begin
					cif.dWEN = 1;
					if(lru1[daddr.idx]) begin
						cif.dstore = block1[1][daddr.idx];
						cif.daddr = {tag1[daddr.idx], daddr.idx, 1'b1, 2'b00};
					end
					else begin
						cif.dstore = block2[1][daddr.idx];
						cif.daddr = {tag2[daddr.idx], daddr.idx, 1'b1, 2'b00};
					end
				end
			end
			WAIT2: begin
				cif.dWEN = 0;
			end
			WCACHE: begin
				cif.dREN = 0;
				cif.dWEN = 0;
				if (lru1[daddr.idx]) begin
					next_dirty1 = '1;
					if(!daddr.blkoff)
						next_data11 = dcif.dmemstore;
					else
						next_data12 = dcif.dmemstore;
				end
				else begin
					next_dirty2 = '1;
					if(!daddr.blkoff)
						next_data21 = dcif.dmemstore;
					else
						next_data22 = dcif.dmemstore;
				end

			end
			WCOUNT: begin
				cif.dWEN = 1;
				cif.dREN = 0;
				cif.daddr = 32'h3100;
				cif.dstore = hitcount;
				if (!cif.dwait) begin
					next_valid1 = '0;
					next_valid2 = '0;
				end
			end
			HALT: begin
				cif.dWEN = 0;
				cif.dREN = 0;
				cif.daddr = 32'h3100;
				cif.dstore = hitcount;
				dcif.flushed = 1;
			end
		endcase
	end
endmodule
