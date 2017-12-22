module puspi
#( parameter DATA_WIDTH = 32
,  parameter SCLK_HALFPERIOD = 8
) 
(
	//-----------------------------Addr---------------------------------------
	// 
	//------------------------------------------------------------------------
	input  [1:0] addr
	//-----------------------------Reset--------------------------------------
	// Сброс
	//------------------------------------------------------------------------
,	input  reset
	//-----------------------------Clock--------------------------------------
	// Сброс
	//------------------------------------------------------------------------
,	input  clk
	// Выходные данные от -> computational.v 
	//------------------------------------------------------------------------
,	input  [DATA_WIDTH-1:0] data_out
	//------------------------------wr----------------------------------------
	// Входные данные для -> computational.v 
	//------------------------------------------------------------------------
,	output  [DATA_WIDTH-1:0] data_in
	//------------------------------wr----------------------------------------
	// Сигнал на запись данных -> computational.v 
	//------------------------------------------------------------------------
,	output wr
	//------------------------------oe----------------------------------------
	// Сигнал на чтение данных -> computational.v
	//------------------------------------------------------------------------
,	output oe


);

//----------------------------Buffer0-------------------------------------
// 1. На запись (Write) -> computational.v
// 2. На чтение (Read) -> computational.v
//------------------------------------------------------------------------
reg [DATA_WIDTH-1:0] Buffer0 [0:1]; // Буфер из 2 слов, каждое по 32 бит
//----------------------------Buffer1-------------------------------------
// Буфер на отправку данных (send)
//------------------------------------------------------------------------
reg [DATA_WIDTH-1:0] Buffer1;
//----------------------------Buffer2-------------------------------------
// Буфер на прием данных (receive)
//------------------------------------------------------------------------
reg [DATA_WIDTH-1:0] Buffer2;
//-------------------------Addr_counter-----------------------------------
// 
//------------------------------------------------------------------------
reg addr_counter;

localparam ADDR_1 = 2'b00; 
localparam ADDR_2 = 2'b01; 
localparam ADDR_3 = 2'b10; 
localparam ADDR_4 = 2'b11; 

localparam ADDR_COUNTER_1 = 1'b0; 
localparam ADDR_COUNTER_2 = 1'b1; 

always @(posedge clk or posedge reset) begin
	if ( reset ) begin
		// reset
	end
end

//	Выбор режима работы с Buffer0
always @(posedge clk) begin
	case ( addr )
		ADDR_1: begin
			// Работа с Buffer0: Режим 1
		end
		ADDR_2: begin
			// Работа с Buffer0: Режим 2
		end
		ADDR_3: begin
			// Работа с Buffer0: Режим 3
		end
		ADDR_4: begin
			// Работа с Buffer0: Режим 4
		end
		default: begin
			// Работа с Buffer0: Режим 1
		end
	endcase
end

//	Работа с Buffer1 и Buffer2
always @(posedge clk) begin
	case ( addr_counter )
		ADDR_COUNTER_1: begin
			// Работа с Buffer1
		end
		ADDR_COUNTER_2: begin
			// Работа с Buffer2
		end
		default: begin
			// Работа с Buffer1
		end
	endcase
end

endmodule