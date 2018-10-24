`timescale 1 ns / 1 ns
module core_logic_tb
#(
   parameter DEFAULT = 32
);

reg clk, rst;

CORE_LOGIC #(
   .DEFAULT( DEFAULT ) 
) CORE_LOGIC_INST
( .clk(clk)
, .rst(rst)
);

always begin
   #5  clk <= ~clk; // 200MHz
end

initial begin
   clk <= 0; @(posedge clk);
   rst <= 1; @(posedge clk);
   rst <= 0; @(posedge clk);
end

initial begin
  // code... 
    @(negedge rst);
    $finish;
end

initial begin
  $dumpfile("core_logic_tb.vcd");
   $dumpvars(-1, core_logic_tb);
end

endmodule