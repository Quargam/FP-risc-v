`include "constants.sv"

module alu (
    input [31:0] SrcA,
    SrcB,
    input [2:0] ALUControl,
    output [31:0] Result,
    output Zero
);

  wire [31:0] Sum;

  assign Sum = (ALUControl[0] == 1'b0) ? SrcA + SrcB : (SrcA + ((~SrcB) + 1));
  assign Result = (ALUControl == `ALU_CTRL_ADD) ? Sum :
                    (ALUControl == `ALU_CTRL_SUB) ? Sum :
                    (ALUControl == `ALU_CTRL_AND) ? SrcA & SrcB :
                    (ALUControl == `ALU_CTRL_OR)  ? SrcA | SrcB :
                    (ALUControl == `ALU_CTRL_SLT) ? {{31{1'b0}}, (Sum[31])} : {32{1'b0}};

  assign Zero = &(~Result);

endmodule
