module program_counter(clk, reset, addr, pc_out);

input clk;
input reset;
input [3:0] addr;
output reg [3:0] pc_out;

always @ (posedge clk or posedge reset) begin
if (reset)	
	pc_out <= 4'b0000;
else
	pc_out <= addr;
end 
endmodule 

module instruction_memory(addr, instruction);

input [3:0] addr;
output reg [7:0] instruction;

reg [7:0] memory [0:15];

initial begin 
	memory[0] = 8'b00000001;
	memory[1] = 8'b00000010;
	memory[2] = 8'b00000011;
	memory[3] = 8'b00000100;
end

always @ (addr) begin
	instruction = memory[addr];
end
endmodule 

module testbench();

reg clk;
reg reset;
reg [3:0] addr;
wire [3:0] pc_out;
wire [7:0] instruction;

program_counter pc(.clk(clk), .reset(reset), .addr(addr), .pc_out(pc_out));

instruction_memory im(.addr(pc_out), .instruction(instruction));

always begin
#5 clk = ~clk;
end

initial begin 
clk = 0;
reset = 0;
addr = 0;

reset = 1;
#10 reset = 0;

#10 addr = 1;
#10 addr = 2;
#10 addr = 3;
#10 addr = 0;

end

endmodule 
