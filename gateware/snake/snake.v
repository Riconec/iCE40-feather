// Example code for LED FeatherWing
// WIP to play a basic version of snake
// @input btn_xxx: four buttons on FeatherWing
// @output row, col: row and col of LED matrix

`default_nettype none
`include "../src/clockDividerHertz.v"
`include "../src/debonce.v"

module top(
    input clk,
    input btn_up,
    input btn_left,
    input btn_right,
    input btn_down,
    output [5:0] row,
    output [5:0] col
);

	// position state machine
	// (0,0) is in top left corner
	`define DIM_X 6
	`define DIM_Y 6
	reg start = 1;
	reg [2:0] pos_x, pos_y;
	// reg field [5:0][5:0];

	// move position within bounds of display
	always @(posedge clk) begin
		if (start) begin
			start <= 0;
			pos_x <= 0;
			pos_y <= 0;			
		end else if (btn_up_rising) begin
			if (pos_y < DIM_Y - 1) begin
				pos_y <= pos_y + 1;
			end 
		end else if (btn_left_rising) begin
			if (pos_x > 0) begin
				pos_x <= pos_x - 1;
			end 
		end else if (btn_right_rising) begin
			if (pos_x < DIM_X - 1) begin
				pos_x <= pos_x + 1;
			end 
		end else if (btn_down_rising) begin
			if (pos_y > 0) begin
				pos_y <= pos_y - 1;
			end 
		end 
	end

	// debonce buttons
	debounce debounce_up
	(
		.clk            (clk),
		.button         (btn_up),
		.button_db      (btn_up_db),
		.button_rising  (btn_up_rising),
		.button_falling (btn_up_falling)
	);

	debounce debounce_left
	(
		.clk            (clk),
		.button         (btn_left),
		.button_db      (btn_left_db),
		.button_rising  (btn_left_rising),
		.button_falling (btn_left_falling)
	);

	debounce debounce_right
	(
		.clk            (clk),
		.button         (btn_right),
		.button_db      (btn_right_db),
		.button_rising  (btn_right_rising),
		.button_falling (btn_right_falling)
	);

	debounce debounce_down
	(
		.clk            (clk),
		.button         (btn_down),
		.button_db      (btn_down_db),
		.button_rising  (btn_down_rising),
		.button_falling (btn_down_falling)
	);

endmodule

