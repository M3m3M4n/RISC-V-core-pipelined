module DataMemory (
    input  logic        i_clk,
    input  logic        i_we,
    input  logic [31:0] i_addr, i_wd,
    input  logic [1:0]  i_mask_type, // 00: byte, 01: halfword, 10: word
    input  logic        i_ext_type,  // 0: signed extension, 1: zero extension
    output logic [31:0] o_rd
);

    logic [31:0] i_addr_p1, i_addr_p2, i_addr_p3;
    assign i_addr_p1 = i_addr + 1;
    assign i_addr_p2 = i_addr_p1 + 1;
    assign i_addr_p3 = i_addr_p2 + 1;

    logic [7:0] RAM[2047:0]; // 2K bytes, individually accessible

    // As this should not be synthesizable anyway...
    initial begin
        for (int i = 0; i < 2048; i = i + 1)
            RAM[i] = 8'h0;
    end

    always_comb begin // mask output
        case(i_mask_type)
            2'b00:
                o_rd = i_ext_type ? {24'b0, RAM[i_addr]} : {{24{RAM[i_addr][7]}}, RAM[i_addr]};
            2'b01:
                // o_rd = i_ext_type ? {16'b0, RAM[i_addr_p1:i_addr]} : {{16{RAM[i_addr_p1:i_addr][15]}}, RAM[i_addr_p1:i_addr]};
                // Because icarus verilog sucks
                o_rd = i_ext_type ? {16'b0, RAM[i_addr_p1], RAM[i_addr]} :
                                    {{16{RAM[i_addr_p1][7]}}, RAM[i_addr_p1], RAM[i_addr]};
            2'b10:
                // o_rd = RAM[i_addr_p3:i_addr];
                o_rd = {RAM[i_addr_p3], RAM[i_addr_p2], RAM[i_addr_p1], RAM[i_addr]};
            default:
                o_rd = 32'hx;
        endcase
    end

    always_ff @(posedge i_clk) begin
        if (i_we) begin
            case(i_mask_type)
                2'b00:
                    RAM[i_addr]    <= i_wd[7:0];
                2'b01: begin
                    // Because icarus verilog sucks
                    // RAM[i_addr_p1:i_addr] <= i_wd[15:0];
                    RAM[i_addr_p1] <= i_wd[15:8];
                    RAM[i_addr]    <= i_wd[7:0];
                end
                2'b10: begin
                    // RAM[i_addr_p3:i_addr] <= i_wd;
                    RAM[i_addr_p3] <= i_wd[31:24];
                    RAM[i_addr_p2] <= i_wd[23:16];
                    RAM[i_addr_p1] <= i_wd[15:8];
                    RAM[i_addr]    <= i_wd[7:0];
                end
                default:
                    begin /* Do nothing */ end
            endcase
        end
    end

endmodule