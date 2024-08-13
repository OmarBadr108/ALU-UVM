`include "uvm_macros.svh"


package alu_subscriber;
	import uvm_pkg::* ;
	import alu_sequence_item_pkg::* ;

class alu_subscriber extends uvm_component ;
	// declare the neccessary uvm macros to register in the uvm classes !
	`uvm_component_utils(alu_subscriber)

	uvm_analysis_export   #(alu_sequence_item) sub_export ;	
	uvm_tlm_analysis_fifo #(alu_sequence_item) sub_fifo   ;
	
	// virtual interface 
	virtual alu_interface inf ;

	alu_sequence_item curr_trans ;


	//---------------------------------------------------------------------------------
	// Cover Groupe
	//---------------------------------------------------------------------------------

	covergroup Inputs;

		in_A : coverpoint inf.A  iff (!(inf.reset)) 
		{ 
			bins extreme_low  = {8'h00};
			bins low      [3] = {[8'd1:8'd85]};
			bins Medium   [3] = {[8'd86:8'd170]};
			bins High     [3] = {[8'd171:8'd254]};
			bins extreme_high = {8'hFF}; 
		} 

		in_B : coverpoint inf.B iff (!(inf.reset)) 
		{
			bins extreme_low  = {8'h00}; // there is a spec that B has to be always less than A 
			bins low      [3] = {[8'd1:8'd85]};
			bins Medium   [3] = {[8'd86:8'd170]};
			bins High     [3] = {[8'd171:8'd254]};
			bins extreme_high = {8'hFF}; 
		}
 
		reset : coverpoint inf.reset 
		{
			bins active     = {1};
			bins not_active = {0};
		}

		op_code : coverpoint inf.op_code  iff (!(inf.reset))
		{
			bins add = {4'b0000};
			bins sub = {4'b0001};
			bins mul = {4'b0010};
			bins div = {4'b0011};
			illegal_bins reserved = {[4'b0100:4'b1111]} ;
		}

	endgroup : Inputs


	covergroup Outputs ;
		Result : coverpoint inf.result iff (!(inf.reset))
		{
			bins extreme_low = {8'd0};
			bins low      [3] = {[8'd1:8'd85]};
			bins Medium   [3] = {[8'd86:8'd170]};
			bins High     [3] = {[8'd171:8'd254]};
			bins extreme_high = {8'hFF};
		}

		Result_at_reset : coverpoint inf.result iff (inf.reset)
		{
			bins safe_reset_value = {8'h00,8'hFF};
		}

		Cout : coverpoint inf.CarryOut iff (!(inf.reset))
		{
			bins Cout_one  = {1} ;
			bins Cout_zero = {0} ;
		}

		Cout_at_reset : coverpoint inf.CarryOut iff (inf.reset)
		{
			bins Cout_rst_val  = {0} ;

		}

		
	endgroup : Outputs

	

	//---------------------------------------------------------------------------------
	// build phase
	//---------------------------------------------------------------------------------

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sub_export = new("sub_export",this);
		sub_fifo   = new("sub_fifo"  ,this);
		curr_trans = new("curr_trans");

		// getting the innterface with safety check
		if (!uvm_config_db #(virtual alu_interface) :: get (this,"*","inf",inf)) begin 
			`uvm_fatal("SUBSCRIBER_CLASS","CAN'T GET THE INTERFACE FROM DB")
		end 

		`uvm_info("SUBSCRIBER_CLASS ","build_phase",UVM_HIGH);
	endfunction : build_phase

	//---------------------------------------------------------------------------------
	// connect phase
	//---------------------------------------------------------------------------------

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		sub_export.connect(sub_fifo.analysis_export);
		`uvm_info("SUBSCRIBER_CLASS","connect_phase phase",UVM_HIGH);
	endfunction : connect_phase



	//---------------------------------------------------------------------------------
	// constructor
	//---------------------------------------------------------------------------------

	function new (string name = "alu_subscriber" ,uvm_component parent);
		super.new(name,parent);
		Inputs  = new();
		Outputs = new();
		`uvm_info("SUBSCRIBER_CLASS","Inside constructor",UVM_HIGH);
	endfunction : new


	//---------------------------------------------------------------------------------
	// run phase
	//---------------------------------------------------------------------------------

	// note that that the run phase is implemented as a task as it can consume time
	task run_phase(uvm_phase phase);
	begin 
		super.run_phase(phase);
		`uvm_info(get_type_name() ,"RUN phase",UVM_HIGH);
		forever begin 
			sub_fifo.get(curr_trans);
			`uvm_info(get_type_name() ,"Subscriber is capturing",UVM_HIGH);
			Inputs.sample();
			Outputs.sample();
		end 
	end
	endtask : run_phase

	
	



endclass : alu_subscriber


endpackage : alu_subscriber