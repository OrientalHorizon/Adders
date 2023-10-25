module multiplier(
    input signed [15:0] a,
    input signed [15:0] b,
    output reg signed [31:0] answer
);
    reg [31:0] sign_ext_a;
    reg signed [31:0] neg_a;
    reg signed [15:-1] new_b;

    reg [31:0] temp, temp2;

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
            answer = answer + temp;
        end
    end
endmodule

module signextend(
    input [31:0] a,
    input [4:0] highest,
    output reg [31:0] res
);
    integer i;
    always @(*) begin
        for (i = 0; i < 32; i = i + 1) begin
            if (i < highest) begin
                res[i] = a[i];
            end else begin
                res[i] = a[highest];
            end
        end
    end

endmodule