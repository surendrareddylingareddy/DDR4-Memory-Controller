 class ddr_o_monitor extends uvm_monitor;

    `uvm_component_utils(ddr_o_monitor)
    virtual ddr_if vif;
    uvm_analysis_port#(ddr_cmd_item) ap;

    longint unsigned tick;

    function new(string n,uvm_component p);
		super.new(n,p);
		ap=new("ap",this);
	endfunction

    function void build_phase(uvm_phase phase);
      	if(!uvm_config_db#(virtual ddr_if)::get(this,"","vif",vif)) 
	  		`uvm_fatal("NOVIF","No interface")
    endfunction

    task run_phase(uvm_phase phase);
     	ddr_cmd_item c;
      	forever begin
        	@(posedge vif.clk);
       	 	if(!vif.rst_n) tick = 0;
        	else begin
          		tick++;
               	if(vif.issued) begin
            		c = ddr_cmd_item::type_id::create("sampled_cmd");
            		c.cmd = vif.cmd;
            		c.bg = vif.cmd_bg; 
					c.ba = vif.cmd_ba;
            		c.row = vif.cmd_row; 
					c.col = vif.cmd_col;
            		c.cycle = tick;
            		ap.write(c);
          		end
        	end
      	end
    endtask

endclass
