module extend (
    input logic [31:7] instr,
    input instr_type_enum instr_type_enum_inst,
    output logic [31:0] immext
);
  import riscv_pkg::*;
  logic [31:0] imm_i_ext, imm_s_ext, imm_b_ext, imm_j_ext;

  // Расчёт расширенных значений для всех типов
  assign imm_i_ext = {{20{instr[31]}}, instr[31:20]};  // тип I
  assign imm_s_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};  // тип S
  assign imm_b_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};  // тип B
  assign imm_j_ext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};  // тип J
  assign imm_u_ext = {instr[31:12], 12'b0};  // тип U
  assign imm_r_ext = 32'b0;  // тип R (нет немедленного значения)

  // Логика выбора
  always_comb begin
    case (instr_type_enum_inst)
      INSTR_TYPE_R: immext = imm_r_ext;
      INSTR_TYPE_I: immext = imm_i_ext;
      INSTR_TYPE_S: immext = imm_s_ext;
      INSTR_TYPE_B: immext = imm_b_ext;
      INSTR_TYPE_U: immext = imm_u_ext;
      INSTR_TYPE_J: immext = imm_j_ext;
      default: immext = 32'bx;
    endcase
  end
endmodule
