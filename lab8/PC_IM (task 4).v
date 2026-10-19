module program_counter(clk, reset, pc_out);

input clk;
input reset;
output reg [31:0] pc_out;

always @(posedge clk or posedge reset) begin
	if (reset)
		pc_out <= 32'h00000000;
	else 
		pc_out <= pc_out + 32'h00000004;
end

endmodule 

module instruction_memory(addr, instruction);

input [31:0] addr;
output reg [31:0] instruction;

reg [31:0] memory [0:15];

initial begin
    memory[0] = 32'h00100093;
    memory[1] = 32'h00200113;
    memory[2] = 32'h003081B3;
    memory[3] = 32'h00400013;
    memory[4] = 32'h00500213;
    memory[5] = 32'h00600293;
    memory[6] = 32'h00700313;
    memory[7] = 32'h00800393;
    memory[8] = 32'h00900413;
    memory[9] = 32'h00A00493;
    memory[10] = 32'h00B00513;
    memory[11] = 32'h00C00593;
    memory[12] = 32'h00D00613;
    memory[13] = 32'h00E00693;
    memory[14] = 32'h00F00713;
    memory[15] = 32'h01000793;
end

always @ *
begin 

if (addr[31:2] < 16)
	instruction = memory[addr[5:2]];
else 
	instruction = 32'h00000000;
end 

endmodule 

module testbench();

reg clk;
reg reset;

wire [31:0] pc_out;
wire [31:0] instruction;

program_counter pc(.clk(clk), .reset(reset), .pc_out(pc_out));

instruction_memory im(.addr(pc_out), .instruction(instruction));

always begin 

#5 clk = ~clk;

end

initial begin 
	clk = 0;
	reset = 1;

	#10 reset = 0;
end 

endmodule 