module instruction_decoder (
    input logic [31:0] Instr,
    input instr_type_enum instr_type_enum_inst,
    output logic [4:0] rd,
    output logic [2:0] funct3,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [6:0] funct7,
    output logic [31:0] imm
);

  assign funct3 = Instr[14:12];
  assign rd = Instr[11:7];
  assign rs1 = Instr[19:15];
  assign rs2 = Instr[24:20];
  assign funct7 = Instr[31:25];

  logic [31:0] imm_i_ext, imm_s_ext, imm_b_ext, imm_j_ext, imm_u_ext, imm_r_ext;
  // Расчёт расширенных значений для всех типов
  assign imm_i_ext = {{20{Instr[31]}}, Instr[31:20]};  // тип I
  assign imm_s_ext = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};  // тип S
  assign imm_b_ext = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};  // тип B
  assign imm_j_ext = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};  // тип J
  assign imm_u_ext = {Instr[31:12], 12'b0};  // тип U
  assign imm_r_ext = 32'b0;  // тип R (нет немедленного значения)


  // Декодирование полей инструкции
  always_comb begin
    case (instr_type_enum_inst)
      INSTR_TYPE_R:
      imm = imm_r_ext;  // Тип R не имеет немедленного значения
      INSTR_TYPE_I: imm = imm_i_ext;  // Тип I
      INSTR_TYPE_S: imm = imm_s_ext;  // Тип S
      INSTR_TYPE_B: imm = imm_b_ext;  // Тип B
      INSTR_TYPE_J: imm = imm_j_ext;  // Тип J
      INSTR_TYPE_U: imm = imm_u_ext;  // Тип U
      default: imm = 32'bx;  // Для неизвестного типа
    endcase
  end
endmodule
