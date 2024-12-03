`include "constants.sv"

module alu (
    input [31:0] SrcA,
    SrcB,
    input logic [6:0] opcode,
input logic [2:0] funct3,
input logic [6:0] funct7,
    output [31:0] Result,
    output Zero
);

  wire [31:0] Sum;
  wire [31:0] Sub;
  assign Sum = SrcA + SrcB;
  assign Sub = SrcA + ((~SrcB) + 1);

   assign Result = 
   // R-type ADD | SUB (opcode: 0110011, funct3: 000, funct7: 0|1000000)
   (opcode == 7'b0110011 && funct3 == 3'b000) ? (funct7[5] ? (Sub) : Sum) :
   // R-type AND (opcode: 0110011, funct3: 111)
   (opcode == 7'b0110011 && funct3 == 3'b111) ? SrcA & SrcB :
   // R-type OR (opcode: 0110011, funct3: 110)
   (opcode == 7'b0110011 && funct3 == 3'b110) ? SrcA | SrcB :
   // R-type SLT (Set Less Than) (opcode: 0110011, funct3: 010)
   (opcode == 7'b0110011 && funct3 == 3'b010) ? (Sub[31] ? {{31{1'b0}}, 1'b1} : {32{1'b0}}):
   // I-type ADDI (Add Immediate) (opcode: 0010011, funct3: 000)
   (opcode == 7'b0010011 && funct3 == 3'b000) ? Sum :
   // I-type ANDI (AND Immediate) (opcode: 0010011, funct3: 111)
   (opcode == 7'b0010011 && funct3 == 3'b111) ? SrcA & SrcB :
   // I-type ORI (OR Immediate) (opcode: 0010011, funct3: 110)
   (opcode == 7'b0010011 && funct3 == 3'b110) ? SrcA | SrcB :
   // I-type SLTI (Set Less Than Immediate) (opcode: 0010011, funct3: 010)
   (opcode == 7'b0010011 && funct3 == 3'b010) ? (Sum[31] ? {{31{1'b0}}, 1'b1} : {32{1'b0}}):
   // B-type BEQ (Branch if Equal) (opcode: 1100011, funct3: 000)
   (opcode == 7'b1100011 && funct3 == 3'b000) ? Sub:
   // S-type SW (Store Word) (opcode: 0100011, funct3: 010)
   (opcode == 7'b0100011 && funct3 == 3'b010) ? Sum:
   // I-type LW (Load Word) (opcode: 0000011, funct3: 010)
   (opcode == 7'b0000011 && funct3 == 3'b010) ? SrcB:
   // J-type JAL (Jump and Link) (opcode: 1101111)
   (opcode == 7'b1101111) ? 32'b0:
   32'b0;

  assign Zero = &(~Result);

endmodule
