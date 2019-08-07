`default_nettype none
`include "../src/clockDividerHertz.v"
`include "nibbleDecode.v"
`include "displaySelect.v"

module top(
    input clk,
    input [7:0] sw,
    input switch,
    output reg [6:0] seg,
    output reg [1:0] com
);

	// params / wires
	localparam COM_ANODE = 1;
	wire dividedClk;
	wire [6:0] disp0, disp1;
	wire [3:0] nibbleMS, nibbleLS;

	// mux displays together
	always @(posedge clk) begin
		case (dividedClk)
			0:begin
				seg<=disp1;
				com <= 2'b01;
				end
			1:begin
				seg<=disp0;
				com <= 2'b10;
				end
		endcase
	end

	// choose what number to show on display
	displaySelect inst_displaySelect (
		.clk 		(clk), 
		.sw 		(sw), 
		.switch 	(switch), 
		.nibbleMS 	(nibbleMS), 
		.nibbleLS 	(nibbleLS)
	);

	// decodes nibble to 7 segment display
	nibbleDecode #(
			.COM_ANODE 	(COM_ANODE)
		) nibbleDecodeMSD (
			.clk 		(clk), 
		 	.nibblein 	(nibbleMS), 
			.segout 	(disp1)
	);
	
	nibbleDecode #(
			.COM_ANODE 	(COM_ANODE)
		) nibbleDecodeLSD (
			.clk 		(clk), 
		 	.nibblein 	(nibbleLS), 
			.segout 	(disp0)
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

endmodule

