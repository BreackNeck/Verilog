`include "IR_DEFINES.v"

module bypass
(
    input          TCK
,   input          TDI
,   input          TLR
,   input          TRST
,   input          LATCH_IR
,   input          CAPTURE_DR
,   input          SHIFT_DR
,   output reg     BYPASS_TDO
);

reg BYPASSR;

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