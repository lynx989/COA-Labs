module immediate_generator(inst, ImmSel, Imm);

input [31:0] inst;
input [1:0] ImmSel;
output reg [31:0] Imm;

always @*
begin
    case (ImmSel)

        2'b00: begin                         // i-type
            Imm = {{20{inst[31]}}, inst[31:20]};
        end

        2'b01: begin                         // s-type
            Imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
        end

        2'b10: begin                         // b-type
            Imm = {{19{inst[31]}}, inst[31], inst[7],
                   inst[30:25], inst[11:8], 1'b0};
        end

        2'b11: begin                         // j-type
            Imm = {{11{inst[31]}}, inst[31], inst[19:12],
                   inst[20], inst[30:21], 1'b0};
        end

        default: Imm = 0;

    endcase
end

endmodule
