`default_nettype none
`include "../src/clockDividerHertz.v"
`include "nibble_decode.v"

module top(
    input clk,
    input [7:0] sw,
    output reg [6:0] seg,
    output reg [1:0] com,
    output UART_RX,
    output UART_TX
);

	localparam comAnode = 1;
	wire dividedClk;
	wire [6:0] disp0, disp1;

	// mux displays
	always @(posedge clk) begin
		case (dividedClk)
			0:begin
				seg<=disp1;
				com = 2'b01;
				end
			1:begin
				seg<=disp0;
				com = 2'b10;
				end
		endcase
	end

	// decode upper nibble
	nibble_decode nibble_decode_right (
		.clk(clk), 
		.nibblein(sw[3:0]), 
		.comAnode(comAnode[0]),
		.segout(disp0)
	);

	// decode lower nibble
	nibble_decode nibble_decode_left (
		.clk(clk), 
		.nibblein(sw[7:4]), 
		.comAnode(comAnode[0]),
		.segout(disp1)
	);

	// generate clock for switching displays
	clockDividerHertz #(
			.FREQUENCY(100)
		) inst_clockDividerHertz (
			.clk        	(clk),
			.rst        	(1'b0),
			.enable     	(1'b1),
			.dividedClk 	(dividedClk),
			.dividedPulse	()
	);

	// keep UART LEDs off
	assign UART_RX = 0;
	assign UART_TX = 0;

endmodule

