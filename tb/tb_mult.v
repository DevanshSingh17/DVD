`timescale 1ns/1ps

module tb_mult;

    reg clk;
    reg rst_n;
    reg [3:0] a, b;
    wire [7:0] p;

    integer i, j, errors;
    reg [7:0] expected;

    mult_array dut (
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .p(p)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("mult.vcd");
        $dumpvars(0, tb_mult);

        a = 0;
        b = 0;
        rst_n = 0;
        errors = 0;

        repeat (2) @(posedge clk);
        @(negedge clk);
        rst_n = 1;

        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                @(negedge clk);
                a = i;
                b = j;
                expected = i * j;

                repeat (2) @(posedge clk);
                #1;

                if (p !== expected) begin
                    $display(
                        "Mismatch: a=%0d b=%0d p=%0d expected=%0d",
                        i, j, p, expected
                    );
                    errors = errors + 1;
                end
            end
        end

        if (errors == 0)
            $display("PASS: 256 vectors checked, 0 errors");
        else
            $display("FAIL: 256 vectors checked, %0d errors", errors);

        $finish;
    end

endmodule
