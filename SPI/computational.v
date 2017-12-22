module computational
#( 
	parameter DATA_WIDTH = 32
,   parameter LENGTH_MICROCODE = 100	
) 
(
	input  [DATA_WIDTH-1:0] data_in
,	input 	wr
,	input	oe
, 	input   clk
,	output reg [DATA_WIDTH-1:0] data_out 
);

reg [DATA_WIDTH-1:0] calculation_value;
reg [DATA_WIDTH-1:0] clk_limit;

initial
	begin
		calculation_value = 32'h0000000F;
	end

// Генерация рандомных значений
always @(posedge clk) begin
	clk_limit = clk_limit + 1;
end

// Как только микрокод отработает все строки, значит вычислительный цикл 
// совершил одну итерцию равную LENGTH_MICROCODE периодам тактового
// сигнала
always @(posedge clk_limit) begin
	if (clk_limit == LENGTH_MICROCODE) begin
		data_out = calculation_value;
		clk_limit = 0;
		calculation_value = calculation_value + 32'h0000000F;
	end
end

endmodule