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


reg [IR_DATA_WIDTH-1:0]  IR;          // Instruction register
reg [IR_DATA_WIDTH-1:0]  LATCHED_IR; //, LATCHED_IR_neg;

always @ (posedge TCK or negedge TRST)
begin
  if(TRST == 0)
    IR[IR_DATA_WIDTH-1:0] <= IR_DATA_WIDTH'b0;
  else if (TLR == 1)
	IR[IR_DATA_WIDTH-1:0] <= IR_DATA_WIDTH'b0;
  else if(CAPTURE_IR)
    IR <= 4'b0101;          // This value is fixed for easier fault detection
  else if(SHIFT_IR)
    IR[IR_DATA_WIDTH-1:0] <= {TDI, IR[IR_DATA_WIDTH-1:1]};
end

// This is latched on a negative TCK edge after the output MUX
always @(negedge TCK) begin
    I_TDO <= IR[0];
end
// Updating jtag_ir (Instruction Register)
// jtag_ir should be latched on FALLING EDGE of TCK when capture_ir == 1
always @ (negedge TCK or negedge TRST)
begin
  if(TRST == 0)
    LATCHED_IR <= IDCODE;   // IDCODE selected after reset
  else if (TLR)
    LATCHED_IR <= IDCODE;   // IDCODE selected after reset
  else if(UPDATE_IR)
    LATCHED_IR <= IR;
end

