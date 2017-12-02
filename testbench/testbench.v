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
,   signal_oe; 

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
always
  #10 clk = ~clk;
event load;
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

task Pull_value;
	input number_of_operation;
	input signal_load;
	input signal_init;
	input signal_neg;
	input signal_oe;
	input data_in;
	begin
		//@(posedge clk);
		$display("Operation Number = %d  Time: ", number_of_operation, $time);
	end
endtask

task write_data;
	input [31:0] data;
	begin
		$display(" Start write_data! Time: ", $time);
		@(posedge signal_load);
		/////////////////////////////////////////////
		@(posedge clk);
		Pull_value (1,,1,,,data_one);
		@(posedge clk);
		Pull_value (2,0,0,1,,data_one);
		@(posedge clk);
		Pull_value (3,1,1,,,);
		@(posedge clk);
		Pull_value (4,0,0,,,data_two);
		@(posedge clk);
		Pull_value (5,0,0,,,data_two);
		@(posedge clk);
		Pull_value (6,,1,,,);
		@(posedge clk);
		Pull_value (7,,0,,,);
		@(posedge clk);
		Pull_value (8,0,,,,);
		@(posedge clk);
		Pull_value (9,1,0,,,);
		/////////////////////////////////////////////		
		-> load;
	end
endtask

// Событие загрузки 
always begin
	@(load);
	$display(" LOAD! ");
	signal_load = 1;
end

initial 
  begin
    $display("start");
    clk = 0; 
	defaultValue ();
	#20	
	-> load;
	write_data(3);	

  end
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

