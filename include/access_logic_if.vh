`ifndef ACCESS_LOGIC_IF_VH
`define ACCESS_LOGIC_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface access_logic_if;
	// import types
	import cpu_types_pkg::*;

	logic          dhit, dmemREN, dmemWEN, halt, datomic, flushed, wempty, hit, dREN, dWEN;
  	word_t         dmemload, dmemstore, dmemaddr, daddr, ddata;

	// access logic ports
	modport al (
		input	dmemaddr, dmemREN, dmemWEN, halt, dmemstore, datomic, hit, ddata, wempty,
		output	dhit, dmemload, flushed, daddr, dREN, dWEN
	);
	// access logic tb
	modport tb (
		input	dhit, dmemload, flushed, daddr, dREN, dWEN,
		output	dmemaddr, dmemREN, dmemWEN, halt, dmemstore, datomic, hit, ddata, wempty
	);
endinterface

`endif //ACCESS_LOGIC_IF_VH