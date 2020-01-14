module bootram(
    input clk, wen, ren, 
    output [31:0] rdata
    );

    ram ram_inst1(clk,wen,ren,8'd0,8'd255,32'd0, rdata);
    
endmodule

module ram (
        input clk, wen, ren, 
        input [7:0] waddr, raddr,
        input [31:0] wdata,
        output reg [31:0] rdata
);
        reg [31:0] mem [0:255];
        always @(posedge clk) begin
                if (wen)
                        mem[waddr] <= wdata;
                if (ren)
                        rdata <= mem[raddr];
        end
endmodule