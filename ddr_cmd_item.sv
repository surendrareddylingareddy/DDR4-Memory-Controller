class ddr_cmd_item extends uvm_sequence_item;

    ddr4_cmd_t cmd;
    bit [1:0] bg,ba;
    bit [15:0] row;
    bit [9:0] col;

    longint unsigned cycle;
	
    `uvm_object_utils_begin(ddr_cmd_item)
      `uvm_field_enum(ddr4_cmd_t,cmd,UVM_DEFAULT)
      `uvm_field_int(bg,UVM_DEFAULT)
      `uvm_field_int(ba,UVM_DEFAULT)
      `uvm_field_int(row,UVM_DEFAULT)
      `uvm_field_int(col,UVM_DEFAULT)
      `uvm_field_int(cycle,UVM_DEFAULT)
    `uvm_object_utils_end
    
	function new(string name="ddr4_cmd_item"); 
		super.new(name); 
	endfunction

endclass
