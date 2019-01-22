`timescale 1 ns / 1 ns
module bist_tb
#(
    parameter DEPTH = 256
)
();

reg  clk;
reg  TMS;
reg  TCK;
reg  TRST;
reg  TDI;
wire TDO;

localparam IDCODE     = 4'h7;
localparam BYPASS     = 4'hF;
localparam SAMPLE     = 4'h1;
localparam EXTEST     = 4'h2;
localparam INTEST     = 4'h3;
localparam USERCODE   = 4'h8;
localparam RUNBIST 		= 4'h4;
localparam GETTEST		= 4'h5;


TOPMODULE 
#(
  .DEPTH(DEPTH)
) TOPMODULE_sample
( 
  .clk(clk) 
, .TMS(TMS)
, .TCK(TCK)
, .TDI(TDI)
, .TDO(TDO)
);

reg  [4:0] X;
wire [3:0] Y;

always begin
   #10  TCK <= ~TCK; // 20MHz
end

always begin
   #5  clk <= ~clk; // 200MHz
end

initial begin
   TCK = 0; clk = 0; TMS = 1; TRST = 0; TDI = 0; @(posedge TCK);
   TRST = 1;                                     @(posedge TCK);
   TRST = 0;                                     @(posedge TCK);
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
  input [9:0] data;
  begin
    TMS = 1; @(negedge TCK); // Select_DR_Scan <- 7
    TMS = 0; @(negedge TCK); // Capture_DR <- 7
    TMS = 0; @(negedge TCK); // Shidt_DR <- 2

      //For LBS
      // TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      // TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2

      TDI = data[0]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[1]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[2]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[3]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2

      TDI = data[4]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[5]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[6]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[7]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[8]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[9]; TMS = 1; @(negedge TCK); // EXIT1_DR <- 2

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

task data8;
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

task data16;
  input [15:0] data;
  begin
    TMS = 1; @(negedge TCK); // Select_DR_Scan <- 7
    TMS = 0; @(negedge TCK); // Capture_DR <- 7
    TMS = 0; @(negedge TCK); // Shidt_DR <- 2

      //For LBS
      // TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      // TDI = 0; TMS = 0; @(negedge TCK); // Shidt_DR <- 2

      TDI = data[0]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[1]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[2]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[3]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2

      TDI = data[4]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[5]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[6]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[7]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[8]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[9]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[10]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[11]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[12]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[13]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[14]; TMS = 0; @(negedge TCK); // Shidt_DR <- 2
      TDI = data[15]; TMS = 1; @(negedge TCK); // EXIT1_DR <- 2

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

task reset;
  begin
    TMS = 1; @(negedge TCK);
    TMS = 1; @(negedge TCK);
    TMS = 1; @(negedge TCK);
    TMS = 1; @(negedge TCK);
    TMS = 0; @(negedge TCK);
  end
endtask

task display_buffers;
  integer i;
  begin
    for ( i = 0; i < 15; i = i + 1 ) begin
      $display("RAM %d -> %b | CHECK -> %b ", i, TOPMODULE_sample.BIST_INST.bist_config[i], TOPMODULE_sample.BIST_INST.bist_check[i]);
    end
  end 
endtask

// task info;
//   begin
//     $display("ERROR %b | STOP -> %b | BIST_LOG -> %b", TOPMODULE_sample.BuiltInSelfTest.error, ics_sample.BuiltInSelfTest.RESET_SM, ics_sample.BuiltInSelfTest.BIST_DATA);
//     $display("++++++++++++++++++++++++++++++++++++++++");
//   end 
// endtask

initial begin

  repeat(5) @(negedge TCK);  

  //display_buffers(); $display("++++++++++++++++++++++++++++++++++++++++");

  command(GETTEST); 

    data(10'b0000000100); //02
    data(10'b1011000010); //b1 0010
    data(10'b1111000000); //F0 0000
    data(10'b0001000100); //12 0100
    data(10'b1111001010); //F5 1010

    data(10'b0000100000); //x0

    data(10'b0000000100); //02
    data(10'b1011000010); //b1
    data(10'b1111000000); //F0 1111
    data(10'b0001000100); //12
    data(10'b1111001010); //F5

    data(10'b0101101010); //x5  

    data(10'b1100000000); //C0
    data(10'b0001000100); //12
    // data(10'b1100011100); //CE
    // data(10'b1101001000); //D4
    // data(10'b1111000010); //F1

  display_buffers();

  command(RUNBIST);

  repeat(5) @(negedge TCK);  

    data16(16'b0);
    
     
  // // ///////////////////////////////////////
   
    // command(GETTEST);

    // data(10'b1001010100); //9A
    // data(10'b0011000100); //32
    // data(10'b0110001110); //67
    // data(10'b0000000000); //00
    // data(10'b1111011010); //FD
    // data(10'b0010000000); //20

    // command(RUNBIST);
    /////////////////////////////////////   



  //   data(SET_STATE);
  //   data(8'b00000000);

  // data(8'b00100001);
  // data(8'b01000000);
  // data(8'b00100001);
  // data(8'b10100011);
  // data(8'b11100010);
  // data(8'b10110001);

  //   data(SET_STATE);
  //   data(8'b00000000);

  // data(8'b00100001);
  // data(8'b01000000);
  // data(8'b00100001);
  // data(8'b10100011);
  // data(8'b11100010);
  // data(8'b10110001);
  // data(8'b00101011);
  // data(8'b10100001);
  // data(8'b01000000);

  //command(BYPASS); data(8'b10000001);
  //command(SAMPLE); data(8'b10100101);
  //command(EXTEST); data(8'b01101111);
  
  // command(INTEST); data8(8'b10101001);
  // command(INTEST); data8(8'b10101001);
  // command(INTEST); data8(8'b00100011);
  // command(INTEST); data8(8'b01110110);
  // command(INTEST); data8(8'b00000000);
  // command(INTEST); data8(8'b11011111);
  // command(INTEST); data8(8'b00000010);

  ///////////////////////////////////// 5210 - 1270 = 3940 ns; 
  ///////////////////////////////////// 1 ???? - 10 ns; ????? ???????????? ? ??????? ??????? - 394 ????? (3940 ns);
  ///////////////////////////////////// 1 ???? - 10 ns; ????? ???????????? ? ??????? BIST - 4 ????? (40 ns)

  //command(BYPASS); data(8'b10000001);

  //repeat(1000) @(posedge clk); info();
  repeat(100) @(posedge clk); $finish;
end

initial begin
  $dumpfile("bist_tb.vcd");
  $dumpvars(-1, bist_tb);
end

endmodule