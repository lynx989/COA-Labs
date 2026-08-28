module multiplexer(y0,y1,y2,y3,y4,y5,y6,y7,a,b,c,z);

input a,b,c,y0,y1,y2,y3,y4,y5,y6,y7;
output z;

wire nota;
wire notb;
wire notc;

assign nota = ~a;
assign notb = ~b;
assign notc = ~c;

wire w0,w1,w2,w3,w4,w5,w6,w7;

assign w0 = y0 & nota & notb & notc;
assign w1 = y1 & nota & notb & c;
assign w2 = y2 & nota & b & notc;
assign w3 = y3 & nota & b & c;
assign w4 = y4 & a & notb & notc;
assign w5 = y5 & a & notb & c;
assign w6 = y6 & a & b & notc;
assign w7 = y7 & a & b & c;

assign z = w0 + w1 + w2 + w3 + w4 + w5 + w5 + w6 + w7;

endmodule 


module testbench(); // dont pass any parameter in test bench

reg a; // select lines
reg b;
reg c;

reg y0;
reg y1;
reg y2;
reg y3;
reg y4;
reg y5;
reg y6;
reg y7;

wire z;

multiplexer uut(y0,y1,y2,y3,y4,y5,y6,y7,a,b,c,z);

initial
begin

y0 = 0;
y1 = 0;
y2 = 1;
y3 = 1;
y4 = 0;
y5 = 0;
y6 = 1;
y7 = 0;

a = 0; b = 0; c = 0;
#50 a = 0; b = 0; c = 1;
#50 a = 0; b = 1; c = 0;
#50 a = 0; b = 1; c = 1;
#50 a = 1; b = 0; c = 0;
#50 a = 1; b = 0; c = 1;
#50 a = 1; b = 1; c = 0;
#50 a = 1; b = 1; c = 1;

end

endmodule 