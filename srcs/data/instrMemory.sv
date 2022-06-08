module InstrMemory (
    input  logic [31:0] i_a,
    output logic [31:0] o_rd
);

    logic [31:0] RAM[127:0]; // 4 bytes * 128

    // As this should not be synthesizable anyway...
    initial begin
        for (int i = 0; i < 127; i = i + 1)
            RAM[i] = 32'h0;

        $readmemh("tests/test.txt",RAM);

        $display("Instr memory dump");
        for (int i = 0; i < 127; i = i + 1)
            $display("%03H: %08H", 4 * i, RAM[i]);
        $display("===================================");
    end

    assign o_rd = RAM[i_a[31:2]]; // == RAM[i_a >> 2]

endmodule