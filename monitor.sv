`include "uvm_macros.svh"
package alu_monitor_pkg;

import uvm_pkg::* ;
import alu_sequence_item_pkg::* ;

class alu_monitor extends uvm_monitor ;
	// declare the neccessary uvm macros to register in the uvm classes !
	`uvm_component_utils(alu_monitor)

	virtual alu_interface inf ;

	alu_sequence_item item ;

	uvm_analysis_port#(alu_sequence_item) monitor_port ;

	// constructor 
	function new (string name = "alu_monitor" ,uvm_component parent);
		super.new(name,parent);
		`uvm_info("MONITOR CLASS","Inside constructor",UVM_HIGH);
	endfunction : new

	//------------------------------------------------------------------------------
	// build phase
	//------------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// search for uvm verposity
		`uvm_info("MONITOR CLASS","build_phase",UVM_HIGH);

		// initializing the port 
		monitor_port = new("monitor_port",this);

		// getting the interface with safety check
		if (!(uvm_config_db#(virtual alu_interface)::get(this, "*", "inf", inf))) begin 
			`uvm_fatal("MONITOR_CLASS","Failed to get inf from config DB !");
		end 

	endfunction : build_phase


	//------------------------------------------------------------------------------
	// run phase
	//------------------------------------------------------------------------------
	// note that that the run phase is implemented as a task as it can consume time
	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		
		
		forever begin 
			item = alu_sequence_item::type_id::create("item");
			// make sure that we are not in the reset mode

			//wait(!inf.reset);
			`uvm_info("Monitor CLASS","Monitor is capturing ",UVM_HIGH);

			// sample the inputs 
			@(negedge inf.clock);
			item.A = inf.A ;
			item.B = inf.B ;
			item.op_code = inf.op_code ;

			// sample the outputs
			item.result = inf.result ;
			item.CarryOut = inf.CarryOut ;

			// send items to scoreboard
			monitor_port.write(item);
			`uvm_info("Monitor CLASS","Monitor is writing the packet into the port ",UVM_HIGH);
		end 

	endtask : run_phase

endclass : alu_monitor

endpackage : alu_monitor_pkg