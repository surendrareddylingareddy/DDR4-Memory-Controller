`include "ddr4_pkg.sv"
`include "address_decoder.sv"
`include "request_queue.sv"
`include "bank_tracker.sv"
`include "timing_engine.sv"
`include "req_scheduler.sv"
`include "memory_controller.sv"

module top();

	import ddr4_pkg::*;

	logic clk;
	logic rst_n;

	logic req_write;
	logic [31:0] req_addr;
	
	ddr4_cmd_t cmd_o;
	logic [BG_WIDTH-1:0] bg_o;
	logic [BA_WIDTH-1:0] ba_o;
	logic [ROW_WIDTH-1:0] row_o;
	logic [COL_WIDTH-1:0] col_o;

	memory_controller dut(clk, rst_n, req_write, req_addr, cmd_o, bg_o, ba_o, row_o, col_o);

	always #5 clk = ~clk;

	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		#15;
		rst_n = 1'b1;
		req_write = 1'b1;
		req_addr = 'h12345678;
		#10;
		req_write = 1'b1;
		req_addr = 'h45678912;
		#5;
		req_write = 1'b1;
		req_addr = 'h34567890;
	end

	initial begin
		#200;
		$finish;
	end

endmodule
