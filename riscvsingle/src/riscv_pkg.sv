package riscv_pkg;

  typedef enum logic [2:0] {
    INSTR_TYPE_R = 3'b000,  // R-type: операции с регистрами
    INSTR_TYPE_I = 3'b001,  // I-type: операции с немедленными значениями
    INSTR_TYPE_S = 3'b010,  // S-type: запись в память
    INSTR_TYPE_B = 3'b011,  // B-type: условные переходы
    INSTR_TYPE_U = 3'b100,  // U-type: установка верхних бит
    INSTR_TYPE_J = 3'b101,  // J-type: долгие переходы
    INSTR_TYPE_UNKNOWN = 3'bxxx  // Неизвестный тип
  } instr_type_enum;


  // Структура для полей инструкции
  typedef struct packed {
    logic [6:0]  opcode;
    logic [4:0]  rd;
    logic [2:0]  funct3;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [6:0]  funct7;
    logic [31:0] imm;
  } fields_instr;
endpackage
