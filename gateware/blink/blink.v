// Verilog implementation of a blinking LED. 
// Utilises the clockDividerHertz module to divide refrence clock down to human visable speeds. 
// @output nLED: led to blink
`default_nettype none
`include "../src/clockDividerHertz.v"

module top(
    input clk,
    output nLED
);

	wire dividedClk;
		
	clockDividerHertz #(
			.FREQUENCY(15)
		) inst_clockDividerHz (
			.clk        	(clk),
			.rst        	(1'b0),
			.enable     	(1'b1),
			.dividedClk 	(dividedClk),
			.dividedPulse	()
		);

	assign nLED = dividedClk;
endmodule

