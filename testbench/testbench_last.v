`timescale 1 ps/ 1 ps
module testbench_last
#(   parameter DATA_WIDTH = 8
  ,  parameter ATTR_WIDTH = 4
  ,  parameter SIGN       = 0
  ,  parameter OVERFLOW   = 1
)
(); 
reg clk 
,   signal_load
,   signal_init
,   signal_neg
,   signal_oe; 

localparam START = 1'b1;
localparam STOP  = 1'b0;

reg [DATA_WIDTH-1:0] data_in;
reg [ATTR_WIDTH-1:0] attr_in = 0;

wire [DATA_WIDTH-1:0] data_out;

bench unit_under_test (
    .clk(clk),
    .signal_load(signal_load),
    .signal_init(signal_init),
    .signal_neg(signal_neg),
    .signal_oe(signal_oe),
    .data_in(data_in),
    .attr_in(attr_in),
    .data_out(data_out)
);

task nop; // nop
    begin
        signal_load <= 0;
        signal_init <= 0;
        signal_neg  <= 0;
        signal_oe   <= 0;
        data_in     <= 0;
    end
endtask

task Initialization;
    input [DATA_WIDTH-1:0] id;
    begin
        signal_load <= 1;
        signal_init <= 1;
        signal_neg  <= 0;
        signal_oe   <= 0;
        data_in     <= id;
    end
endtask

task Load_Data;
    input [DATA_WIDTH-1:0] id;
    begin
        signal_load <= 1;
        signal_init <= 0;
        signal_neg  <= 0;
        signal_oe   <= 0;
        data_in     <= id;
    end
endtask

task outputdata;
    begin
        signal_load <= 0;
        signal_init <= 0;
        signal_neg  <= 0;
        signal_oe   <= 1;
    end
endtask


//task Initialization;
  //  input x_init;
    //begin
      //  signal_init <= x_init;
  //  end
//endtask

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

always
  #5 clk = ~clk;
reg RST;

initial 
  begin
    RST <= 1;
    $display("Start programm");
    clk = 0;

    nop(); @(posedge clk);
 
//    Load_Data(START);                @(posedge clk);
    RST <= 0;
    Initialization (25);       @(posedge clk);
    //nop(); @(posedge clk);
    //nop(); @(posedge clk);
    Load_Data(25);                 @(posedge clk);
    // Initialization (STOP);           @(posedge clk);
    // Send_Value(3);         repeat(2) @(posedge clk);
    // Send_Neg(START);                 @(posedge clk);
    // Send_Value(2);                   @(posedge clk);    
    // Load_Data(STOP);                 @(posedge clk);
    // Send_Neg(STOP);                  @(posedge clk);
    // Send_Data_Out(START);            @(posedge clk);
    // Send_Data_Out(STOP);             @(posedge clk);

    nop(); repeat(10) @(posedge clk);
    outputdata(); repeat(10) @(posedge clk);

    Initialization (5);   repeat(2) @(posedge clk);
    Load_Data(5);                 @(posedge clk);
    nop(); repeat(10) @(posedge clk);
    outputdata(); repeat(10) @(posedge clk);

    // nop(); @(posedge clk);

    // Load_Data(START);                @(posedge clk);
    // Initialization (START);          @(posedge clk);
    // Initialization (STOP);           @(posedge clk);
    // Send_Value(5);         repeat(2) @(posedge clk);
    // Send_Data_Out(START);            @(posedge clk);
    // Send_Data_Out(STOP);             @(posedge clk);
    // Send_Value(1);         repeat(2) @(posedge clk);
    // Send_Value(data_out);            @(posedge clk);
    // Send_Data_Out(START);            @(posedge clk);
    // Load_Data(STOP);                @(posedge clk);
    // Send_Data_Out(STOP);             @(posedge clk);



  //Initialization(START); @(posedge clk);
  //Initialization(STOP);  //@(posedge clk);


  end

initial
begin
  #6000 $finish;
end

initial
begin
    $dumpfile("bench.vcd");
    $dumpvars(0, testbench_last);
    $display("finish");
end 

endmodule

// ----------------------------------------------
// iverilog -o test -I./ -y./ bench.v testbench.v
// vvp test
// gtkwave bench.vcd
// iverilog -o test -I./ -y./ bench.v testbench.v && vvp test && gtkwave bench.vcd
// ----------------------------------------------