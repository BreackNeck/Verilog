`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:16:59 10/28/2018 
// Design Name: 
// Module Name:    TOPMODULE 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module TOPMODULE
#(
/*
relation RAM DEPTH = 2 ^ (ADDRESS WIDTH)
ADDRESS WIDTH = log (base 2) RAM DEPTH.
The $clog2 system task was added to the SystemVerilog extension to Verilog (IEEE Std 1800-2005). 
This returns an integer which has the value of the ceiling of the log base 2. 
The DEPTH need not be a power of 2.
*/
    parameter DEPTH = 112;
    parameter WIDTH = $clog2(DEPTH);
)
(
    input            TMS       // J20: V14
,   input            clk       // J20: V15	
,   input            TCK       // J20: V15
,   input            TDI       // J20: W16
,   output reg       TDO       // J20: V16

,   output           TMS_LA    // J18: AA21 : A0
,   output           TCK_LA    // J18: AB21 : A1
,   output           TDI_LA    // J18: AA19 : A2
,   output           TDO_LA    // J18: AB19 : A3

,   output     [3:0] state     // state[0] -> J15: AB3 : I1+ : 9pin  : A4
										 // state[1] -> J15: AA6 : I2+ : 13pin : A5
										 // state[2] -> J15: Y7  : I3+ : 21pin : A6
										 // state[3] -> J15: AA8 : I4+ : 25pin : A7
										 // �������� GPIO �������� 17 ������������
                               // ��������� LA: 256 | 50 | 1 | 1
										 // ��������� A1 Triger �� �������� �����
										 
,   output     [7:0] LEDs      // LEDs[7] : W21 : LED7
										 // LEDs[6] : Y22 : LED6
										 // LEDs[5] : V20 : LED5
										 // LEDs[4] : V19 : LED4
										 // LEDs[3] : U19 : LED3
										 // LEDs[2] : U20 : LED2
										 // LEDs[1] : T19 : LED1
										 // LEDs[0] : R20 : LED0
,   input      [3:0] TUMBLERS  // SW0 : TUMBLERS[0] : V8										 
                               // SW1 : TUMBLERS[1] : U10
										 // SW2 : TUMBLERS[2] : U8
										 // SW3 : TUMBLERS[3] : T9

);

// �������� ��� �������� � ����������� ������������
reg [3:0] EXTEST_IO;
reg [3:0] INTEST_CL;

// �������� ������� ��� �����������
assign TMS_LA = TMS;
assign TCK_LA = TCK;
assign TDI_LA = TDI;
assign TDO_LA = TDO;

// ������� � �������� ����������
wire       CAPTUREIR;
wire       SHIFTIR;
wire       UPDATEIR;
wire       CAPTUREDR;
wire       SHIFTDR;
wire       UPDATEDR;
wire       TLR;

// ������� ��� ������
wire [3:0] LATCH_JTAG_IR;

// ��� TDO
wire       INSTR_TDO;
wire       ID_REG_TDO;
wire       BYPASS_TDO;
wire       BSR_TDO;

// ��������� �������
wire       IDCODE_SELECT;
wire       BYPASS_SELECT;
wire       SAMPLE_SELECT;
wire       EXTEST_SELECT;
wire       INTEST_SELECT;
wire	   USERCODE_SELECT;
wire       RUNBIST_SELECT;
wire 	   GETTEST_SELECT

//
wire [9:0] BSR;
wire [3:0] CORE_LOGIC;
wire [7:0] UR_OUT;
wire [7:0] IR_REG_OUT;
wire [7:0] BIST_LOG;

wire       RESET_SM;
wire       error;
wire [3:0] CL_INPUT;
wire       ASSIGN_STATE;
tap_controller test_access_port
( 
  .TMS(TMS)
, .TCK(TCK)

, .state_out(state)

, .CAPTUREIR(CAPTUREIR)
, .SHIFTIR(SHIFTIR)
, .UPDATEIR(UPDATEIR)
, .CAPTUREDR(CAPTUREDR)
, .SHIFTDR(SHIFTDR)
, .UPDATEDR(UPDATEDR)

, .TLR(TLR)
);

ir instruction_register
(
  .TDI(TDI)
, .TCK(TCK)
, .TLR(TLR)
, .CAPTUREIR(CAPTUREIR)
, .SHIFTIR(SHIFTIR)
, .UPDATEIR(UPDATEIR)
, .INSTR_TDO(INSTR_TDO)
, .LATCH_JTAG_IR(LATCH_JTAG_IR)
);

state_decoder state_decoder_sample
(
  .LATCH_JTAG_IR(LATCH_JTAG_IR)
, .IDCODE_SELECT(IDCODE_SELECT)
, .BYPASS_SELECT(BYPASS_SELECT)
, .EXTEST_SELECT(EXTEST_SELECT)
, .SAMPLE_SELECT(SAMPLE_SELECT)
, .INTEST_SELECT(INTEST_SELECT)
, .USERCODE_SELECT(USERCODE_SELECT)
, .RUNBIST_SELECT(RUNBIST_SELECT)
, .GETTEST_SELECT(GETTEST_SELECT)
, .SETSTATE_SELECT(SETSTATE_SELECT)
);

dr test_data_register
(
  .TCK(TCK)
, .TDI(TDI)
, .SHIFTDR(SHIFTDR)
, .CAPTUREDR(CAPTUREDR)
, .UPDATEDR(UPDATEDR)
, .IDCODE_SELECT(IDCODE_SELECT)
, .SAMPLE_SELECT(SAMPLE_SELECT)
, .EXTEST_SELECT(EXTEST_SELECT)
, .INTEST_SELECT(INTEST_SELECT)
, .USERCODE_SELECT(USERCODE_SELECT)
, .CORE_LOGIC(CORE_LOGIC)
, .ID_REG_TDO(ID_REG_TDO)
, .BSR_TDO(BSR_TDO)
, .BSR(BSR)
, .TUMBLERS(TUMBLERS)
, .EXTEST_IO(EXTEST_IO)
, .INTEST_CL(INTEST_CL)
, .UR_OUT(UR_OUT)
, .BIST_LOG(BIST_LOG)
, .RUNBIST_SELECT(RUNBIST_SELECT)
, .GETTEST_SELECT(GETTEST_SELECT)
, .SETSTATE_SELECT(SETSTATE_SELECT)
);

bypass bypass_tar
(
  .TCK(TCK)
, .TDI(TDI)
, .SHIFTDR(SHIFTDR)
, .BYPASS_TDO(BYPASS_TDO)
);

core_logic core_logic_inst
(
  .TCK(TCK)
, .clk(clk) 
, .TLR(TLR) 
, .RESET_SM(RESET_SM)
, .X(CL_INPUT)
, .Y(CORE_LOGIC)
, .ASSIGN_STATE(ASSIGN_STATE)
, .RUNBIST_SELECT(RUNBIST_SELECT)
, .INTEST_SELECT(INTEST_SELECT)
, .TUMBLERS(ASSIGN_STATE)
);

BIST #(.DEPTH(DEPTH), .WIDTH(WIDTH)) BIST_INST
(
  .TCK(TCK)
, .clk(clk)
, .TLR(TLR)
, .UPDATEDR(UPDATEDR)
, .BSR(BSR)
, .RUNBIST_SELECT(RUNBIST_SELECT)
, .GETTEST_SELECT(GETTEST_SELECT)
, .SETSTATE_SELECT(SETSTATE_SELECT)
, .BIST_IN(CORE_LOGIC)
, .BIST_OUT(bist_data_out)
, .BIST_DATA(BIST_DATA)
, .RESET_SM(RESET_SM)
, .error(error)
, .ASSIGN_STATE(ASSIGN_STATE)
);

always @(posedge TCK) begin
    if( UPDATEDR & SAMPLE_SELECT ) begin
		EXTEST_IO <= BSR[9:6];		
	   INTEST_CL <= BSR[5:2];
	 end else 
	 if( UPDATEDR & EXTEST_SELECT ) begin
		EXTEST_IO <= BSR[9:6];
	 end else
	 if( UPDATEDR & INTEST_SELECT ) begin
		INTEST_CL <= BSR[5:2];
	 end
end

localparam IDCODE   = 4'h7;
localparam BYPASS   = 4'hF;
localparam SAMPLE   = 4'h1;
localparam EXTEST   = 4'h2;
localparam INTEST   = 4'h3;
localparam USERCODE = 4'h8;
localparam RUNBIST  = 4'h4;

assign CL_INPUT = RUNBIST_SELECT ? bist_data_out : INTEST_CL;

always @(posedge TCK) begin
    if ( SHIFTDR ) begin
        case(LATCH_JTAG_IR)
           		IDCODE:     begin TDO <= ID_REG_TDO;       end
				BYPASS:     begin TDO <= BYPASS_TDO;       end
				SAMPLE:     begin TDO <= BSR_TDO;          end
				EXTEST:     begin TDO <= BSR_TDO;          end
				INTEST:     begin TDO <= BSR_TDO;          end
				USERCODE:   begin TDO <= BSR_TDO;          end
				RUNBIST:    begin TDO <= BSR_TDO;          end
            	default:    begin TDO <= ID_REG_TDO;       end
        endcase  
    end else
	 if ( SHIFTIR ) begin
        TDO <= INSTR_TDO; 
    end
end

assign LEDs[0] = INTEST_SELECT ? INTEST_CL[0] : SAMPLE_SELECT ? EXTEST_IO[0] : TUMBLERS[0];
assign LEDs[1] = INTEST_SELECT ? INTEST_CL[1] : SAMPLE_SELECT ? EXTEST_IO[1] : TUMBLERS[1];
assign LEDs[2] = INTEST_SELECT ? INTEST_CL[2] : SAMPLE_SELECT ? EXTEST_IO[2] : TUMBLERS[2];
assign LEDs[3] = INTEST_SELECT ? INTEST_CL[3] : SAMPLE_SELECT ? EXTEST_IO[3] : TUMBLERS[3];

assign LEDs[4] = INTEST_SELECT ? CORE_LOGIC[0] : SAMPLE_SELECT ? INTEST_CL[0] : EXTEST_IO[0];
assign LEDs[5] = INTEST_SELECT ? CORE_LOGIC[1] : SAMPLE_SELECT ? INTEST_CL[1] : EXTEST_IO[1];
assign LEDs[6] = INTEST_SELECT ? CORE_LOGIC[2] : SAMPLE_SELECT ? INTEST_CL[2] : EXTEST_IO[2];
assign LEDs[7] = INTEST_SELECT ? CORE_LOGIC[3] : SAMPLE_SELECT ? INTEST_CL[3] : EXTEST_IO[3];

endmodule
