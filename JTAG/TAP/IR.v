module IR
#(   
	parameter IR_DATA_WIDTH = 4  // IR_LENGTH PARAMETR
)
(
    input      TRST
,   input      TDI
,   input      TCK
,   input      UPDATE_IR
,   input      SHIFT_IR
,   input      CAPTURE_IR
,   input      TLR
,   output reg [3:0] LATCH_IR
,   output reg I_TDO
);


reg [IR_DATA_WIDTH-1:0]  IR;           
//reg [7:0]  IDCODE = 8'hF1;
localparam BYPASS   = 4'hF;

always @ (posedge TCK or negedge TRST)
begin
if (TRST == 0)
    IR[IR_DATA_WIDTH-1:0] <= 4'b0000;
  else if (TLR == 1)
  	IR[IR_DATA_WIDTH-1:0] <= 4'b0000;
  else if(CAPTURE_IR)
    IR <= 4'b0101;
  else if (SHIFT_IR)
    IR[3:0] <= {TDI, IR[IR_DATA_WIDTH-1:1]};
end


always @(negedge TCK) begin
    I_TDO <= IR[0]; // This is latched on a negative TCK edge after the output MUX
end

// Updating jtag_ir (Instruction Register)
// jtag_ir should be latched on FALLING EDGE of TCK when capture_ir == 1
always @ (negedge TCK or negedge TRST)
begin
  if (TRST == 0)
    LATCH_IR <= BYPASS;
//    LATCH_IR <= IDCODE; //IDCODE selected after reset
//  else if (TLR)
//    LATCH_IR <= IDCODE; //IDCODE selected after reset
  else if (UPDATE_IR)
    LATCH_IR <= IR;
end

endmodule