`timescale 1ns / 1ps
`default_nettype none

module clockDivider #(
	parameter integer THRESHOLD = 12_000
	)(
	input clk,
	input rst,
	input enable,
	output reg dividedClk = 0	
);	

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