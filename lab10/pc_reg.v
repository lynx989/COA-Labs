module pc_reg(clk, reset, next_pc, pc);

input clk;
input reset;
input [31:0] next_pc;
output reg [31:0] pc;

always @(posedge clk or posedge reset)
begin
    if (reset)
        pc <= 32'h00000000;
    else
        pc <= next_pc;
end

endmodule
