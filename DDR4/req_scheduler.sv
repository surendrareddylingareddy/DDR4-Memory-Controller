module req_scheduler
	import ddr4_pkg::*;
	(
	input ddr4_req_t req_queue[NUM_REQS],
	input bank_state_t bank_state[NUM_BANKS],
	
	input logic [NUM_BANKS-1:0] act_allowed,
	input logic [NUM_BANKS-1:0] pre_allowed,
	input logic [NUM_BANKS-1:0] wr_allowed,
	input logic [NUM_BANKS-1:0] rd_allowed,

	output ddr4_cmd_t cmd_type,
	output logic cmd_valid,
	output logic [BG_WIDTH-1:0] cmd_bg,
	output logic [BA_WIDTH-1:0] cmd_ba,
	output logic [ROW_WIDTH-1:0] cmd_row,
	output logic [COL_WIDTH-1:0] cmd_col,
	output logic [NUM_REQS-1:0] completed_req
	);

	logic[BG_WIDTH-1:0] bg;
	logic[BA_WIDTH-1:0] ba;

	logic[BG_WIDTH+BA_WIDTH-1:0] ba_id;

	logic found;

	always_comb begin

		cmd_type = CMD_IDLE;
		cmd_valid = '0;
		cmd_bg = '0;
		cmd_ba = '0;
		cmd_row = '0;
		cmd_col = '0;
		found = '0;

		completed_req = '0;

		for(int i=0; i<NUM_REQS; i++) begin
			bg = req_queue[i].bg;
			ba = req_queue[i].ba;
			ba_id = bank_idx(bg, ba);
			if(req_queue[i].valid) begin
				if(!bank_state[ba_id].active) begin
					if(act_allowed[ba_id] && !found) begin
						cmd_type = CMD_ACT;
						cmd_valid = 1'b1;
						cmd_bg = req_queue[i].bg;
						cmd_ba = req_queue[i].ba;
						cmd_row = req_queue[i].row;

						found = 1'b1;
					end
				end
				else if(bank_state[ba_id].open_row == req_queue[i].row) begin
					if(req_queue[i].write && wr_allowed[ba_id] && !found) begin
						cmd_type = CMD_WR;
						cmd_valid = 1'b1;
						cmd_bg = req_queue[i].bg;
						cmd_ba = req_queue[i].ba;
						cmd_row = req_queue[i].row;
						cmd_col = req_queue[i].col;

						completed_req[i] = 1'b1;

						found = 1'b1;
					end else if(!req_queue[i].write && rd_allowed[ba_id] && !found) begin
						cmd_type = CMD_RD;
						cmd_valid = 1'b1;
						cmd_bg = req_queue[i].bg;
						cmd_ba = req_queue[i].ba;
						cmd_row = req_queue[i].row;
						cmd_col = req_queue[i].col;

						completed_req[i] = 1'b1;

						found = 1'b1;
					end
				end else begin
					if(pre_allowed[ba_id] && !found) begin
						cmd_type = CMD_PRE;
						cmd_valid = 1'b1;
						cmd_bg = req_queue[i].bg;
						cmd_ba = req_queue[i].ba;

						found = 1'b1;
					end
				end
			end
		end
	end	

endmodule
