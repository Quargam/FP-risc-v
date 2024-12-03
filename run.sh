iverilog -g2012 -I ./riscvsingle/test -I ./riscvsingle//src -o ./build/testbench.vvp ./riscvsingle/test/testbench_common.sv
vvp ./build/testbench.vvp
gtkwave ./build/testbench.vcd
