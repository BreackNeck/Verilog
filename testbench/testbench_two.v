`timescale 1 ps/ 1 ps
module testbench
#(   parameter DATA_WIDTH = 8
  ,  parameter ATTR_WIDTH = 4
  ,  parameter SIGN       = 0
  ,  parameter OVERFLOW   = 1
)
(); 
reg clk 
,   signal_load
,   signal_init
,   signal_neg
,   signal_oe; 

reg [DATA_WIDTH-1:0] data_in;
reg [ATTR_WIDTH-1:0] attr_in = 0;

bench testbench (
        .clk(clk),
        .signal_load(signal_load),
        .signal_init(signal_init),
        .signal_neg(signal_neg),
        .signal_oe(signal_oe),
        .data_in(data_in),
        .attr_in(attr_in)
);
initial begin
  clk = 0;
  forever #10 clk = !clk;
end

task defaultValue;
    begin
        $display(" Start default! ");
        signal_load = 0;
        signal_init = 0;
        signal_neg  = 0;
        signal_oe    = 1;
        data_in     = 0;
        $display(" Stop default! ");
    end
endtask

task sumTwoValue;
    input [DATA_WIDTH-1:0] data_one, data_two, data_three, data_four;
    begin
        $display(" Start write_data! ");
        @(posedge clk);
        signal_load = 1;
        signal_init = 1; // Заполняем нулями int_arg / Инициилизируем
        data_in = data_one;
        repeat(1) begin @(posedge clk); end
        signal_init = 0; // Возвращаем в исходное состояние
        data_in = data_two;
        repeat(2) begin @(posedge clk); end
        data_in = data_three;
        repeat(2) begin @(posedge clk); end
        data_in = data_four;
        repeat(2) begin @(posedge clk); end
        signal_load = 0;
    end
endtask

initial 
  begin
    $display("Start programm");
    clk = 0;
    defaultValue();
    sumTwoValue(1,2,3,4);
  end

initial
begin
  #6000 $finish;
end

initial
begin
    $dumpfile("bench.vcd");
    $dumpvars(0,testbench);
    $display("finish");
end 

endmodule


