`timescale 10ns / 10ns

module BusUpsizerTest;
  parameter S_DATA_WIDTH = 8, M_DATA_WIDTH = 32;
  reg clock;
  reg reset;
  reg s_val;
  reg [S_DATA_WIDTH-1:0] s_data;
  reg m_rdy;
  wire s_rdy;
  wire m_val;
  wire [M_DATA_WIDTH-1:0] m_data;
 
  BusUpsizer #(.S_DATA_WIDTH(S_DATA_WIDTH), 
               .M_DATA_WIDTH(M_DATA_WIDTH))
  BUS

  (
    .clock(clock), 
    .reset(reset), 
    .s_val (s_val),
    .s_data(s_data), 
    .m_rdy (m_rdy),
    .s_rdy (s_rdy),
    .m_val (m_val),
    .m_data(m_data)
  );


initial begin
      $dumpfile("BusUpsizer.vcd");
      $dumpvars(0);
      clock = 1'b0;
      //assert (clk == 1'b0) $display ("clock = 0");
      forever #5 clock = ~clock;
    end
  
initial begin
    $dumpfile("BusUpsizer.vcd");
    $dumpvars(0,BUS);
    m_rdy = 0;
    s_val = 0;
    clock = 1;
    reset = 1;
    s_data = 8'b00000000; 
      repeat(1) #1 clock = ~clock;
      $display("Reset all");
      
    clock = 1;
    reset = 0;
    m_rdy=1;
    s_val = 1;
    s_data = 8'b00010000;
      repeat(8) #1  clock = ~clock;  
    
    clock = 1;
    reset = 0;
    m_rdy=1;
    s_val = 1;
    s_data =  8'b00000001;
      repeat(8) #1 clock = ~clock;
  clock = ~clock;
   
    
    clock = 1;
    reset = 0;
    m_rdy=1;
    s_val = 1;
    s_data =  8'b00000010;
    repeat(8) #1 clock = ~clock;
      
    clock = 1;
    reset = 0;
    m_rdy=1;
    s_val = 1;
    s_data =  8'b00000100;
    repeat(8) #1 clock = ~clock;
   
    $finish;
  end

endmodule