`include "uvm_macros.svh"
package alu_env_pkg;

import uvm_pkg::* ;
import alu_agent_pkg::* ;
import alu_scoreboard::* ; 

class alu_env extends uvm_env ;
	// declare the neccessary uvm macros to register in the uvm classes !
	`uvm_component_utils(alu_env)

	alu_agent agent ;
	// for connection phase
	alu_scoreboard scb ;
	



	// constructor 
	function new (string name = "alu_env" ,uvm_component parent);
		super.new(name,parent);
		`uvm_info("ENV CLASS","Inside constructor",UVM_HIGH);
	endfunction : new

	//------------------------------------------------------------------------------
	// build phase
	//------------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("ENV CLASS","build_phase",UVM_HIGH);
		// create method with heirarchy of env contains agent
		agent = alu_agent      :: type_id :: create("agent",this);
		scb   = alu_scoreboard :: type_id :: create("scb"  ,this);
	endfunction : build_phase

	//------------------------------------------------------------------------------
	// connect phase
	//------------------------------------------------------------------------------
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("ENV CLASS","connect_phase phase",UVM_HIGH);
		//agent.mon.monitor_port.connect(scb.scoreboard_export);
		// new
		agent.agent_port.connect(scb.scoreboard_export);
	endfunction : connect_phase

	//------------------------------------------------------------------------------
	// run phase
	//------------------------------------------------------------------------------
	// note that that the run phase is implemented as a task as it can consume time
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
	
	endtask : run_phase
endclass : alu_env
endpackage : alu_env_pkg