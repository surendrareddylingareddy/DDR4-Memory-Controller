class ddr_driver extends uvm_driver#(ddr_txn);

    `uvm_component_utils(ddr_driver)
    virtual ddr_if vif;

    function new(string n,uvm_component p);
		super.new(n,p);
	endfunction

    function void build_phase(uvm_phase phase);

      	super.build_phase(phase);

      	if(!uvm_config_db#(virtual ddr_if)::get(this,"","vif",vif)) 
			`uvm_fatal("NOVIF","ddr_if missing")

    endfunction
	
    task run_phase(uvm_phase phase);
		
		ddr_txn req;

      	vif.req_valid=0; 
		vif.req_write=0; 
		vif.req_addr=0;

      	wait(vif.rst_n);

      	forever begin
        	seq_item_port.get_next_item(req);
        	repeat(req.idle_cycles) @(negedge vif.clk);
       
        	@(negedge vif.clk);
        	vif.req_valid = 1'b1;
        	vif.req_write = req.write;
        	vif.req_addr = req.addr();

			do begin
				@(posedge vif.clk);
			end while(vif.req_ready != 1'b1);
			
        	@(negedge vif.clk);
        	vif.req_valid = 1'b0;

          	seq_item_port.item_done();
      	end
    endtask

endclass
