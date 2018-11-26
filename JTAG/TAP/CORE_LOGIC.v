module core_logic
(
    input           TCK
,   input  [3:0]    data_in
,   output [3:0]    data_out
);

assign data_out[0] = data_in[0] & data_in[1];
assign data_out[1] = data_in[0] | data_in[1];         
assign data_out[2] = data_in[2] & data_in[3];         
assign data_out[3] = data_in[2] | data_in[3];   



//   ^   ^   ^   ^   |   |   |   |
//   |   |   |   |   v   v   v   v
//  -------------------------------
// | R | R | R | R | T | T | T | T |  <- { EXTEST_IO, TUMBLERS }
//  -------------------------------
//   ^   ^   ^   ^   v   v   v   v
//   |   |   |   |   |   |   |   |   
//   v   v   v   v   v   v   v   v
// ----------------------------------------
// | x | x | x | x | x | x | x | x | x | x | BSR     
// ----------------------------------------
//   ^   ^   ^   ^   ^   ^   ^   ^    LSB
//   |   |   |   |   |   |   |   |
//   |   |   |   |   v   v   v   v
//   |   |   |   |  ---------------
//   |   |   |   | | R | R | R | R |  INTEST_CL
//   |   |   |   |  ---------------                 
//   |   |   |   |   |   |   |   |   data_in
//   |   |   |   |   v   v   v   v               
//   |   |   |   | -----------------
//   |   |   |   | |   CoreLogic   |
//   |   |   |   | -----------------
//   |   |   |   |   |   |   |   |
//   |   |   |   -----   |   |   |   data_out      
//   |   |   -------------   |   | 
//   |   ---------------------   |      
//   -----------------------------

endmodule