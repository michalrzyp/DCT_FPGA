module MUX
(
input wire		CLK,
input wire		RST,

input wire	STBi,
input wire[7:0]	DATi,
output wire ACKi,

output reg STBo,
output wire [7:0] DATo0,
output wire [7:0] DATo1,
output wire [7:0] DATo2,
output wire [7:0] DATo3,
output wire [7:0] DATo4,
output wire [7:0] DATo5,
output wire [7:0] DATo6,
output wire [7:0] DATo7,
input wire ACKo
);

reg [7:0] RAM [0:7];

assign DATo0=RAM[0];
assign DATo1=RAM[1];
assign DATo2=RAM[2];
assign DATo3=RAM[3];
assign DATo4=RAM[4];
assign DATo5=RAM[5];
assign DATo6=RAM[6];
assign DATo7=RAM[7];


reg [2:0] index;
assign ACKi = STBi & ~STBo ;	 

always @(posedge CLK)
	if(ACKi) RAM[index]<=DATi;
	 
always @(posedge CLK or posedge RST)
		if(RST) index<=0;
			else if (ACKi) index<=(index+1);
			else index<=index;

always @(posedge CLK or posedge RST)
		if(RST) STBo<=0;
			else if (index==7 && STBi) STBo<=1;
			else if(ACKo) STBo <= 0;
			else STBo<=STBo;


endmodule