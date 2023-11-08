`timescale 1ns / 1ps

`define NOP         7'b0000001
`define ADD         7'b0000010
`define ADDF        7'b0000011
`define SUB         7'b0000100
`define SUBF        7'b0000101
`define AND         7'b0000110
`define OR          7'b0000110
`define XOR         7'b0001000
`define NAND        7'b0001001
`define NOR         7'b0001010
`define NXOR        7'b0001011
`define SHIFTR      7'b0001100
`define SHIFTRA     7'b0001101
`define SHIFTL      7'b0001110
`define LOAD        7'b0001111
`define LOADC       7'b0010000
`define STORE       7'b0010001
`define JMP         7'b0010010
`define JMPR        7'b0010011
`define JMPcond     7'b0010100
`define JMPRcond    7'b0010101 
`define HALT        7'b0010110

`define D_SIZE 32
`define A_SIZE 10

`define R0 3'd0
`define R1 3'd1
`define R2 3'd2
`define R3 3'd3
`define R4 3'd4
`define R5 3'd5
`define R6 3'd6
`define R7 3'd7 
`define Rresult 3'd0
    
module Simulation();

   reg clk_tb;
   reg rst_tb;
   reg [15:0] instruction_tb;
   
//   wire [`A_SIZE-1:0] pc_tb;
   wire [`A_SIZE-1:0] pc_tb;
   // Clock generator
   initial
   begin
   
        clk_tb = 1'b1;
        forever #5  clk_tb = ~clk_tb; // Toggle clock every 5 ticks
    
   end  
   
   initial 
   begin
        instruction_tb = 0;
        #10
        instruction_tb = {`ADD, `Rresult, `R1, `R2};
        if (instruction_tb <= 1226) begin
            $display ("ADD correct");
         end
         else begin
            $display ("ADD wrong");
         end 
          
        #15
        instruction_tb = {`SUB, `R1, `R2, `R1};
        if (instruction_tb <= 2129) begin
            $display ("SUB correct");
         end
         else begin
            $display ("SUB wrong");
         end
   end
   
   initial 
   begin 
       rst_tb = 0;
       #10
       rst_tb = 1;
   end    
   //Initialize variables
   initial begin
   $display ("time\t clk reset enable counter");	
   $monitor ("%g\t %b   %b     %b", $time, clk_tb, rst_tb, pc_tb);	 
   #100 $finish;   
   end
    
   Golden_Model gm(
   // Input
    .rst(rst_tb),
    .clk(clk_tb),
    .instruction(instruction_tb),
    
    // Output
    .pc(pc_tb)
    );
       
endmodule
