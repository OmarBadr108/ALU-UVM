`include "uvm_macros.svh"

package alu_driver_pkg;

import uvm_pkg::* ;
import alu_sequence_item_pkg::* ;

	

class alu_driver extends uvm_driver#(alu_sequence_item) ;
	// declare the neccessary uvm macros to register in the uvm classes !
	`uvm_component_utils(alu_driver)

	virtual alu_interface inf ;
	alu_sequence_item item ;

	//------------------------------------------------------------------------------
	// constructor 
	//------------------------------------------------------------------------------
	function new (string name = "alu_driver" ,uvm_component parent);
		super.new(name,parent);
		`uvm_info("DRIVER CLASS","Inside constructor",UVM_HIGH);
	endfunction : new

	//------------------------------------------------------------------------------
	// build phase
	//------------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("DRIVER CLASS","build_phase",UVM_HIGH);
		// getting the interface with safety check
		if (!(uvm_config_db#(virtual alu_interface)::get(this, "*", "inf", inf))) begin 
			`uvm_fatal("DRIVER_CLASS","Failed to get inf from config DB !");
		end 
	endfunction : build_phase

	//------------------------------------------------------------------------------
	// run phase
	//------------------------------------------------------------------------------
	// note that that the run phase is implemented as a task as it can consume time
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		// build phase logic
		`uvm_info("DRIVER CLASS","Run phase",UVM_HIGH);
		forever begin 
			item = alu_sequence_item::type_id::create("item",this);

			// getting the packet (item)
			seq_item_port.get_next_item(item);

			// driving the packet via task
			drive();
			
			// end of sending packet
			`uvm_info("DRIVER CLASS","Finished Driving",UVM_HIGH);
			seq_item_port.item_done(item);
		end 

	endtask : run_phase

	//------------------------------------------------------------------------------
	// Drive task
	//------------------------------------------------------------------------------
	
	task drive(); // passing by refference since i'm passing an object
		begin 
			@(negedge  inf.clock);
			inf.reset <= item.reset ;
			inf.A <= item.A ;
			inf.B <= item.B ;
			inf.op_code <= item.op_code ;
			`uvm_info("DRIVER CLASS","Driving Stimulus",UVM_HIGH);
		end 
	endtask : drive


endclass : alu_driver

endpackage : alu_driver_pkg