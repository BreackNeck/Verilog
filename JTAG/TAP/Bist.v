module BIST
#(
/*
relation RAM DEPTH = 2 ^ (ADDRESS WIDTH)
ADDRESS WIDTH = log (base 2) RAM DEPTH.
The $clog2 system task was added to the SystemVerilog extension to Verilog (IEEE Std 1800-2005). 
This returns an integer which has the value of the ceiling of the log base 2. 
The DEPTH need not be a power of 2.
*/
    parameter DEPTH = 6;
    parameter WIDTH = $clog2(DEPTH);
)
(
    input            clk
,   input            TCK
,   input            TLR 
,   input            RUNBIST_SELECT
,   input      [3:0] BIST_IN
,   output     [3:0] BIST_OUT
,   output reg       stop
,   output reg       err
,   output     [7:0] BIST_LOG

,   input            LOADDATA_SELECT
,   input            UPDATEDR
,   input      [9:0] BSR
,   output           ASSIGN_STATE
);






