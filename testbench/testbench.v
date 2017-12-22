`timescale 1 ps/ 1 ps
module testbench
#(   parameter DATA_WIDTH = 8
  ,  parameter ATTR_WIDTH = 4
  ,  parameter SIGN       = 0
  ,  parameter OVERFLOW   = 1
)
(); 
reg clk 
,	signal_load
,	signal_init
,	signal_neg
, signal_oe; 

reg [DATA_WIDTH-1:0] data_in = 5;
reg [ATTR_WIDTH-1:0] attr_in = 0;
reg number_of_operation;

bench testbench (
        .clk(clk),
        .signal_load(signal_load),
        .signal_init(signal_init),
        .signal_neg(signal_neg),
        .signal_oe(signal_oe),
        .data_in(data_in),
        .attr_in(attr_in)        
);

//event load;
event reset_trigger; 
event reset_done_trigger;
/////////////////////////
/////////////////////////
/////////////////////////
/////////////////////////
/////////////////////////
task defaultValue;
	begin
		$display(" START default ");		
		signal_load = 0;
		signal_init = 0;
		signal_neg  = 0;
		signal_oe	= 0;
		$display(" STOP default ");
	end
endtask 

initial begin 
 forever begin 
  @ (reset_trigger); 
  @ (negedge clk); 
  signal_load = 0;   
  //@ (negedge clock); 
  //signal_load = 1; 
  -> reset_done_trigger; 
  end 
end

task init;
begin
  signal_init = 1;
  @ (posedge clk);
  signal_init = !signal_init;
end
endtask

task send;
  input [DATA_WIDTH-1:0] data;//, del;
begin
   @(posedge clk);
  signal_load = 1;
  
  //repeat (del) begin @(posedge clk); end
  data_in = data;
  repeat(2) begin @(posedge clk); end
  signal_neg = 0;
  -> reset_trigger;
end
endtask

task neg;
    begin
        signal_neg = 1;
    end
endtask

task oe;
    begin
        signal_oe = 1;
        -> reset_trigger;
    end
endtask
// Событие загрузки 
// always begin
// 	@(load);
// 	$display(" LOAD! ");
// 	signal_load = 1;
// end
initial begin
  clk = 0;
  forever #5 clk = !clk;
end

initial 
  begin

    $display("Start programm");
    //clk = 0;

    defaultValue();

    init(); 
    send(4); send(3); neg(); send(5);
    oe();

    init();
    send(2); send(3); send(2);
    oe();

  end
// initial 
//   begin
//     $display("start");
//     clk = 0; 
// 	defaultValue ();
// 	sumTwoValue (1,2,3,4);
//   //write_data(3);	

//   end
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
initial
begin
  #6000 $finish;
end

initial
begin
	$dumpfile("bench.vcd");
	$dumpvars(0,testbench);
	$display("finish");
end 

endmodule

// ----------------------------------------------
// iverilog -o test -I./ -y./ bench.v testbench.v
// vvp test
// gtkwave bench.vcd
// iverilog -o test -I./ -y./ bench.v testbench.v && vvp test && gtkwave bench.vcd
// ----------------------------------------------

