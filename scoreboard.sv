`include "uvm_macros.svh"

package alu_scoreboard;
	import uvm_pkg::* ;
	import alu_sequence_item_pkg::* ;

class alu_scoreboard extends uvm_scoreboard ;
	// declare the neccessary uvm macros to register in the uvm classes !
	`uvm_component_utils(alu_scoreboard)

	uvm_analysis_export   #(alu_sequence_item) scoreboard_export ;	
	uvm_tlm_analysis_fifo #(alu_sequence_item) scoreboard_fifo   ;
	

	// virtual interface 
	virtual alu_interface inf ;

	alu_sequence_item curr_trans ;

	//---------------------------------------------------------------------------------
	// constructor
	//---------------------------------------------------------------------------------

	function new (string name = "alu_scoreboard" ,uvm_component parent);
		super.new(name,parent);
		`uvm_info("SCB_CLASS","Inside constructor",UVM_HIGH);
	endfunction : new

	//---------------------------------------------------------------------------------
	// build phase
	//---------------------------------------------------------------------------------

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("SCB_CLASS ","build_phase",UVM_HIGH);

		scoreboard_export = new("scoreboard_export",this);
		scoreboard_fifo   = new("scoreboard_fifo"  ,this);

		// new .. hwa 3amlha ordinary allocation using new ,, idk why he didn't use type_id here .. we'll figure out inshallah
		curr_trans 		  = new("curr_trans");

		// getting the innterface with safety check
		if (!uvm_config_db #(virtual alu_interface) :: get (this,"*","inf",inf)) begin 
			`uvm_fatal("SCB_CLASS","CANT GET THE INTERFACE FROM DB")
		end 

		`uvm_info("SCB_CLASS","END OF BUILD PHASE",UVM_HIGH)
	endfunction : build_phase

	//---------------------------------------------------------------------------------
	// connect phase
	//---------------------------------------------------------------------------------

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		scoreboard_export.connect(scoreboard_fifo.analysis_export);

		`uvm_info("SCB_CLASS","connect_phase phase",UVM_HIGH);
	endfunction : connect_phase


/*
	function void end_of_elaboration_phase (uvm_phase phase);
  		super.end_of_elaboration_phase (phase);                         
	endfunction
*/

	//---------------------------------------------------------------------------------
	// run phase
	//---------------------------------------------------------------------------------

	// note that that the run phase is implemented as a task as it can consume time
	task run_phase(uvm_phase phase);
	begin 
		super.run_phase(phase);
	
		// build phase logic
		`uvm_info(get_type_name() ,"RUN phase",UVM_HIGH);

		forever begin 

			// get the packet from the fifo 
			`uvm_info("SCB_CLASS","GETTING the packet from the FIFO ",UVM_HIGH);
			scoreboard_fifo.get(curr_trans);
			`uvm_info("SCB_CLASS","GOT the packet from the FIFO ",UVM_HIGH);
			compare(curr_trans);

		end 
	end
	endtask : run_phase



	
	//---------------------------------------------------------------------------------
	// Compare : generated expected Result and compare with actual
	//---------------------------------------------------------------------------------

	task compare(input alu_sequence_item curr_trans_task);
	begin 
		

		logic [7:0] expected , actual ;
		logic 	 	Cout_expected , Cout_actual ;
		`uvm_info("SCB_CLASS","start of the comparison",UVM_HIGH);
		case (curr_trans_task.op_code) 
			0 : begin // A + B
				{Cout_expected,expected} = curr_trans_task.A + curr_trans_task.B ;
			end 

			1 : begin // A - B
				{Cout_expected,expected} = curr_trans_task.A - curr_trans_task.B ;
			end 

			2 : begin // A * B
				{Cout_expected,expected} = curr_trans_task.A * curr_trans_task.B ;
			end

			3 : begin // A / B
				{Cout_expected,expected} = curr_trans_task.A / curr_trans_task.B ;
			end

		endcase

		// actual signals .. not mandatory but for better readability
		actual = curr_trans_task.result ;
		Cout_actual = curr_trans_task.CarryOut ;

		if ((actual != expected) || (Cout_expected != Cout_actual)) begin 
			`uvm_error("compare",$sformatf("transaction failed A = %b , B = %b Cout = %b , opcode = %b actual = %b while expected = %b",curr_trans_task.A , curr_trans_task.B , curr_trans_task.CarryOut , curr_trans_task.op_code , {Cout_actual, actual},{Cout_expected, expected}))
		end 
		else begin 
			`uvm_info("compare",$sformatf("transaction Passed actual = %b while expected = %b",{Cout_actual, actual},{Cout_expected, expected}),UVM_HIGH)
		end 
	end 

	endtask : compare



/*
	// new
	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
	endfunction


	// new
	function void final_phase (uvm_phase phase);
		super.final_phase(phase);
	endfunction

*/

endclass : alu_scoreboard


endpackage : alu_scoreboard