module comparator(a,b,greater,equal,lesser);

input [1:0] a,b;
output reg greater, equal, lesser;

always @ * 
begin

greater = 0; equal = 0; lesser = 0;
if (a > b)
greater = 1;
else if (a == b)
equal = 1;
else 
lesser = 1;

end

endmodule 

module testbench();

reg [1:0] a,b;
wire greater, equal, lesser;

comparator uut(a,b,greater,equal,lesser);

initial 
begin
a = 2'b01; b = 2'b10;
    #10;
a = 2'b11; b = 2'b10;
    #10;
a = 2'b00; b = 2'b01;
    #10;
a = 2'b10; b = 2'b10;

end
endmodule
