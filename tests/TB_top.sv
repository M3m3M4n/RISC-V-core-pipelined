`timescale 1ms/100us

module TB_Top (
);
    
logic clk = 1'b1;
logic rst = 1'b1;
logic [31:0] clk_count = 32'd0;
Top UUT (
    .i_clk(clk),
    .i_rst(rst)
);

always begin
    #1 clk = ~clk;
    clk_count = clk_count + 1;
    if (clk_count % 2 == 0) begin
        $display("REG DUMP FOR CYCLE %D", clk_count/2);
        $display("EXEC STAGE PC AT %H", UUT.dataPipeline.e_pc[31:0]);
        $display("FIRST HALF");
    end
    else begin
        $display("=================");
        $display("SECOND HALF");
    end
    for (int i = 0; i < 32; i = i+1) begin
        $display("R%02D: %08H", i, UUT.dataPipeline.dataDecodeStageBlock.registerFile.regs[i]);
    end
    if (clk_count % 2 != 0)
        $display("===================================");
end

initial begin
    $dumpfile(`DUMPFILENAME);
    $dumpvars(0, TB_Top);
    #5 rst = 0;
    #10 rst = 1;
    #1985
    $finish;
end

endmodule