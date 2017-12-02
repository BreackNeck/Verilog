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

reg [DATA_WIDTH-1:0] m = 5;
wire [DATA_WIDTH-1:0] data_in = m[DATA_WIDTH-1:0];
wire [ATTR_WIDTH-1:0] attr_in = 0;

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

initial 
  begin
    $display("start");
    clk = 0;  
	signal_load = 0;
	signal_init = 0;
	signal_neg  = 0;
	signal_oe	= 1;


 //-------------Симуляция тута ---------------
 // Сложение (Нормальное)
	#10
 	signal_load = 1;
 	signal_init = 1;
 	#10
 	signal_init = 0;
 	m = 3;
 	#10
 	signal_init = 1;
	#10
 	signal_init = 0;
 	#20	
 	signal_load = 0;

// Вычитание (Нормальное)
 	// Обнулим
 	#100
 	m = 0;
 	signal_load = 1;
 	signal_init = 1;
 	// Вернем стартовое состояние
 	#40
 	signal_load = 0;
	signal_init = 0;
	signal_neg = 1;
	m = 5;
	#10
	signal_load = 1;
 	signal_init = 1;
 	#10
 	signal_init = 0;
 	signal_neg = 0;
 	m = 7;
 	#10
 	signal_init = 1;
	#10
 	signal_init = 0;
 	#20	
 	signal_load = 0;

// Сложение (Проверка корректности) signal_init раньше, signal_load позже

 	// Обнулим
 	#100
 	m = 0;
 	signal_load = 1;
 	signal_init = 1;
 	// Вернем стартовое состояние
 	#40
 	signal_load = 0;
	signal_init = 0;
	//signal_neg = 1;
	m = 5;
	
	#100
 	signal_init = 1;
	#10
	signal_load = 1;
 	#10 // 20
 	signal_init = 0;
 	m = 7;
 	#10
 	signal_init = 1;
	#10
 	signal_init = 0;
 	#20	
 	signal_load = 0;

// Сложение (Проверка корректности) signal_load раньше, signal_init позже

 	// Обнулим
 	#100
 	m = 0;
 	signal_load = 1;
 	signal_init = 1;
 	// Вернем стартовое состояние
 	#40
 	signal_load = 0;
	signal_init = 0;
	m = 5;
	#100
 	signal_load = 1;
	#10
	signal_init = 1;
 	#10 // 20
 	signal_init = 0;
 	m = 7;
 	#10
 	signal_init = 1;
	#10
 	signal_init = 0;
 	#20	
 	signal_load = 0;
	

// Сложение (Проверка корректности) передача второго параметра чуть позже

 	// Обнулим
 	#100
 	m = 0;
 	signal_load = 1;
 	signal_init = 1;
 	// Вернем стартовое состояние
 	#40
 	signal_load = 0;
	signal_init = 0;
	m = 5;
	#10
 	signal_load = 1;
	#10
	signal_init = 1;
 	#10 
 	signal_init = 0;
	#50 // передаем уть позже
 	m = 7;
 	#10
 	signal_init = 1;
	#10
 	signal_init = 0;
 	#20	
 	signal_load = 0;
 	
// Сложение (Проверка корректности) передаем первый параметр чуть позже

 	// Обнулим
 	#100
 	m = 0;
 	signal_load = 1;
 	signal_init = 1;
 	// Вернем стартовое состояние
 	#40
 	signal_load = 0;
	signal_init = 0;
	#100
	m = 5;
	#10
 	signal_load = 1;
	#10
	signal_init = 1;
 	#10 
 	signal_init = 0;
 	m = 7;
 	#10
 	signal_init = 1;
	#10
 	signal_init = 0;
 	#20	
 	signal_load = 0;

// Сложение (Проверка корректности) позже подача сгнала конец суммирования

 	// Обнулим
 	#100
 	m = 0;
 	signal_load = 1;
 	signal_init = 1;
 	// Вернем стартовое состояние
 	#40
 	signal_load = 0;
	signal_init = 0;
	m = 5;
	#10
 	signal_load = 1;
	#10
	signal_init = 1;
 	#10 
 	signal_init = 0;
 	m = 7;
 	#10 
 	signal_init = 1;
	// Конец суммирования
	#30 // Граница по времени, когда перестает работать
 	signal_init = 0;
 	#20	
 	signal_load = 0;

// Сложение (Проверка корректности) Конец загрузки данных чуть позже

 	// Обнулим
 	#100
 	m = 0;
 	signal_load = 1;
 	signal_init = 1;
 	// Вернем стартовое состояние
 	#40
 	signal_load = 0;
	signal_init = 0;
	m = 5;
	#10
 	signal_load = 1;
	#10
	signal_init = 1;
 	#10 
 	signal_init = 0;
 	m = 7;
 	#10
 	signal_init = 1;
	#10
 	signal_init = 0;
 	#100
 	signal_load = 0;

// Сложение (Проверка корректности) Все  подается с задержкой

 	// Обнулим
 	#200
 	m = 0;
 	signal_load = 1;
 	signal_init = 1;
	
 	// Вернем стартовое состояние
 	#100
 	signal_load = 0;
	#100
	signal_init = 0;
	#100
	m = 5;
	#100
 	signal_load = 1;
	#100
	signal_init = 1;
 	#100
 	signal_init = 0;
	#100
 	m = 7;
 	#100
 	signal_init = 1;
	#100
 	signal_init = 0;
 	#100
 	signal_load = 0;

 //-------------Конец симуляции---------------

  end  

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
// Использовать task время #x заменить на always