module request_queue
	import ddr4_pkg::*;
	(
	input logic clk,
	input logic rst_n,
	input ddr4_req_t req_i,
	input logic[NUM_REQS-1:0] completed_req,

	output ddr4_req_t req_queue[NUM_REQS]);
	
	always_ff@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			for(int i=0; i<NUM_REQS; i++) begin
				req_queue[i] <= '0;
			end
		end
		else begin
			
			if(!req_i.valid) begin
				logic found;
				found = 1'b0;

				for(int i=0; i<NUM_REQS; i++) begin
					if(!req_queue[i].valid && !found) begin
						req_queue[i] <= req_i;
						req_queue[i].valid <= 1'b1;
						found = 1'b1;
					end
				end
			end

			for(int i=0; i<NUM_REQS; i++) begin
				if(completed_req[i]) begin
					req_queue[i].valid <= 1'b0;
				end
			end
		end
	end
			
	
endmodule
