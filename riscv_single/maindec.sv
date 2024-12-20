module maindec (
    input logic [6:0] op,
    output logic [1:0] ResultSrc,
    output logic data_mem_write_enable,
    output logic Branch,
    ALUSrc,
    output logic write_enable_rd,
    Jump,
    output logic [1:0] ImmSrc
);
  logic [10:0] controls;
  assign {write_enable_rd, ImmSrc, ALUSrc, data_mem_write_enable, ResultSrc, Branch, Jump} = controls;
  always_comb
    case (op)
      7'b0000011: controls = 11'b1_00_1_0_01_0_0;  // lw
      7'b0100011: controls = 11'b0_01_1_1_00_0_0;  // sw
      7'b0110011: controls = 11'b1_xx_0_0_00_0_0;  // тип R
      7'b1100011: controls = 11'b0_10_0_0_00_1_0;  // beq
      7'b0010011: controls = 11'b1_00_1_0_00_0_0;  // тип I
      7'b1101111: controls = 11'b1_11_0_0_10_0_1;  // jal
      default: controls = 11'bx_xx_x_x_xx_x_x;  // ???
    endcase
endmodule
