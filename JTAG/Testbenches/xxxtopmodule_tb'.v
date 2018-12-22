`timescale 1 ns / 1 ns
module topmodule_tb();

reg  TMS;
reg  TCK;
reg  TRST;
reg  TDI;
wire TDO;

localparam BYPASS   = 4'hF;
localparam SAMPLE   = 4'h1;
localparam EXTEST   = 4'h2;
localparam INTEST   = 4'h3; 
localparam RUNBIST  = 4'h4;
localparam CLAMP    = 4'h5;
localparam IDCODE   = 4'h7;
localparam USERCODE = 4'h8;
localparam HIGHZ    = 4'h9;

TOPMODULE ics_sample
( 
  .TMS(TMS)
, .TCK(TCK)
//, .TRST(TRST)
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

task command;
  input [3:0] cmd;
  begin
    TMS = 0; repeat(1) @(negedge TCK); // Run Test IDLE <- C
    TMS = 1; @(negedge TCK); // Select DR_Scan <- 7
    TMS = 1; @(negedge TCK); // Select IR_Scan <- 4
    TMS = 0; @(negedge TCK); // Capture_IR <- E
    TMS = 0; @(negedge TCK); // SHIFT_IR <- A 

      TDI = cmd[0]; TMS = 0; @(negedge TCK); // SHIFT_IR <- A
      TDI = cmd[1]; TMS = 0; @(negedge TCK); // SHIFT_IR <- A
      TDI = cmd[2]; TMS = 0; @(negedge TCK); // SHIFT_IR <- A
      TDI = cmd[3]; TMS = 1; @(negedge TCK); // EXIT1_IR <- 9

    TDI = 0; TMS = 1; @(negedge TCK); // UPDATE_IR <- D
    TMS = 0; @(negedge TCK); // Run Test IDLE <- C
    TMS = 0; @(negedge TCK); // Run Test IDLE <- C
    TMS = 0; @(negedge TCK); // Run Test IDLE <- C
  end 
endtask

task data;
  input [7:0] data;
  begin
    TMS = 1; @(negedge TCK); // Select_DR_Scan <- 7
    TMS = 0; @(negedge TCK); // Capture_DR <- 7
    TMS = 0; @(negedge TCK); // Shidt_DR <- 2

      // For LBS
      TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2

      TDI = data[0]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[1]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[2]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[3]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2

      TDI = data[4]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[5]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[6]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[7]; TMS = 1; @(negedge TCK); // EXIT1_DR <- 2

      TDI = 0; TMS = 0; @(negedge TCK); // PAUSE_DR <- 3
      TDI = 0; TMS = 0; @(negedge TCK); // PAUSE_DR <- 3
      TDI = 0; TMS = 0; @(negedge TCK); // PAUSE_DR <- 3
      TDI = 0; TMS = 0; @(negedge TCK); // PAUSE_DR <- 3

    TMS = 1; @(negedge TCK); // EXIT2_DR  <- 0
    TMS = 1; @(negedge TCK); // UPDATE_DR <- 5
    TMS = 0; @(negedge TCK); // RUN_TEST_IDLE <- C
    TMS = 0; @(negedge TCK); // RUN_TEST_IDLE <- C
    TMS = 0; @(negedge TCK); // RUN_TEST_IDLE <- C
  end 
endtask

initial begin

  repeat(5) @(negedge TCK); // Test Logic Reset <- F

  command(BYPASS); data(8'b10000001);
  command(SAMPLE); data(8'b10100101);
  command(EXTEST); data(8'b01101111);
  command(INTEST); data(8'b01101111);
  command(BYPASS); data(8'b10000001);
  
  repeat(10) @(posedge TCK); $finish;
end

initial begin
  $dumpfile("topmodule_tb.vcd");
  $dumpvars(-1, topmodule_tb);
end

endmodule