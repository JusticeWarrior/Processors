/*
	Jordan Huffaker
	jhuffak@purdue.edu

	write queue interface
*/
`ifndef WRITE_QUEUE_IF_VH
`define WRITE_QUEUE_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface write_queue_if;
	// import types
	import cpu_types_pkg::*;

	logic	wempty, full, ddirtyWEN, dmissREN, dqueueWEN, dwait;
	word_t	ddirtydata, ddirtyaddr, wdaddr, dstore;

	// request unit ports
	modport wq (
		input		ddirtydata, ddirtyaddr, ddirtyWEN, dmisREN, dwait,
		output		wempty, full, wdaddr, dqueueWEN, dstore
	);
	// request unit tb
	modport tb (
		input		wempty, full, wdaddr, dqueueWEN, dstore,
		output		ddirtydata, ddirtyaddr, ddirtyWEN, dmisREN, dwait
	);
endinterface

`endif //REQUEST_UNIT_IF_VH
