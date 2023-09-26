module Add (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] sum
);

    wire [31:0] sum1;
    wire [2:0] g;
    wire [2:0] p;
    Add16 add16_1 (a[15:0], b[15:0], 1'b0, sum1[15:0], g[0], p[0]);
    wire carry = g[0]; // cin = 0
    wire [31:16] res[2];
    Add16 add16_2 (a[31:16], b[31:16], 1'b0, res[0][31:16], g[1], p[1]);
    Add16 add16_3 (a[31:16], b[31:16], 1'b1, res[1][31:16], g[2], p[2]);
    assign sum1[31:16] = res[carry];
    always @(*) begin
        sum <= sum1;
    end

endmodule

module Add1 (
    input a,
    input b,
    input cin,
    output sum,
    output g,
    output p
);
    
    assign sum = a ^ b ^ cin;
    assign g = a & b;
    assign p = a | b;

endmodule

module Lookahead4 (
    input [3:0] g,
    input [3:0] p,
    input cin,
    output [4:1] cout,
    output gm,
    output pm
);

    assign cout[1] = g[0] | p[0] & cin;
    assign cout[2] = g[1] | p[1] & g[0] | p[1] & p[0] & cin;
    assign cout[3] = g[2] | p[2] & g[1] | p[2] & p[1] & g[0] | p[2] & p[1] & p[0] & cin;
    assign cout[4] = g[3] | p[3] & g[2] | p[3] & p[2] & g[1] | p[3] & p[2] & p[1] & g[0] | p[3] & p[2] & p[1] & p[0] & cin;
    assign gm      = g[3] | p[3] & g[2] | p[3] & p[2] & g[1] | p[3] & p[2] & p[1] & g[0];
    assign pm      = p[3] & p[2] & p[1] & p[0];

endmodule

module Add4 (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output gm,
    output pm
);

    wire [4:1] carry;
    wire [3:0] g;
    wire [3:0] p;

    Lookahead4 la4 (g, p, cin, carry, gm, pm);

    Add1 add1_1 (a[0], b[0], cin, sum[0], g[0], p[0]);
    Add1 add1_2 (a[1], b[1], carry[1], sum[1], g[1], p[1]);
    Add1 add1_3 (a[2], b[2], carry[2], sum[2], g[2], p[2]);
    Add1 add1_4 (a[3], b[3], carry[3], sum[3], g[3], p[3]);

endmodule

module Add16 (
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output gm,
    output pm
);

    wire [4:1] carry;
    wire [3:0] g;
    wire [3:0] p;

    Lookahead4 la4 (g, p, cin, carry, gm, pm);

    Add4 add4_1 (a[15:12], b[15:12], carry[3], sum[15:12], g[3], p[3]);
    Add4 add4_2 (a[11:8], b[11:8], carry[2], sum[11:8], g[2], p[2]);
    Add4 add4_3 (a[7:4], b[7:4], carry[1], sum[7:4], g[1], p[1]);
    Add4 add4_4 (a[3:0], b[3:0], cin, sum[3:0], g[0], p[0]);

endmodule