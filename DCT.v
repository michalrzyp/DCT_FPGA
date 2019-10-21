module DCT
#(
  parameter horizontal = 1		 // 1 - horizontal, 0 - vertical
)
(
	input wire        CLK, // CLK 
	input wire        RST, // Active high reset			
	
	input wire i_stb,	
	input wire  [7:0] i_D0,
	input wire  [7:0] i_D1,
	input wire  [7:0] i_D2,
	input wire  [7:0] i_D3,
	input wire  [7:0] i_D4,
	input wire  [7:0] i_D5,
	input wire  [7:0] i_D6,
	input wire  [7:0] i_D7,
	
	
  	output wire o_stb, 
	output wire signed [7:0] o_D0,
	output wire signed [7:0] o_D1,
	output wire signed [7:0] o_D2,
	output wire signed [7:0] o_D3,
	output wire signed [7:0] o_D4,
	output wire signed [7:0] o_D5,
	output wire signed [7:0] o_D6,
	output wire signed [7:0] o_D7
	
  ); 
  
  	assign o_D0=s3_DST0;
	assign o_D1=s3_DST1;
	assign o_D2=s3_DST2;
	assign o_D3=s3_DST3;
	assign o_D4=s3_DST4;
	assign o_D5=s3_DST5;
	assign o_D6=s3_DST6;
	assign o_D7=s3_DST7;	
  
localparam  TRANSFORM_JPEG_IPREC_CONST_BITS   =     13																   ;
localparam  TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER = (1<<TRANSFORM_JPEG_IPREC_CONST_BITS)							   ;
//#define TRANSFORM_JPEG_IPREC_CALC_COEFF(x)     (((int32) ((x) * TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER + 0.5)))	   

localparam  TRANSFORM_JPEG_IFAST_CONST_BITS       = 8																   ;
localparam  TRANSFORM_JPEG_IFAST_CONST_MULTIPLIER = (1<<TRANSFORM_JPEG_IFAST_CONST_BITS)							   ;
//#define  TRANSFORM_JPEG_IFAST_CALC_COEFF(x)    = (((int32) ((x) * TRANSFORM_JPEG_IFAST_CONST_MULTIPLIER + 0.5))) 	

localparam  PASS1_BITS = 2																								;

localparam  Shift1st  = TRANSFORM_JPEG_IPREC_CONST_BITS - PASS1_BITS;												   ;
localparam  Add1st    = 1<<(Shift1st-1); 																			   ;
localparam  Shift2nd  = TRANSFORM_JPEG_IPREC_CONST_BITS + PASS1_BITS -1;										  ;
localparam  Add2nd    = 1<<(Shift2nd-1); 	



localparam Add = horizontal ? Add1st : Add2nd;
localparam Shift = horizontal ? Shift1st : Shift2nd;

  

localparam integer m_P_0o298631336 = (0.298631336 * TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER)+ 0.5 ;
localparam integer m_P_0o390180644 = (0.390180644 * TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER)+ 0.5 ;
localparam integer m_P_0o541196100 = (0.541196100 * TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER)+ 0.5 ;
localparam integer m_P_0o765366865 = (0.765366865 * TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER)+ 0.5 ;
localparam integer m_P_0o899976223 = (0.899976223 * TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER)+ 0.5 ;
localparam integer m_P_1o175875602 = (1.175875602 * TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER)+ 0.5 ;
localparam integer m_P_1o501321110 = (1.501321110 * TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER)+ 0.5 ;
localparam integer m_P_1o847759065 = (1.847759065 * TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER)+ 0.5 ;
localparam integer m_P_1o961570560 = (1.961570560 * TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER)+ 0.5 ;
localparam integer m_P_2o053119869 = (2.053119869 * TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER)+ 0.5 ;
localparam integer m_P_2o562915447 = (2.562915447 * TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER)+ 0.5 ;
localparam integer m_P_3o072711026 = (3.072711026 * TRANSFORM_JPEG_IPREC_CONST_MULTIPLIER)+ 0.5 ;

  
  reg s1_stb;
  reg signed [31:0]  s1_D0;
  reg signed [31:0] s1_D1;
  reg signed [31:0] s1_D2;
  reg signed [31:0] s1_D3;
  reg signed [31:0] s1_D4;
  reg signed [31:0] s1_D5;
  reg signed [31:0] s1_D6;
  reg signed [31:0] s1_D7;	 
  
  reg signed [31:0] s1_E0;
  reg signed [31:0] s1_E1;
  reg signed [31:0] s1_E2;
  reg signed [31:0] s1_E3;
  reg signed [31:0] s1_O3;
  reg signed [31:0] s1_O2;
  reg signed [31:0] s1_O1;
  reg signed [31:0] s1_O0;	  
  
  
  always@(posedge CLK)begin   
	  s1_stb <= i_stb;
	  s1_D0 <=  i_D0 ;
	  s1_D1	<=  i_D1 ;
	  s1_D2	<=  i_D2 ;
	  s1_D3	<=  i_D3 ;
	  s1_D4	<=  i_D4 ;
	  s1_D5	<=  i_D5 ;
	  s1_D6	<=  i_D6 ;
	  s1_D7	<=  i_D7 ;
	       
	  s1_E0	<=  i_D0 + i_D7;
	  s1_E1	<=  i_D1 + i_D6;
	  s1_E2 <=  i_D2 + i_D5;
	  s1_E3	<=  i_D3 + i_D4;
	  s1_O3	<=  i_D3 - i_D4;
	  s1_O2	<=  i_D2 - i_D5;
	  s1_O1	<=  i_D1 - i_D6;
	  s1_O0	<=  i_D0 - i_D7;	  
	  end

	 
