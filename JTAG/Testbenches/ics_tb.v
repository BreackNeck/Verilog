`timescale 1 ns / 1 ns
module ics_tb();

reg  TMS;
reg  TCK;
reg  TRST;
reg  TDI;
wire TDO;

ics ics_sample
( 
  .TMS(TMS)
, .TCK(TCK)
, .TRST(TRST)
, .TDI(TDI)
, .TDO(TDO)
);

always begin
   #5  TCK <= ~TCK; // 200MHz
end

initial begin
   TCK = 0; TMS = 1; TRST = 0; TDI = 0; @(posedge TCK);
   TRST = 1;                            @(posedge TCK);
   TRST = 0;                            @(posedge TCK);
end  

initial begin

  // Работа с Instruction, загружаем 0b1001 и 0b1111
  repeat(5) @(negedge TCK); // Test Logic Reset <- F
  // Переходим в состояние Run Test IDLE подав на TMS = 0
  TMS = 0; repeat(1) @(negedge TCK); // Run Test IDLE <- C
  TMS = 1; @(negedge TCK); // Select DR_Scan <- 7
  TMS = 1; @(negedge TCK); // Select IR_Scan <- 4
  TMS = 0; @(negedge TCK); // Capture_IR <- E
  TMS = 0; @(negedge TCK); // SHIFT_IR <- A (Переходим в состояние)

    TDI = 0; TMS = 0; @(negedge TCK); // SHIFT_IR <- A (Передаем бит)
    TDI = 1; TMS = 0; @(negedge TCK); // SHIFT_IR <- A (Передаем бит)
    TDI = 0; TMS = 0; @(negedge TCK); // SHIFT_IR <- A (Передаем бит)
    TDI = 0; TMS = 1; @(negedge TCK); // EXIT1_IR <- 9 (Передаем бит)

  TDI = 0; TMS = 0; @(negedge TCK); // PAUSE_IR <- B
  TMS = 0; @(negedge TCK); // PAUSE_IR <- B
  TMS = 0; @(negedge TCK); // PAUSE_IR <- B
  TMS = 0; @(negedge TCK); // PAUSE_IR <- B
  TMS = 0; @(negedge TCK); // PAUSE_IR <- B
  TMS = 0; @(negedge TCK); // PAUSE_IR <- B
  TMS = 1; @(negedge TCK); // EXIT2_IT <- 8
  TMS = 0; @(negedge TCK); // SHIFT_IR <- A

    TDI = 1; TMS = 0; @(negedge TCK); // SHIFT_IR <- A
    TDI = 0; TMS = 0; @(negedge TCK); // SHIFT_IR <- A
    TDI = 0; TMS = 0; @(negedge TCK); // SHIFT_IR <- A
    TDI = 0; TMS = 1; @(negedge TCK); // EXIT1_IR <- 9

  TDI = 0; TMS = 1; @(negedge TCK); // PAUSE_IR <- B
  TMS = 0; @(negedge TCK); // Run Test IDLE <- B
  TMS = 0; @(negedge TCK); // Run Test IDLE <- B
  TMS = 0; @(negedge TCK); // Run Test IDLE <- B

  // Работа с data, 
  TMS = 1; @(negedge TCK); // Select_DR_Scan <- 7
  TMS = 0; @(negedge TCK); // Capture_DR <- 7
  TMS = 0; @(negedge TCK); // Shidt_DR <- 2

    TDI = 1; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
    TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
    TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
    TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2

    TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
    TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
    TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
    TDI = 1; TMS = 1; @(negedge TCK); // EXIT1_DR <- 2
    TDI = 0; TMS = 0; @(negedge TCK); // PAUSE_DR <- 3
    TDI = 0; TMS = 0; @(negedge TCK); // PAUSE_DR <- 3
    TDI = 0; TMS = 0; @(negedge TCK); // PAUSE_DR <- 3
    TDI = 0; TMS = 0; @(negedge TCK); // PAUSE_DR <- 3

  TMS = 1; @(negedge TCK); // EXIT2_DR <- 0
  TMS = 0; @(negedge TCK); // SHIFT_DR <- 2

    TDI = 1; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
    TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
    TDI = 1; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
    TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2

    TDI = 1; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
    TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
    TDI = 1; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
    TDI = 0; TMS = 1; @(negedge TCK); // EXIT1_DR <- 2
    TDI = 0; TMS = 0; @(negedge TCK); // PAUSE_DR <- 3
    TDI = 0; TMS = 0; @(negedge TCK); // PAUSE_DR <- 3
    TDI = 0; TMS = 0; @(negedge TCK); // PAUSE_DR <- 3
    TDI = 0; TMS = 0; @(negedge TCK); // PAUSE_DR <- 3

  TMS = 1; @(negedge TCK); // EXIT2_DR  <- 0
  TMS = 1; @(negedge TCK); // UPDATE_DR <- 5
  TMS = 0; @(negedge TCK); // RUN_TEST_IDLE <- C
  TMS = 1; @(negedge TCK); // SELECT_DR_SCAN <- 7
  TMS = 1; @(negedge TCK); // SELECT_IR_SCAN <- 4
  TMS = 1; @(negedge TCK); // TEST_LOGIC <- 5
  TMS = 1; @(negedge TCK); // TEST_LOGIC <- 5



  repeat(10) @(posedge TCK); $finish;
end



initial begin
  $dumpfile("ics_tb.vcd");
  $dumpvars(-1, ics_tb);
end

endmodule