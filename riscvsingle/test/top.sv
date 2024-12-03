`include "../src/riscvsingle.sv"
`include "imem.sv"
`include "dmem.sv"

module top (
    input  logic        clk,
    reset,
    output logic [31:0] data_mem_write_data,
    data_mem_address,
    output logic        data_mem_write_enable
);
  logic [31:0] PC, Instr, data_mem_read_data;
  // инстанциирование процессора и памяти
  riscvsingle rvsingle (
      clk,
      reset,
      PC,
      Instr,
      data_mem_write_enable,
      data_mem_address,
      data_mem_write_data,
      data_mem_read_data
  );
  imem instr_mem (
      PC,
      Instr
  );
  dmem data_mem (
      clk,
      data_mem_write_enable,
      data_mem_address,
      data_mem_write_data,
      data_mem_read_data
  );
endmodule
