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
    output wire nLED_RED_fw,
    output wire [5:0] row,
    output wire [5:0] col
);
	// Size of matrix
	parameter DIM_X = 6;
	parameter DIM_Y = 6;

	// Wires and regs are here
	wire btn_up_rising, btn_left_rising, btn_right_rising, btn_down_rising;
	reg error = 0;

	// Direction of snake
	parameter UP = 	4'b0001;
	parameter DOWN = 4'b0010;
	parameter LEFT = 4'b0100;
	parameter RIGHT = 4'b1000;
	// Initial direction of snake
	reg [3:0] direction = UP;

	// position state machine
	reg [2:0] pos_x = 0;
	reg [2:0] pos_y = 0;
	reg change = 1;

	// change direction after button press
	always @(posedge clk) begin
		if (btn_up_rising) begin
				direction <= UP;
		end else if (btn_left_rising) begin
				direction <= LEFT;
		end else if (btn_right_rising) begin
				direction <= RIGHT;
		end else if (btn_down_rising) begin
				direction <= DOWN;
		end 
	end

	// move snake every clock cycle
	wire pulse_1Hz;
	always @(posedge clk) begin
		if (pulse_1Hz) begin
			case(direction)
			UP: 	if (pos_y < DIM_Y) begin
						if (pos_y < DIM_Y - 1) begin
							pos_y <= pos_y + 1;
							error <= 1'b0;
						end else begin
							error <= 1'b1;
						end
					end 

			LEFT: 	if (pos_x >= 0) begin
						if (pos_x > 0) begin
							pos_x <= pos_x - 1;
							error <= 1'b0;
				  		end else begin
				  			error <= 1'b1;
				  		end

				  	end 

			RIGHT: 	if (pos_x < DIM_X) begin
						if (pos_x < DIM_X - 1) begin
							pos_x <= pos_x + 1;
							error <= 1'b0;
						end else begin
							error <= 1'b1;
						end
					end

			DOWN: 	if (pos_y >= 0) begin
						if (pos_y > 0) begin
							pos_y <= pos_y - 1;
							error <= 1'b0;
				  		end else begin
				  			error <= 1'b1;
				  		end

				  	end 

			default: pos_x = pos_x;
			endcase
		end
	end

	assign nLED_RED_fw = ~error;

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

	// 1Hz clock
	clkDivHz #(
		.FREQUENCY(1)
	) inst_clkDivHz (
		.clk          (clk),
		.rst          (1'b0),
		.enable       (1'b1),
		.dividedClk   (),
		.dividedPulse (pulse_1Hz)
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

