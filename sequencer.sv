`include "uvm_macros.svh"
package alu_sequencer_pkg;

import uvm_pkg::* ;
import alu_sequence_item_pkg::* ;

	

class alu_sequencer extends uvm_sequencer#(alu_sequence_item) ;
	// declare the neccessary uvm macros to register in the uvm classes !
	`uvm_component_utils(alu_sequencer)

	// constructor 
	function new (string name = "alu_sequencer" ,uvm_component parent);
		super.new(name,parent);
		`uvm_info("SEQUENCER CLASS","Inside constructor",UVM_HIGH);
	endfunction : new

	//------------------------------------------------------------------------------
	// build phase
	//------------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("SEQUENCER CLASS","build_phase",UVM_HIGH);
	endfunction : build_phase

	//------------------------------------------------------------------------------
	// connect phase
	//------------------------------------------------------------------------------
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("SEQUENCER CLASS","connect_phase phase",UVM_HIGH);
	endfunction : connect_phase

	//------------------------------------------------------------------------------
	// run phase
	//------------------------------------------------------------------------------
	// note that that the run phase is implemented as a task as it can consume time
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
	endtask : run_phase

endclass : alu_sequencer

endpackage : alu_sequencer_pkg