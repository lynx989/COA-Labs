module onescompliment(a, b, c, d, nota, notb, notc, notd);

 input a;
 input b;
 input c;
 input d;

 output nota;
 output notb;
 output notc;
 output notd;

 assign nota = ~a;
 assign notb = ~b;
 assign notc = ~c;
 assign notd = ~d;

endmodule



module testbench(); // dont pass any parameter in test bench
 reg a;
 reg b;
 reg c;
 reg d;

 wire nota;
 wire notb;
 wire notc;
 wire notd;

 onescompliment uut (a, b, c, d, nota, notb, notc, notd);

 initial 
 begin 
 a = 0; b = 0; c = 0; d = 0;
 #50 a = 1; b = 0; c = 0; d = 0;
 #50 a = 1; b = 1; c = 0; d = 0;
 #50 a = 1; b = 1; c = 1; d = 0;
 #50 a = 1; b = 1; c = 1; d = 1;
 end

endmodule

