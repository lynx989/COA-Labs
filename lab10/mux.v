module mux(a, b, sel, out);

input [31:0] a, b;
input sel;
output reg [31:0] out;

always @*
begin
    if (sel == 0)
        out = a;
    else
        out = b;
end

endmodule
