module imem (
    input  logic [31:0] PC,
    output logic [31:0] Instr
);
  logic [31:0] RAM[63:0];
  `ifdef SOURCE_FILE_HEX
  initial begin
  $readmemh(`SOURCE_FILE_HEX, RAM, 0, 63);
  end
  `else
  initial $readmemh("riscvsingle/test/riscvtest.txt", RAM, 0, 63);
  `endif
  assign Instr = RAM[PC[31:2]];  // word aligned (деление на 4: PC / 4)
endmodule
