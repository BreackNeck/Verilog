`include "IR_DEFINES.v"

module TOPMODULE

(
    input      TMS
,   input      TCK
,   input      TRST
,   input      TDI
,   output reg TDO  
);

reg  [3:0] EXTERNAL_inREG;
reg  [3:0] CORE_LOGIC;

wire [3:0] EXTERNAL_outREG;
wire [3:0] CORE_LOGIC_OUT;

wire       CAPTURE_IR;
wire       SHIFT_IR;
wire       UPDATE_IR;

wire       CAPTURE_DR;
wire       SHIFT_DR;
wire       UPDATE_DR;

wire [7:0] BSR;

wire       MOD;
wire       ENABLE;
wire       TRST;

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

tapController tapController_inst
( 
  .TMS(TMS)
, .TCK(TCK)
, .TRST(TRST)
, .MOD(MOD)
, .ENABLE(ENABLE)
, .TLR(TLR)
, .EXIT1_DR(EXIT1_DR)
, .UPDATE_IR(UPDATE_IR)
, .SHIFT_IR(SHIFT_IR)
, .UPDATE_DR(UPDATE_DR)
, .SHIFT_DR(SHIFT_DR)
, .CAPTURE_IR(CAPTURE_IR)
, .CAPTURE_DR(CAPTURE_DR)
);

ir ir_inst 
(.IR_DATA_WIDTH(IR_DATA_WIDTH))
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
(.ID_WIDTH(ID_WIDTH)
, .USER_WIDTH(USER_WIDTH)
, .ID_VALUE(ID_VALUE)
, .USER_VALUE(USER_VALUE)
, .BSR_WIDTH(BSR_WIDTH) 
)
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
, .EXTERNAL_inREG(EXTERNAL_inREG)
, .CORE_LOGIC(CORE_LOGIC)
, .EXTERNAL_outREG(EXTERNAL_outREG)
, .CORE_LOGIC_OUT(CORE_LOGIC_OUT)
);

core_logic core_logic_inst
(
  .TCK(TCK)
, .IN_CORE(IN_CORE)
, .CORE_LOGIC(CORE_LOGIC)
);

state_decode state_decode_inst
(
  .LATCH_IR(LATCH_IR)
, .BYPASS_SELECT(BYPASS_SELECT)
, .SAMPLE_SELECT(SAMPLE_SELECT)
, .EXTEST_SELECT(EXTEST_SELECT)
, .INTEST_SELECT(INTEST_SELECT)
, .RUNBIST_SELECT(RUNBIST_SELECT)
, .CLAMP_SELECT(CLAMP_SELECT)
, .IDCODE_SELECT(IDCODE_SELECT)
, .USERCODE_SELECT(USERCODE_SELECT)
, .HIGHZ_SELECT(HIGHZ_SELECT)
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

always @ (posedge TCK) begin
    if( UPDATE_DR & (EXTEST_SELECT | SAMPLE_SELECT)) EXTERNAL_inREG <= EXTERNAL_outREG;
end

always @ (posedge TCK) begin
    if( UPDATE_DR & (INTEST_SELECT | SAMPLE_SELECT)) IN_CORE<= CORE_LOGIC_OUT;
end

always @(ID_TDO or USER_TDO or BSR_TDO or BYPASS_TDO or I_TDO or TRST ...
                or SHIFT_DR or SHIFT_IR or EXIT1DR) begin
    if (TRST)
    TDO = 1'bz;
    else if ( SHIFT_IR ) 
        TDO <= I_TDO; 
    else begin
        case(IR)
            IDCODE:   begin TDO <= ID_TDO;       end
            USERCODE: begin TDO <= USER_TDO;     end
            EXTEST:   begin TDO <= BSR_TDO;      end
            BYPASS:   begin TDO <= BYPASS_TDO;   end
            INTEST:   begin TDO <= BSR_TDO;      end
            SAMPLE:   begin TDO <= BSR_TDO;      end
            default:  begin TDO <= BYPASS_TDO;   end
        endcase 
    end
end

endmodule