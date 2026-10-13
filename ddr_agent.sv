class ddr_agent extends uvm_agent;

    `uvm_component_utils(ddr_agent)
    ddr_seqr seqr;
    ddr_driver drv;
    ddr_i_monitor mon;

    function new(string n,uvm_component p);
		super.new(n,p);
	endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon = ddr_i_monitor::type_id::create("mon",this);
      seqr = ddr_seqr::type_id::create("seqr",this);
      drv = ddr_driver::type_id::create("drv",this);
    endfunction

    function void connect_phase(uvm_phase phase); 
		drv.seq_item_port.connect(seqr.seq_item_export);
	endfunction

endclass
