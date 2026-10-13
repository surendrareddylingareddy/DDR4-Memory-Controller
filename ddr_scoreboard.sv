class ddr_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(ddr_scoreboard)
    uvm_tlm_analysis_fifo#(ddr_txn) req_fifo;
    uvm_tlm_analysis_fifo#(ddr_cmd_item) cmd_fifo;

    ddr_txn pending[$];
    bit opened[16];
    bit [15:0] open_row[16];

    longint signed last_act[16], last_pre[16], last_wr[16], last_rd[16];
    longint signed last_act_bg[4], last_col_bg[4];
    longint signed last_act_any, last_col_any, last_wr_any, last_rd_any;
    int unsigned n_cmd, n_done, n_req,n_errors;

    function new(string n,uvm_component p);
		super.new(n,p);
	endfunction

    function void build_phase(uvm_phase phase);
      	super.build_phase(phase);
      	req_fifo=new("req_fifo",this);
	  	cmd_fifo=new("cmd_fifo",this);
      	reset_model();
    endfunction

    function void reset_model();
      	pending.delete();
      	for(int i = 0; i<16; i++) begin
        	opened[i] = 0;
			open_row[i] = 0;
        	last_act[i] = -100000;
			last_pre[i] = -100000;
        	last_wr[i] = -100000;
			last_rd[i] = -100000;
      	end

      	for(int i=0;i<4;i++)begin 
			last_act_bg[i] = -100000;
			last_col_bg[i] = -100000;
		end

      	last_act_any = -100000;
		last_col_any = -100000;
      	last_wr_any = -100000;
		last_rd_any = -100000;

    endfunction

    function void err(string msg);
      	n_errors++;
		`uvm_error("DDR4_SCB",msg)
    endfunction

    function bit matching_pending(ddr_cmd_item c);

      	foreach(pending[i]) begin
        	if(pending[i].bg == c.bg && pending[i].ba == c.ba && pending[i].row == c.row && 
			pending[i].col == c.col && pending[i].write == (c.cmd == CMD_WR)) begin
				return 1;
			end
		end

      	return 0;

    endfunction

    function void check_cmd(ddr_cmd_item c);
      	int bank = {c.bg,c.ba};
      	longint signed t = c.cycle;
      	n_cmd++;
      	case(c.cmd)
        	CMD_ACT: begin
          		if(opened[bank])err($sformatf("ACT while bank %0d active",bank));
          		if(t-last_pre[bank]<T_RP)err("tRP violation");
          		if(t-last_act[bank]<T_RC)err("tRC violation");
          		if(t-last_act_bg[c.bg]<T_RRD_L)err("tRRD_L violation");
          		if(t-last_act_any<T_RRD_S)err("tRRD_S violation");

          		opened[bank] = 1;
				open_row[bank] = c.row;
          		last_act[bank] = t;
				last_act_bg[c.bg] = t;
				last_act_any = t;
        	end
        	CMD_PRE: begin
          		if(!opened[bank])err("PRE on closed bank");
          		if(t-last_act[bank]<T_RAS)err("tRAS violation");
          		if(t-last_wr[bank]<T_WR)err("tWR violation");
          		if(t-last_rd[bank]<T_RTP)err("tRTP violation");

          		opened[bank]=0;
				last_pre[bank]=t;
       	 	end
        	CMD_WR,CMD_RD: begin
          		if(!opened[bank] || open_row[bank] != c.row) err("Read/write without matching open row");
          		if(t-last_act[bank]<T_RCD)err("tRCD violation");
          		if(t-last_col_bg[c.bg]<T_CCD_L)err("tCCD_L violation");
          		if(t-last_col_any<T_CCD_S)err("tCCD_S violation");

          		if(c.cmd == CMD_WR) begin
            		if(t-last_rd_any<T_RTW_S)err("tRTW_S violation");

            		for(int g=0; g<4; g++) if(g == c.bg && t-last_rd[bank]<T_RTW_L)err("tRTW_L violation (conservative)");

            		last_wr[bank] = t;
					last_wr_any = t;
          		end else begin
            		if(t-last_wr_any<T_WTR_S)err("tWTR_S violation");
            		for(int g=0; g<4; g++) if(g == c.bg && t-last_wr[bank]<T_WTR_L)err("tWTR_L violation (conservative)");
            		last_rd[bank] = t;
					last_rd_any = t;
         	 	end

          		if(!matching_pending(c))err($sformatf("Unexpected %s BG%0d BA%0d row%0h col%0h",c.cmd.name(),c.bg,c.ba,c.row,c.col));
          		else begin 
					foreach(pending[i]) begin
            			if(pending[i].bg==c.bg && pending[i].ba==c.ba && pending[i].row==c.row &&
						pending[i].col==c.col && pending[i].write == (c.cmd == CMD_WR)) begin

              				pending.delete(i); 
							n_done++;
							break;
						end
            		end
				end
          		last_col_bg[c.bg] = t;
				last_col_any = t;
        	end
      	endcase

    endfunction


    task run_phase(uvm_phase phase);
      	ddr_txn r;
      	ddr_cmd_item c;
      	fork
        	forever begin
          		req_fifo.get(r);
          		pending.push_back(r);
				n_req++;
          		if(pending.size()>NUM_REQS)err("More than NUM_REQS pending: request loss possible");
        	end
        	forever begin 
				cmd_fifo.get(c); 
				check_cmd(c);
			end
      	join
    endtask

    function void report_phase(uvm_phase phase);
      	`uvm_info("DDR_SCB",$sformatf("Requests %0d, commands %0d, completed %0d, pending %0d, errors %0d", n_req, n_cmd, n_done, pending.size(), n_errors),UVM_NONE)

      	if(pending.size()!=0) `uvm_warning("PENDING","Uncompleted transactions at end of test")

    endfunction


endclass
