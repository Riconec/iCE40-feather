`default_nettype none
`include "../src/clockDividerHertz.v"

module top(
    input clk,
    output nLED_RED,
    output UART_RX,
    output UART_TX
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

	assign nLED_RED = dividedClk;

	// Keep UART LEDs off
	assign UART_RX = 0;
	assign UART_TX = 0;

endmodule

