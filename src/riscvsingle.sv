`include "riscv_pkg.sv"
import riscv_pkg::*;
`include "controller.sv"
`include "datapath.sv"


module riscvsingle (
    input logic clk,
    reset,
    output logic [31:0] PC,
    input logic [31:0] Instr,
    output logic data_mem_write_enable,
    output logic [31:0] ALUResult,
    data_mem_write_data,
    input logic [31:0] data_mem_read_data
);
  logic ALUSrc, write_enable_rd, Jump, Zero;
  logic [1:0] ResultSrc, ImmSrc;
      logic [6:0] opcode;
  logic [2:0] funct3;
  logic [6:0] funct7;

  instr_type_enum instr_type_enum_inst;

  controller c (
      Instr,
      Zero,
      ResultSrc,
      data_mem_write_enable,
      PCSrc,
      ALUSrc,
      write_enable_rd,
      Jump,
      ImmSrc,
        opcode,
        funct3,
        funct7,
      instr_type_enum_inst
  );
  datapath dp (
      clk,
      reset,
      ResultSrc,
      PCSrc,
      ALUSrc,
      write_enable_rd,
      instr_type_enum_inst,
      opcode,
        funct3,
        funct7,
      Zero,
      PC,
      Instr,
      ALUResult,
      data_mem_write_data,
      data_mem_read_data
  );
endmodule
