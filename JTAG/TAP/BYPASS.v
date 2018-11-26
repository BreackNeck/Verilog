module bypass
(
    input      TCK
,   input      TDI
,   input      SHIFTDR
,   output reg BYPASS_TDO
);

reg BYPASS;

always @(posedge TCK) begin
    if ( SHIFTDR ) begin
        BYPASS <= TDI;
    end
end

always @(negedge TCK) begin
    BYPASS_TDO <= BYPASS;
end

endmodule