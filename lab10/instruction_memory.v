module instruction_memory(addr, instruction);

input [31:0] addr;
output reg [31:0] instruction;

reg [31:0] memory [0:15];

integer i;

initial
begin
    for (i = 0; i < 16; i = i + 1)
        memory[i] = 32'h00000000;
end

always @*
begin
    if (addr[31:2] < 16)
        instruction = memory[addr[5:2]];
    else
        instruction = 32'h00000000;
end

endmodule