// S2
	  
	  
  reg s2_stb;
  reg signed [31:0] s2_D0;
  reg signed [31:0] s2_D1;
  reg signed [31:0] s2_D2;
  reg signed [31:0] s2_D3;
  reg signed [31:0] s2_D4;
  reg signed [31:0] s2_D5;
  reg signed [31:0] s2_D6;
  reg signed [31:0] s2_D7;	 
  			  
  reg signed [31:0] s2_E0;
  reg signed [31:0] s2_E1;
  reg signed [31:0] s2_E2;
  reg signed [31:0] s2_E3;
  reg signed [31:0] s2_O3;
  reg signed [31:0] s2_O2;
  reg signed [31:0] s2_O1;
  reg signed [31:0] s2_O0;	 
  
  reg signed [31:0] s2_EE0;
  reg signed [31:0] s2_EO0;
  reg signed [31:0] s2_EE1;
  reg signed [31:0] s2_EO1;
 
  reg signed [31:0] s2_B;
  reg signed [31:0] s2_B1;
  reg signed [31:0] s2_B2;
  reg signed [31:0] s2_B3;
  reg signed [31:0] s2_B4;

  reg signed [31:0] s2_A;

  always@(posedge CLK)begin  
	  s2_stb <= s1_stb;
	  s2_D0 <=  s1_D0 ;
	  s2_D1	<=  s1_D1 ;
	  s2_D2	<=  s1_D2 ;
	  s2_D3	<=  s1_D3 ;
	  s2_D4	<=  s1_D4 ;
	  s2_D5	<=  s1_D5 ;
	  s2_D6	<=  s1_D6 ;
	  s2_D7	<=  s1_D7 ;
	       
	  s2_E0	<=  s1_E0;
	  s2_E1	<=  s1_E1;
	  s2_E2 <=  s1_E2;
	  s2_E3	<=  s1_E3;
	  s2_O3	<=  s1_O3;
	  s2_O2	<=  s1_O2;
	  s2_O1	<=  s1_O1;
	  s2_O0	<=  s1_O0;
	  
	  s2_EE0 <=  s1_E0 + s1_E3;
	  s2_EO0 <=  s1_E0 - s1_E3;
	  s2_EE1 <=  s1_E1 + s1_E2;
	  s2_EO1 <=  s1_E1 - s1_E2;	
	  

	s2_B  	<=  (s1_O0 + s1_O1 + s1_O2 + s1_O3)* m_P_1o175875602;
	s2_B1	<=(s1_O3+s1_O0)*(-m_P_0o899976223);
	s2_B2	<=(s1_O2+s1_O1)*(-m_P_2o562915447);
  end
  reg s2_stb_tmp;
  always@(posedge CLK)begin  
	s2_stb_tmp <= s2_stb;
	s2_B3<=(s1_O3+s1_O1)*(-m_P_1o961570560)+s2_B;
	s2_B4<=(s1_O2+s1_O0)*(-m_P_0o390180644)+s2_B;
	s2_A <=(s2_EO1+s2_EO0)*m_P_0o541196100;
  end

	 
// S3

  reg signed [15:0] s3_DST0;
  reg signed [15:0] s3_DST1;
  reg signed [15:0] s3_DST2;
  reg signed [15:0] s3_DST3;
  reg signed [15:0] s3_DST4;
  reg signed [15:0] s3_DST5;
  reg signed [15:0] s3_DST6;
  reg signed [15:0] s3_DST7;
  reg s3_stb;  
  //wire signed [15:0] s333=s1_O0 * (m_P_1o501321110);
 
  
  always@(posedge CLK)
 begin  	 
	  s3_stb<= s2_stb_tmp; 
	  
	  s3_DST0 <=  (s2_EE0 + s2_EE1)<< PASS1_BITS;
	  s3_DST4 <=  (s2_EE0 - s2_EE1)<< PASS1_BITS;

	  s3_DST2 <=  (s2_A+ (s2_EO0 * m_P_0o765366865) + Add) >> Shift;
	  s3_DST6 <=  (s2_A +(s2_EO1 * (-m_P_1o847759065)) + Add) >> Shift;

	  s3_DST1 <=  (((s1_O0 * (m_P_1o501321110))+s2_B1 + s2_B4 + Add) >> Shift);	 
	 // s3_DST1 <=  (((s333)+s2_B1 + s2_B4 + Add) >> Shift);
	  s3_DST3 <=  (((s1_O1 * (m_P_3o072711026))+s2_B2 + s2_B3 + Add) >> Shift);
	  s3_DST5 <=  (((s1_O2 * (m_P_2o053119869))+s2_B2 + s2_B4 + Add) >> Shift);
	  s3_DST7 <=  (((s1_O3 * (m_P_0o298631336))+s2_B1 + s2_B3 + Add) >> Shift);		
 end	 
  reg signed [15:0] s4_DST0;
  reg signed [15:0] s4_DST1;
  reg signed [15:0] s4_DST2;
  reg signed [15:0] s4_DST3;
  reg signed [15:0] s4_DST4;
  reg signed [15:0] s4_DST5;
  reg signed [15:0] s4_DST6;
  reg signed [15:0] s4_DST7;

  assign o_stb=s3_stb;
  
/*
 
assign o_stb = i_stb; 
assign o_D0=i_D0;
assign o_D1=i_D1;
assign o_D2=i_D2;
assign o_D3=i_D3;
assign o_D4=i_D4;
assign o_D5=i_D5;
assign o_D6=i_D6;
assign o_D7=i_D7; 
    */
  
endmodule	