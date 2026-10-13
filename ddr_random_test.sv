class ddr_random_test extends uvm_test;

    `uvm_component_utils(ddr_random_test)

    ddr_env env;
    ddr_random_seq seq;

    function new(string name = "ddr_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = ddr_env::type_id::create("env", this);
    endfunction

    // Run phase
    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        `uvm_info("DDR_TEST", "Starting DDR4 random test", UVM_LOW)

        // Create random sequence
        seq = ddr_random_seq::type_id::create("seq");

        // Start sequence on the agent sequencer
        seq.start(env.agent.seqr);

        `uvm_info("DDR_TEST", "Random sequence completed", UVM_LOW)

        #1000ns;

        phase.drop_objection(this);

    endtask

endclass
