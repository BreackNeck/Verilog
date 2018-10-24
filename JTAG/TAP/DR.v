`include "IR_DEFINES.v"

module dr
#(   
	parameter ID_WIDTH = 8  // ID_LENGTH PARAMETR
    , USER_WIDTH = 8
    , ID_VALUE = 8'hA1
    , USER_VALUE = 8'hA1
    , BSR_WIDTH = 10
)
(
    input            TRST
,   input            TLR
,   input            TCK
,   input            TDI
,   input            ENABLE
,   input            LATCH_IR
,   input            CAPTURE_DR
,   input            UPDATE_DR
,   input            SHIFT_DR
,   input            EXTERNAL_inREG
,   input            CORE_LOGIC

,   output reg       [BSR_WIDTH-1:0] BSR
,   output reg       BSR_TDO
,   output reg       ID_TDO
,   output reg       USER_TDO
,   output [3:0]     EXTERNAL_outREG
,   output [3:0]     CORE_LOGIC_OUT
);

reg [ID_WIDTH-1:0]   ID <= ID_VALUE;
wire                 ID_TDO;
reg [USER_WIDTH-1:0] USER <= USER_VALUE;
wire                 USER_TDO;

always @(LATCH_IR) begin

    BYPASS_SELECT   <= 1'b0;
    SAMPLE_SELECT   <= 1'b0;
    EXTEST_SELECT   <= 1'b0;
    INTEST_SELECT   <= 1'b0;
    RUNBIST_SELECT  <= 1'b0;
    CLAMP_SELECT    <= 1'b0;
    IDCODE_SELECT   <= 1'b0;
    USERCODE_SELECT <= 1'b0;
    HIGHZ_SELECT    <= 1'b0;

    case(LATCH_IR)
        `BYPASS:   begin BYPASS_SELECT   <= 1'b1; end
        `SAMPLE:   begin SAMPLE_SELECT   <= 1'b1; end
        `EXTEST:   begin EXTEST_SELECT   <= 1'b1; end
        `INTEST:   begin INTEST_SELECT   <= 1'b1; end
        `RUNBIST:  begin RUNBIST_SELECT  <= 1'b1; end
        `CLAMP:    begin CLAMP_SELECT    <= 1'b1; end
        `IDCODE:   begin IDCODE_SELECT   <= 1'b1; end
        `USERCODE: begin USERCODE_SELECT <= 1'b1; end
        `HIGHZ:    begin HIGHZ_SELECT    <= 1'b1; end
        default:  begin BYPASS_SELECT    <= 1'b1; end
    endcase
end

always @ (posedge TCK or negedge TRST)
begin
  if(TRST == 0) 
    begin
      ID <= ID_VALUE;
      USER <= USER_VALUE; 
    end  
  else if (TLR)
    begin
      ID <= ID_VALUE;
      USER <= USER_VALUE;
    end
  else if (IDCODE_SELECT & CAPTURE_DR)
      ID <=  ID_VALUE;
  else if (USERCODE_SELECT & CAPTURE_DR)
      USER <= USER_VALUE;
  else if (IDCODE_SELECT & SHIFT_DR)
      ID <= {TDI, ID[ID_WIDTH-1:1]};
  else if (USERCODE_SELECT & SHIFT_DR)
      USER <= {TDI, USER[USER_WIDTH-1:1]};
end

always @ (posedge TCK) 
begin
    if ( SAMPLE_SELECT & CAPTURE_DR) 
        BSR <= { EXTERNAL_inREG[3:0], LSB };
    else if ( EXTEST_SELECT & CAPTURE_DR) 
        BSR <= { EXTERNAL_inREG[3:0], BSR[3:0], LSB };
    else if ( INTEST_SELECT & CAPTURE_DR) 
        BSR <= { CORE_LOGIC[3:0], LSB };
    else if ( SHIFTDR & (SAMPLE_SELECT | EXTEST_SELECT | INTEST_SELECT))
        BSR <= { TDI, BSR[BSR_WIDTH-1:1] };
   
end

assign EXTERNAL_outREG = BSR[9:6];
assign CORE_LOGIC_OUT  = BSR[5:2];

always @ (negedge TCK) ID_TDO <= ID[0];
always @ (negedge TCK) USER_TDO <= USER[0];
always @ (negedge TCK) BSR_TDO <= BSR[0];


endmodule