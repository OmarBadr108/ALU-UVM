`include "uvm_macros.svh"

// object not a component
package alu_scoreboard;
	import uvm_pkg::* ;
	import alu_sequence_item_pkg::* ;

class alu_scoreboard extends uvm_scoreboard ;
	// declare the neccessary uvm macros to register in the uvm classes !
	`uvm_component_utils(alu_scoreboard)

	// implementation is taking 2 arguments as it connects two ports .. i think so 
	// the name "implement" as we implement the method write below 
	//uvm_analysis_imp #(alu_sequence_item, alu_scoreboard) scoreboard_port ;
		
	// new
		
	uvm_tlm_analysis_fifo #(alu_sequence_item) scoreboard_fifo   ;
	uvm_analysis_export   #(alu_sequence_item) scoreboard_export ;


	// virtual interface 
	virtual alu_interface inf ;


	alu_sequence_item transactions[$];
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
		//transactions      = alu_sequence_item :: type_id :: create("transactions",this) ;
		//transactions      = new ("transactions") ;
		curr_trans        = alu_sequence_item :: type_id :: create("curr_trans",this) ;
		// getting the innterface with safety check
		if (!uvm_config_db #(virtual alu_interface) :: get (this,"*","inf",inf)) begin 
			`uvm_fatal("SCOREBOARD","CANT GET THE INTERFACE FROM DB")
		end 

		`uvm_info("SCOREBOARD","END OF BUILD PHASE",UVM_HIGH)
	endfunction : build_phase

	//---------------------------------------------------------------------------------
	// connect phase
	//---------------------------------------------------------------------------------

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		// new .. i have no idea what is this xD 
		scoreboard_export.connect(scoreboard_fifo.analysis_export);

		`uvm_info("SCB_CLASS","connect_phase phase",UVM_HIGH);
	endfunction : connect_phase


	// NEW .. no idea 
	function void end_of_elaboration_phase (uvm_phase phase);
  		super.end_of_elaboration_phase (phase);                         
	endfunction


	//---------------------------------------------------------------------------------
	// write method
	//---------------------------------------------------------------------------------
	function void write(alu_sequence_item item);
		transactions.push_back(item);
	endfunction : write


	//---------------------------------------------------------------------------------
	// run phase
	//---------------------------------------------------------------------------------

	// note that that the run phase is implemented as a task as it can consume time
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
	
		// build phase logic
		`uvm_info(get_type_name() ,"RUN phase",UVM_HIGH);

		forever begin 

			// get the packet
			// new .. no idea  
			$display("first :time = %0t , size = %0d",$time , transactions.size());
			scoreboard_fifo.get(curr_trans);

			$display("second :time = %0t , size = %0d",$time , transactions.size());
			wait((transactions.size() != 0));

			// generate expected value
			$display("third :time = %t",$time);
			curr_trans = transactions.pop_front() ; // it behaves as FIFO  

			// compare it with actual value 
			$display("fourth :time = %t",$time);
			compare(curr_trans);
			// store the transctions accordibgly 
			
		end 
	endtask : run_phase

	//---------------------------------------------------------------------------------
	// Compare : generated expected Result and compare with actual
	//---------------------------------------------------------------------------------

	task compare(alu_sequence_item curr_trans );
		logic [7:0] expected , actual ;
		logic 	 	Cout_expected , Cout_actual ;

		case (curr_trans.op_code) 
			0 : begin // A + B
				expected = curr_trans.A + curr_trans.B ;
				Cout_expected = curr_trans.CarryOut ;
			end 

			1 : begin // A - B
				expected = curr_trans.A - curr_trans.B ;
				Cout_expected = curr_trans.CarryOut ;
			end 

			2 : begin // A * B
				expected = curr_trans.A * curr_trans.B ;
				Cout_expected = curr_trans.CarryOut ;
			end

			3 : begin // A / B
				expected = curr_trans.A / curr_trans.B ;
				Cout_expected = curr_trans.CarryOut ;
			end

		endcase


		// actual 
		actual = curr_trans.result ;
		Cout_actual = curr_trans.CarryOut ;

		if ((actual != expected) || (Cout_expected != Cout_actual)) begin 
			`uvm_error("compare",$sformatf("transaction failed actual = %d while expected = %d",{Cout_actual, actual},{Cout_expected, expected}))

		end 
		else begin 
			`uvm_info("compare",$sformatf("transaction Passed actual = %d while expected = %d",{Cout_actual, actual},{Cout_expected, expected}),UVM_HIGH)
		end 


	endtask : compare



	// new
	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
	endfunction


	// new
	function void final_phase (uvm_phase phase);
		super.final_phase(phase);
	endfunction


endclass : alu_scoreboard


endpackage : alu_scoreboard