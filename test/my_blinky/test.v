module test (
    input clk,
    input i_rst_n,

    output ledr_n,
    output ledg_n,
    output ledb_n,
    output led_user
);
    parameter  CLK_DIV = 32'd6000000; // Address size

    reg [31:0] r_clk_div;

    always @(posedge clk, negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_clk_div <= 32'd0;
        end else begin
            if (r_clk_div == CLK_DIV) begin
                r_clk_div <= 32'd0;
            end else begin
                r_clk_div <= r_clk_div + 1'b1;
            end
        end
    end

    assign count_clk_en = r_clk_div == CLK_DIV;


    reg [3:0] leds;

    always @(posedge clk, negedge i_rst_n) begin
        if (!i_rst_n) begin
            leds <= 4'd1;
        end else begin
            if (count_clk_en) begin
                leds <= {leds[2:0], leds[3]};
            end else begin
                //  nothing in this case?
            end
        end
    end

    assign ledr_n = !leds[3];
    assign ledg_n = !leds[2];
    assign ledb_n = !leds[1];
    assign led_user = !leds[0];

endmodule