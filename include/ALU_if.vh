/*
  Jordan Huffaker
  jhuffak@purdue.edu

  ALU interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface ALU_if;
  // import types
  import cpu_types_pkg::*;

  logic     neg, overflow, zero;
  aluop_t   ALUOP;
  word_t    portA, portB, portOut;

  // register file ports
  modport rf (
    input   ALUOP, portA, portB,
    output  neg, overflow, zero, portOut
  );
  // register file tb
  modport tb (
    input  neg, overflow, zero, portOut,
    output   ALUOP, portA, portB
  );
endinterface

`endif //ALU_IF_VH
