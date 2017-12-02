iverilog -o Bus -I./ -y./ BusUpsizer.v BusUpsizerTest.v && vvp Bus && gtkwave BusUpsizer.vcd
pause