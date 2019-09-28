// -----------------------------------------------------------------------------
// Copyright (c) 2019 All rights reserved
// -----------------------------------------------------------------------------
// Author      : Josh Johnson <josh@joshajohnson.com>
// File        : snake.v
// Description : WIP game of snake of the LED matrix FeatherWing
// Created     : 2019-09-06 19:22:27
// Revised     : 2019-09-06 19:22:27
// Editor      : sublime text3, tab size (4)
// -----------------------------------------------------------------------------

`default_nettype none
`include "../src/debounce.v"
`include "../src/ledMatrix.v"

module top(
    input clk,
    input btn_up,
    input btn_left,
    input btn_right,
    input btn_down,
    output wire [5:0] row,
    output wire [5:0] col
);
	parameter DIM_X = 6;
	parameter DIM_Y = 6;

	wire btn_up_rising, btn_left_rising, btn_right_rising, btn_down_rising;
	
	// position state machine
	reg [2:0] pos_x = 0;
	reg [2:0] pos_y = 0;
	reg change = 1;

	// move position within bounds of display
	always @(posedge clk) begin
		if (btn_up_rising) begin
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

	reg [35:0] img;
	// generate img to be sent over
	always @(posedge clk) begin
		img = 0;
		case (5 - pos_y)
			3'd0: img [5:0] 	= 1 << (5 - pos_x);
			3'd1: img [11:6] 	= 1 << (5 - pos_x);
			3'd2: img [17:12] 	= 1 << (5 - pos_x);
			3'd3: img [23:18] 	= 1 << (5 - pos_x);
			3'd4: img [29:24] 	= 1 << (5 - pos_x);
			3'd5: img [35:30] 	= 1 << (5 - pos_x);
			default: img 		= 36'd0;
		endcase
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

