module DEMUX
(
input wire		CLK,
input wire		RST,

output reg	STBo,
output wire[7:0] DATo,
input wire ACKo,

input wire STBi,
input wire [7:0] DATi0,
input wire [7:0] DATi1,
input wire [7:0] DATi2,
input wire [7:0] DATi3,
input wire [7:0] DATi4,
input wire [7:0] DATi5,
input wire [7:0] DATi6,
input wire [7:0] DATi7,
output wire ACKi
);

reg [2:0] index;
wire [7:0] RAM [0:7]; 
//reg [7:0]DATwy;
reg acki;
assign ACKi=acki;
assign RAM[0]=DATi0;
assign RAM[1]=DATi1;
assign RAM[2]=DATi2;
assign RAM[3]=DATi3;
assign RAM[4]=DATi4;
assign RAM[5]=DATi5;
assign RAM[6]=DATi6;
assign RAM[7]=DATi7;
assign DATo=RAM[index];

always @(posedge CLK)
	if(((STBi==1) && (index==7))) acki<=1;	  
	else acki<=0;	
	 
always @(posedge CLK or posedge RST)
		if(RST) index<=0;
		else if (((STBi==1) && (ACKo==1))) index<=(index+1);
		else index<=index;

always @(posedge CLK or posedge RST)
	if(RST) STBo<=0;
	else if((ACKo==1) && (index==7)) STBo <= 0;	   	
	else if(STBi & ~ACKi ) STBo <= 1;		  
	else STBo<=STBo;


endmodule