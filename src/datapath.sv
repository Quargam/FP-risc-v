`include "flopr.sv"
`include "adder.sv"
`include "mux2.sv"
`include "mux3.sv"
`include "extend.sv"
`include "regfile.sv"
`include "alu.sv"

module datapath (
    input  logic                  clk,
    reset,
    input  logic           [ 1:0] ResultSrc,
    input  logic                  PCSrc,
    ALUSrc,
    input  logic                  write_enable_rd,
    input  instr_type_enum        instr_type_enum_inst,
    input  logic           [ 2:0] ALUControl,
    output logic                  Zero,
    output logic           [31:0] PC,
    input  logic           [31:0] Instr,
    output logic           [31:0] ALUResult,
    data_rs2,
    input  logic           [31:0] data_mem_read_data
);

  logic [31:0] PCNext, PCPlus4, PCTarget;
  logic [31:0] ImmExt;
  logic [31:0] data_rs1, SrcA, SrcB;
  logic [31:0] write_data_rd;

  assign SrcA = data_rs1;
  // логика PC
  flopr #(32) pcreg (
      clk,
      reset,
      PCNext,
      PC
  );
  adder pcadd4 (
      PC,
      32'd4,
      PCPlus4
  );
  adder pcaddbranch (
      PC,
      ImmExt,
      PCTarget
  );
  mux2 #(32) pcmux (
      PCPlus4,
      PCTarget,
      PCSrc,
      PCNext
  );
  // логика регистрового файла
  regfile rf (
      clk,
      write_enable_rd,
      Instr[19:15],
      Instr[24:20],
      Instr[11:7],
      write_data_rd,
      data_rs1,
      data_rs2
  );

  extend ext (
      Instr[31:7],
      instr_type_enum_inst,
      ImmExt
  );
  // логика АЛУ
  mux2 #(32) srcbmux (
      data_rs2,
      ImmExt,
      ALUSrc,
      SrcB
  );
  alu alu (
      SrcA,
      SrcB,
      ALUControl,
      ALUResult,
      Zero
  );
  mux3 #(32) resultmux (
      ALUResult,
      data_mem_read_data,
      PCPlus4,
      ResultSrc,
      write_data_rd
  );
endmodule
