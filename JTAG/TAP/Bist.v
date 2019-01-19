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

wire [3:0] bist_check_check;
assign bist_check_check = bist_check[pc][4:1];
wire [3:0] bist_config_check;
assign bist_config_check = bist_config[pc][4:1];

wire [WIDTH-1:0] width_param;
assign width_param = WIDTH;

reg [WIDTH-1:0] pc_load;
reg [WIDTH-1:0] pc_safe;

always @(posedge TCK) 
    begin
        if (TLR) 
            begin
                pc_load <= 0;    
                pc_safe <= DEPTH - 1; 
            end 
        else if (GETTEST_SELECT) 
                begin
                    if (UPDATEDR) 
                        begin
                            bist_config[pc_load] <= config_bsr;
                            bist_check[pc_load]  <= check_bsr;
                            pc_load <= pc_load + 1'b1;    
                            pc_safe <= pc_load;       
                        end
                end else pc_load <= 0;        
    end

reg [WIDTH-1:0] pc;
reg [WIDTH-1:0] pc_bist;
wire signal_stop;
reg cycle;


assign   signal_stop = (pc == pc_safe) | (bist_check[pc][BIT_STOP_FLAG] == STOP_BIT_FLAG) | error; // signal stop for RESET_SM 


always @(posedge clk) begin
    if (TLR | signal_stop ) pc <= 0;
    else if (RUNBIST_SELECT && !RESET_SM && !cycle) begin 
            pc <= pc + 1; 
            pc_bist <= pc;
         end
end

assign BIST_OUT  = RUNBIST_SELECT ? bist_config[pc] : 5'b00000;

// always @(posedge clk) 
//     begin
//         if (TLR)                                                                                           error <= 0;
//         else if (pc & (!bist_config[pc-1][0]) /*& (!bist_config[pc][0])*/) error <= BIST_IN != bist_check[pc-1][4:1] ; // pc bist_check[pc-1]
//     end

always @(posedge clk) 
    begin
        if (TLR ) error <= 0;
        else if ((!bist_config[pc-1][0]) &  (BIST_IN != bist_check[pc-1][4:1]) & (!bist_config[pc][0])) begin           // pc bist_check[pc-1]
                 error <= 1; 
                 pc <= 0;
             end
    end

///////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk) begin
    if (TLR)                                                                   cycle <= 0;
    else if ( BIST_IN != bist_check[pc-1][4:1] & bist_config[pc-1][0] != 1'b1) cycle <= 1;
end

always @(posedge clk) begin
        if (TLR | !RUNBIST_SELECT) RESET_SM <= 0;
        else if ( signal_stop | error | !enable) begin 
                RESET_SM <= 1;
                //pc = 0;
         end
end

reg [WIDTH-1:0] bc;
reg [WIDTH-1:0] zc;

always @(posedge clk) begin
    if (enable) bc <= pc-1;
end

always @(posedge clk) begin
    if (enable & !error) zc <= pc-1;
end

reg [3:0] CORRECT_CHECK;

always @(posedge clk) begin
    if ( zc | bc ) begin
        CORRECT_CHECK = BIST_IN; 
     end
end

assign BIST_STATUS = RESET_SM & !error ? {bist_check[bc-1][4:1], bist_config[bc][4:1], bist_check[bc][4:1], 4'hF} :                                     
                                         {bist_check[zc-1][4:1], bist_config[zc][4:1], CORRECT_CHECK,  4'h5} ;

// assign BIST_STATUS = RESET_SM & !error ? 8'hFF : pc-1;
endmodule
