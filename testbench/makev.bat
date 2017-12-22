iverilog -o test -I./ -y./ bench.v testbench_last.v && vvp test && gtkwave bench.vcd
pause