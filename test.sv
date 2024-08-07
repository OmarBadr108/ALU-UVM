`include "uvm_macros.svh"
package alu_test_pkg;

import uvm_pkg::* ;
import alu_env_pkg::* ;
import alu_sequence_item_pkg::* ;
import alu_sequence_pkg::* ;

class alu_test extends uvm_test ;
	// declare the neccessary uvm macros to register in the uvm classes !
	`uvm_component_utils(alu_test)

	alu_env env ;
	alu_base_sequence reset_seq ;
	alu_test_sequence test_seq ;

	// constructor 
	function new (string name = "alu_test" ,uvm_component parent);
		super.new(name,parent);
		`uvm_info("TEST CLASS","Inside constructor",UVM_HIGH)
	endfunction : new


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("TEST CLASS","build_phase",UVM_HIGH)
		// create method with heirarchy of test contains env
		env = alu_env :: type_id :: create("env",this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("TEST CLASS","connect_phase phase",UVM_HIGH)

		// connect monitor with scoreboard 

	endfunction : connect_phase


	// note that that the run phase is implemented as a task as it can consume time
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
	
		// build phase logic
		`uvm_info("TEST CLASS","RUN phase",UVM_HIGH)

		phase.raise_objection(this);
			// reset seq
			reset_seq = alu_base_sequence :: type_id :: create("reset_seq"); // second argument can be put "null" or left to take the default value which is null too 
			reset_seq.start(env.agent.seqr); // takes the path of the sequence
			#10 ;
		`uvm_info("TEST CLASS","END OF RST SEQUENCE",UVM_HIGH)
			// test sequence
			repeat(100) begin 
				test_seq = alu_test_sequence :: type_id :: create("test_seq");// second argument can be put "null" or left to take the default value which is null too
				test_seq.start(env.agent.seqr); // takes the path of the sequence
				#10 ;
			end 

		`uvm_info("TEST CLASS","END of RUN phase",UVM_HIGH)
		// drop objection to indicate the ending of the test
		phase.drop_objection(this);

	endtask : run_phase

endclass : alu_test

endpackage : alu_test_pkg