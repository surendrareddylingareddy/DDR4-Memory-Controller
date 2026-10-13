package ddr4_pkg;
	

	parameter int BG_WIDTH = 2;
	parameter int BA_WIDTH = 2;
	parameter int ROW_WIDTH = 16;
	parameter int COL_WIDTH = 10;
	parameter int DATA_WIDTH = 64;
	parameter int NUM_REQS = 8;
	parameter int NUM_BANKS = 16;
	parameter int NUM_BANK_GROUPS = 4;
	
	//timing constraints
	parameter int T_RCD = 5;
	parameter int T_RP = 5;
	parameter int T_RAS = 9;
	parameter int T_RC = 14;
	parameter int T_WR = 3;
	parameter int T_RTP = 3;

	parameter int T_RRD_L = 3;
	parameter int T_RRD_S = 2;

	parameter int T_CCD_L = 3;
	parameter int T_CCD_S = 2;

	parameter int T_RTW_L = 4;
	parameter int T_RTW_S = 3;

	parameter int T_WTR_L = 4;
	parameter int T_WTR_S = 3;

	typedef struct packed {

		logic valid;
		logic write;

		logic[BG_WIDTH-1:0] bg;
		logic[BA_WIDTH-1:0] ba;
		logic[ROW_WIDTH-1:0] row;
		logic[COL_WIDTH-1:0] col;

	} ddr4_req_t;

	typedef struct packed {

		logic active;
		logic [ROW_WIDTH-1:0] open_row;

	} bank_state_t;

	typedef enum {

		CMD_IDLE,
		CMD_ACT,
		CMD_WR,
		CMD_RD,
		CMD_PRE
		
	} ddr4_cmd_t;

	function automatic logic [3:0] bank_idx(
    	input logic [1:0] bg,
    	input logic [1:0] ba);

    	return {bg, ba};

	endfunction


endpackage
