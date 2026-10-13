class ddr_env extends uvm_env;

    `uvm_component_utils(ddr_env)
    ddr_agent agent;
    ddr_o_monitor cmon;
    ddr_scoreboard scb;
    ddr_coverage cov;

    function new(string n,uvm_component p);
		super.new(n,p);
	endfunction

    function void build_phase(uvm_phase phase);
      	agent = ddr_agent::type_id::create("agent",this);
      	cmon = ddr_o_monitor::type_id::create("cmon",this);
      	scb = ddr_scoreboard::type_id::create("scb",this);
      	cov = ddr_coverage::type_id::create("cov",this);
    endfunction

    function void connect_phase(uvm_phase phase);
      	agent.mon.ap.connect(scb.req_fifo.analysis_export);
      	cmon.ap.connect(scb.cmd_fifo.analysis_export);
      	cmon.ap.connect(cov.analysis_export);
    endfunction

endclass
