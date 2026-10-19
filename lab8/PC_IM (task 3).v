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
	if (addr < 4)
		instruction = memory[addr];
	else 
		instruction = 8'b00000000;
end

endmodule

module testbench();

reg clk;
reg reset;

wire [31:0] pc_out;
wire [7:0] instruction;
wire [3:0] tempaddr;

assign tempaddr = pc_out[3:0];

program_counter pc(.clk(clk), .reset(reset), .pc_out(pc_out));

instruction_memory im(.addr(tempaddr), .instruction(instruction));

always begin
	#5 clk = ~clk;
end

initial begin 
	clk = 0;
	reset = 1;
	#10 reset  = 0;
end

endmodule 		
