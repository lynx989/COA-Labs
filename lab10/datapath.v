module datapath_top(
    input clk,
    input reset,

    input PCSel,
    input RegWEn,
    input ASel,
    input BSel,

    input [2:0] ALUSel,
    input [1:0] ImmSel,
    input [1:0] WBSel,

    output [31:0] pc,
    output [31:0] inst,
    output [31:0] alu_result,
    output [31:0] wb,

    output BrEq,
    output BrLT
);

wire [31:0] pc4;
wire [31:0] next_pc;
wire [31:0] target;

wire [31:0] DataA, DataB;
wire [31:0] Imm;

wire [31:0] ALU_A, ALU_B;

wire [31:0] DataD;

wire zero;

assign target = pc + Imm;

// Program Counter

pc_reg PC(
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .pc(pc)
);

// PC + 4

pc_adder PC_ADD(
    .pc(pc),
    .pc4(pc4)
);

// Instruction Memory

instruction_memory IMEM(
    .addr(pc),
    .instruction(inst)
);

// Register File

register_file RF(
    .clk(clk),
    .RegWEn(RegWEn),
    .AddrA(inst[19:15]),
    .AddrB(inst[24:20]),
    .AddrD(inst[11:7]),
    .DataD(wb),
    .DataA(DataA),
    .DataB(DataB)
);

// Immediate Generator

immediate_generator IMM_GEN(
    .inst(inst),
    .ImmSel(ImmSel),
    .Imm(Imm)
);

// ALU Input A MUX

mux MUX_A(
    .a(DataA),
    .b(pc),
    .sel(ASel),
    .out(ALU_A)
);

// ALU Input B MUX

mux MUX_B(
    .a(DataB),
    .b(Imm),
    .sel(BSel),
    .out(ALU_B)
);

// ALU

alu ALU(
    .a(ALU_A),
    .b(ALU_B),
    .alu_op(ALUSel),
    .result(alu_result),
    .zero(zero)
);

// Branch Comparator

branch_comparator COMP(
    .DataA(DataA),
    .DataB(DataB),
    .BrEq(BrEq),
    .BrLT(BrLT)
);

// Write Back MUX

reg [31:0] wb_temp;

assign wb = wb_temp;

always @*
begin
    case (WBSel)

        2'b00: wb_temp = alu_result;
        2'b01: wb_temp = pc4;

        default: wb_temp = 32'b0;

    endcase
end

// PC Selection MUX

mux MUX_PC(
    .a(pc4),
    .b(target),
    .sel(PCSel),
    .out(next_pc)
);

endmodule