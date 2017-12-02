module counter
#(   
	parameter DATA_WIDTH = 2
)
(
	input  wire clock
   ,input  wire reset
   ,input  wire enable
   ,output reg  [DATA_WIDTH-1:0] counter
);

always @(posedge clock)
	if ( enable ) begin
		if ( reset ) begin
			counter = 0;
		end else begin
			counter <= counter + 1'd1;
		end
	end else begin
		counter = 0;
	end
endmodule

/*
module BusUpsizer
#(   
	parameter S_DATA_WIDTH = 8
	,M_DATA_WIDTH = 32
)
(
	 input wire clock
	,input wire reset
	//,input wire s_val
	,input wire [S_DATA_WIDTH-1:0] s_data
	//,input wire m_rdy
	//,input wire s_rdy
	//,input wire m_val	
	,output reg [M_DATA_WIDTH-1:0] m_data
);
  
reg [1:0] counter;
reg [S_DATA_WIDTH-1:0] m_data1, m_data2, m_data3, m_data4;

always @(posedge clock or negedge reset)
  begin

  	  if (reset) begin
	  counter <= 1'b0;
    end
  else begin
    counter <= counter + 1'b1;
  end
  case(counter)
    2'b00: m_data1 <= s_data;
    2'b01: m_data2 <= s_data;
    2'b10: m_data3 <= s_data;
    2'b11: m_data4 <= s_data;
  endcase
     m_data = {m_data1, m_data2, m_data3, m_data4};
  end
endmodule
*/