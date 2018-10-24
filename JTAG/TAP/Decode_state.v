`include "IR_DEFINES.v"

module state_decode
(
    input      [3:0] LATCHED_IR

,   output reg       BYPASS_SELECT
,   output reg       SAMPLE_SELECT
,   output reg       EXTEST_SELECT
,   output reg       INTEST_SELECT
,   output reg       RUNBIST_SELECT
,   output reg       CLAMP_SELECT
,   output reg       IDCODE_SELECT
,   output reg       USERCODE_SELECT
,   output reg       HIGHZ_SELECT
);

always @(LATCHED_IR) begin

    BYPASS_SELECT   <= 1'b0;
    SAMPLE_SELECT   <= 1'b0;
    EXTEST_SELECT   <= 1'b0;
    INTEST_SELECT   <= 1'b0;
    RUNBIST_SELECT  <= 1'b0;
    CLAMP_SELECT    <= 1'b0;
    IDCODE_SELECT   <= 1'b0;
    USERCODE_SELECT <= 1'b0;
    HIGHZ_SELECT    <= 1'b0;

    case(LATCHED_IR)
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

endmodule