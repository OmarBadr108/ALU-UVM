`include "uvm_macros.svh"
package alu_agent_pkg;

import uvm_pkg::* ;
import alu_driver_pkg::* ;
import alu_monitor_pkg::* ;
import alu_sequencer_pkg::* ;
import alu_sequence_item_pkg::*;

	

class alu_agent extends uvm_agent ;
	// declare the neccessary uvm macros to register in the uvm classes !
	`uvm_component_utils(alu_agent)

	// port declarations 
	uvm_analysis_port #(alu_sequence_item) agent_port ;

	alu_driver drv ;
	alu_monitor mon ;
	alu_sequencer seqr ;


	// constructor 
	function new (string name = "alu_agent" ,uvm_component parent);
		super.new(name,parent);
		`uvm_info("AGENT CLASS","Inside constructor",UVM_HIGH);
	endfunction : new

	//------------------------------------------------------------------------------
	// build phase
	//------------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		drv = alu_driver::type_id::create("drv",this);
		mon = alu_monitor::type_id::create("mon",this);
		seqr = alu_sequencer::type_id::create("seqr",this);

		// allocating the agent port 
		agent_port = new("agent_port",this);

		`uvm_info("AGENT CLASS","build_phase",UVM_HIGH);
	endfunction : build_phase

	//------------------------------------------------------------------------------
	// connect phase
	//------------------------------------------------------------------------------
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		// handshake between sequencer and driver (Port and export)
		drv.seq_item_port.connect(seqr.seq_item_export);

		// (connecting heririchal analysis ports)
		mon.monitor_port.connect(agent_port);

		`uvm_info("AGENT CLASS","connect_phase phase",UVM_HIGH);
	endfunction : connect_phase

endclass : alu_agent

endpackage : alu_agent_pkg