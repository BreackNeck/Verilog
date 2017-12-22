`timescale 1 ms/ 1 ms
module testbench
#( parameter DATA_WIDTH = 32
,  parameter SCLK_HALFPERIOD = 8
) ();

reg clk;
reg rst;
wire ready;
reg start_transaction;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;

// puspi.v
reg [1:0] addr;
wire       wr;
wire       oe;
wire [DATA_WIDTH-1:0] data_out_puspi;
wire [DATA_WIDTH-1:0] data_in_puspi;

// slave / master
wire mosi_SM;
wire miso_SM;
wire sclk;
wire cs;
reg sclk_slave;
reg cs_slave;

// master
spi_master_driver testbench_1 (
	.clk(clk)
,	.rst(rst)
,	.start_transaction(start_transaction)
,	.data_in(data_in)
, .mosi(miso_SM)
, .miso(mosi_SM)
, .data_out(data_out)
, .ready(ready)
, .sclk(sclk)
, .cs(cs)
);

// slave
spi_slave_driver testbench_2 (
  .clk(clk)
, .rst(rst)
, .data_in(data_in)
, .ready(ready)
, .data_out(data_out)
, .mosi(miso_SM)
, .miso(mosi_SM)
, .sclk(sclk_slave)
, .cs(cs_slave)
);

// process unit spi
puspi testbench_3 (
	.addr(addr)
,	.reset(rst)
,	.clk(clk)
, .wr(wr)
, .oe(oe)
, .data_out(data_in_puspi)
, .data_in(data_out_puspi)
);

// computational
computational testbench_4 (
  .data_in(data_out_puspi)
, .data_out(data_in_puspi)
, .wr(wr)
, .oe(oe)
, .clk(clk)
);

always @* begin
  sclk_slave <= sclk;
  cs_slave   <= cs;
end

always begin
  #5 clk = ~clk;
end 

initial 
  begin
    $display("Start");
    clk = 0;
    // Work

    // End work
  end

initial
  begin
    #10000 $finish;
  end

initial
  begin
    $dumpfile("testbench.vcd");
    $dumpvars(0,testbench);
    $display("finish");
  end 

endmodule