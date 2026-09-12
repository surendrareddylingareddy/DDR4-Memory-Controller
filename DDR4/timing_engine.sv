module timing_engine
	import ddr4_pkg::*;
	(
	input logic clk,
	input logic rst_n,

	input logic cmd_valid_i,
	input ddr4_cmd_t cmd_type_i,

	input logic[BG_WIDTH-1:0] cmd_bg_i,
	input logic[BA_WIDTH-1:0] cmd_ba_i,

	output logic[NUM_BANKS-1:0] act_allowed_o,
	output logic[NUM_BANKS-1:0] pre_allowed_o,
	output logic[NUM_BANKS-1:0] rd_allowed_o,
	output logic[NUM_BANKS-1:0] wr_allowed_o);

	localparam int TIMER_BITS = 10;

	logic[TIMER_BITS-1:0] tmr_rcd[NUM_BANKS];
	logic[TIMER_BITS-1:0] tmr_rp[NUM_BANKS];
	logic[TIMER_BITS-1:0] tmr_ras[NUM_BANKS];
	logic[TIMER_BITS-1:0] tmr_rc[NUM_BANKS];
	logic[TIMER_BITS-1:0] tmr_wr[NUM_BANKS];
	logic[TIMER_BITS-1:0] tmr_rtp[NUM_BANKS];


	logic[TIMER_BITS-1:0] tmr_ccd_l[NUM_BANK_GROUPS];
	logic[TIMER_BITS-1:0] tmr_rrd_l[NUM_BANK_GROUPS];

	logic[TIMER_BITS-1:0] tmr_ccd_s;
	logic[TIMER_BITS-1:0] tmr_rrd_s;

	logic[TIMER_BITS-1:0] tmr_rtw_l[NUM_BANK_GROUPS];
	logic[TIMER_BITS-1:0] tmr_wtr_l[NUM_BANK_GROUPS];

	logic[TIMER_BITS-1:0] tmr_rtw_s;
	logic[TIMER_BITS-1:0] tmr_wtr_s;

	logic [BG_WIDTH+BA_WIDTH-1:0] ba_id;

	always_ff@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			for(int i=0; i<NUM_BANKS; i++) begin
				tmr_rcd[i] <= 'b0;
				tmr_rp[i] <= 'b0;
				tmr_ras[i] <= 'b0;
				tmr_rc[i] <= 'b0;
				tmr_wr[i] <= 'b0;
				tmr_rtp[i] <= 'b0;
			end
		end else begin
			for(int i=0; i<NUM_BANKS; i++) begin
				tmr_rcd[i] <= (tmr_rcd[i] > 0) ? (tmr_rcd[i] - 'b1) : 'b0;
				tmr_rp[i] <= (tmr_rp[i] > 0) ? (tmr_rp[i] - 'b1) : 'b0;
				tmr_ras[i] <= (tmr_ras[i] > 0) ? (tmr_ras[i] - 'b1) : 'b0;
				tmr_rc[i] <= (tmr_rc[i] > 0) ? (tmr_rc[i] - 'b1) : 'b0;
				tmr_wr[i] <= (tmr_wr[i] > 0) ? (tmr_wr[i] - 'b1) : 'b0;
				tmr_rtp[i] <= (tmr_rtp[i] > 0) ? (tmr_rtp[i] - 'b1) : 'b0;
			end
		end
	end

	always_ff@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			for(int i=0; i<NUM_BANK_GROUPS; i++) begin
				tmr_rrd_l[i] <= 'b0;
				tmr_ccd_l[i] <= 'b0;
				tmr_rtw_l[i] <= 'b0;
				tmr_wtr_l[i] <= 'b0;
			end
		end else begin
			for(int i=0; i<NUM_BANK_GROUPS; i++) begin
				tmr_rrd_l[i] <= (tmr_rrd_l[i] > 0) ? (tmr_rrd_l[i] - 'b1) : 'b0;
				tmr_ccd_l[i] <= (tmr_ccd_l[i] > 0) ? (tmr_ccd_l[i] - 'b1) : 'b0;
				tmr_rtw_l[i] <= (tmr_rtw_l[i] > 0) ? (tmr_rtw_l[i] - 'b1) : 'b0;
				tmr_wtr_l[i] <= (tmr_wtr_l[i] > 0) ? (tmr_wtr_l[i] - 'b1) : 'b0;
			end
		end
	end

	always_ff@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			tmr_rrd_s <= 'b0;
			tmr_ccd_s <= 'b0;
			tmr_rtw_s <= 'b0;
			tmr_wtr_s <= 'b0;
		end else begin
			tmr_rrd_s <= (tmr_rrd_s > 'b0) ? (tmr_rrd_s - 'b1) : 'b0;
			tmr_ccd_s <= (tmr_ccd_s > 'b0) ? (tmr_ccd_s - 'b1) : 'b0;
			tmr_rtw_s <= (tmr_rtw_s > 'b0) ? (tmr_rtw_s - 'b1) : 'b0;
			tmr_wtr_s <= (tmr_wtr_s > 'b0) ? (tmr_wtr_s - 'b1) : 'b0;
		end
	end

	assign ba_id = bank_idx(cmd_bg_i, cmd_ba_i);

	always_ff@(posedge clk) begin
		if(cmd_valid_i) begin
			case(cmd_type_i) 
				CMD_ACT : begin
					tmr_rc[ba_id] <= T_RC;
					tmr_rcd[ba_id] <= T_RCD;
					tmr_ras[ba_id] <= T_RAS;
					tmr_rrd_s <= T_RRD_S;
					tmr_rrd_l[cmd_bg_i] <= T_RRD_L;
				end
				CMD_WR : begin
					tmr_wr[ba_id] <= T_WR;
					tmr_ccd_l[cmd_bg_i] <= T_CCD_L;
					tmr_wtr_l[cmd_bg_i] <= T_WTR_L;
					tmr_ccd_s <= T_CCD_S;
					tmr_wtr_s <= T_WTR_S;
				end
				CMD_RD : begin
					tmr_rtp[ba_id] <= T_RTP;
					tmr_ccd_l[cmd_bg_i] <= T_CCD_L;
					tmr_rtw_l[cmd_bg_i] <= T_RTW_L;
					tmr_ccd_s <= T_CCD_S;
					tmr_rtw_s <= T_RTW_S;
				end
				CMD_PRE : begin
					tmr_rp[ba_id] <= T_RP;
				end
			endcase
		end
	end

	always_comb begin
		for(int i=0; i<NUM_BANKS; i++) begin
			act_allowed_o[i] = (tmr_rc[i] == '0)&&(tmr_rp[i] == '0)&&(tmr_rrd_s == '0)&&(tmr_rrd_l[i/4] == '0);
			pre_allowed_o[i] = (tmr_ras[i] == '0)&&(tmr_wr[i] == '0)&&(tmr_rtp[i] == '0);
			wr_allowed_o[i] = (tmr_rcd[i] == '0)&&(tmr_rtw_l[i/4] == '0)&&(tmr_rtw_s == '0)&&(tmr_ccd_l[i/4] == '0)&&(tmr_ccd_s == '0);
			rd_allowed_o[i] = (tmr_rcd[i] == '0)&&(tmr_wtr_l[i/4] == '0)&&(tmr_wtr_s == '0)&&(tmr_ccd_l[i/4] == '0)&&(tmr_ccd_s == '0);
		end
	end

endmodule
