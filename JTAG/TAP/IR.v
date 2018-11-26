module ir
(
    input            TDI
,   input            TCK
,   input            TLR
,   input            UPDATEIR
,   input            SHIFTIR
,   input            CAPTUREIR
,   output reg       INSTR_TDO
,   output reg [3:0] LATCH_JTAG_IR
);

localparam IDCODE   = 4'h7;
reg [3:0] JTAG_IR;

always @(posedge TCK) begin
    if( SHIFTIR ) JTAG_IR <= {TDI,JTAG_IR[3:1]};
end

always @(negedge TCK) begin
    INSTR_TDO <= JTAG_IR[0];
end

always @(posedge TCK) begin
    if ( TLR ) begin
        LATCH_JTAG_IR <= IDCODE;
    end else 
    if ( UPDATEIR ) begin
        LATCH_JTAG_IR <= JTAG_IR;
    end
end

endmodule