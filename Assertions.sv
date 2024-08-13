`timescale 1ns /1ps 

module alu_assertions (

    input       clock   , 
    input       reset   ,
    input [7:0] A       ,
    input [7:0] B       ,
    input [3:0] ALU_Sel ,
    input [7:0] ALU_Out ,
    input       CarryOut
    );



    property Division_safety_check ;

        @(posedge clock) disable iff(reset) (ALU_Sel == 4'd3) |->  (B != 8'd0) ; 

    endproperty

    chk_Division_safety_check : assert property(Division_safety_check) $display($stime,,,"\t\t %m PASS"); else $display("Error");
    cvg_Division_safety_check : cover  property(Division_safety_check) ;



endmodule
