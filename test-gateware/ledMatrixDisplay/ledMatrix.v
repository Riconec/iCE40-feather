// Example code to drive LED FeatherWing
// @input [35:0] img: 6x6 image to be displayed, mapping as below
// 0  1  2  3  4  5
// 6  7  8  9  10 11
// 12 13 14 15 16 17
// 18 19 20 21 22 23
// 24 25 26 27 28 29
// 30 31 32 33 34 35
// @output row, col: row and col of LED matrix, col is active low

`default_nettype none
`include "../src/clkDivHz.v"

module top(
    input clk,
    input [35:0] img,
    output [5:0] row,
    output [5:0] col
);
	wire dividedPulse;
	parameter DIM_X = 6;
	parameter DIM_Y = 6;
	reg [2:0] rowCnt = 0;
	reg [5:0] colOut = 0;

	always @(posedge clk) begin
		if (dividedPulse) begin
			if (rowCnt < DIM_Y - 1) begin
				rowCnt <=  rowCnt + 1;
			end else begin
				rowCnt <= 0;
			end
		end 
	end

	always @(*) begin
		case (rowCnt)
			3'd0: colOut = img [5:0];
			3'd1: colOut = img [11:6];
			3'd2: colOut = img [17:12];
			3'd3: colOut = img [23:18];
			3'd4: colOut = img [29:24];
			3'd5: colOut = img [35:30];
		endcase
	end

	assign row = rowCnt;
	assign col = ~colOut;
		
	clkDivHz #(
			.FREQUENCY(3600)
		) inst_clockDividerHz (
			.clk        	(clk),
			.rst        	(1'b0),
			.enable     	(1'b1),
			.dividedClk 	(),
			.dividedPulse	(dividedPulse)
		);

endmodule

