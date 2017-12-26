`timescale 1 ms/ 1 ms
module testbench
#( parameter DATA_WIDTH = 2
,  parameter ATTR_WIDTH = 4
) ();

reg                  clk;
reg                  signal_load;
reg                  signal_init;
reg                  signal_neg;
reg [DATA_WIDTH-1:0] data_in;
reg [ATTR_WIDTH-1:0] attr_in;
reg                  signal_oe;

wire  [DATA_WIDTH-1:0] data_out;
wire  [ATTR_WIDTH-1:0] attr_out;

pu_accum pu_accum_sum(
  .clk(clk)
, .signal_load(signal_load)
, .signal_init(signal_init)
, .signal_neg(signal_neg)
, .data_in(data_in)
, .data_out(data_out)
, .signal_oe(signal_oe)
, .attr_in(attr_in)
, .attr_out(attr_out)
);

localparam START = 1'b1;
localparam STOP  = 1'b0;

task nop;
    begin
        $display(" Start default! ");
        signal_load = 0;
        signal_init = 0;
        signal_neg  = 0;
        signal_oe   = 0;
        data_in     = 0;
        attr_in     = 0;
        $display(" Stop default! ");
    end
endtask

task Load_Data;
    input x_load;
    begin
        signal_load = x_load;
        signal_init = 0;
        signal_oe   = 0;
        signal_neg  = 0;
    end
endtask

task Initialization;
    input x_init;
    begin
        signal_init = x_init;
    end
endtask

task Send_Value;
    input [DATA_WIDTH-1:0] data;
    begin
        data_in = data;
    end
endtask

task Send_Data_Out;
    input x_oe;
    begin
        signal_oe = x_oe;
    end
endtask

task Send_Neg;
    input x_neg;
    begin
        signal_neg = x_neg;
    end
endtask

always begin
  #5 clk = ~clk;
end 

initial 
  begin
    $display("Start");
    clk = 0;            @(posedge clk);

    nop(); @(posedge clk);

    Load_Data(START);                @(posedge clk);
    signal_init = START;             @(posedge clk);
    signal_init = STOP;  
    Load_Data(STOP);                 @(posedge clk);
    Load_Data(START);
    Send_Value(1);                   @(posedge clk);
    Load_Data(STOP);                 @(posedge clk);
    //Send_Neg(STOP);                  @(posedge clk); // start
    Load_Data(START);
    Send_Value(3);                   @(posedge clk);    
    Load_Data(STOP);                 @(posedge clk);
    //Send_Neg(STOP);                  @(posedge clk);
    Send_Data_Out(START);            @(posedge clk);
    Send_Data_Out(STOP);             @(posedge clk);
    repeat(10) @(posedge clk);
    $finish;
  end

initial
  begin
    $dumpfile("testbench.vcd");
    $dumpvars(0,pu_accum_sum);
    $display("finish");
  end 

endmodule