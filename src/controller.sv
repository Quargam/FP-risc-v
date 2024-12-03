`include "maindec.sv"
`include "opcode_decoder.sv"
`include "instruction_format_decoder.sv"


module controller (
    input logic [31:0] Instr,
    input logic Zero,
    output logic [1:0] ResultSrc,
    output logic data_mem_write_enable,
    output logic PCSrc,
    ALUSrc,
    output logic write_enable_rd,
    Jump,
    output logic [1:0] ImmSrc,
    output logic [6:0] opcode,
    output logic [2:0] funct3,
    output logic [6:0] funct7,
    output instr_type_enum instr_type_enum_inst
);
  logic [1:0] ALUOp;
  logic Branch;
  logic [4:0] rd, rs1, rs2;
  logic [31:0] imm;

  opcode_decoder od (
      Instr,
      instr_type_enum_inst
  );

  instruction_format_decoder ifd (
      Instr,
      instr_type_enum_inst,
      opcode,
      rd,
      funct3,
      rs1,
      rs2,
      funct7,
      imm
  );

  maindec md (
      opcode,
      ResultSrc,
      data_mem_write_enable,
      Branch,
      ALUSrc,
      write_enable_rd,
      Jump,
      ImmSrc
  );

  assign PCSrc = Branch & Zero | Jump;
endmodule
