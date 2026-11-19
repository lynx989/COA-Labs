module control_unit_rv32(
    inst, br_eq, br_lt,
    PCSel, ImmSel, RegWEn, BrUn,
    BSel, ASel, ALUSel, MemRW, WBSel
);

input [31:0] inst;
input br_eq, br_lt;

output reg PCSel;
output reg [2:0] ImmSel;
output reg RegWEn;
output reg BrUn;
output reg BSel;
output reg ASel;
output reg [3:0] ALUSel;
output reg MemRW;
output reg [1:0] WBSel;

always @(*) begin

    PCSel = 0;
    ImmSel = 3'b000;
    RegWEn = 0;
    BrUn = 0;
    BSel = 0;
    ASel = 0;
    ALUSel = 4'b0000;
    MemRW = 0;
    WBSel = 2'b01;

    case (inst[6:0])

        // r-type instructions
        7'b0110011: begin
            RegWEn = 1;
            WBSel = 2'b01;

            case (inst[14:12])
                3'b000: begin
                    if (inst[30] == 1)
                        ALUSel = 4'b0001;
                    else
                        ALUSel = 4'b0000;
                end

                3'b001: ALUSel = 4'b0101;
                3'b010: ALUSel = 4'b1000;
                3'b011: ALUSel = 4'b1001;
                3'b100: ALUSel = 4'b0100;

                3'b101: begin
                    if (inst[30] == 1)
                        ALUSel = 4'b0111;
                    else
                        ALUSel = 4'b0110;
                end

                3'b110: ALUSel = 4'b0011;
                3'b111: ALUSel = 4'b0010;
            endcase
        end

        // i-type alu instructions
        7'b0010011: begin
            RegWEn = 1;
            BSel = 1;
            WBSel = 2'b01;

            case (inst[14:12])
                3'b000: ALUSel = 4'b0000;
                3'b001: ALUSel = 4'b0101;
                3'b010: ALUSel = 4'b1000;
                3'b011: ALUSel = 4'b1001;
                3'b100: ALUSel = 4'b0100;

                3'b101: begin
                    if (inst[30] == 1)
                        ALUSel = 4'b0111;
                    else
                        ALUSel = 4'b0110;
                end

                3'b110: ALUSel = 4'b0011;
                3'b111: ALUSel = 4'b0010;
            endcase
        end

        // load
        7'b0000011: begin
            ImmSel = 3'b000;
            RegWEn = 1;
            BSel = 1;
            ALUSel = 4'b0000;
            WBSel = 2'b00;
        end

        // store
        7'b0100011: begin
            ImmSel = 3'b001;
            BSel = 1;
            ALUSel = 4'b0000;
            MemRW = 1;
        end

        // branch
        7'b1100011: begin
            ImmSel = 3'b010;
            ALUSel = 4'b0001;

            case (inst[14:12])
                3'b000: PCSel = br_eq;
                3'b001: PCSel = !br_eq;
                3'b100: PCSel = br_lt;
                3'b101: PCSel = !br_lt;

                3'b110: begin
                    BrUn = 1;
                    PCSel = br_lt;
                end

                3'b111: begin
                    BrUn = 1;
                    PCSel = !br_lt;
                end
            endcase
        end

        // jal
        7'b1101111: begin
            ImmSel = 3'b100;
            RegWEn = 1;
            PCSel = 1;
            ASel = 1;
            BSel = 1;
            ALUSel = 4'b0000;
            WBSel = 2'b10;
        end

        // jalr
        7'b1100111: begin
            ImmSel = 3'b000;
            RegWEn = 1;
            PCSel = 1;
            BSel = 1;
            ALUSel = 4'b0000;
            WBSel = 2'b10;
        end

        // lui
        7'b0110111: begin
            ImmSel = 3'b011;
            RegWEn = 1;
            BSel = 1;
            ALUSel = 4'b1010;
            WBSel = 2'b01;
        end

        // auipc
        7'b0010111: begin
            ImmSel = 3'b011;
            RegWEn = 1;
            ASel = 1;
            BSel = 1;
            ALUSel = 4'b0000;
            WBSel = 2'b01;
        end

        default: begin
        end

    endcase
end

endmodule

module testbench();

reg [31:0] inst;
reg br_eq, br_lt;

wire PCSel;
wire [2:0] ImmSel;
wire RegWEn;
wire BrUn;
wire BSel;
wire ASel;
wire [3:0] ALUSel;
wire MemRW;
wire [1:0] WBSel;

control_unit_rv32 uut(
    inst, br_eq, br_lt,
    PCSel, ImmSel, RegWEn, BrUn,
    BSel, ASel, ALUSel, MemRW, WBSel
);

initial begin

    br_eq = 0;
    br_lt = 0;

    // r-type add
    inst = 32'h003100B3;
    #10;

    // r-type sub
    inst = 32'h403100B3;
    #10;

    // i-type addi
    inst = 32'h00510093;
    #10;

    // load
    inst = 32'h00812083;
    #10;

    // store
    inst = 32'h00112423;
    #10;

    // branch beq
    inst = 32'h00208463;
    br_eq = 1;
    #10;

    // branch bne
    inst = 32'h00209463;
    br_eq = 0;
    #10;

    // branch blt
    inst = 32'h0020C463;
    br_lt = 1;
    #10;

    // branch bltu
    inst = 32'h0020E463;
    br_lt = 1;
    #10;

    // jal
    inst = 32'h008000EF;
    #10;

    // jalr
    inst = 32'h008100E7;
    #10;

    // lui
    inst = 32'h123450B7;
    #10;

    // auipc
    inst = 32'h12345097;
    #10;

end

initial begin
    $monitor("Time=%0t | Instruction=%h | PCSel=%b | ImmSel=%b | RegWEn=%b | BrUn=%b | BSel=%b | ASel=%b | ALUSel=%b | MemRW=%b | WBSel=%b",
    $time, inst, PCSel, ImmSel, RegWEn, BrUn, BSel, ASel, ALUSel, MemRW, WBSel);
end

endmodule
