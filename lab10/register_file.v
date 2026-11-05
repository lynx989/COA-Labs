module register_file(clk, RegWEn, AddrA, AddrB, AddrD, DataD, DataA, DataB);

input clk;
input RegWEn;
input [4:0] AddrA, AddrB, AddrD;
input [31:0] DataD;

output [31:0] DataA, DataB;

reg [31:0] registers [0:31];

integer i;

initial
begin
    for (i = 0; i < 32; i = i + 1)
        registers[i] = 0;
end

assign DataA = (AddrA == 0) ? 32'd0 : registers[AddrA];
assign DataB = (AddrB == 0) ? 32'd0 : registers[AddrB];

always @(posedge clk)
begin
    if (RegWEn && AddrD != 0)
        registers[AddrD] <= DataD;

    registers[0] <= 0;
end

endmodule
