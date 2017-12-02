module BusUpsizer
#(   
	parameter S_DATA_WIDTH = 8
	,M_DATA_WIDTH = 32
)
(
	 input wire clock
	,input wire reset
	,input wire s_val
	,input wire [S_DATA_WIDTH-1:0] s_data
	,input wire m_rdy
	,output reg s_rdy
	,output reg m_val	
	,output reg [M_DATA_WIDTH-1:0] m_data
);
  
reg [1:0] counter;
reg [S_DATA_WIDTH-1:0] m_data1, m_data2, m_data3, m_data4;

always @(posedge clock or posedge reset)
  begin
	  	if (reset) 
	  	begin
	  	 	counter <= 1'b0;
	  	 	m_val <= 0; 
		  	s_rdy <= 0;	
		  
	    end 
		else 
		begin
		    if (s_rdy == 1'b1 && s_val == 1'b1) 
			begin
			  	counter <= counter + 1'b1;
				case(counter)
					2'b00: m_data1 <= s_data;
					2'b01: m_data2 <= s_data;
					2'b10: m_data3 <= s_data;
					2'b11: m_data4 <= s_data;
				endcase	
			end
	  	end

		if (counter == 2'b11) 
		begin
		    m_val <= 1;
		    m_rdy <= 1;
		end
		    else begin
		        m_val <=0;
		        s_rdy <=0;
		    end
		m_data <= {m_data1, m_data2, m_data3, m_data4};	
	end
endmodule
