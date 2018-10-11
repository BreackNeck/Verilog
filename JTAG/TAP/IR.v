module IR
#(   
	parameter IR_DATA_WIDTH = 4  // IR_LENGTH PARAMETR
)
(
    input                        TRST
,   input                        TDI
,   input                        TCK
,   input                        UPDATE_IR
,   input                        SHIFT_IR
,   input                        CAPTURE_IR
,   input                        TLR
,   output reg [IR_DATA_WIDTH:0] LATCH_IR
,   output reg                   I_TDO
);


reg [IR_DATA_WIDTH-1:0]  IR;          
reg [IR_DATA_WIDTH-1:0]  LATCHED_IR; 

always @ (posedge TCK or negedge TRST)
begin
  if(TRST == 0)
    IR[IR_DATA_WIDTH-1:0] <= IR_DATA_WIDTH'b0;
  else if (TLR == 1)
	IR[IR_DATA_WIDTH-1:0] <= IR_DATA_WIDTH'b0;
  else if(CAPTURE_IR)
    IR <= 4'b0001; 
  else if(SHIFT_IR)
    IR[IR_DATA_WIDTH-1:0] <= {TDI, IR[IR_DATA_WIDTH-1:1]};
end


always @(negedge TCK) begin
    I_TDO <= IR[0];
end

always @ (negedge TCK or negedge TRST)
begin
  if(TRST == 0)
    LATCHED_IR <= IDCODE;  
  else if (TLR)
    LATCHED_IR <= IDCODE;  
  else if(UPDATE_IR)
    LATCHED_IR <= IR;
end

