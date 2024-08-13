`include "uvm_macros.svh"

//--------------------------------------------------------------------------------// 

package alu_sequence_item_pkg ;
import uvm_pkg::* ;

// object not a component
class alu_sequence_item extends uvm_sequence_item ;
  `uvm_object_utils(alu_sequence_item)

	//------------------------------------------------------------------------------
	// signals
	//------------------------------------------------------------------------------
	rand logic       reset ;
	rand logic [7:0] A ;
	rand logic [7:0] B ;
	rand logic [3:0] op_code ;
	
	logic [7:0] result ;
	bit 	    CarryOut ;


	//------------------------------------------------------------------------------
	// default constrains
	//------------------------------------------------------------------------------
	constraint input_1_c {
		A >= B ; // A can never get the value 0 , where B can never get the value 255

		if (op_code == 4'd3) {B != 8'd0}; // at division , B can't take the value zero
	} 

	constraint op_code_c { op_code inside {[0:3]};}


	//------------------------------------------------------------------------------
	// build phase (constructor)
	//------------------------------------------------------------------------------
	function new (string name = "alu_sequence_item");
		super.new(name);
	endfunction : new


endclass : alu_sequence_item

endpackage : alu_sequence_item_pkg