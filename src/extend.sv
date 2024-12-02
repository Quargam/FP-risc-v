module extend(
    input logic [31:7] instr,
    input logic [1:0] immsrc,
    output logic [31:0] immext
);
    logic [31:0] imm_i_ext, imm_s_ext, imm_b_ext, imm_j_ext;

    // Расчёт расширенных значений для всех типов
    assign imm_i_ext = {{20{instr[31]}}, instr[31:20]};                 // тип I
    assign imm_s_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};    // тип S
    assign imm_b_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; // тип B
    assign imm_j_ext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; // тип J

    // Логика выбора
    always_comb begin
        case (immsrc)
            2'b00: immext = imm_i_ext;
            2'b01: immext = imm_s_ext;
            2'b10: immext = imm_b_ext;
            2'b11: immext = imm_j_ext;
            default: immext = 32'bx;
        endcase
    end
endmodule
