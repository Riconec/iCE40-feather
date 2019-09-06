// -----------------------------------------------------------------------------
// Copyright (c) 2019 All rights reserved
// -----------------------------------------------------------------------------
// Author      : Josh Johnson <josh@joshajohnson.com>
// File        : ledMatrix.v
// Description : Handles display of input 'img' on multiplexed array featherwing
// Created     : 2019-09-06 19:11:33
// Revised     : 2019-09-06 19:11:33
// Editor      : sublime text3, tab size (4)
// 
// @input [35:0] img: 6x6 image to be displayed, mapping as below
// 31 32 33 34 35 36
// 25 26 27 28 29 30
// 19 20 21 22 23 24
// 13 14 15 16 17 18 
// 12 13 14 15 16 17
//  6  7  8  9 10 11
//  5  4  3  2  1  0
// -----------------------------------------------------------------------------


`ifndef _ledMatrix_v_
`define _ledMatrix_v_

`default_nettype none
`include "../src/clockDividerHertz.v"

module ledMatrix(
    input clk,
    input [35:0] img,
    output [5:0] row,
    output [5:0] col
);
	wire dividedPulse;
	parameter DIM_X = 6;
	parameter DIM_Y = 6;
	reg [2:0] rowCnt = 0;
	reg [5:0] colOut;

	always @(posedge clk) begin
		if (dividedPulse) begin
			if (rowCnt < DIM_Y - 1) begin
				rowCnt <=  rowCnt + 1;
			end else begin
				rowCnt <= 0;
			end
		end else begin
			rowCnt <= rowCnt;
		end
	end

	assign row = 1 << rowCnt;

	always @(*) begin
		case (rowCnt)
			3'd5: colOut = img [35:30];
			3'd4: colOut = img [29:24];
			3'd3: colOut = img [23:18];	
			3'd2: colOut = img [17:12];
			3'd1: colOut = img [11:6];
			3'd0: colOut = img [5:0];
			default: colOut = 6'b111111;
		endcase
	end

	assign col = ~colOut;
		
	clockDividerHertz #(
			.FREQUENCY(3600)
		) inst_clockDividerHz (
			.clk        	(clk),
			.rst        	(1'b0),
			.enable     	(1'b1),
			.dividedClk 	(),
			.dividedPulse	(dividedPulse)
	);

endmodule

`endif

