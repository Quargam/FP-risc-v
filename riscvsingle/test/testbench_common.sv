`include "top.sv"

module testbench ();
  logic clk;
  logic reset;
  logic [31:0] WriteData, DataAdr;
  logic MemWrite;

  // инициализация проверяемого устройства
  top dut (
      clk,
      reset,
      WriteData,
      DataAdr,
      MemWrite
  );

  // запуск тестбенча
  initial begin
    // Настройка вывода VCD
`ifdef SAVE_FILE_VCD
    $dumpfile(`SAVE_FILE_VCD);  // Указание имени файла
`else
    $dumpfile("./build/testbench.vcd");  // Указание имени файла
`endif
    $dumpvars(0, testbench);  // Запись всех сигналов тестбенча в VCD

    // Инициализация
    reset <= 1;
    #5;
    reset <= 0;
  end

  // генерация тактовых импульсов
  always begin
    clk <= 1;
    #5;
    clk <= 0;
    #5;
  end

  initial begin
    #250 $finish;
  end

  // проверка результата
  always @(negedge clk) begin
    if (MemWrite) begin
      if (DataAdr === 100 & WriteData === 25) begin
        $display("The verification was successfully completed");
        // $stop;
      end else if (DataAdr !== 96) begin
        $display("An error has been detected");
        // $stop;
      end
    end
  end
endmodule
