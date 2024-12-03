module imem (
    input  logic [31:0] PC,
    output logic [31:0] Instr
);
  logic [31:0] RAM[63:0];
  initial $readmemh("test/riscvtest.txt", RAM, 0, 20);
  assign Instr = RAM[PC[31:2]];  // word aligned (деление на 4: PC / 4)
endmodule
