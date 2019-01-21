module dr
(
    input            TCK
,   input            TDI

,   input            CAPTUREDR
,   input            SHIFTDR
,   input            UPDATEDR

,   output reg       ID_REG_TDO
,   output reg       USERCODE_REG_TDO
,   output reg       BSR_TDO
, 	output reg  	 STATUS_BIST_REG_TDO

,   input            IDCODE_SELECT
,   input            SAMPLE_SELECT
,   input            EXTEST_SELECT
,   input            INTEST_SELECT
,   input            USERCODE_SELECT
,   input            RUNBIST_SELECT
,   input            GETTEST_SELECT

,   input       [3:0]  EXTEST_IO
,   input       [3:0]  INTEST_CL
 
,   input       [3:0]  CORE_LOGIC
,   input       [15:0] BIST_STATUS
 
,   output reg  [9:0]  BSR
,   input       [3:0]  TUMBLERS
,   output      [7:0]  UR_OUT
);

localparam LSB        = 2'b01;

localparam PRELOAD_DATA = 8'h81;
reg [7:0] ID_REG = 8'hA1;
reg [7:0] ID_REG_COPY;
reg [15:0] STATUS_BIST_REG;
reg [7:0] USERCODE_REG = 8'h01;

always @(posedge TCK) begin
    if ( IDCODE_SELECT ) begin
        ID_REG_COPY <= SHIFTDR ? { TDI, ID_REG_COPY[7:1] } : ID_REG;
    end else
	 if ( SAMPLE_SELECT ) begin 
		 if ( CAPTUREDR ) begin
			BSR <= { PRELOAD_DATA, LSB };
		 end
	 end else
	 if ( EXTEST_SELECT ) begin 
		if ( CAPTUREDR ) begin
			BSR <= { EXTEST_IO, TUMBLERS, LSB };
		 end else
		 if ( SHIFTDR ) begin
			BSR <= { TDI, BSR[9:1] };
		 end		 
	 end else
	 if ( INTEST_SELECT ) begin 
		 if ( CAPTUREDR ) begin
			BSR <= { CORE_LOGIC, INTEST_CL, LSB };
		 end else
		 if ( SHIFTDR ) begin
			BSR <= { TDI, BSR[9:1] };
		 end
	 end else
	 if ( USERCODE_SELECT ) begin
	    if ( CAPTUREDR ) begin
			BSR <= { USERCODE_REG, LSB };
		 end else
		 if ( SHIFTDR ) begin
			BSR <= { TDI, BSR[9:1] };
		 end else
		 if ( UPDATEDR ) begin
			USERCODE_REG <= BSR[9:2];
		 end
	 end else
	 if ( RUNBIST_SELECT ) begin
        if( CAPTUREDR ) begin
            STATUS_BIST_REG <= { BIST_STATUS }; 
        end else
        if ( SHIFTDR ) begin
            STATUS_BIST_REG <= { TDI, STATUS_BIST_REG[15:1] };
         end
     end    
	 if ( GETTEST_SELECT ) begin
        if ( SHIFTDR ) begin
            BSR <= { TDI, BSR[9:1] };
        end
    end
end


always @(negedge TCK) BSR_TDO      			<= BSR[0];
always @(negedge TCK) ID_REG_TDO   			<= ID_REG_COPY[0];
always @(negedge TCK) STATUS_BIST_REG_TDO   <= STATUS_BIST_REG[0];

assign UR_OUT = USERCODE_REG;
///1///
endmodule