module core_logic
(
    input           clk    
,   input  [4:0]    X
,   input           enable
///////////////////////////////////
,   output [3:0]    Y
);

localparam BIT_STATE_FLAG = 0;
localparam SET_STATE_FLAG = 1'b1;

reg [3:0] state;
assign Y = state;

wire [3:0] assign_X;
assign assign_X = X[4:1];

assign XXX = X[BIT_STATE_FLAG] == SET_STATE_FLAG;

always @ (posedge clk) begin
	if ( !enable )
		state <= 4'b0000;
	else begin

		if (X[BIT_STATE_FLAG] == SET_STATE_FLAG)
			state <= assign_X;
        else begin                    	
            case(state)
            4'b0000 : begin
                            if((assign_X == 4'b0000) | (assign_X == 4'b0001))
                                state <= 4'b0010;
                            else if(assign_X == 4'b1000)
                                state <= 4'b0110;
                            else if((assign_X  == 4'b1001) | (assign_X == 4'b1101))
                                state <= 4'b1010;
                            else if(assign_X == 4'b1111)
                                state <= 4'b1101;					 
                        end

            4'b0001 : begin
                            if(assign_X == 4'b1111)
                                state <= 4'b0000;
                            else if(assign_X == 4'b1011)
                                state <= 4'b0011;
                            else if(assign_X == 4'b1100)
                                state <= 4'b1000;
                            else if(assign_X == 4'b0010)
                                state <= 4'b1011;					 
                        end

            4'b0010 : begin
                            if(assign_X == 4'b1011)
                                state <= 4'b0001;
                            else if(assign_X == 4'b1111)
                                state <= 4'b0101;
                            else if(assign_X == 4'b0110)
                                state <= 4'b0111;
                            else if((assign_X == 4'b0000) | (assign_X == 4'b0010))
                                state <= 4'b1001;						
                            else if(assign_X == 4'b1100)
                                state <= 4'b1110;					 
                        end

            4'b0011 : begin
                            if(assign_X == 4'b1010)
                                state <= 4'b0100;
                            else if(assign_X == 4'b0110)
                                state <= 4'b1111;					 
                        end

            4'b0100 : begin
                            if(assign_X == 4'b1111)
                                state <= 4'b0001;
                            else if(assign_X == 4'b0001)
                                state <= 4'b0111;
                            else if(assign_X == 4'b0101)
                                state <= 4'b1100;					 
                        end

            4'b0101 : begin
                            if(assign_X == 4'b1100)
                                state <= 4'b0000;
                            else if(assign_X == 4'b0011)
                                state <= 4'b0010;
                            else if(assign_X == 4'b1111)
                                state <= 4'b0100;
                            else if(assign_X == 4'b0010)
                                state <= 4'b1000;					 
                        end

            4'b0110 : begin
                            if(assign_X == 4'b0001)
                                state <= 4'b0001;
                            else if(assign_X == 4'b0010)
                                state <= 4'b0101;
                            else if(assign_X == 4'b0011)
                                state <= 4'b1000;
                            else if(assign_X == 4'b1001)
                                state <= 4'b1011;	
                            else if(assign_X == 4'b1111)
                                state <= 4'b1110;	
                            else if(assign_X == 4'b1110)
                                state <= 4'b1111;							
                        end

            4'b0111 : begin
                            if(assign_X == 4'b0000)
                                state <= 4'b0000;
                            else if((assign_X & 4'b1101) == 4'b1100)
                                state <= 4'b0010;
                            else if(assign_X == 4'b0101)
                                state <= 4'b0101;
                            else if(assign_X == 4'b0011)
                                state <= 4'b1010;					 
                        end

            4'b1000 : begin
                            if(assign_X == 4'b1010)
                                state <= 4'b0001;
                            else if(assign_X == 4'b1101)
                                state <= 4'b0011;
                            else if(assign_X == 4'b0011)
                                state <= 4'b0111;
                            else if(assign_X == 4'b1011)
                                state <= 4'b1011;		
                            else if(assign_X == 4'b0010)
                                state <= 4'b1101;								
                        end

            4'b1001 : begin
                            if(assign_X == 4'b0000)
                                state <= 4'b0100;
                            else if(assign_X == 4'b0001)
                                state <= 4'b0110;
                            else if(assign_X == 4'b1110)
                                state <= 4'b1100;
                            else if(assign_X == 4'b1010)
                                state <= 4'b1110;					 
                        end

            4'b1010 : begin
                            if(assign_X == 4'b0011)
                                state <= 4'b0010;
                            else if(assign_X == 4'b1111)
                                state <= 4'b0101;
                            else if(assign_X == 4'b1010)
                                state <= 4'b1000;
                            else if(assign_X == 4'b0001)
                                state <= 4'b1101;					 
                        end

            4'b1011 : begin
                            if(assign_X == 4'b1010)
                                state <= 4'b0001;
                            else if(assign_X == 4'b0101)
                                state <= 4'b0100;
                            else if(assign_X == 4'b1101)
                                state <= 4'b1000;
                            else if(assign_X == 4'b1001)
                                state <= 4'b1110;					 
                        end

            4'b1100 : begin
                            if(assign_X == 4'b1110)
                                state <= 4'b0011;
                            else if(assign_X == 4'b1001)
                                state <= 4'b0110;
                            else if(assign_X == 4'b1010)
                                state <= 4'b1001;
                            else if(assign_X == 4'b1111)
                                state <= 4'b1011;	
                            else if(assign_X == 4'b0000)
                                state <= 4'b1110;							
                        end

            4'b1101 : begin
                            if(assign_X == 4'b0010)
                                state <= 4'b0000;
                            else if(assign_X == 4'b0101)
                                state <= 4'b0010;
                            else if(assign_X == 4'b1001)
                                state <= 4'b0011;
                            else if(assign_X == 4'b1110)
                                state <= 4'b0101;
                            else if(assign_X == 4'b1111)
                                state <= 4'b1010;							
                        end

            4'b1110 : begin
                            if(assign_X == 4'b1111)
                                state <= 4'b0001;
                            else if(assign_X == 4'b1101)
                                state <= 4'b0100;
                            else if((assign_X & 4'b1101) == 4'b1100)
                                state <= 4'b0111;			 
                        end

            4'b1111 : begin
                            if(assign_X == 4'b1100)
                                state <= 4'b0011;
                            else if(assign_X == 4'b1010)
                                state <= 4'b0110;
                            else if(assign_X == 4'b0000)
                                state <= 4'b1010;
                            else if((assign_X & 4'b1100) == 4'b0100)
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
///1///
endmodule