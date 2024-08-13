`include "uvm_macros.svh"
package alu_env_pkg;
import uvm_pkg::* ;

import alu_agent_pkg::* ;
import alu_scoreboard::* ; 
import alu_subscriber::* ;

class alu_env extends uvm_env ;
	// declare the neccessary uvm macros to register in the uvm classes !
	`uvm_component_utils(alu_env)

	alu_agent agent ;
	alu_scoreboard scb ;
	alu_subscriber subs ;

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
		`uvm_info("ENV CLASS","BUILD PHASE is running ..",UVM_HIGH);
		// create method with heirarchy of env contains agent
		agent = alu_agent      :: type_id :: create("agent",this);
		scb   = alu_scoreboard :: type_id :: create("scb"  ,this);
		subs  = alu_subscriber :: type_id :: create("subs" ,this);
		`uvm_info("ENV CLASS","BUILD PHASE is done"       ,UVM_HIGH);
	endfunction : build_phase

	//------------------------------------------------------------------------------
	// connect phase
	//------------------------------------------------------------------------------
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("ENV CLASS","CONNNECT PHASE is running ..",UVM_HIGH);
		agent.agent_port.connect(scb.scoreboard_export);
		agent.agent_port.connect(subs.sub_export);
		`uvm_info("ENV CLASS","connect_phase is done"       ,UVM_HIGH);	
	endfunction : connect_phase

endclass : alu_env
endpackage : alu_env_pkg