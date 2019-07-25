`timescale 1ns / 1ps
`default_nettype none
// Below includes are for SublimeLinter
// Ensure they are commented out before building
// `include "clockDividerHertz.v"

module top(
    input clk,
    output nLED_RED
);

	wire dividedClk;
		
	clockDividerHz #(
			.FREQUENCY(20)
		) inst_clockDividerHz (
			.clk        (clk),
			.rst        (1'b0),
			.enable     (1'b1),
			.dividedClk (dividedClk)
		);

	assign nLED_RED = dividedClk;

endmodule

