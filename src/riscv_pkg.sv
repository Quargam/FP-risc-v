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

  // Структура для R-типа инструкции
  typedef struct packed {
    logic [6:0] funct7;  // Дополнительный функциональный код
    logic [4:0] rs2;     // Регистровый источник 2
    logic [4:0] rs1;     // Регистровый источник 1
    logic [2:0] funct3;  // Функциональный код
    logic [4:0] rd;      // Регистровый результат
    logic [6:0] opcode;  // Операция
  } R_type_instr;

  // Структура для I-типа инструкции
  typedef struct packed {
    logic [11:0] imm;     // Немедленное значение
    logic [4:0]  rs1;     // Регистровый источник 1
    logic [2:0]  funct3;  // Функциональный код
    logic [4:0]  rd;      // Регистровый результат
    logic [6:0]  opcode;  // Операция
  } I_type_instr;

  // Структура для S_B-типа инструкции
  typedef struct packed {
    logic [4:0] rs2;     // Регистровый источник 2
    logic [4:0] rs1;     // Регистровый источник 1
    logic [2:0] funct3;  // Функциональный код
    logic [11:0] imm;    // Немедленное значение
    logic [6:0] opcode;  // Операция
  } S_B_type_instr;

  // Структура для U_J-типа инструкции
  typedef struct packed {
    logic [4:0]  rd;      // Регистровый результат
    logic [6:0]  opcode;  // Операция
    logic [19:0] imm;     // Немедленное значение (20 бит)
  } U_J_type_instr;

endpackage
