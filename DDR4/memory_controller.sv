module memory_controller
	import ddr4_pkg::*;
	(
	input  logic        clk,
    input  logic        rst_n,

    input  logic        req_write_i,
    input  logic [31:0] req_addr_i,

    output ddr4_cmd_t cmd_o,
	output logic [BG_WIDTH-1:0] cmd_bg_o,
	output logic [BA_WIDTH-1:0] cmd_ba_o,
	output logic [ROW_WIDTH-1:0] cmd_row_o,
	output logic [COL_WIDTH-1:0] cmd_col_o);

	ddr4_req_t decoded_req;
	logic [NUM_REQS-1:0] completed_req;

	ddr4_req_t req_queue [NUM_REQS];
	ddr4_cmd_t cmd_type;
	logic cmd_valid;
	logic [BG_WIDTH-1:0] cmd_bg;
	logic [BA_WIDTH-1:0] cmd_ba;
	logic [ROW_WIDTH-1:0] cmd_row;
	logic [COL_WIDTH-1:0] cmd_col;

	bank_state_t bank_state [NUM_BANKS];

	logic [NUM_BANKS-1:0] act_allowed;
	logic [NUM_BANKS-1:0] wr_allowed;
	logic [NUM_BANKS-1:0] rd_allowed;
	logic [NUM_BANKS-1:0] pre_allowed;

	always_ff@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			cmd_o <= CMD_IDLE;
			cmd_bg_o <= '0;
			cmd_ba_o <= '0;
			cmd_row_o <= '0;
			cmd_col_o <= '0;
		end
		else begin
			cmd_o <= cmd_type;
			cmd_bg_o <= cmd_bg;
			cmd_ba_o <= cmd_ba;
			cmd_row_o <= cmd_row;
			cmd_col_o <= cmd_col;
		end
	end

	address_decoder ad(req_write_i, req_addr_i, decoded_req);

	request_queue rq(clk, rst_n, decoded_req, completed_req, req_queue);

	bank_tracker bt(clk, rst_n, cmd_type, cmd_valid, cmd_bg, cmd_ba, cmd_row, bank_state);

	timing_engine te(clk, rst_n, cmd_valid, cmd_type, cmd_bg, cmd_ba, act_allowed, pre_allowed, wr_allowed, rd_allowed);

	req_scheduler rs(req_queue, bank_state, act_allowed, pre_allowed, wr_allowed, rd_allowed, cmd_type, cmd_valid, cmd_bg, cmd_ba, cmd_row, cmd_col, completed_req);
	
endmodule
