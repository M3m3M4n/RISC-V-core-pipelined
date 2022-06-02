module DataFetchStageBlock (
    input  logic        i_clk,
    input  logic        i_rst,         // Active low
    // From pc adder in exec stage
    input  logic [31:0] i_pc_ext_addr,
    // From control
    input  logic        i_mux_pc_src,
    // From hazard
    input  logic        i_f_en_pc,     // Active high
    // To decode
    output logic [31:0] o_pc_p_4,
    output logic [31:0] o_pc,
    output logic [31:0] o_instr
);

    InstrMemory instrMemory(
        .i_a(o_pc),
        .o_rd(o_instr)
    );

    assign o_pc_p_4 = o_pc + 4;

    always_ff @(posedge i_clk, negedge i_rst) begin
        if (~i_rst)
            o_pc <= 0;
        else
            if (i_f_en_pc)
                o_pc <= i_mux_pc_src ? i_pc_ext_addr : o_pc_p_4;
    end

endmodule