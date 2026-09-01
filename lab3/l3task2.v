module twoonemux(a,b,select,c);

input a,b;
input select;
output reg c;

always @ *
begin

if (select == 0)
c = a & b;
else if (select == 1)
c = a + b;
end

endmodule

module testbench();

reg a,b;
reg select;
wire c;

twoonemux uut(a,b,select,c);

initial 
begin
 a = 0; b = 0; select = 0;
    #10;
    a = 0; b = 1; select = 0;
    #10;
    a = 1; b = 0; select = 0;
    #10;
    a = 1; b = 1; select = 0;
    #10;
    a = 0; b = 0; select = 1;
    #10;
    a = 0; b = 1; select = 1;
    #10;
    a = 1; b = 0; select = 1;
    #10;
    a = 1; b = 1; select = 1;
    #10;
end
endmodule
