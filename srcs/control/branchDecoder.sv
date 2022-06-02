module BranchDecoder (
    input  logic [3:0] alu_flags, // from a - b
    input  logic [2:0] funct3,
    input  logic       branch,    // enable from B type instr
    input  logic       jump,      //             J type
    output logic       pc_src     // 0 -> pc += 4; 1 -> pc = imm 
);
    
    logic zero;
    logic neg;
    logic carry;
    logic overflow;

    logic branch_o;

    assign zero     = alu_flags[0];
    assign neg      = alu_flags[1];
    assign carry    = alu_flags[2];
    assign overflow = alu_flags[3];

    always_comb begin
        if (branch) begin
            case (funct3)
                4'b000: // be  =
                    branch_o = zero ? 1 : 0;
                4'b001: // bne !=
                    branch_o = zero ? 0 : 1;
                4'b100: // blt <
                    branch_o = (neg ^ overflow) ? 1 : 0;
                4'b101: // bge >=
                    branch_o = (neg ^ overflow) ? 0 : 1;
                4'b110: // bltu <  unsigned
                    branch_o = carry ? 0 :1;
                4'b111: // bgeu >= unsigned
                    branch_o = (carry | zero) ? 1 : 0;
                default: branch_o = 1'bx;
            endcase
        end
        else
            branch_o = 0; // not branch
    end

    assign pc_src = branch_o | jump;

endmodule