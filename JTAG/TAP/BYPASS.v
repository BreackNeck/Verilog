//https://nikomedvedev.ru/other/vscodeshortcuts/hotkeys.html
//`include "IR_DEFINES.v"

module bypass
(
    input          TCK
,   input          TDI
,   input          TLR
,   input          TRST
,   input          [3:0] LATCH_IR
,   input          CAPTURE_DR
,   input          SHIFT_DR
,   output reg     BYPASS_TDO
);

reg BYPASSR        ; // This is a 1-bit register 
reg BYPASS_SELECT  ;
reg SAMPLE_SELECT  ;
reg EXTEST_SELECT  ;
reg INTEST_SELECT  ;
reg RUNBIST_SELECT ;
reg CLAMP_SELECT   ;
reg IDCODE_SELECT  ;
reg USERCODE_SELECT;
reg HIGHZ_SELECT   ;

localparam BYPASS   = 4'hF;
localparam SAMPLE   = 4'h1; 
localparam EXTEST   = 4'h2; 
localparam INTEST   = 4'h3; 
localparam RUNBIST  = 4'h4; 
localparam CLAMP    = 4'h5; 
localparam IDCODE   = 4'h7; 
localparam USERCODE = 4'h8; 
localparam HIGHZ    = 4'h9;

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
        BYPASS:   begin BYPASS_SELECT   <= 1'b1; end
        SAMPLE:   begin SAMPLE_SELECT   <= 1'b1; end
        EXTEST:   begin EXTEST_SELECT   <= 1'b1; end
        INTEST:   begin INTEST_SELECT   <= 1'b1; end
        RUNBIST:  begin RUNBIST_SELECT  <= 1'b1; end
        CLAMP:    begin CLAMP_SELECT    <= 1'b1; end
        IDCODE:   begin IDCODE_SELECT   <= 1'b1; end
        USERCODE: begin USERCODE_SELECT <= 1'b1; end
        HIGHZ:    begin HIGHZ_SELECT    <= 1'b1; end
        default:  begin BYPASS_SELECT   <= 1'b1; end
    endcase
end

always @(posedge TCK or negedge TRST) begin
 if ( TRST == 0 )
    BYPASSR <= 1'b0;
 else if (TLR == 1)
    BYPASSR <= 1'b0;
 else if(BYPASS_SELECT & CAPTURE_DR)
    BYPASSR <= 1'b0;
 else if (BYPASS_SELECT & SHIFT_DR)
    BYPASSR <= TDI;
end

always @(negedge TCK) begin
    BYPASS_TDO <= BYPASSR;
end

endmodule