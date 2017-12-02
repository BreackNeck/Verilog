 `timescale 10ns / 10ns

module test;
  parameter WIDTH = 8;
  
  reg 				clk;
  reg 				rst_n;
  reg 				s0_val;
  reg 				s0_dst;
  reg  [WIDTH-1:0]  s0_data;
  wire 				s0_rdy;
  reg 				s1_val; 
  reg 				s1_dst;
  reg  [WIDTH-1:0]  s1_data;
  wire 				s1_rdy;
  wire 				m0_val;
  wire 				m0_src;
  wire [WIDTH-1:0]  m0_data;
  reg 				m0_rdy;
  wire 				m1_val;
  wire 				m1_src;
  wire [WIDTH-1:0]  m1_data;
  reg 				m1_rdy;
  
  crossbar 
  #(.WIDTH(WIDTH))
  CROSSBAR (.clk(clk), 
            .rst_n(rst_n),      
            .s0_val(s0_val),
            .s0_dst(s0_dst),
            .s0_data(s0_data),
            .s0_rdy(s0_rdy),
            .s1_val(s1_val),
            .s1_dst(s1_dst), 
            .s1_data(s1_data),
  			.s1_rdy(s1_rdy),
            .m0_val(m0_val),
  			.m0_src(m0_src),
  			.m0_data(m0_data), 
  			.m0_rdy(m0_rdy),
            .m1_val(m1_val),
  			.m1_src(m1_src), 
  			.m1_data(m1_data),
            .m1_rdy(m1_rdy));            
  
    initial begin
    	$dumpfile("dump.vcd");
    	$dumpvars(1);
    	clk = 1'b0;
      	assert (clk == 1'b0) $display ("clock = 0");
    	forever #5 clk = ~clk;
    end
  
 
  	initial begin
    	rst_n    = 1;  
		#1 rst_n = 0;
        assert (rst_n == 0) $display ("rst_n = 0");
   		#3 rst_n = 1; 
      	assert (rst_n == 1) $display ("rst_n = 1");
 //----------------------------------------------------
    	s0_data <= 1;//data
   		s0_dst   = 0; // 0 for m0, 1 for m1
    	s0_val  <= 1;  // 1 is ok
    
    	s1_data <= 2;// same settings 
    	s1_dst   = 1; 
    	s1_val  <= 1; 
     	assert (s0_dst == 0 && s1_dst == 1) 
        	$display ("s0->m0 s1->m1");
    	m0_rdy  <= 1;
      
    	m1_rdy  <= 1;
 //----------------------------------------------------
		#1 rst_n = 0;
		m0_rdy = 0;
		m1_rdy = 0;
   		#2 rst_n = 1;
		assert (m0_rdy == 0 && m1_rdy == 0) 
        	$display ("reset with m(0)_rdy, m(1)_rdy = 0");
//----------------------------------------------------
    #10 
    	s0_data <= 3;//data
    	s0_dst   = 0; // 0 for m0, 1 for m1
    	s0_val  <= 1;  // 1 is ok
    
    	s1_data <= 4;// same settings 
    	s1_dst   = 1; 
    	s1_val  <= 1;
      
    	m0_rdy  = 1;
      
    	m1_rdy  = 0; 
        assert (m0_rdy == 1 && m1_rdy == 0) 
          $display ("s0->m0 s1->m1, m1_rdy = 0");
 //----------------------------------------------------
    #10 
    	s0_data <= 1;//data
    	s0_dst   = 1; // 0 for m0, 1 for m1
    	s0_val  <= 1;  // 1 is ok
    
    	s1_data <= 2;// same settings 
    	s1_dst   = 0; 
    	s1_val  <= 1; 
      
     	assert (s0_dst == 1 && s1_dst == 0) 
        	$display ("s0->m1 s1->m0");
      
    	m0_rdy  <= 1;
      
    	m1_rdy  <= 1;
 //----------------------------------------------------
    #10 
    	s0_data <= 3;//data
    	s0_dst   = 0; // 0 for m0, 1 for m1
    	s0_val  <= 1;  // 1 is ok
    
    	s1_data <= 4;// same settings 
    	s1_dst   = 0; 
    	s1_val  <= 1; 
      
      	assert (s0_dst == 0 && s1_dst == 0) 
        	$display ("s0->m0 s1->m0, prioity check");
      
    	m0_rdy  <= 1;
      
    	m1_rdy  <= 1;  
 //----------------------------------------------------
    #10 
    	s0_data <= 1;//data
    	s0_dst   = 0; // 0 for m0, 1 for m1
    	s0_val   = 0;  // 1 is ok
    
    	s1_data <= 2;// same settings 
    	s1_dst   = 0; 
    	s1_val  <= 1; 
      
      	assert (s0_dst == 0 && s1_dst == 0 && s0_val==0) 
        	$display ("s0->m0 s1->m0, s0 isn't valid");
      
      	m0_rdy  <= 1;
      
    	m1_rdy  <= 1;
 //----------------------------------------------------
    #10 
    	s0_data <= 5;//data
    	s0_dst   = 1; // 0 for m0, 1 for m1
    	s0_val  <= 1;  // 1 is ok
    
    	s1_data <= 6;// same settings 
    	s1_dst   = 1; 
    	s1_val   = 0; 
      
      	assert (s0_dst == 1 && s1_dst == 1 && s1_val==0) 
        	$display ("s0->m1 s1->m1, s1 isn't valid");
     
    	m0_rdy  <= 1;
      
    	m1_rdy  <= 1;
 //----------------------------------------------------
    #10 
    	s0_data <= 5;//data
    	s0_dst  <= 0; // 0 for m0, 1 for m1
    	s0_val  <= 1;  // 1 is ok
    
    	s1_data <= 6;// same settings 
    	s1_dst  <= 1; 
    	s1_val  <= 1; 
     
    	m0_rdy   = 0;
      
    	m1_rdy  <= 1;
      	
      	assert (m0_rdy == 0) 
        	$display ("s0->m0 s1->m1, m0 isn't ready");
 //----------------------------------------------------
    #10 
    	s0_data <= 7;//data
    	s0_dst  <= 0; // 0 for m0, 1 for m1
    	s0_val  <= 1;  // 1 is ok
    
    	s1_data <= 6;// same settings 
    	s1_dst  <= 1; 
    	s1_val  <= 1; 
     
    	m0_rdy  <= 1;
      
    	m1_rdy   = 0;  
      
     	assert (m1_rdy == 0) 
       		$display ("s0->m0 s1->m1, m1 isn't ready");
 //----------------------------------------------------
  #10 $finish;
  end 
  
endmodule
