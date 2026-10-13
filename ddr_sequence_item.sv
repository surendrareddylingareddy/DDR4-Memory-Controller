class ddr4_txn extends uvm_sequence_item;

    rand bit write;
    rand bit [1:0] bg, ba;
    rand bit [15:0] row;
    rand bit [9:0] col;
    rand int unsigned idle_cycles;

    constraint c_idle { 
		idle_cycles inside {[0:3]}; 
	}

    `uvm_object_utils_begin(ddr4_txn)
      `uvm_field_int(write,UVM_DEFAULT)
      `uvm_field_int(bg,UVM_DEFAULT)
      `uvm_field_int(ba,UVM_DEFAULT)
      `uvm_field_int(row,UVM_DEFAULT)
      `uvm_field_int(col,UVM_DEFAULT)
      `uvm_field_int(idle_cycles,UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name="ddr4_txn"); 
		super.new(name); 
	endfunction

    function bit [31:0] addr(); 
		return {bg,ba,row,col,2'b00}; 
	endfunction
endclass
