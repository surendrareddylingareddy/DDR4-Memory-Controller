interface ddr_if(input logic clk);
	import ddr4_pkg::*;
	
    logic rst_n;
    logic req_valid;
    logic req_write;
    logic [31:0] req_addr;
	logic req_ready;

    ddr4_cmd_t cmd;
    logic [BG_WIDTH-1:0] cmd_bg;
    logic [BA_WIDTH-1:0] cmd_ba;
    logic [ROW_WIDTH-1:0] cmd_row;
    logic [COL_WIDTH-1:0] cmd_col;
    logic issued;

endinterface
