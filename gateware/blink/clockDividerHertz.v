`timescale 1ns / 1ps
`default_nettype none

module clockDividerHz #(
	parameter integer FREQUENCY = 1
	)(
	input clk,
	input rst,
	input enable,
	output reg dividedClk = 0	
);	

	localparam CLK_FREQ = 32'd12_000_000;
	localparam THRESHOLD = CLK_FREQ / FREQUENCY;
	
	reg [31:0] counter;

	always @(posedge clk) begin
		if (rst | counter >= THRESHOLD - 1) begin
			counter = 0;
		end
		else if (enable) begin
			counter = counter + 1;
		end
	end

	always @(posedge clk) begin
		if (rst) begin
			dividedClk = 0;
		end
		else if (counter >= THRESHOLD - 1) begin
			dividedClk = ~dividedClk;
		end
	end
endmodule

