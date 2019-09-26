`timescale 1ns/1ps
`include "ledMatrix.v"

module ledMatrix_tb();

	logic clk;
	reg  [35:0] img;
	wire [5:0] row, col;

	// Clock
	initial begin
		clk = 0;
		forever #(42) clk = ~clk;
	end

	initial begin
		img[5:0] 	= 6'b000001;
		img[11:6] 	= 6'b000010;
		img[17:12] 	= 6'b000100;
		img[23:18] 	= 6'b001000;
		img[29:24] 	= 6'b010000;
		img[35:30] 	= 6'b100000;

		#(500_000_00);

		img[5:0] 	= ~6'b000001;
		img[11:6] 	= ~6'b000010;
		img[17:12] 	= ~6'b000100;
		img[23:18] 	= ~6'b001000;
		img[29:24] 	= ~6'b010000;
		img[35:30] 	= ~6'b100000;
	end


	ledMatrix inst_top (
		.clk(clk), 
		.img(img), 
		.row(row), 
		.col(col)
	);

	// Dump wave
	initial begin
		$dumpfile("ledMatrix_tb.lxt");
		$dumpvars(0,ledMatrix_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 100;
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
