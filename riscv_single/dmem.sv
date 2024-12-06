module dmem (
    input logic clk,
    data_mem_write_enable,
    input logic [31:0] data_mem_address,
    data_mem_write_data,
    output logic [31:0] data_mem_read_data
);
  logic [31:0] RAM[63:0];
  assign data_mem_read_data = RAM[data_mem_address[31:2]];  // выравнивание по слову (деление на 4: PC / 4)
  always_ff @(posedge clk)
    if (data_mem_write_enable)
      RAM[data_mem_address[31:2]] <= data_mem_write_data;

`ifdef DATA_MEM_FILE_HEX
  final begin
    $writememh(`DATA_MEM_FILE_HEX, RAM, 0, 63);
  end
`endif

endmodule
