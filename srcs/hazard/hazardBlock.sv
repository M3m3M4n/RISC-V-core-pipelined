
/* Forward logic:
 *  - Basically: Move data from available registers in the pipeline to current ones in exec
 *  - The earliest forwarding is needed is in exec stage 
 *  - Data from earier stages (mem, writeback) of atmost 2 prev instr
 *  - Possible forwading path is mem -> exec, wb -> exec 
 *  - wb -> mem is not needed in RV32I since data needed in mem stage
 *    are address (calc in exec, forward already needed in exec) and data
 *    which is supplied through a dedicated register.
 *  - To check if forward is needed, check current source for alu:
 *      - If reg is used then check it with destination reg of previous 
 *        instrs, if match, reg write enable and not 0 then forward
 *      - To avoid confusion with stall conditions, compare exec stage of current instr
 *        to mem and writeback of ealier instrs (compare forward)
 *  - To foward, add data lines and muxes from later pipeline to exec alu inputs
 */

/* Stall logic:
 *  - Condition for stall is almost the same as forward, except
 *    you only need to stall after reading memory data, everything else
 *    is forwardable (for RV32I). Thus load instrs.
 *  - To check if stall is needed check write destination with upcoming instr sources
 *    (Compare backward), and target matches load instrs
 *  - To stall, stop updating pc and stop fecting from instr mem
 *    Flush exec stage
 */ 

/* Branch flush logic:
 *  - If branch (pc != pc + 4) then initiate flush on both fd and de
 */

module HazardBlock (
    // Forward
    //   From data
    input  logic [4:0] i_data_e_rs1,
    input  logic [4:0] i_data_e_rs2,
    input  logic [4:0] i_data_m_rd,
    input  logic [4:0] i_data_w_rd,
    //   From control
    input  logic       i_ctrl_m_en_regfile_write,
    input  logic       i_ctrl_w_en_regfile_write,
    input  logic [1:0] i_ctrl_m_mux_final_result_src,
    //   To data
    output logic [1:0] o_data_mux_alu_forward_src_a,
    output logic [1:0] o_data_mux_alu_forward_src_b,
    // Stall
    //   From data
    input  logic [4:0] i_data_d_rs1,
    input  logic [4:0] i_data_d_rs2,
    input  logic [4:0] i_data_e_rd,
    //   From control
    input  logic [1:0] i_ctrl_e_mux_final_result_src,
    input  logic       i_ctrl_d_mux_alu_src_a,
    input  logic       i_ctrl_d_mux_alu_src_b,
    //   To data
    output logic       o_data_f_stall,
    output logic       o_data_fd_stall,
    //   To both 
    output logic       o_de_flush,
    // Branch
    //   From control
    input  logic       i_ctrl_e_mux_pc_src,
    //   To data
    output logic       o_data_fd_flush // also o_de_flush 

);
    // Forward logic
    always_comb begin
        // Rs1 mux
        if ((i_data_e_rs1 == i_data_m_rd) & (i_data_e_rs1 != 0) & (i_ctrl_m_en_regfile_write))
            if (i_ctrl_m_mux_final_result_src == 2'b11)
                o_data_mux_alu_forward_src_a = 2'b11;
            else
                o_data_mux_alu_forward_src_a = 2'b10;
        else
        if ((i_data_e_rs1 == i_data_w_rd) & (i_data_e_rs1 != 0) & (i_ctrl_w_en_regfile_write))
            o_data_mux_alu_forward_src_a = 2'b01;
        else
            o_data_mux_alu_forward_src_a = 2'b00;

        // Rs2 mux
        if ((i_data_e_rs2 == i_data_m_rd) & (i_data_e_rs2 != 0) & (i_ctrl_m_en_regfile_write))
            o_data_mux_alu_forward_src_b = 2'b10;
        else
        if ((i_data_e_rs2 == i_data_w_rd) & (i_data_e_rs2 != 0) & (i_ctrl_w_en_regfile_write))
            o_data_mux_alu_forward_src_b = 2'b01;
        else
            o_data_mux_alu_forward_src_b = 2'b00;
    end

    logic _stall;
    // Stall detection logic
    always_comb begin
        if (i_ctrl_e_mux_final_result_src == 2'b01) begin        // match load
            if (i_data_e_rd != 0) begin // not 0
                if (i_data_e_rd == i_data_d_rs1) begin // will use
                    if (~i_ctrl_d_mux_alu_src_a) // actually used
                        _stall = 1'b1;
                    else
                        _stall = 1'b0;
                end
                else
                if (i_data_e_rd == i_data_d_rs2) begin
                    // Can't compare like this because write data line
                    // comes directly from before mux, used for cases like:
                    //      lw      a5,-20(s0)
                    //      sw      a5,-24(s0)
                    // if (~i_ctrl_d_mux_alu_src_b)  
                    //     _stall = 1'b1;
                    // else
                    //     _stall = 1'b0;
                    _stall = 1'b1;
                end
                else
                    _stall = 1'b0;
            end
            else
                _stall = 1'b0;
        end
        else 
            _stall = 1'b0;
    end

    logic _branch_flush;
    // Branch detection logic
    assign _branch_flush   = i_ctrl_e_mux_pc_src;

    // Stall and flush
    assign o_data_f_stall  = _stall;
    assign o_data_fd_stall = _stall;
    // Flush
    assign o_de_flush      = _stall | _branch_flush;
    assign o_data_fd_flush = _branch_flush;

endmodule