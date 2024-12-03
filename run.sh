iverilog -g2012 -I ./test -I ./src -o ./build/testbench.vvp test/testbench.sv
vvp ./build/testbench.vvp
gtkwave ./build/testbench.vcd
