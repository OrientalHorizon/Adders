module multiplier(
    input signed [15:0] a,
    input signed [15:0] b,
    output reg signed [31:0] answer
);
    reg [31:0] sign_ext_a;
    reg signed [31:0] neg_a;
    reg signed [15:-1] new_b;

    reg [31:0] temp;

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
            answer = answer + temp;
        end
    end
endmodule
