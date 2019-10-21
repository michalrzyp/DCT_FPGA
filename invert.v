module invert
(
input wire		CLK,
input wire		RST,

input wire	STBi,
input wire[7:0]DATi0,
input wire[7:0]DATi1,
input wire[7:0]DATi2,
input wire[7:0]DATi3,
input wire[7:0]DATi4,
input wire[7:0]DATi5,
input wire[7:0]DATi6,
input wire[7:0]DATi7,
output wire ACKi,

output wire STBo,
output wire[7:0]DATo0,
output wire[7:0]DATo1,
output wire[7:0]DATo2,
output wire[7:0]DATo3,
output wire[7:0]DATo4,
output wire[7:0]DATo5,
output wire[7:0]DATo6,
output wire[7:0]DATo7,
input wire ACKo
);


reg [2:0] count1;  
//initial count1 <= 0;
	
//*******************************************ACK*******************************************	
//ACK otrzymywane od kolejnego modu3u, przekazywane do wszystkich kolejek
wire ack_tmp;
assign ack_tmp=ACKo;
//ACK które jest sum1 ACK wszystkich kolejek, wartooa 1 gdy którykolwiek modu3 zwraca ACKwe=1
//wire ACKsumall;
wire ack1,ack2,ack3,ack4,ack5,ack6,ack7,ack8;
//assign ACKsumall=ack1 | ack2 | ack3 | ack4 | ack5 | ack6 | ack7 | ack8;
//ACK zwracane przez ca3y modu3 invert, wartooa 1 gdy ostatnia kolejka zwraca ACKwe=1
wire ACKinput=(count1==7)? 1 : 0; 
assign ACKi=ACKinput;
	
//*******************************************STB*******************************************
//Rejestr stb bitem wybiera która kolejka otrzymuje dane
reg [7:0] stb;	
//stbwy to STB ca3ego modu3u invert	
wire stbwy;
assign STBo=stbwy;
//stb_tmpX to wyjociowe STB z wszystkich kolejek, stbwy 31czy ich wartooci w STB wyjociowe ca3ego modu3u invert
wire stb_tmp1,stb_tmp2,stb_tmp3,stb_tmp4,stb_tmp5,stb_tmp6,stb_tmp7,stb_tmp8;
assign stbwy=(stb_tmp8)? 1 :0;
//STBi opóYnione o 1 takt, inaczej jest sytuacja w której STBi jest 1 a data jest XX
reg STBinput;

always@ (posedge CLK or posedge RST)
	if(RST) STBinput<=0;
	else STBinput<=STBi; 
//data to rejestr s³u¿¹cy przekazywaniu danych na wejœcia kolejek
reg [7:0] data;
//data_tmpX to dane wyjœciowe ka¿dej z kolejek oraz wyjœcia ca³ego modu³u invert
wire [7:0]data_tmp1;
wire [7:0]data_tmp2;
wire [7:0]data_tmp3;
wire [7:0]data_tmp4;
wire [7:0]data_tmp5;
wire [7:0]data_tmp6;
wire [7:0]data_tmp7;
wire [7:0]data_tmp8;
assign DATo0=data_tmp1;
assign DATo1=data_tmp2;
assign DATo2=data_tmp3;
assign DATo3=data_tmp4;
assign DATo4=data_tmp5;
assign DATo5=data_tmp6;
assign DATo6=data_tmp7;
assign DATo7=data_tmp8;		
reg zmienko;

//Always z rejestrem przesuwnym inkremetuj1cym stb, stb wybiera która kolejka otrzymuje dane
always@(posedge CLK or posedge RST)
	if(RST) zmienko<=0;
	else if(STBi && count1==7) zmienko<=1; 
	else zmienko<=0;
		
always@(posedge CLK or posedge RST) 
	if(RST) stb<=1;	
	else if(zmienko==1) stb<={stb[6:0],stb[7]}; 
	//else stb<=0;
		
//Always przepisuj1ce dane wejociowe modu3u invert do rejestru data które przekazuje dane na wejocia kolejek
always@(posedge CLK)
	//if(STBi) 
	case (count1)
 0:   data<=DATi0;
 1:   data<=DATi1;
 2:   data<=DATi2;
 3:   data<=DATi3;
 4:   data<=DATi4;
 5:   data<=DATi5;
 6:   data<=DATi6;
 7:   data<=DATi7;
      default: data<=DATi0;
    endcase

//Always inkrementuj1cy licznik, licznik steruje przepisywaniem wartooci wejociowych do kolejek 
always@(posedge CLK or posedge RST)   
	if(RST)	count1<=0;
	else if(STBi) count1<=count1+1;
					  				  
fifonew #(.length(8), .width(8)) my_fifo0(.CLK(CLK),.RST(RST),.i_stb(stb[0] & STBinput),.i_data(data),.i_ack(ack1),.o_stb(stb_tmp1),.o_data(data_tmp1),.o_ack(ack_tmp));
fifonew #(.length(8), .width(8)) my_fifo1(.CLK(CLK),.RST(RST),.i_stb(stb[1] & STBinput),.i_data(data),.i_ack(ack2),.o_stb(stb_tmp2),.o_data(data_tmp2),.o_ack(ack_tmp));
fifonew #(.length(8), .width(8)) my_fifo2(.CLK(CLK),.RST(RST),.i_stb(stb[2] & STBinput),.i_data(data),.i_ack(ack3),.o_stb(stb_tmp3),.o_data(data_tmp3),.o_ack(ack_tmp));
fifonew #(.length(8), .width(8)) my_fifo3(.CLK(CLK),.RST(RST),.i_stb(stb[3] & STBinput),.i_data(data),.i_ack(ack4),.o_stb(stb_tmp4),.o_data(data_tmp4),.o_ack(ack_tmp));
fifonew #(.length(8), .width(8)) my_fifo4(.CLK(CLK),.RST(RST),.i_stb(stb[4] & STBinput),.i_data(data),.i_ack(ack5),.o_stb(stb_tmp5),.o_data(data_tmp5),.o_ack(ack_tmp));
fifonew #(.length(8), .width(8)) my_fifo5(.CLK(CLK),.RST(RST),.i_stb(stb[5] & STBinput),.i_data(data),.i_ack(ack6),.o_stb(stb_tmp6),.o_data(data_tmp6),.o_ack(ack_tmp));
fifonew #(.length(8), .width(8)) my_fifo6(.CLK(CLK),.RST(RST),.i_stb(stb[6] & STBinput),.i_data(data),.i_ack(ack7),.o_stb(stb_tmp7),.o_data(data_tmp7),.o_ack(ack_tmp));
fifonew #(.length(8), .width(8)) my_fifo7(.CLK(CLK),.RST(RST),.i_stb(stb[7] & STBinput),.i_data(data),.i_ack(ack8),.o_stb(stb_tmp8),.o_data(data_tmp8),.o_ack(ack_tmp));		

endmodule