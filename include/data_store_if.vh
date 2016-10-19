`ifndef DATA_STORE_IF_VH
`define DATA_STORE_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface access_logic_if;
	// import types
	import cpu_types_pkg::*;

	logic          hit, halt, full, ddirtyWEN, dmissREN, dwait;
  	word_t         ddata, daddr, ddirtydata, ddirtyaddr, rdaddr, dload, daccessstore;

	// access logic ports
	modport ds (
		input	dREN, dWEN, halt, full, daddr, dwait, dload, daccessstore,
		output	ddata, hit, ddirtydata, ddirtyaddr, ddirtyWEN, dmissREN, rdaddr
	);
	// access logic tb
	modport tb (
		input	ddata, hit, ddirtydata, ddirtyaddr, ddirtyWEN, dmissREN, rdaddr,
		output	dREN, dWEN, halt, full, daddr, dwait, dload, daccessstore
	);
endinterface

`endif //DATA_STORE_IF_VH
