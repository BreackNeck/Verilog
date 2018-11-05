`timescale 1 ns / 1 ns
module tap_controller_tb();

reg TMS;
reg TCK;
reg TRST;

tapController tapController_sample
( 
  .TMS(TMS)
, .TCK(TCK)
, .TRST(TRST)
);

always begin
   #5  TCK <= ~TCK; // 200MHz
end

initial begin
   TCK <= 0; TMS = 0; @(posedge TCK);
   TRST <= 1;          @(posedge TCK);
   TRST <= 0;          @(posedge TCK);
end

initial begin

  @(negedge TRST)  TMS = 1; // <- STATE_TEST_LOGIC_RESET
  @(posedge TCK);  TMS = 0; // <- STATE_RUN_TEST_IDLE
  repeat(2) @(posedge TCK); // <- STATE_RUN_TEST_IDLE
  @(posedge TCK);  TMS = 1;

  repeat(10) @(posedge TCK); $finish;
end

initial begin
  $dumpfile("tap_controller_tb.vcd");
  $dumpvars(-1, tap_controller_tb);
end

endmodule