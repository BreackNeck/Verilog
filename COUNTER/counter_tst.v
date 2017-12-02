`timescale 1 ps/ 1 ps
module counter_tst
#(   
	parameter WIDTH = 2
)
();
reg clock;
reg reset;
reg	enable; 

counter counter_tst (
    .clock(clock),
    .reset(reset),
    .enable(enable)    
);

always
  #5 clock = ! clock;

initial 
  begin    
    clock = 0;  
    enable = 0;
	  reset = 0;	
	$display("Running Test");	
  end  


event reset_trigger; 
event reset_done_trigger;

initial begin 
 forever begin 
  @ (reset_trigger); 
  @ (negedge clock); 
  reset = 1;    
  @ (negedge clock); 
  reset = 0; 
  -> reset_done_trigger; 
  end 
end

initial  
  begin: TEST_CASE 
  #10  -> reset_trigger;  
  @ (reset_done_trigger); 
  @ (negedge clock);      
        enable = 1; 
  repeat (1000) begin  
    @ (negedge clock); 
  end 
  enable = 0; 
end

initial
begin
  #1000 $finish;
end

initial
begin
	$dumpfile("Test.vcd");
	$dumpvars(0,counter_tst);
	$display("finish");
end 

endmodule
/*
module BusUpsizerTest;
  parameter S_DATA_WIDTH = 8, M_DATA_WIDTH = 32;
  reg clock;
  reg reset;
  reg [S_DATA_WIDTH-1:0] s_data;
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

initial clk=0;
always
#5 clk=~clk;
  
  initial 
    begin
    clock = 1;
    reset = 0; 
    s_data <= 8'b00000000; 
      repeat(1) #1 clock = ~clock;
    clock = 1;
    reset = 1;
    s_data <= 8'b00000001;
      
      repeat(8) #1 clock = ~clock;
    clock = 1;
    reset = 1;
    s_data <=  8'b00000010;
      
      repeat(8) #1 clock = ~clock;
    clock = 1;
    reset = 1;
    s_data <=  8'b00000011;
      repeat(8) #1 clock = ~clock;
      
    clock = 1;
    reset = 1;
    s_data <=  8'b00000100;
      repeat(8) #1 clock = ~clock;  
    
  end
 
 initial
begin
  #1000 $finish;
end
 
initial
begin
  $dumpfile("BusUpsizer.vcd");
  $dumpvars(0,BusUpsizerTest);
  $display("finish");
end

endmodule
*/