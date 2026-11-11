module data_memory(i_clk, i_we, i_data, i_addr, o_data);

input wire i_clk;
input wire i_we;
input wire [31:0] i_data;
input wire [9:0] i_addr;
output wire [31:0] o_data;

reg [31:0] mem [0:1023];

integer i;

initial begin 
for (i = 0; i < 1024; i=i+1)
	mem[i] = 32'h00000000;
end

// write port
always @(posedge i_clk)
begin 

if (i_we && i_addr != 0)
	mem[i_addr] <= i_data;
end 


// read port
reg [31:0] r_data;

always @(posedge i_clk)
begin 

if (i_we == 0 && i_addr != 0)
r_data <= mem[i_addr];

end

assign o_data = r_data;

endmodule 



module tb_data_memory();

reg i_clk;
reg i_we;
reg [31:0] i_data;
reg [9:0] i_addr;
wire [31:0] o_data;

data_memory dut(
    .i_clk(i_clk),
    .i_we(i_we),
    .i_data(i_data),
    .i_addr(i_addr),
    .o_data(o_data)
);

initial begin
    i_clk = 0;
    forever #5 i_clk = ~i_clk;
end

initial begin

    i_we = 1;
    i_data = 32'd120;
    i_addr = 10'd16;

    @(posedge i_clk);
    #1;

    $display("Memory[16] = %d", dut.mem[16]);

    i_we = 0;
    i_addr = 10'd16;

    @(posedge i_clk);
    #1;

    $display("data = %d", o_data);
end

endmodule

