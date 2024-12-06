`include "PipelineTop.v"

`timescale 1ns / 1ps

module Pipeline_TestBench ();

  reg clk = 0, rst = 1;

  always begin
    clk = ~clk;
    #50;
  end

  initial begin
    rst <= 1'b1;
    #200;
    rst <= 1'b0;
    #1000000;
    $finish;
  end

  initial begin

`ifdef SAVE_FILE_VCD
    $dumpfile(`SAVE_FILE_VCD);
`else
    $dumpfile("./build/testbench.vcd");
`endif
    $dumpvars(0);
  end

  PipelineTop Pipeline (
      .clk(clk),
      .rst(rst)
  );
endmodule
