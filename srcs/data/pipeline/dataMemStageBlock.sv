module DataMemStageBlock (
    input  logic        i_clk,
    //From control
    input  logic        i_we,
    input  logic [1:0]  i_mask_type,
    input  logic        i_ext_type,
    // From exec
    input  logic [31:0] i_alu_result,
    input  logic [31:0] i_memory_data,
    // To Writeback
    output logic [31:0] o_memory_readout

);

    DataMemory dataMemory (
        .i_clk(i_clk),
        .i_we(i_we),
        .i_addr(i_alu_result),
        .i_wd(i_memory_data),
        .i_mask_type(i_mask_type),
        .i_ext_type(i_ext_type),
        .o_rd(o_memory_readout)
    );

endmodule