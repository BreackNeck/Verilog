module IR
(
        input RST
,       input TDI
,       input UPDATE_IR
,       input CLOCK_IR
,       input SHIFT_IR
,       input reg State [3:0]
,       output reg [3:0] IR    
)

localparam BYPASS           = 4'hF; // OVERCOME TEST LOGIC
localparam SAMPLE_PRELOAD   = 4'h0; // IN CAPTURE STATE LOAD DATAIN (NORMAL -> 0), DATA DOESN'T APPEAR AT ICS PIN
localparam EXTEST           = 4'h1; // MODETEST -> 1, TRANSFER DATA ON ICS PIN
localparam INTEST           = 4'h2; // 
localparam RUNBIST          = 4'h3; // START INNER TEST
localparam CLAMP            = 4'h4; // ~BYPASS< BUT ON ICS PIN APPEARS SOME VALUES
localparam IDCODE           = 4'h5; // MANUFACTURER IDENTIFIER
localparam USERCODE         = 4'h6; // USER IDENTIFIER 
localparam HIGHZ            = 4'h7; // HIGH IMPEDANCE STATE

always @(posedge CLOCKIR) begin
    case (State)

    endcase
end
