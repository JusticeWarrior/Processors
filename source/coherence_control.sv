// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module coherence_control (
	input CLK, nRST,
	output logic c2c,
	cache_control_if.cc ccif
);

	// type import
	import cpu_types_pkg::*;

	typedef enum bit [2:0] {
			WAIT,
			READ1,
			READ2,
			WRITE1,
			WRITE2
	} StateType;

	StateType state;
	StateType nextState;

	always_comb begin
			 nextState = state;
			 case(state)
					WAIT : begin
							if ( (ccif.cctrans[0] && !ccif.ccwrite[0]) || (ccif.cctrans[1] && !ccif.ccwrite[1]) )
									nextState = READ1;
							else if ( (ccif.cctrans[0] && ccif.ccwrite[0]) || (ccif.cctrans[1] && ccif.ccwrite[1]) )
									nextState = WRITE1;
					end

					READ1 : begin
							if ( (!ccif.dwait[0] || (ccif.cctrans[1] && ccif.ccwrite[1] && !ccif.dwait[1])) || (!ccif.dwait[1] || (ccif.cctrans[0] && ccif.ccwrite[0] && !ccif.dwait[0])) )
									nextState = READ2;
					end

					READ2 : begin
							if ( (!ccif.dwait[0] || (ccif.cctrans[1] && ccif.ccwrite[1] && !ccif.dwait[1])) || (!ccif.dwait[1] || (ccif.cctrans[0] && ccif.ccwrite[0] && !ccif.dwait[0])) )
									nextState = WAIT;
					end

					WRITE1 : begin
							if (!ccif.cctrans[0])
								nextState = WAIT;
					end

					WRITE2 : begin
							if ( (!ccif.dwait[0] && ccif.dREN[0]) || (!ccif.dwait[1] && ccif.dREN[1]) )
								nextState = WAIT;
					end

			endcase
	end

	always_ff @(posedge CLK, negedge nRST) begin
			if (nRST == 0)
					state <= WAIT;
			else
					state <= nextState;
	end

	always_comb begin
			ccif.ccwait[0] = '0;
			ccif.ccwait[1] = '0;
			ccif.ccinv[0] = '0;
			ccif.ccinv[1] = '0;
			ccif.ccsnoopaddr[0] = '0;
			ccif.ccsnoopaddr[1] = '0;
			c2c = 0;

			case(state)
					WAIT: begin
					end

					READ1: begin
						if (ccif.cctrans[0]) begin
							ccif.ccwait[1] = 1;
							ccif.ccsnoopaddr[1] = ccif.daddr[0];

							if (ccif.ccwrite[1]) begin
								c2c = 1;
								ccif.dload[0] = ccif.dstore[1];
								//ccif.dwait[0] = 0;
							end
						end else begin
							ccif.ccwait[0] = 1;
							ccif.ccsnoopaddr[0] = ccif.daddr[1];

							if (ccif.ccwrite[0]) begin
								c2c = 1;
								ccif.dload[1] = ccif.dstore[0];
								//ccif.dwait[1] = 0;
							end
						end
					end

					READ2: begin
						if (ccif.cctrans[0]) begin
							ccif.ccwait[1] = 1;
							ccif.ccsnoopaddr[1] = ccif.daddr[0];

							if (ccif.ccwrite[1]) begin
								c2c = 1;
								ccif.dload[0] = ccif.dstore[1];
								//ccif.dwait[0] = 0;
							end
						end else begin
							ccif.ccwait[0] = 1;
							ccif.ccsnoopaddr[0] = ccif.daddr[1];

							if (ccif.ccwrite[0]) begin
								c2c = 1;
								ccif.dload[1] = ccif.dstore[0];
								//ccif.dwait[1] = 0;
							end
						end
					end

					WRITE1: begin
						if (ccif.cctrans[0]) begin
							ccif.ccwait[1] = 1;
							ccif.ccsnoopaddr[1] = ccif.daddr[0];
							ccif.ccinv[1] = 1;
						end else begin
							ccif.ccwait[0] = 1;
							ccif.ccsnoopaddr[0] = ccif.daddr[1];
							ccif.ccinv[0] = 1;
						end
					end

					WRITE2: begin
						if (ccif.cctrans[0]) begin
							ccif.ccwait[1] = 1;
							ccif.ccsnoopaddr[1] = ccif.daddr[0];
							ccif.ccinv[1] = 1;
						end else begin
							ccif.ccwait[0] = 1;
							ccif.ccsnoopaddr[0] = ccif.daddr[1];
							ccif.ccinv[0] = 1;
						end
					end

			endcase
	end

endmodule
