module Top (
    input logic i_clk,
    input logic i_rst
);
    
    // Control - Data
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic       funct7_b5;
    logic [3:0] alu_flags;
    logic       en_regfile_write;
    logic [2:0] mux_immext_src;
    logic       mux_pc_adder_src;
    logic       mux_alu_src_a;
    logic       mux_alu_src_b;
    logic       en_datamem_write;
    logic [1:0] mux_final_result_src;
    logic       mux_pc_src;
    logic [3:0] alu_control;
    logic [1:0] mask_type;
    logic       ext_type;

    // Control - Hazard
    logic       m_en_regfile_write;
    logic       w_en_regfile_write;
    logic [1:0] e_mux_final_result_src;
    logic       d_mux_alu_src_a;
    logic       d_mux_alu_src_b;

    // Data - Hazard
    logic [1:0] mux_alu_forward_src_a;
    logic [1:0] mux_alu_forward_src_b;
    logic       f_stall;
    logic       fd_stall;
    logic       fd_clr;
    logic [4:0] e_rs1;
    logic [4:0] e_rs2;
    logic [4:0] m_rd;
    logic [4:0] w_rd;
    logic [4:0] d_rs1;
    logic [4:0] d_rs2;
    logic [4:0] e_rd;

    // Hazard - Both
    logic       de_clr;


    ControlPipeline controlPipeline(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_opcode(opcode),
        .i_funct3(funct3),
        .i_funct7_b5(funct7_b5),
        .i_alu_flags(alu_flags),
        .o_en_regfile_write(en_regfile_write),
        .o_mux_immext_src(mux_immext_src),
        .o_mux_pc_adder_src(mux_pc_adder_src),
        .o_mux_alu_src_a(mux_alu_src_a),
        .o_mux_alu_src_b(mux_alu_src_b),
        .o_en_datamem_write(en_datamem_write),
        .o_mux_final_result_src(mux_final_result_src),
        .o_mux_pc_src(mux_pc_src),
        .o_alu_control(alu_control),
        .o_mask_type(mask_type),
        .o_ext_type(ext_type),
        .i_de_clr(de_clr),
        .o_m_en_regfile_write(m_en_regfile_write),
        .o_w_en_regfile_write(w_en_regfile_write),
        .o_e_mux_final_result_src(e_mux_final_result_src),
        .o_d_mux_alu_src_a(d_mux_alu_src_a),
        .o_d_mux_alu_src_b(d_mux_alu_src_b)
    );

    DataPipeline dataPipeline(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_mux_pc_src(mux_pc_src),
        .i_en_regfile_write(en_regfile_write),
        .i_mux_immext_src(mux_immext_src),
        .i_mux_pc_adder_src(mux_pc_adder_src),
        .i_mux_alu_src_a(mux_alu_src_a),
        .i_mux_alu_src_b(mux_alu_src_b),
        .i_alu_control(alu_control),
        .i_mask_type(mask_type),
        .i_ext_type(ext_type),
        .i_en_datamem_write(en_datamem_write),
        .i_mux_final_result_src(mux_final_result_src),
        .o_alu_flags(alu_flags),
        .o_opcode(opcode),
        .o_funct3(funct3),
        .o_funct7_b5(funct7_b5),
        .i_mux_alu_forward_src_a(mux_alu_forward_src_a),
        .i_mux_alu_forward_src_b(mux_alu_forward_src_b),
        .i_f_en_pc(~f_stall), // en == ! stall
        .i_fd_en(~fd_stall),
        .i_fd_clr(fd_clr),
        .i_de_clr(de_clr),
        .o_e_rs1(e_rs1),
        .o_e_rs2(e_rs2),
        .o_m_rd(m_rd),
        .o_w_rd(w_rd),
        .o_d_rs1(d_rs1),
        .o_d_rs2(d_rs2),
        .o_e_rd(e_rd)
    );

    HazardBlock hazardBlock(
        .i_data_e_rs1(e_rs1),
        .i_data_e_rs2(e_rs2),
        .i_data_m_rd(m_rd),
        .i_data_w_rd(w_rd),
        .i_ctrl_m_en_regfile_write(m_en_regfile_write),
        .i_ctrl_w_en_regfile_write(w_en_regfile_write),
        .o_data_mux_alu_forward_src_a(mux_alu_forward_src_a),
        .o_data_mux_alu_forward_src_b(mux_alu_forward_src_b),
        .i_data_d_rs1(d_rs1),
        .i_data_d_rs2(d_rs2),
        .i_data_e_rd(e_rd),
        .i_ctrl_e_mux_final_result_src(e_mux_final_result_src),
        .i_ctrl_d_mux_alu_src_a(d_mux_alu_src_a),
        .i_ctrl_d_mux_alu_src_b(d_mux_alu_src_b),
        .o_data_f_stall(f_stall),
        .o_data_fd_stall(fd_stall),
        .o_de_flush(de_clr),
        .i_ctrl_e_mux_pc_src(mux_pc_src),
        .o_data_fd_flush(fd_clr) 
    );

endmodule