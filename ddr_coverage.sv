  class ddr_coverage extends uvm_subscriber#(ddr_cmd_item);

    `uvm_component_utils(ddr_coverage)
    ddr_cmd_item observed;

    covergroup cmd_cg;
      	option.per_instance=1;
      	cp_cmd: coverpoint observed.cmd { 
	  		bins act={CMD_ACT}; bins pre={CMD_PRE}; bins rd={CMD_RD}; bins wr={CMD_WR};
		}
      	cp_bg: coverpoint observed.bg;
      	cp_ba: coverpoint observed.ba;
      	x_cmd_bg: cross cp_cmd,cp_bg;
      	x_cmd_ba: cross cp_cmd,cp_ba;
    endgroup

    function new(string n,uvm_component p);
		super.new(n,p);
		cmd_cg=new();
	endfunction

    function void write(ddr_cmd_item t); 
		observed = t;
		cmd_cg.sample();
	endfunction

endclass
