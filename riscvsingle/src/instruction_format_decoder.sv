module instruction_format_decoder (
    input logic [31:0] Instr,
    input instr_type_enum instr_type_enum_inst,
    output fields_instr fields_instr_inst
);

  // Промежуточные сигналы для вычисления расширений imm
  logic [31:0] imm_i_ext, imm_s_ext, imm_b_ext, imm_j_ext, imm_u_ext, imm_r_ext;

  // Расчёт расширенных значений для всех типов
  assign imm_i_ext = {{20{Instr[31]}}, Instr[31:20]};  // тип I
  assign imm_s_ext = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};  // тип S
  assign imm_b_ext = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};  // тип B
  assign imm_j_ext = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};  // тип J
  assign imm_u_ext = {Instr[31:12], 12'b0};  // тип U
  assign imm_r_ext = 32'b0;  // тип R (нет немедленного значения)

  logic [ 6:0] opcode;
  logic [ 4:0] rd;
  logic [ 2:0] funct3;
  logic [ 4:0] rs1;
  logic [ 4:0] rs2;
  logic [ 6:0] funct7;
  logic [31:0] imm;

  assign opcode = Instr[6:0];
  assign funct3 = Instr[14:12];
  assign rd = Instr[11:7];
  assign rs1 = Instr[19:15];
  assign rs2 = Instr[24:20];
  assign funct7 = Instr[31:25];

  // Декодирование полей инструкции
  always_comb begin
    fields_instr_inst.opcode = opcode;
    fields_instr_inst.funct3 = funct3;
    fields_instr_inst.rd = rd;
    fields_instr_inst.rs1 = rs1;
    fields_instr_inst.rs2 = rs2;
    fields_instr_inst.funct7 = funct7;

    // Декодирование imm для каждого типа инструкции
    case (instr_type_enum_inst)
      INSTR_TYPE_R:
      fields_instr_inst.imm = imm_r_ext;  // Тип R не имеет немедленного значения
      INSTR_TYPE_I: fields_instr_inst.imm = imm_i_ext;  // Тип I
      INSTR_TYPE_S: fields_instr_inst.imm = imm_s_ext;  // Тип S
      INSTR_TYPE_B: fields_instr_inst.imm = imm_b_ext;  // Тип B
      INSTR_TYPE_J: fields_instr_inst.imm = imm_j_ext;  // Тип J
      INSTR_TYPE_U: fields_instr_inst.imm = imm_u_ext;  // Тип U
      default: fields_instr_inst.imm = 32'bx;  // Для неизвестного типа
    endcase
  end

endmodule
