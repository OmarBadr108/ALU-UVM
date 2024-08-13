`include "uvm_macros.svh"

package alu_sequence_pkg;

import uvm_pkg::* ;
import alu_sequence_item_pkg::* ;


	

// object not a component
class alu_base_sequence extends uvm_sequence ;
	`uvm_object_utils(alu_base_sequence)


	alu_sequence_item reset_pkt ;

	function new (string name = "alu_base_sequence");
		super.new(name);
		`uvm_info("RST_SEQ" , "Inside Costructor",UVM_HIGH)
	endfunction : new

	task body ();
		reset_pkt = alu_sequence_item::type_id::create("reset_pkt");
		`uvm_info("RST_SEQ","Inside Body Task",UVM_HIGH)
		
		start_item(reset_pkt);
		reset_pkt.randomize() with {reset == 1;};
		finish_item(reset_pkt);

		`uvm_info("RST_SEQ","AFTER FINISHING ",UVM_HIGH)
	endtask : body


endclass : alu_base_sequence	

//---------------------------------------------------------------------------------
// test sequence class 
//---------------------------------------------------------------------------------

class alu_test_sequence extends alu_base_sequence ;
	`uvm_object_utils(alu_test_sequence)


	alu_sequence_item item ;

	function new (string name = "alu_test_sequence");
		super.new(name);
		`uvm_info("TEST_SEQ" , "Inside Costructor",UVM_HIGH)
	endfunction : new

	task body ();
		`uvm_info("TEST_SEQ","Inside Body Task",UVM_HIGH)

		item = alu_sequence_item::type_id::create("item");

		start_item(item);
		assert(item.randomize() with {reset == 0;});
		finish_item(item);

		`uvm_info("TEST_SEQ","AFTER FINISHING ",UVM_HIGH)

	endtask : body


endclass : alu_test_sequence


endpackage : alu_sequence_pkg
