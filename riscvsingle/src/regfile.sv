module regfile (
    input logic clk,
    input logic write_enable_rd,
    input logic [4:0] address_rs1,
    address_rs2,
    address_rd,
    input logic [31:0] write_data_rd,
    output logic [31:0] data_rs1,
    data_rs2
);
  logic [31:0] register_x[31:0];
  // трехпортовый регистровый файл
  // комбинационное чтение двух портов 
  // (A1/RD1, A2/RD2)
  // запись в третий порт по переднему 
  // фронту тактового импульса (A3/WD3/WE3)
  // значение регистра 0 жестко привязано 
  // к значению 0
  always_ff @(posedge clk) if (write_enable_rd) register_x[address_rd] <= write_data_rd;
  assign data_rs1 = (address_rs1 != 0) ? register_x[address_rs1] : 0;
  assign data_rs2 = (address_rs2 != 0) ? register_x[address_rs2] : 0;

`ifdef REGISTER_MEM_FILE_HEX
  final begin
    $writememh(`REGISTER_MEM_FILE_HEX, register_x, 0, 31);
  end
`endif

endmodule
