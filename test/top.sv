`include "../src/riscvsingle.sv"
`include "imem.sv"
`include "dmem.sv"

module top (
    input  logic        clk,
    reset,
    output logic [31:0] WriteData,
    DataAdr,
    output logic        MemWrite
);
  logic [31:0] PC, Instr, ReadData;
  // инстанциирование процессора и памяти
  riscvsingle rvsingle (
      clk,
      reset,
      PC,
      Instr,
      MemWrite,
      DataAdr,
      WriteData,
      ReadData
  );
  imem imem (
      PC,
      Instr
  );
  dmem dmem (
      clk,
      MemWrite,
      DataAdr,
      WriteData,
      ReadData
  );
endmodule
