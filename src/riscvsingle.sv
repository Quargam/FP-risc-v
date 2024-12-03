`include "riscv_pkg.sv"
import riscv_pkg::*;
`include "controller.sv"
`include "datapath.sv"


module riscvsingle (
    input logic clk,
    reset,
    output logic [31:0] PC,
    input logic [31:0] Instr,
    output logic MemWrite,
    output logic [31:0] ALUResult,
    WriteData,
    input logic [31:0] ReadData
);
  logic ALUSrc, RegWrite, Jump, Zero;
  logic [1:0] ResultSrc, ImmSrc;
  logic [2:0] ALUControl;

  instr_type_enum instr_type_enum_inst;

  controller c (
      Instr,
      Zero,
      ResultSrc,
      MemWrite,
      PCSrc,
      ALUSrc,
      RegWrite,
      Jump,
      ImmSrc,
      ALUControl,
      instr_type_enum_inst
  );
  datapath dp (
      clk,
      reset,
      ResultSrc,
      PCSrc,
      ALUSrc,
      RegWrite,
      instr_type_enum_inst,
      ALUControl,
      Zero,
      PC,
      Instr,
      ALUResult,
      WriteData,
      ReadData
  );
endmodule
