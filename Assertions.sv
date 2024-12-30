`timescale 1ns /1ps 

module alu_assertions (

    input       clock   , 
    input       reset   ,
    input  [7:0] A       ,
    input  [7:0] B       ,
    input [3:0] ALU_Sel ,
    input [7:0] ALU_Out ,
    input       CarryOut
    );



    property Division_safety_check ;

        @(posedge clock) disable iff(reset) (ALU_Sel == 4'd3) |->  (B != 8'd0) ; 

    endproperty

    chk_Division_safety_check : assert property(Division_safety_check) $display($stime,,,"\t\t %m PASS"); else $display("Error");
    cvg_Division_safety_check : cover  property(Division_safety_check) ;

    property A_is_Greater_or_Equal_B ;

        @(posedge clock) disable iff(reset) (ALU_Sel == 4'd0 
                                          || ALU_Sel == 4'd1 
                                          || ALU_Sel == 4'd2 
                                          || ALU_Sel == 4'd3 ) |->  (A >= B) ; 

    endproperty

    chk_A_is_Greater_or_Equal_B : assert property(A_is_Greater_or_Equal_B) $display($stime,,,"\t\t %m PASS"); else $display("Error");
    cvg_A_is_Greater_or_Equal_B : cover  property(A_is_Greater_or_Equal_B) ;

endmodule
