module bench
// Параметры 
#(   parameter DATA_WIDTH = 8
  ,  parameter ATTR_WIDTH = 4
  ,  parameter SIGN       = 0
  ,  parameter OVERFLOW   = 1
)
// Входные/выходные сигналы
(
  input  wire                  clk
, input  wire                  signal_load      // Загрузка данных
, input  wire                  signal_init      // Старт/Стоп сумматора/счетчика
, input  wire                  signal_neg       // На увеличение (0) / уменьшение (1) 
, input  wire [DATA_WIDTH-1:0] data_in
, input  wire [ATTR_WIDTH-1:0] attr_in          // 
, input  wire                  signal_oe        // отвечает за обнуление?
, output reg  [DATA_WIDTH-1:0] data_out
, output reg  [ATTR_WIDTH-1:0] attr_out
); 

reg [DATA_WIDTH-1:0]   ext_arg;
reg [DATA_WIDTH-1:0]   int_arg;
reg [DATA_WIDTH:0]     acc; // +1 на переполнение
reg overflow;

always @(posedge clk)
  if ( signal_load ) begin
    if ( signal_init ) begin
      overflow <= attr_in[ OVERFLOW ];              // Нужно использовать <=
      int_arg = 0;
    end else begin 
      //overflow = overflow || attr_in[ OVERFLOW ];
      int_arg = acc[DATA_WIDTH:0];
    end
    ext_arg = signal_neg ? -data_in : data_in;
  end

wire [DATA_WIDTH:0]  wacc; // +1 на переполнение 33 битный 
wire carry;
// 31 бит
assign { carry, wacc[DATA_WIDTH-2:0] } = ext_arg[DATA_WIDTH-2:0] + int_arg[DATA_WIDTH-2:0];
assign wacc[DATA_WIDTH:DATA_WIDTH-1]   = ext_arg[DATA_WIDTH-1] + int_arg[DATA_WIDTH-1] + carry;

always @(posedge clk) begin
    acc[DATA_WIDTH:0] <= wacc;                // Не записывается
    //overflow <= carry ^ acc[DATA_WIDTH];
  end

always @(posedge clk)
  if ( ~signal_oe )
    { attr_out, data_out } <= 0;
  else begin
    data_out           <= acc[DATA_WIDTH-1:0];
    attr_out[SIGN]     <= acc[DATA_WIDTH];
    //attr_out[OVERFLOW] <= overflow;
  end  

endmodule