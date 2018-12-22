module core_logic
(
    input           TCK
,   input           clk    
,   input           TLR
,   input           RESET_SM
,   input  [3:0]    X
,   input           RUNBIST_SELECT
,   input           INTEST_SELECT
,   input           TUMBLERS
,   input           ASSIGN_STATE
,   output [3:0]    Y
);

wire clock = RUNBIST_SELECT ? clk : TCK;
assign Y = state;

reg [3:0] state;

always @ (posedge clock) begin
	if (TLR | RESET_SM)
		state <= 4'b0000;
	else
		begin
			if (RUNBIST_SELECT | INTEST_SELECT)
				begin
                    if (ASSIGN_STATE)
                        state <= X;
                    else 
                        begin                    	
                            case(state)
                                4'b0000 : begin
                                                if((X & 4'b1110) == 4'b0000)
                                                    state <= 4'b0010;
                                                else if(X == 4'b1000)
                                                    state <= 4'b0110;
                                                else if((X & 4'b1011) == 4'b1001)
                                                    state <= 4'b1010;
                                                else if(X == 4'b1111)
                                                    state <= 4'b1101;					 
                                            end

                                4'b0001 : begin
                                                if(X == 4'b1111)
                                                    state <= 4'b0000;
                                                else if(X == 4'b1011)
                                                    state <= 4'b0011;
                                                else if(X == 4'b1100)
                                                    state <= 4'b1000;
                                                else if(X == 4'b0010)
                                                    state <= 4'b1011;					 
                                            end

                                4'b0010 : begin
                                                if(X == 4'b1011)
                                                    state <= 4'b0001;
                                                else if(X == 4'b1111)
                                                    state <= 4'b0101;
                                                else if(X == 4'b0110)
                                                    state <= 4'b0111;
                                                else if((X & 4'b1101) == 4'b0000)
                                                    state <= 4'b1001;						
                                                else if(X == 4'b1100)
                                                    state <= 4'b1110;					 
                                            end

                                4'b0011 : begin
                                                if(X == 4'b1010)
                                                    state <= 4'b0100;
                                                else if(X == 4'b0110)
                                                    state <= 4'b1111;					 
                                            end

                                4'b0100 : begin
                                                if(X == 4'b1111)
                                                    state <= 4'b0001;
                                                else if(X == 4'b0001)
                                                    state <= 4'b0111;
                                                else if(X == 4'b0101)
                                                    state <= 4'b1100;					 
                                            end

                                4'b0101 : begin
                                                if(X == 4'b1100)
                                                    state <= 4'b0000;
                                                else if(X == 4'b0011)
                                                    state <= 4'b0010;
                                                else if(X == 4'b1111)
                                                    state <= 4'b0100;
                                                else if(X == 4'b0010)
                                                    state <= 4'b1000;					 
                                            end

                                4'b0110 : begin
                                                if(X == 4'b0001)
                                                    state <= 4'b0001;
                                                else if(X == 4'b0010)
                                                    state <= 4'b0101;
                                                else if(X == 4'b0011)
                                                    state <= 4'b1000;
                                                else if(X == 4'b1001)
                                                    state <= 4'b1011;	
                                                else if(X == 4'b1111)
                                                    state <= 4'b1110;	
                                                else if(X == 4'b1110)
                                                    state <= 4'b1111;							
                                            end

                                4'b0111 : begin
                                                if(X == 4'b0000)
                                                    state <= 4'b0000;
                                                else if((X & 4'b1101) == 4'b1100)
                                                    state <= 4'b0010;
                                                else if(X == 4'b0101)
                                                    state <= 4'b0101;
                                                else if(X == 4'b0011)
                                                    state <= 4'b1010;					 
                                            end

                                4'b1000 : begin
                                                if(X == 4'b1010)
                                                    state <= 4'b0001;
                                                else if(X == 4'b1101)
                                                    state <= 4'b0011;
                                                else if(X == 4'b0011)
                                                    state <= 4'b0111;
                                                else if(X == 4'b1011)
                                                    state <= 4'b1011;		
                                                else if(X == 4'b0010)
                                                    state <= 4'b1101;								
                                            end

                                4'b1001 : begin
                                                if(X == 4'b0000)
                                                    state <= 4'b0100;
                                                else if(X == 4'b0001)
                                                    state <= 4'b0110;
                                                else if(X == 4'b1110)
                                                    state <= 4'b1100;
                                                else if(X == 4'b1010)
                                                    state <= 4'b1110;					 
                                            end

                                4'b1010 : begin
                                                if(X == 4'b0011)
                                                    state <= 4'b0010;
                                                else if(X == 4'b1111)
                                                    state <= 4'b0101;
                                                else if(X == 4'b1010)
                                                    state <= 4'b1000;
                                                else if(X == 4'b0001)
                                                    state <= 4'b1101;					 
                                            end

                                4'b1011 : begin
                                                if(X == 4'b1010)
                                                    state <= 4'b0001;
                                                else if(X == 4'b0101)
                                                    state <= 4'b0100;
                                                else if(X == 4'b1101)
                                                    state <= 4'b1000;
                                                else if(X == 4'b1001)
                                                    state <= 4'b1110;					 
                                            end

                                4'b1100 : begin
                                                if(X == 4'b1110)
                                                    state <= 4'b0011;
                                                else if(X == 4'b1001)
                                                    state <= 4'b0110;
                                                else if(X == 4'b1010)
                                                    state <= 4'b1001;
                                                else if(X == 4'b1111)
                                                    state <= 4'b1011;	
                                                else if(X == 4'b0000)
                                                    state <= 4'b1110;							
                                            end

                                4'b1101 : begin
                                                if(X == 4'b0010)
                                                    state <= 4'b0000;
                                                else if(X == 4'b0101)
                                                    state <= 4'b0010;
                                                else if(X == 4'b1001)
                                                    state <= 4'b0011;
                                                else if(X == 4'b1110)
                                                    state <= 4'b0101;
                                                else if(X == 4'b1111)
                                                    state <= 4'b1010;							
                                            end

                                4'b1110 : begin
                                                if(X == 4'b1111)
                                                    state <= 4'b0001;
                                                else if(X == 4'b1101)
                                                    state <= 4'b0100;
                                                else if((X & 4'b1101) == 4'b1100)
                                                    state <= 4'b0111;			 
                                            end

                                4'b1111 : begin
                                                if(X == 4'b1100)
                                                    state <= 4'b0011;
                                                else if(X == 4'b1010)
                                                    state <= 4'b0110;
                                                else if(X == 4'b0000)
                                                    state <= 4'b1010;
                                                else if((X & 4'b1100) == 4'b0100)
                                                    state <= 4'b1100;					 
                                            end                                
                                default:            state <= 4'b0000;
                            endcase
                        end
                end
        end

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