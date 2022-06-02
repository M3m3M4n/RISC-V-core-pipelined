module InstrMemory (
    input  logic [31:0] i_a,
    output logic [31:0] o_rd
);

    logic [31:0] RAM[63:0];

    // As this should not be synthesizable anyway...
    initial begin
        for (int i = 0; i < 64; i=i+1)
            RAM[i] = 32'h0;

        $readmemh("tests/riscvtest.txt",RAM);
    end

    assign o_rd = RAM[i_a[31:2]]; // word aligned

endmodule