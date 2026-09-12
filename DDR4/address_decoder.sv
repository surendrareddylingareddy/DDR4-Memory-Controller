module address_decoder
	import ddr4_pkg::*;
	(
	input logic req_write_i,
	input logic [31:0] req_addr_i,

	output ddr4_req_t decoded_req);

	assign decoded_req.valid = 1'b0;
	assign decoded_req.write = req_write_i;
	assign decoded_req.bg = req_addr_i[31:30];
	assign decoded_req.ba = req_addr_i[29:28];
	assign decoded_req.row = req_addr_i[27:12];
	assign decoded_req.col = req_addr_i[11:2];

endmodule
