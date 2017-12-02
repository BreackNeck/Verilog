iverilog -o test -I./ -y./ bench.v testbench.v && vvp test && gtkwave bench.vcd
pause