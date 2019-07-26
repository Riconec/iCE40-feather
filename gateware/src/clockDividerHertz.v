`default_nettype none

module clockDividerHertz #(
	parameter integer FREQUENCY = 1
	)(
	input clk,
	input rst,
	input enable,
	output reg dividedClk = 0,
	output reg dividedPulse = 0
);	

	localparam CLK_FREQ = 32'd12_000_000;
	localparam THRESHOLD = CLK_FREQ / FREQUENCY;
	
	reg [31:0] counter = 0;

	always @(posedge clk) begin
		if (rst | counter >= THRESHOLD - 1) begin
			counter <= 0;
			dividedPulse <= (1 & ~dividedClk);
		end
		else if (enable) begin
			counter <= counter + 1;
			dividedPulse <= 0;
		end
	end

	always @(posedge clk) begin
		if (rst) begin
			dividedClk <= 0;
		end
		else if (counter >= THRESHOLD - 1) begin
			dividedClk <= ~dividedClk;
		end
	end
endmodule

