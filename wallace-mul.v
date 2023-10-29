module multiplier(
    input signed [15:0] a,
    input signed [15:0] b,
    output reg signed [31:0] answer
);
    reg [31:0] sign_ext_a;
    reg signed [31:0] neg_a;
    reg signed [15:-1] new_b;

    reg [31:0] temp, t[8];
    reg [31:0] C[6];
    wire [31:0] wall[12];

    FullAdder add1(t[0], t[1], t[2], wall[0], wall[1]);
    FullAdder add2(t[3], t[4], t[5], wall[2], wall[3]);

    FullAdder add3(wall[0], wall[1], wall[2], wall[4], wall[5]);
    FullAdder add4(wall[3], t[6], t[7], wall[6], wall[7]);

    // wall 4, 5, 6, 7 -> wall 8, 9, 7
    FullAdder add5(wall[4], wall[5], wall[6], wall[8], wall[9]);

    FullAdder add6(wall[8], wall[9], wall[7], wall[10], wall[11]);

    integer i;
    integer j;
    always @(*) begin
        if (a[15] == 1'b0) begin
            sign_ext_a = {16'b0, a};
        end else begin
            sign_ext_a = {16'b1, a};
        end
        neg_a = ~a + 1;

        new_b = {b, 1'b0};
        // $display("neg_a = %d", neg_a);
        answer = 0;

        for (i = 0; i < 16; i = i + 2) begin
            if (new_b[(i + 1) -: 3] == 3'b000) begin
                temp = 0;
            end
            else if (new_b[(i + 1) -: 3] == 3'b001) begin
                temp = (a << i);
            end
            else if (new_b[(i + 1) -: 3] == 3'b010) begin
                temp = (a << i);
            end
            else if (new_b[(i + 1) -: 3] == 3'b011) begin
                temp = (a << (i + 1));
            end
            else if (new_b[(i + 1) -: 3] == 3'b100) begin
                temp = (neg_a << (i + 1));
            end
            else if (new_b[(i + 1) -: 3] == 3'b101) begin
                temp = (neg_a << i);
            end
            else if (new_b[(i + 1) -: 3] == 3'b110) begin
                temp = (neg_a << i);
            end
            else if (new_b[(i + 1) -: 3] == 3'b111) begin
                temp = 0;
            end

            // $display("temp = %d", temp);

            // for (j = 0; j < 32; j = j + 1) begin
            //     if (j < 15 + i) begin
            //         temp2[j] = temp[j];
            //     end else begin
            //         temp2[j] = temp[j];
            //     end
            // end
            // answer = answer + temp;

            t[i / 2] = temp;
            answer = wall[10] + wall[11];
        end

        // Wallis tree for addition
    end

endmodule

module FullAdder(
    input [31:0] a,
    input [31:0] b,
    input [31:0] cin,
    output [31:0] sum,
    output [31:0] cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b | a & cin | b & cin) << 1;
endmodule