module DataMemory (
    input  logic        i_clk,
    input  logic        i_we,
    input  logic [31:0] i_addr, i_wd,
    input  logic [1:0]  i_mask_type, // 00: byte, 01: halfword, 10: word
    input  logic        i_ext_type,  // 0: signed extension, 1: zero extension
    output logic [31:0] o_rd
);

    logic [31:0] RAM[63:0]; // 2K

    // As this should not be synthesizable anyway...
    initial begin
        for (int i = 0; i < 64; i=i+1)
            RAM[i] = 32'h0;
    end

    always_comb begin // mask output
        case(i_mask_type)
            2'b00:
                o_rd = i_ext_type ? {24'b0, RAM[i_addr][7:0]} : {{24{RAM[i_addr][7]}}, RAM[i_addr][7:0]};
            2'b01:
                o_rd = i_ext_type ? {16'b0, RAM[i_addr[31:1]][15:0]} : {{16{RAM[i_addr[31:1]][15]}}, RAM[i_addr[31:1]][15:0]};
            // 2'b10: // is default 
            default:  // full word read, no sign change
                o_rd = RAM[i_addr[31:2]]; // word aligned
        endcase
    end

    logic [31:0] _wd;

    always_comb begin // mask input
        case(i_mask_type)
            2'b00:
                _wd = i_ext_type ? {24'b0, i_wd[7:0]} : {{24{i_wd[7]}}, i_wd[7:0]};
            2'b01:
                _wd = i_ext_type ? {16'b0, i_wd[15:0]} : {{16{i_wd[15]}}, i_wd[15:0]};
            // 2'b10: // is default 
            default:  // full word read, no sign change
                _wd = i_wd; // word aligned
        endcase
    end

    always_ff @(posedge i_clk)
        if (i_we) RAM[i_addr[31:2]] <= _wd;

endmodule