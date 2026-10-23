
`timescale 1ns/1ps

module tb_mult_example;

    reg clk;
    reg rst_n;
    reg [3:0] a, b;
    wire [7:0] p;

    mult_array dut (
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .p(p)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("mult_example.vcd");
        $dumpvars(0, tb_mult_example);

        a = 0;
        b = 0;
        rst_n = 0;

        repeat (2) @(posedge clk);
        @(negedge clk);
        rst_n = 1;

        @(negedge clk);
        a = 4'd7;
        b = 4'd9;

        repeat (2) @(posedge clk);
        #1;

        $display("A=%0d, B=%0d, P=%0d, Expected=63",
                 a, b, p);

        if (p === 8'd63)
            $display("PASS: 7 x 9 = 63");
        else
            $display("FAIL: expected 63, got %0d", p);

        $finish;
    end

endmodule
