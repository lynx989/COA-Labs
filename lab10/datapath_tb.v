module datapath_tb();

reg clk, reset;
reg PCSel, RegWEn, ASel, BSel;
reg [2:0] ALUSel;
reg [1:0] ImmSel, WBSel;

wire [31:0] pc, inst, alu_result, wb;
wire BrEq, BrLT;

datapath_top dut(
    .clk(clk), .reset(reset),
    .PCSel(PCSel), .RegWEn(RegWEn),
    .ASel(ASel), .BSel(BSel),
    .ALUSel(ALUSel), .ImmSel(ImmSel),
    .WBSel(WBSel),
    .pc(pc), .inst(inst),
    .alu_result(alu_result), .wb(wb),
    .BrEq(BrEq), .BrLT(BrLT)
);

always begin
    #5 clk = ~clk;
end

initial begin
    clk = 0;
    reset = 1;

    PCSel = 0;
    RegWEn = 0;
    ASel = 0;
    BSel = 0;
    ALUSel = 0;
    ImmSel = 0;
    WBSel = 0;

    // loading instructions
    #1;
    dut.IMEM.memory[0] = 32'h00700293;
    dut.IMEM.memory[1] = 32'h00500313;
    dut.IMEM.memory[2] = 32'h006283B3;
    dut.IMEM.memory[3] = 32'h40628433;
    dut.IMEM.memory[4] = 32'h00038063;
    dut.IMEM.memory[5] = 32'h008384B3;

    // release reset before first instruction
    @(negedge clk);
    reset = 0;

    // ADDI x5, x0, 7
    RegWEn = 1;
    ASel = 0;
    BSel = 1;
    ALUSel = 3'b000;
    ImmSel = 2'b00;
    WBSel = 2'b00;
    PCSel = 0;

    @(posedge clk);
    #1;

    // ADDI x6, x0, 5
    @(negedge clk);
    RegWEn = 1;
    ASel = 0;
    BSel = 1;
    ALUSel = 3'b000;
    ImmSel = 2'b00;
    WBSel = 2'b00;
    PCSel = 0;

    @(posedge clk);
    #1;

    // ADD x7, x5, x6
    @(negedge clk);
    RegWEn = 1;
    ASel = 0;
    BSel = 0;
    ALUSel = 3'b000;
    WBSel = 2'b00;
    PCSel = 0;

    @(posedge clk);
    #1;

    // SUB x8, x5, x6
    @(negedge clk);
    RegWEn = 1;
    ASel = 0;
    BSel = 0;
    ALUSel = 3'b001;
    WBSel = 2'b00;
    PCSel = 0;

    @(posedge clk);
    #1;

    // BEQ x7, x0, label
    @(negedge clk);
    RegWEn = 0;
    ASel = 0;
    BSel = 0;
    ImmSel = 2'b10;
    PCSel = 0;

    @(posedge clk);
    #1;

    // ADD x9, x7, x8
    @(negedge clk);
    RegWEn = 1;
    ASel = 0;
    BSel = 0;
    ALUSel = 3'b000;
    WBSel = 2'b00;
    PCSel = 0;

    @(posedge clk);
    #1;

    // displaying values
    $display("x5 = %d", dut.RF.registers[5]);
    $display("x6 = %d", dut.RF.registers[6]);
    $display("x7 = %d", dut.RF.registers[7]);
    $display("x8 = %d", dut.RF.registers[8]);
    $display("x9 = %d", dut.RF.registers[9]);

    $display("Final PC = %d", pc);

    
end

endmodule
