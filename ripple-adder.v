/*
    Problem:
    https://acm.sjtu.edu.cn/OnlineJudge/problem?problem_id=1250

    任务：掌握组合逻辑，完成一个加法器。
*/

module Add(
    input       [31:0]          a,
    input       [31:0]          b,
    output      [31:0]          sum
);
    parameter N = 32;
    // TODO
    wire [N:0] carries;
    wire [N-1:0] newsum;
    generate // start of generate block
        genvar i;
        // special variable that doesn’t represent any real hardware,
        // just used for evaluation purposes
        assign carries[0] = 1'b0;
        for (i=0; i<N; i=i+1) begin : blockname
            one_bit ob( .a(a[i]), .b(b[i]),
            .cin(carries[i]),
            .sum(newsum[i]),
            .cout(carries[i+1]));
        end
    endgenerate //end of generate block
    // always @(*) begin : test
    //     integer i;
    //     for (i = 0; i < 32; i = i + 1) begin
    //         sum[i] = newsum[i];
    //     end
    // end
    assign #100 sum = newsum;

endmodule
module one_bit(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = a & b | a & cin | b & cin;
endmodule