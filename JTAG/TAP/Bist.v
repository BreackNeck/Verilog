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
    input            clk
,   input            TCK
,   input            TLR 
,   input            RUNBIST_SELECT
,   input            GETTEST_SELECT
,   input            SETSTATE_SELECT
,   input      [3:0] BIST_IN
,   output     [3:0] BIST_OUT
,   output reg       RESET_SM
,   output reg       error
,   output     [7:0] BIST_DATA
,   input            UPDATEDR
,   input      [9:0] BSR
,   output     [3:0] ASSIGN_STATE
);

wire [3:0] config_bsr;
assign config_bsr = BSR[9:6];

wire [3:0] check_bsr;
assign check_bsr = BSR[5:2];

wire [3:0] state_number;
assign state_number = BSR[9:6];

reg [3:0] assign_state;

always @(posedge TCK) 
    begin
         if (TLR)                             assign_state <= 4'b0000;                   
         else if (SETSTATE_SELECT & UPDATEDR) assign_state <= state_number;                   
    end

assign  ASSIGN_STATE = assign_state;

function integer clog2;
    input integer value;
    begin 
        value = value - 1;
        for (clog2 = 0; value > 0; clog2 = clog2 + 1)
            value = value >> 1;
    end 
endfunction

localparam WIDTH = clog2(DEPTH);

reg [3:0] bist_config[0:DEPTH-1];
initial $readmemb("bistconfig.io", bist_config, 0, DEPTH-1); // Initial Regestry file (memory) (("<file_name>", <memory_name>, memory_start, memory_finish");)

reg [3:0] bist_check[0:DEPTH-1];
initial $readmemb("bistcheck.io", bist_check, 0, DEPTH-1); // Check transition result

reg [WIDTH-1:0] counter;
reg [WIDTH-1:0] temp;

always @(posedge TCK) 
    begin
        if (TLR) 
            begin
                counter <= 0;    
                temp <= DEPTH - 1; 
            end 
        else if (GETTEST_SELECT) 
                begin
                    if (UPDATEDR) 
                        begin
                            bist_config[counter] <= config_bsr;
                            bist_check[counter]  <= check_bsr;
                            counter <= counter + 1'b1;    
                            temp <= counter;       
                        end
                end else counter <= 0;        
    end

reg [WIDTH-1:0] pc;
wire stop_command;
reg cycle;
assign stop_command  = pc == temp; // signal stop for RESET_SM

always @(posedge clk) begin
    if (TLR | stop_command) pc <= 0;
    else if (RUNBIST_SELECT && !RESET_SM && !cycle) pc <= pc + 1;
end

always @(posedge clk) 
    begin
        if(TLR) error <= 0;
        else if(pc) error <= BIST_IN != bist_check[pc-1];
    end

always @(posedge clk) begin
    if (TLR)                                                         cycle <= 0;
    else if (BIST_IN != bist_check[pc-1] & SETSTATE_SELECT)          cycle <= 1;
end

always @(posedge clk) 
    begin
        if (TLR | !RUNBIST_SELECT) RESET_SM <= 0;
        else if (stop_command)     RESET_SM <= 1;
    end

assign BIST_OUT  = RUNBIST_SELECT ? bist_config[pc] : 4'b1001;
assign BIST_DATA = RESET_SM & !error ? 8'hFF : pc - 1;

endmodule


