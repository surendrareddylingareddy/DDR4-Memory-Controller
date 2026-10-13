package ddr_uvm_pkg;

    import uvm_pkg::*;
    import ddr4_pkg::*;

    `include "uvm_macros.svh"

    // Transaction objects
    `include "ddr_txn.sv"
    `include "ddr_cmd_item.sv"

    // Sequences
    `include "ddr_random_sequence.sv"
	`include "ddr_read_sequence.sv"
	`include "ddr_row_hit_sequence.sv"
	`include "ddr_row_miss_sequence.sv"
	`include "ddr_write_sequence.sv"
	

    // Sequencer and driver
    `include "ddr_sequencer.sv"
    `include "ddr_driver.sv"

    // Monitors
    `include "ddr_i_monitor.sv"
    `include "ddr_o_monitor.sv"

    // Agent
    `include "ddr_agent.sv"

    // Scoreboard and coverage
    `include "ddr_scoreboard.sv"
    `include "ddr_coverage.sv"

    // Environment
    `include "ddr_env.sv"

    // Tests
    `include "ddr_random_test.sv"
	`include "ddr_read_test.sv"
	`include "ddr_write_test.sv"
	`include "ddr_row_hit_test.sv"
	`include "ddr_row_miss_test.sv"

endpackage
