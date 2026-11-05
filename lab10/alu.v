module alu (a, b, alu_op, result, zero);

input [31:0] a, b;
input [2:0] alu_op;
output reg [31:0] result;
output zero;

always @*
begin
    case (alu_op)

        3'b000: result = a + b;                 // add
        3'b001: result = a - b;                 // sub
        3'b010: result = a & b;                 // and
        3'b011: result = a | b;                 // or
        3'b100: result = a ^ b;                 // xor

        3'b101: begin                           // slt
            if ($signed(a) < $signed(b))
                result = 1;
            else
                result = 0;
        end

        3'b110: begin                           // sltu
            if (a < b)
                result = 1;
            else
                result = 0;
        end

        3'b111: result = a << b[4:0];           // sll

        default: result = 0;

    endcase
end

assign zero = (result == 0);

endmodule
