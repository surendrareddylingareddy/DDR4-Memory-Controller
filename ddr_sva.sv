module ddr4_sva
	import ddr4_pkg::*;
    (input logic clk, rst_n,
    input ddr4_cmd_t cmd,
    input logic [BG_WIDTH-1:0] bg,
    input logic [BA_WIDTH-1:0] ba,
    input logic [ROW_WIDTH-1:0] row,
    input logic [COL_WIDTH-1:0] col);
  
    ap_legal_cmd: assert property(@(posedge clk) disable iff(!rst_n)
    	cmd inside {CMD_IDLE, CMD_ACT, CMD_PRE, CMD_RD, CMD_WR}
	);

	

 endmodule
