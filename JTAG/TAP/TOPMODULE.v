`include "IR_DEFINES.v"

module TOPMODULE

(
    input      TMS
,   input      TCK
,   input      TRST
,   input      TDI
,   output reg TDO  
);

wire       CAPTURE_IR;
wire       SHIFT_IR;
wire       UPDATE_IR;

wire       CAPTURE_DR;
wire       SHIFT_DR;
wire       UPDATE_DR;

wire [7:0] BSR;

wire       MOD;
wire       ENABLE;

wire [3:0] IR;

wire       ID_TDO;
wire       USER_TDO;
wire       I_TDO;    
wire       BSR_TDO;     
wire       BYPASS_TDO;

wire BYPASS_SELECT;
wire SAMPLE_SELECT;
wire EXTEST_SELECT;
wire INTEST_SELECT;
wire RUNBIST_SELECT;
wire CLAMP_SELECT;
wire IDCODE_SELECT;
wire USERCODE_SELECT;
wire HIGHZ_SELECT;

tar_controller tar_controller_inst
( 
  .TMS(TMS)
, .TCK(TCK)
, .TRST(TRST)
, .TAP_RST(TAP_RST)
, .SELECT(SELECT)
, .ENABLE(ENABLE)
, .UPDATEIR(UPDATEIR)
, .SHIFTIR(SHIFTIR)
, .UPDATEDR(UPDATEDR)
, .SHIFTDR(SHIFTDR)
, .CAPTUREIR(CAPTUREIR)
, .CAPTUREDR(CAPTUREDR)
);

ir ir_inst
(
  .TDI(TDI)
, .TCK(TCK)
, .TRST(TRST)
, .UPDATE_IR(UPDATE_IR)
, .SHIFT_IR(SHIFT_IR)
, .CAPTURE_IR(CAPTURE_IR)
, .LATCH_IR(LATCH_IR)
, .TLR(TLR)
, .I_TDO(I_TDO)
);

dr dr_inst
(
  .TRST(TRST)
, .TCK(TCK)
, .TDI(TDI)
, .LATCH_IR(LATCH_IR)
, .BSR(BSR)
, .UPDATE_DR(UPDATE_DR)
, .SHIFT_DR(SHIFT_DR)
, .CAPTURE_DR(CAPTURE_DR)
, .ENABLE(ENABLE)
, .BSR_TDO(BSR_TDO)
, .ID_TDO(ID_REG_TDO)
, .USER_TDO(USER_REG_TDO)
);

core_logic core_logic_inst
(
  .TCK(TCK)
, .TRST(TRST)
, .FROM_CORE_DATA(FROM_CORE_DATA)
, .SHIFT_DR(SHIFT_DR)
);

bypass bypass_inst
(
  .TCK(TCK)
, .TDI(TDI)
, .TLR(TLR)
, .TRST(TRST)
, .LATCH_IR(LATCH_IR)
, .CAPTURE_DR(CAPTURE_DR)
, .SHIFT_DR(SHIFT_DR)
, .BYPASS_TDO(BYPASS_TDO)
);

always @(ID_TDO or USER_TDO or BSR_TDO or BYPASS_TDO or I_TDO) begin
    if ( SHIFT_IR ) begin
        TDO <= I_TDO; 
    end 
    else begin
        case(IR)
            IDCODE:   begin TDO <= ID_TDO;   end
            USERCODE: begin TDO <= USER_TDO; end
            EXTEST:   begin TDO <= BSR_TDO;      end
            BYPASS:   begin TDO <= BYPASS_TDO;   end
            default:  begin TDO <= BYPASS_TDO;   end
        endcase 
    end
end

endmodule