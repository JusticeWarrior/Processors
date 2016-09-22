/*
  Jordan Huffaker
  jhuffak@purdue.edu

  dcache interface
*/
`ifndef DCACHE_IF_VH
`define DCACHE_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface dcache_if;
  // import types
  import cpu_types_pkg::*;

  logic     dWEN, out_dWEN, dREN, out_dREN, dwait, halt;
  word_t    dstore, portout, dload, out_dload, out_daddr, out_dstore;

  // register file ports
  modport dc (
    input   dstore, dWEN, dREN, portout, dwait, dload, halt,
    output  out_dload, out_dWEN, out_dREN, out_daddr, out_dstore
  );
  // register file tb
  modport tb (
    input 	 out_dload, out_dWEN, out_dREN, out_daddr, out_dstore,
    output   dstore, dWEN, dREN, portout, dwait, dload, halt
  );
endinterface

`endif //DCACHE_IF_VH
