class ddr_i_monitor extends uvm_monitor;

    `uvm_component_utils(ddr_i_monitor)
    virtual ddr_if vif;
    uvm_analysis_port#(ddr_txn) ap;

    function new(string n,uvm_component p);
		super.new(n,p);
		ap=new("ap",this);
	endfunction

    function void build_phase(uvm_phase phase);
      	if(!uvm_config_db#(virtual ddr_if)::get(this,"","vif",vif))
	  		`uvm_fatal("NOVIF","No interface")
    endfunction

    task run_phase(uvm_phase phase);
      	ddr_txn t;
      	forever begin
        	@(posedge vif.clk);
        	if(vif.rst_n && vif.req_valid) begin
          		t = ddr_txn::type_id::create("sampled_req");
          		t.write = vif.req_write;
          		{t.bg,t.ba,t.row,t.col} = vif.req_addr[31:2];
          		ap.write(t);
        	end
      	end
    endtask

endclass
