class ddr_write_seq extends uvm_sequence#(ddr_txn);

 	`uvm_object_utils(ddr_write_seq)
    int unsigned count=32;

    function new(string n="ddr_write_seq");
		super.new(n);
	endfunction

    task body();
      	ddr_txn t;
      	for(int i=0;i<count;i++)begin

        	t=ddr_txn::type_id::create("ddr_txn");
        	start_item(t);

        	if(!t.randomize() with { write == 1'b1; })
				`uvm_fatal("RAND","Transaction randomization failed")

        	finish_item(t);

      	end
    endtask

endclass
