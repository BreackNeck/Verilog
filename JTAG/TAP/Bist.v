module Bist
#(
/*
relation RAM DEPTH = 2 ^ (ADDRESS WIDTH)
ADDRESS WIDTH = log (base 2) RAM DEPTH.
The $clog2 system task was added to the SystemVerilog extension to Verilog (IEEE Std 1800-2005). 
This returns an integer which has the value of the ceiling of the log base 2. 
The DEPTH need not be a power of 2.
*/
    parameter DEPTH = 256
    //parameter WIDTH = $clog2(DEPTH);
)
(
    input             clk
,   input             TCK
,   input             TLR 
,   input             enable
,   input             RUNBIST_SELECT
,   input             GETTEST_SELECT
,   input      [3:0]  BIST_IN
,   output     [4:0]  BIST_OUT
,   output reg        RESET_SM
,   output reg        error
,   output     [15:0] BIST_STATUS
,   input             UPDATEDR
,   input      [9:0]  BSR


,   output     [4:0]  bist_config_wire
,   output     [4:0]  bist_check_wire
);

wire [4:0] config_bsr;
assign config_bsr = BSR[9:5];

wire [4:0] check_bsr;
assign check_bsr = BSR[4:0];

function integer clog2;
    input integer value;
    begin 
        value = value - 1;
        for (clog2 = 0; value > 0; clog2 = clog2 + 1)
            value = value >> 1;
    end 
endfunction

localparam WIDTH = clog2(DEPTH);
localparam BIT_STOP_FLAG  = 0;
localparam BIT_STATE_FLAG = 0;
localparam SET_STATE_FLAG = 1'b1;
localparam STOP_BIT_FLAG  = 1'b1;

reg [4:0] bist_config[0:DEPTH-1];
initial $readmemb("bistconfig.io", bist_config, 0, DEPTH-1); // Initial Regestry file (memory) (("<file_name>", <memory_name>, memory_start, memory_finish");)

reg [4:0] bist_check[0:DEPTH-1];
initial $readmemb("bistcheck.io", bist_check, 0, DEPTH-1); // Check transition result

wire [WIDTH-1:0] width_param;
assign width_param = WIDTH;

reg [WIDTH-1:0] pc_load;
reg [WIDTH-1:0] pc_safe;

always @(posedge TCK) begin
    if (TLR) begin
            pc_load <= 0;    
            pc_safe <= DEPTH - 1; 
        end 
    else if ( GETTEST_SELECT ) 
    begin
        if (UPDATEDR) 
            begin
                bist_config[pc_load] <= config_bsr;
                bist_check[pc_load]  <= check_bsr;
                pc_load <= pc_load + 1'b1;    
                pc_safe <= pc_load + 2;       
            end
    end else pc_load <= 0;        
end

wire signal_stop;

assign signal_stop = (pc == pc_safe) & !error;

reg [WIDTH-1:0] pc;
always @(posedge clk) begin
    if      (TLR)                                     pc <= 0;
    else if (RUNBIST_SELECT & !signal_stop & !error)  pc <= pc + 1;    
end

always @(posedge clk) begin
    if      (TLR)                                                            error <= 0;
    else if (BIST_IN != bist_check[pc - 1][4:1] & !signal_stop & !set_state) error <= 1;
end

reg set_state;
always @(posedge clk) begin
    set_state <= bist_config[pc][0];
end

always @(posedge clk) begin
    RESET_SM <= RUNBIST_SELECT & (error|signal_stop);
end

// ---------- WIRE ----------
//wire [4:0] bist_check_wire;
//wire [4:0] bist_config_wire;

assign BIST_OUT = RUNBIST_SELECT ? bist_config[pc] : 5'b00000;
assign bist_check_wire  = bist_check[pc];
assign bist_config_wire = bist_config[pc];

wire [15:0] EXEPTION_LESS_TWO;
wire [15:0] EXEPTION_MORE_TWO;



assign EXEPTION_LESS_TWO = !error & (pc <= 2) ? { 4'h0, bist_config [pc-1][4:1], bist_check[pc-1][4:1], 4'hF} : 
                                                { 4'h0, bist_config [pc-2][4:1], bist_check[pc-2][4:1], 4'h5};
assign EXEPTION_MORE_TWO = !error & (pc > 2)  ? { bist_check[pc - 3][4:1], bist_config [pc-2][4:1], bist_check[pc-2][4:1], 4'hF} :
                                                { bist_check[pc - 3][4:1], bist_config [pc-2][4:1], bist_check[pc-2][4:1], 4'h5};

assign BIST_STATUS = pc > 2 ? EXEPTION_MORE_TWO : EXEPTION_LESS_TWO;
///1///
endmodule
