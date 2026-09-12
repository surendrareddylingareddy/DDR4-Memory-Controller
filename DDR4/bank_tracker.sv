module bank_tracker
	import ddr4_pkg::*;
	(
	input logic clk,
	input logic rst_n,

	input ddr4_cmd_t cmd_i,
	input logic cmd_valid,
	input logic [BG_WIDTH-1:0] bg,
	input logic [BA_WIDTH-1:0] ba,
	input logic [ROW_WIDTH-1:0] row,

	output bank_state_t bank_state[NUM_BANKS]);

	logic [BG_WIDTH+BA_WIDTH-1:0] ba_id;

	assign ba_id = bank_idx(bg, ba);

	always_ff@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			for(int i=0; i<NUM_BANKS; i++) begin
				bank_state[i].active <= '0;
				bank_state[i].open_row <= '0;
			end
		end else begin
			if(cmd_valid) begin
				case(cmd_i)
					CMD_ACT : begin
						bank_state[ba_id].active <= '1;
						bank_state[ba_id].open_row <= row;
					end
					CMD_PRE : begin
						bank_state[ba_id].active <= '0;
						bank_state[ba_id].open_row <= '0;
					end
					default : begin
					end
				endcase
			end
		end
	end
endmodule
