module register_file_32bit(
    input clk,
    input rst,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] wdata,
    input reg_write,
    output reg [31:0] rdata1,
    output reg [31:0] rdata2
);

reg [31:0] registers [0:31];
integer i;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'b0;
        end
    end
    else begin
        if (reg_write && rd != 5'd0) begin
            registers[rd] <= wdata;
        end
    end
end

always @(*) begin
    if (rs1 == 5'd0)
        rdata1 = 32'b0;
    else
        rdata1 = registers[rs1];

    if (rs2 == 5'd0)
        rdata2 = 32'b0;
    else
        rdata2 = registers[rs2];
end

endmodule


module testbench;

reg clk, rst, reg_write;
reg [4:0] rs1, rs2, rd;
reg [31:0] wdata;
wire [31:0] rdata1, rdata2;

register_file_32bit uut (
    .clk(clk),
    .rst(rst),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .wdata(wdata),
    .reg_write(reg_write),
    .rdata1(rdata1),
    .rdata2(rdata2)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1;
    reg_write = 0;
    rs1 = 0;
    rs2 = 0;
    rd = 0;
    wdata = 0;

    #10 rst = 0;

    rd = 1;
    wdata = 100;
    reg_write = 1;
    #10;

    rd = 2;
    wdata = 200;
    #10;

    reg_write = 0;
    rs1 = 1;
    rs2 = 2;
    #1;

    $display("x1 = %d", rdata1);
    $display("x2 = %d", rdata2);

    rs1 = 0;
    #1;
    $display("x0 = %d", rdata1);

end

endmodule
