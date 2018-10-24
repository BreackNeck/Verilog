module core_logic
(
    input           TCK
,   input  [3:0]    IN_CORE
,   output [3:0]    CORE_LOGIC
);

assign CORE_LOGIC[0] = IN_CORE[0] & IO_CORE[1];
assign CORE_LOGIC[1] = IN_CORE[0] | IO_CORE[1];         
assign CORE_LOGIC[2] = IN_CORE[2] & IO_CORE[3];         
assign CORE_LOGIC[3] = IN_CORE[2] | IO_CORE[3];         

endmodule