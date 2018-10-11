`timescale 1 ns / 1 ns
module debugging_tb
#(
   parameter DEFAULT = 32
);

reg clk, rst;

debugging #(
   .DEFAULT( DEFAULT ) 
) debugging_sample
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
  $dumpfile("debugging_tb.vcd");
   $dumpvars(-1, debugging_tb);
end

endmodule