module branch_comparator(DataA, DataB, BrEq, BrLT);

input [31:0] DataA, DataB;
output BrEq, BrLT;

assign BrEq = (DataA == DataB);
assign BrLT = ($signed(DataA) < $signed(DataB));

endmodule
