// Example code for LED FeatherWing
// WIP to play a basic version of snake
// @input btn_xxx: four buttons on FeatherWing
// @output row, col: row and col of LED matrix

`default_nettype none
`include "../src/debounce.v"
`include "../src/ledMatrix.v"
`include "../src/clockDividerHertz.v"

module top(
    input clk,
    input btn_up,
    input btn_left,
    input btn_right,
    input btn_down,
    output [5:0] row,
    output [5:0] col
);
	wire btn_up_rising, btn_left_rising, btn_right_rising, btn_down_rising;
	// position state machine
	// (0,0) is in top left corner
	parameter DIM_X = 6;
	parameter DIM_Y = 6;
	reg [2:0] pos_x = 0;
	reg [2:0] pos_y = 0;
	reg [35:0] img;
	reg change = 1;

	// move position within bounds of display
	always @(posedge clk) begin
		if (btn_up_rising) begin
			if (pos_y > 0) begin
				pos_y <= pos_y - 1;
				change <= 1;
			end 
		end else if (btn_left_rising) begin
			if (pos_x > 0) begin
				pos_x <= pos_x - 1;
				change <= 1;
			end 
		end else if (btn_right_rising) begin
			if (pos_x < DIM_X - 1) begin
				pos_x <= pos_x + 1;
				change <= 1;
			end 
		end else if (btn_down_rising) begin
			if (pos_y < DIM_Y - 1) begin
				pos_y <= pos_y + 1;
				change <= 1;
			end 
		end 
	end

	// generate img to be sent over
	always @(posedge clk) begin
		if (change) begin
			img = 0;
			case (pos_y)
				3'd0: img [5:0] 	= 1 << DIM_X - 1 - pos_x;
				3'd1: img [11:6] 	= 1 << DIM_X - 1 - pos_x;
				3'd2: img [17:12] 	= 1 << DIM_X - 1 - pos_x;
				3'd3: img [23:18] 	= 1 << DIM_X - 1 - pos_x;
				3'd4: img [29:24] 	= 1 << DIM_X - 1 - pos_x;
				3'd5: img [35:30] 	= 1 << DIM_X - 1 - pos_x;
				default: img 		= 0;
			endcase
		end
	end

	// led matrix
	ledMatrix inst_ledMatrix (
		.clk	(clk), 
		.img	(img), 
		.row 	(row), 
		.col 	(col)
	);

	// debonce buttons
	debounce debounce_up
	(
		.clk            (clk),
		.button         (btn_up),
		.button_db      (),
		.button_rising  (btn_up_rising),
		.button_falling ()
	);

	debounce debounce_left
	(
		.clk            (clk),
		.button         (btn_left),
		.button_db      (),
		.button_rising  (btn_left_rising),
		.button_falling ()
	);

	debounce debounce_right
	(
		.clk            (clk),
		.button         (btn_right),
		.button_db      (),
		.button_rising  (btn_right_rising),
		.button_falling ()
	);

	debounce debounce_down
	(
		.clk            (clk),
		.button         (btn_down),
		.button_db      (),
		.button_rising  (btn_down_rising),
		.button_falling ()
	);

endmodule

