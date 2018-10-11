`timescale 1 ns / 1 ns
module state_decoder_tb
#(
   parameter DEFAULT = 32
);

reg clk, rst;

state_decoder #(
   .DEFAULT( DEFAULT ) 
) state_decoder_sample
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
  $dumpfile("state_decoder_tb.vcd");
   $dumpvars(-1, state_decoder_tb);
end

endmodule