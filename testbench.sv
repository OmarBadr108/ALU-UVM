`timescale 1ns /1ps 
`include "uvm_macros.svh"
 import uvm_pkg::* ;
 import alu_test_pkg::*;
 
//--------------------------------------------------------------------------------//

module top ;

	logic clock ;




//------------------------------------
// Interface
//------------------------------------

	alu_interface inf(clock);

//------------------------------------
// DUT
//------------------------------------
	alu dut(
		.clock(clock),
		.reset(inf.reset),
		.A(inf.A),
		.B(inf.B),
		.ALU_Sel(inf.op_code),
		.ALU_Out(inf.result),
		.CarryOut(inf.CarryOut)
	);
	



//------------------------------------
// clk generation
//------------------------------------
	initial begin 
		clock = 0 ;
		#5;
		forever begin 
			#2 clock = ! clock ;
		end 
	end 

	// to limit the simulation 
	initial begin 
		#5000;
		$display("Sorry! Ran out of clock cycles!");
		$stop();
	end 

	// for waveforms
	initial begin 
		$dumpfile("alu_design.vcd");
		$dumpvars();
	end 

	initial begin 
	// setting the virtual interface handle
	// uvm_config_db #(Data Type) :: set ("caller handle >> none if called from the top testbecnh" , "path if i want to specify who can get what i'm setting" ,"Name" , value or instance);
		uvm_config_db #(virtual alu_interface)::set(null,"*","inf",inf);
		
		// running test from data base
		run_test("alu_test");
	end 
	

endmodule : top



