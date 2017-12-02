module crossbar
  
  #(
    parameter WIDTH = 8
  )

  (input              clk,
   input              rst_n,
   
   input              s0_val,
   input            s0_dst, 
   input      [WIDTH-1:0]   s0_data, 
   output reg         s0_rdy, 
   
   input            s1_val,  
   input            s1_dst,  
   input      [WIDTH-1:0]   s1_data, 
   output reg         s1_rdy,
   
   output reg         m0_val,
   output reg         m0_src, 
   output reg [WIDTH-1:0]   m0_data,
   input            m0_rdy,
   
   output reg         m1_val,
   output reg         m1_src, 
   output reg [WIDTH-1:0]   m1_data,
   input            m1_rdy);

  always @(clk or negedge rst_n) begin
    
 //---------------------------------------------------------reset  
    if (rst_n == 1'b0) begin
      m0_val <= 0; // tells enviroment that data is a lie
      m1_val <= 0;
      s0_rdy <= 0; // not ready to get any data ..
      s1_rdy <= 0; 
    end 
 //---------------------------------------------------------------
      
    if (clk == 1) begin
      
 //-----------------------------------------------check regs & dst    
   
     if ((s0_dst == 0 && m0_val == 1) || (s0_dst == 1 && m1_val == 1)) 
     begin
      s0_rdy <= 0;
     end 
      
     if ((s1_dst == 0 && m0_val == 1) || (s1_dst == 1 && m1_val == 1)) 
     begin
      s1_rdy <= 0;  
     end 
 
//---------------------------------------------------------------
  

      
//-------------------------------if everything is ok - get message 
      
      if ((s0_dst == 0 && m0_val == 0) || (s0_dst == 1 && m1_val == 0)) 
      begin
        s0_rdy <= 1;
      end
      
      if ((s1_dst == 0 && m0_val == 0) || (s1_dst == 1 && m1_val == 0)) 
      begin
        s1_rdy <= 1;  
      end  
      
      if (s0_rdy && s0_val) begin             // if input data is valid         
    if ((s0_dst == 0) && (m0_rdy==1)) begin // check destination, check if env is ready
          m0_data <= s0_data;
            m0_val  <= 1;
            m0_src  <= 0;
        end 
        
        if ((s0_dst == 1) && (m1_rdy==1)) begin
            m1_data <= s0_data;
            m1_val  <= 1;
            m1_src  <= 0;
        end
      end 

      if (s1_rdy && s1_val) begin
        if ((s1_dst == 0) && ((s1_dst!=s0_dst) || (s0_val==0)) 
                && (m0_rdy==1)) begin // +priority check +s0 valid check          
            m0_data <= s1_data;
            m0_val  <= 1;
            m0_src  <= 1;
        end     
    
          if ((s1_dst == 1) && (s1_dst!=s0_dst || (s0_val==0))
                  && (m1_rdy==1)) begin         
            m1_data <= s1_data;
            m1_val  <= 1;
            m1_src  <= 1; 
        end        
       end  
      
    end 
    
    if (clk == 0 && m0_rdy) begin
      m0_val <=0; 
    end
    if (clk == 0 && m1_rdy) begin
      m1_val <=0; 
    end
    
end
endmodule