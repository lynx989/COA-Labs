module control_unit(clk, reset, opcode, alu_control, write_enable, seldatasource, pc_inc, clear);

input clk;
input reset;
input [3:0] opcode;

output reg [2:0] alu_control;
output reg write_enable;
output reg seldatasource;
output reg pc_inc;
output reg clear;

parameter RESET  = 2'b00,
          FETCH  = 2'b01,
          DECODE = 2'b10,
          EXECUTE = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;


always @(*) begin


    alu_control = 3'b000;
    write_enable = 0;
    seldatasource = 0;
    pc_inc = 0;
    clear = 0;

    case (current_state)

        RESET: begin
            clear = 1;
        end

        FETCH: begin
            clear = 0;
            pc_inc = 0;
            write_enable = 0;
        end

        DECODE: begin
            alu_control = opcode[2:0];
        end

        EXECUTE: begin
            write_enable = 1;
            seldatasource = 0;
            pc_inc = 1;
        end

        default: begin
        end

    endcase

end


always @(*) begin

    case (current_state)

        RESET:   next_state = FETCH;
        FETCH:   next_state = DECODE;
        DECODE:  next_state = EXECUTE;
        EXECUTE: next_state = FETCH;

        default: next_state = RESET;

    endcase

end


always @(posedge clk or posedge reset) begin

    if (reset)
        current_state <= RESET;

    else
        current_state <= next_state;

end

endmodule




module testbench();

reg clk, reset;
reg [3:0] opcode;

wire [2:0] alu_control;
wire write_enable, seldatasource, pc_inc, clear;

control_unit uut(clk, reset, opcode, alu_control,
                 write_enable, seldatasource, pc_inc, clear);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    opcode = 4'b0010;

    #10 reset = 0;
    #80;
end

initial begin
    $monitor("Time=%0t | ALU=%b | Write=%b | PC_Inc=%b | Clear=%b",
             $time, alu_control, write_enable, pc_inc, clear);
end

endmodule

