module OpcodeDecoder (
    input  logic [6:0] op,
    output logic       RegWrite,
    output logic [2:0] ImmSrc,
    output logic       PCAdderSrc,
    output logic       ALUSrcA,
    output logic       ALUSrcB,
    output logic       MemWrite,
    output logic [1:0] ResultSrc,
    output logic       Branch,
    output logic       Jump,
    output logic [1:0] ALUOp
);

    logic [13:0] controls;

    assign {RegWrite, ImmSrc, PCAdderSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, Jump, ALUOp} = controls;

    always_comb
        case(op)
            /* RegWrite_ImmSrc_PCAdderSrc_ALUSrcA_ALUSrcB_MemWrite_ResultSrc_Branch_Jump_ALUOp
             * RegWrite  : 1 bit : Enable register write to register specified with Rd
             * ImmSrc    : 3 bits: Select format for immidiate extender based on instruction format (View immidiate extender src)
             * PCAdderSrc: 1 bit : Select input for first input of PCtarget adder (0: PC, 1: Register output 1)
             * ALUSrcA   : 1 bit : Select first input of the ALU (0: Register output 1 | 1: PC) 
             * ALUSrcB   : 1 bit : Select second input of the ALU (0: Register output 2 | 1: Extended immidiate)
             * MemWrite  : 1 bit : Enable data write to data memory
             * ResultSrc : 2 bits: Select data for register file input line (00: ALU | 01: Data mem | 10: PC + 4 | 11: Extended immidiate)
             * Branch    : 1 bit : (Internal) Enable branch for branch decoder
             * Jump      : 1 bit : (Internal) Enable jump for branch decoder
             * ALUOp     : 2 bits: (Internal) Select mode for alu decoder
             */
            7'b0000011: controls = 14'b1_000_x_0_1_0_01_0_0_00; // 3   - I-type
            7'b0010011: controls = 14'b1_000_x_0_1_0_00_0_0_10; // 19  - I-type ALU
            7'b0010111: controls = 14'b1_100_x_1_1_0_00_0_0_00; // 23  - U-type PC
            7'b0100011: controls = 14'b0_001_x_0_1_1_xx_0_0_00; // 35  - S-type
            7'b0110011: controls = 14'b1_xxx_x_0_0_0_00_0_0_10; // 51  - R-type
            7'b0110111: controls = 14'b1_100_x_x_x_0_11_0_0_xx; // 55  - U-type 
            7'b1100011: controls = 14'b0_010_0_0_0_0_xx_1_0_01; // 99  - B-type
            7'b1100111: controls = 14'b1_000_1_x_x_0_10_0_1_xx; // 103 - I-type jump link
            7'b1101111: controls = 14'b1_011_0_x_x_0_10_0_1_xx; // 111 - J-type
            // Branch and jump has to be 0 else will affect fetching
            default:    controls = 14'b0_xxx_x_x_x_0_xx_0_0_xx; // non-implemented instruction
    endcase


endmodule