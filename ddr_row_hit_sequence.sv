class ddr_row_hit_seq extends uvm_sequence#(ddr_txn);

 	`uvm_object_utils(ddr_row_hit_seq)
    int unsigned count=32;

    function new(string n="ddr_row_hit_seq");
		super.new(n);
	endfunction

    task body();
      	ddr_txn t;

      	t = ddr_txn::type_id::create("ddr_txn");

        start_item(t);

        if(!t.randomize() with { write == 1'b0; bg == 0; ba == 0; row == 100; col == 200; })
				`uvm_fatal("RAND","Transaction randomization failed")

        finish_item(t);

		t = ddr_txn::type_id::create("ddr_txn");

        start_item(t);

        if(!t.randomize() with { write == 1'b0; bg == 0; ba == 0; row == 100; col == 400; })
				`uvm_fatal("RAND","Transaction randomization failed")

        finish_item(t);	
    endtask

endclass
