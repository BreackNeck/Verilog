module tapController 
(
    // input Jtag interface pins

	input   TMS
,	input   TCK
,	input   TRST
    // output Jtag interface pins
,   output reg ENABLE
    // output from STATE
,   output reg TLR
,   output reg RTI
,   output reg UPDATE_IR
,   output reg UPDATE_DR
,   output reg CAPTURE_DR
,   output reg CAPTURE_IR
,   output reg SHIFT_IR
,   output reg SHIFT_DR
,	output 	   MOD
);

// State assignments for example TAP controller
localparam STATE_TEST_LOGIC_RESET = 4'hF;
localparam STATE_RUN_TEST_IDLE    = 4'hC;
localparam STATE_SELECT_DR_SCAN   = 4'h7;
localparam STATE_CAPTURE_DR       = 4'h6;
localparam STATE_SHIFT_DR         = 4'h2;
localparam STATE_EXIT1_DR         = 4'h1;
localparam STATE_PAUSE_DR         = 4'h3;
localparam STATE_EXIT2_DR         = 4'h0;
localparam STATE_UPDATE_DR        = 4'h5;
localparam STATE_SELECT_IR_SCAN   = 4'h4;
localparam STATE_CAPTURE_IR       = 4'hE;
localparam STATE_SHIFT_IR         = 4'hA;
localparam STATE_EXIT1_IR         = 4'h9;
localparam STATE_PAUSE_IR         = 4'hB;
localparam STATE_EXIT2_IR         = 4'h8;
localparam STATE_UPDATE_IR        = 4'hD;
/////////////////////////////////////////////////

reg     [3:0] State;
reg     [3:0] NextState;

// monitored state of TAP FSM 
always @ (posedge TCK or negedge TRST)
begin
	if(TRST == 0)
		State = STATE_TEST_LOGIC_RESET;
	else
		State = NextState;
end

// Ыtate transitions in FSM
always @ (State or TMS)
begin
	case(State)
		STATE_TEST_LOGIC_RESET: begin
			if(TMS) NextState = STATE_TEST_LOGIC_RESET; 
			else NextState = STATE_RUN_TEST_IDLE;
			end
		STATE_RUN_TEST_IDLE: begin
			if(TMS) NextState = STATE_SELECT_DR_SCAN; 
			else NextState = STATE_RUN_TEST_IDLE;
			end
		STATE_SELECT_DR_SCAN: begin
			if(TMS) NextState = STATE_SELECT_IR_SCAN; 
			else NextState = STATE_CAPTURE_DR;
			end
		STATE_CAPTURE_DR: begin
			if(TMS) NextState = STATE_EXIT1_DR; 
			else NextState = STATE_SHIFT_DR;
			end
		STATE_SHIFT_DR: begin
			if(TMS) NextState = STATE_EXIT1_DR; 
			else NextState = STATE_SHIFT_DR;
			end
		STATE_EXIT1_DR: begin
			if(TMS) NextState = STATE_UPDATE_DR; 
			else NextState = STATE_PAUSE_DR;
			end
		STATE_PAUSE_DR: begin
			if(TMS) NextState = STATE_EXIT2_DR; 
			else NextState = STATE_PAUSE_DR;
			end
		STATE_EXIT2_DR: begin
			if(TMS) NextState = STATE_UPDATE_DR; 
			else NextState = STATE_SHIFT_DR;
			end
		STATE_UPDATE_DR: begin
			if(TMS) NextState = STATE_SELECT_DR_SCAN; 
			else NextState = STATE_RUN_TEST_IDLE;
			end
		STATE_SELECT_IR_SCAN: begin
			if(TMS) NextState = STATE_TEST_LOGIC_RESET;
			else NextState = STATE_CAPTURE_IR;
			end
		STATE_CAPTURE_IR: begin
			if(TMS) NextState = STATE_EXIT1_IR; 
			else NextState = STATE_SHIFT_IR;
			end
		STATE_SHIFT_IR: begin
			if(TMS) NextState = STATE_EXIT1_IR; 
			else NextState = STATE_SHIFT_IR;
			end
		STATE_EXIT1_IR: begin
			if(TMS) NextState = STATE_UPDATE_IR;
			else NextState = STATE_PAUSE_IR;
			end
		STATE_PAUSE_IR: begin
			if(TMS) NextState = STATE_EXIT2_IR;
			else NextState = STATE_PAUSE_IR;
			end
		STATE_EXIT2_IR: begin
			if(TMS) NextState = STATE_UPDATE_IR;
			else NextState = STATE_SHIFT_IR;
			end
		STATE_UPDATE_IR: begin
			if(TMS) NextState = STATE_SELECT_DR_SCAN;
			else NextState = STATE_RUN_TEST_IDLE;
			end
		default: NextState = STATE_TEST_LOGIC_RESET;
	endcase
end

// Output FSM results
always @ (State)
begin
	// Default everything to 0, keeps the case statement simple
	TLR <= 1'b0;
	RTI <= 1'b0;
	SHIFT_DR <= 1'b0;	
	UPDATE_DR <= 1'b0;
	CAPTURE_DR <= 1'b0;	
	SHIFT_IR <= 1'b0;	
	UPDATE_IR <= 1'b0;	
	CAPTURE_IR <= 1'b0;

	case (State)
		STATE_TEST_LOGIC_RESET: TLR <= 1'b1;
		STATE_RUN_TEST_IDLE:    RTI <= 1'b1;		
		STATE_SHIFT_DR:         SHIFT_DR <= 1'b1;		
		STATE_UPDATE_DR:        UPDATE_DR <= 1'b1;		
		STATE_SHIFT_IR:         SHIFT_IR <= 1'b1;		
		STATE_UPDATE_IR:        UPDATE_IR <= 1'b1;
		STATE_CAPTURE_IR:		CAPTURE_IR <= 1'b1;
		STATE_CAPTURE_IR:		CAPTURE_DR <= 1'b1;
	endcase
end
always @ (posedge TCK)
begin
  ENABLE <= SHIFT_IR | SHIFT_DR;
end

assign MOD = state == STATE_CAPTURE_IR
                | state == STATE_SHIFT_IR
                | state == STATE_EXIT1_IR
                | state == STATE_PAUSE_IR
                | state == STATE_EXIT2_IR
                | state == STATE_UPDATE_IR;

endmodule
