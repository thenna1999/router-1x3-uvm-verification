package router_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "source_agt_config.sv"
        `include "destination_agt_config.sv"
        `include "env_config.sv"
        `include "src_xtn.sv"
        `include "sseq.sv"

        `include "sdriver.sv"
        `include "smonitor.sv"
        `include "ssequencer.sv"
        `include "src_agt.sv"
        `include "src_agt_top.sv"
        `include "dst_xtn.sv"
        `include "dseq.sv"
        `include "ddriver.sv"
        `include "dmonitor.sv"
        `include "dsequencer.sv"
        `include "dst_agt.sv"
        `include "dst_agt_top.sv"
	`include "scoreboard.sv"
        `include "env.sv"
 	`include "test.sv"
endpackage

