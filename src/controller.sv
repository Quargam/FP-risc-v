`include "maindec.sv"
`include "aludec.sv"
`include "opcode_decoder.sv"
`include "instruction_decoder.sv"


module controller (
    input logic [31:0] Instr,
    input logic Zero,
    output logic [1:0] ResultSrc,
    output logic MemWrite,
    output logic PCSrc,
    ALUSrc,
    output logic RegWrite,
    Jump,
    output logic [1:0] ImmSrc,
    output logic [2:0] ALUControl,
    output instr_type_enum instr_type_enum_inst
);
  logic [1:0] ALUOp;
  logic Branch;
  logic [2:0] funct3;
  logic [4:0] rd, rs1, rs2;
  logic [6:0] funct7;
  logic [31:0] imm;

  opcode_decoder od (
      Instr,
      instr_type_enum_inst
  );

  instruction_decoder id (
      Instr,
      instr_type_enum_inst,
      rd,
      funct3,
      rs1,
      rs2,
      funct7,
      imm
  );

  maindec md (
      Instr[6:0],
      ResultSrc,
      MemWrite,
      Branch,
      ALUSrc,
      RegWrite,
      Jump,
      ImmSrc,
      ALUOp
  );
  aludec ad (
      Instr[5],
      funct3,
      Instr[30],
      ALUOp,
      ALUControl
  );

  assign PCSrc = Branch & Zero | Jump;
endmodule
