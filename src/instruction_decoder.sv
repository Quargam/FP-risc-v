module instruction_decoder (
    input logic [31:0] Instr,
    output instr_type_enum instr_type_enum_inst
);

  logic [6:0] opcode;
  assign opcode = Instr[6:0];
  // Логика декодирования типа инструкции
  always_comb begin
    case (opcode)  // Поле opcode в инструкции
      7'b0110011: instr_type_enum_inst = INSTR_TYPE_R;  // Тип R
      7'b0010011: instr_type_enum_inst = INSTR_TYPE_I;  // Тип I
      7'b0000011: instr_type_enum_inst = INSTR_TYPE_I;  // Тип I
      7'b0100011: instr_type_enum_inst = INSTR_TYPE_S;  // Тип S
      7'b1100011: instr_type_enum_inst = INSTR_TYPE_B;  // Тип B
      7'b0110111: instr_type_enum_inst = INSTR_TYPE_U;  // Тип U
      7'b1101111: instr_type_enum_inst = INSTR_TYPE_J;  // Тип J
      default:    instr_type_enum_inst = INSTR_TYPE_UNKNOWN;  // Неизвестный тип
    endcase
  end
endmodule
