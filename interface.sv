interface alu_interface (input logic clock);
	
	logic       reset ;
	logic [7:0] A , B ;
	logic [3:0] op_code ;
	logic [7:0] result ;
	bit 	    CarryOut ;

endinterface : alu_interface