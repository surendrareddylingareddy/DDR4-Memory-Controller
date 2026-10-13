class ddr_seqr extends uvm_sequencer#(ddr_txn);

    `uvm_component_utils(ddr_seqr)

    function new(string name = "seqr", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
endclass
