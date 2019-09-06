`timescale 1ns/1ps
`include "snake.v"

module snake_tb();

	reg clk;
	reg btn_up, btn_left, btn_right, btn_down;
	// Clock
	initial begin
		clk = 0;
		forever #(42) clk = ~clk;
	end

	top inst_top
	(
		.clk       (clk),
		.btn_up    (btn_up),
		.btn_left  (btn_left),
		.btn_right (btn_right),
		.btn_down  (btn_down),
		.row       (row),
		.col       (col)
	);

	initial begin
		btn_right = 1;
		#(50_000_000) // 50ms
		btn_right = 0;
		#(50_000) // 50 us

		btn_up = 1;
		#(50_000_000) // 50ms
		btn_up = 0;
		#(50_000) // 50 us

		btn_left = 1;
		#(50_000_000) // 50ms
		btn_left = 0;
		#(50_000) // 50 us

		btn_left = 1;
		#(50_000_000) // 50ms
		btn_left = 0;
		#(50_000) // 50 us

		btn_down = 1;
		#(50_000_000) // 50ms
		btn_down = 0;
		#(50_000) // 50 us

		btn_left = 1;
		#(50_000_000) // 50ms
		btn_left = 0;
		#(50_000) // 50 us
	end




	// Dump wave
	initial begin
		$dumpfile("snake_tb.lxt");
		$dumpvars(0,snake_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 500;
	localparam SIM_TIME = SIM_TIME_MS * 1000_000; // @ 1 ns / unit
	initial begin
		$display("Simulation Started");
		#(SIM_TIME/10);
		$display("10%");
		#(SIM_TIME/10);
		$display("20%");
		#(SIM_TIME/10);
		$display("30%");
		#(SIM_TIME/10);
		$display("40%");
		#(SIM_TIME/10);
		$display("50%");
		#(SIM_TIME/10);
		$display("60%");
		#(SIM_TIME/10);
		$display("70%");
		#(SIM_TIME/10);
		$display("80%");
		#(SIM_TIME/10);
		$display("90%");
		#(SIM_TIME/10);
		$display("Finished");
		$finish;
	end

endmodule
