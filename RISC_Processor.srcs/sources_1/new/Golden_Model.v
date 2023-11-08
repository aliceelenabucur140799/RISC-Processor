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


module Golden_Model(
    // general
    input rst,   // active 0
    input clk,
    // program memory
    output reg [`A_SIZE-1:0] pc,
    input [15:0] instruction,
    // data memory
    output reg read,  // active 1
    output reg write, // active 1
    output [`A_SIZE-1:0] address,
    input  [`D_SIZE-1:0] data_in,
    output [`D_SIZE-1:0] data_out
    );
    
    reg [15:0] a [0:7];
    integer i;
    
    
    always@(posedge clk) begin
     
     // Conditie de reset
         if (~rst) begin
            pc <= 0;
            for (i = 0; i < 8; i = i + 1) begin
                a[i] <= 0;
            end
         end 
         else begin
             case (instruction [15:9])
                
                `NOP: 
                 begin
                    read <= 0;
                    write <= 0;
                    pc <= pc + 1;
                    $display ("NOP"); 
                 end 

                 `ADD:
                  begin
                    read <= 0;
                    write <= 0; 
                    a[instruction[8:6]] <= a[instruction[5:3]] + a[instruction[2:0]];
                    pc <= pc + 1;
                    $display ("ADD");
                  end
                  
                  `SUB:
                  begin
                    read <= 0;
                    write <= 0; 
                    a[instruction[8:6]] <= a[instruction[5:3]] - a[instruction[2:0]];
                    pc <= pc + 1;
                    $display ("SUB");
                  end
                  
                  `SUBF:
                  begin
                    read <= 0;
                    write <= 0; 
                    a[instruction[8:6]] <= a[instruction[5:3]] - a[instruction[2:0]];
                    pc <= pc + 1;
                    $display ("SUBF");
                  end
                  
                  `AND:
                  begin
                    read <= 0;
                    write <= 0; 
                    a[instruction[8:6]] <= a[instruction[5:3]] & a[instruction[2:0]];
                    pc <= pc + 1;
                    $display ("AND");
                  end
                  
                  `OR:
                  begin
                    read <= 0;
                    write <= 0; 
                    a[instruction[8:6]] <= a[instruction[5:3]] | a[instruction[2:0]];
                    pc <= pc + 1;
                    $display ("OR");
                  end
                  
                  `XOR:
                  begin
                    read <= 0;
                    write <= 0; 
                    a[instruction[8:6]] <= a[instruction[5:3]] ^ a[instruction[2:0]];
                    pc <= pc + 1;
                    $display ("XOR");
                  end
                  
                  `NAND:
                  begin
                    read <= 0;
                    write <= 0; 
                    a[instruction[8:6]] <= ~(a[instruction[5:3]] & a[instruction[2:0]]);
                    pc <= pc + 1;
                    $display ("NAND");
                  end
                  
                  `NOR:
                  begin
                    read <= 0;
                    write <= 0; 
                    a[instruction[8:6]] <= ~(a[instruction[5:3]] | a[instruction[2:0]]);
                    pc <= pc + 1;
                    $display ("NOR");
                  end
                  
                  `NXOR:
                  begin 
                    read <= 0;
                    write <= 0;
                    a[instruction[8:6]] <= ~(a[instruction[5:3]] ^ a[instruction[2:0]]);
                    pc <= pc + 1;
                    $display ("NXOR");
                  end
                  
                  `SHIFTR:
                  begin 
                    read <= 0;
                    write <= 0;
                    a[instruction[8:6]] <= a[instruction[8:6]] >> a[instruction[5:0]];
                    pc <= pc + 1;
                    $display ("SHIFTR");
                  end
                  
                  `SHIFTRA:
                  begin 
                    read <= 0;
                    write <= 0;
                    a[instruction[8:6]] <= a[instruction[8:6]] >>> a[instruction[5:0]];
                    pc <= pc + 1;
                    $display ("SHIFTRA");
                  end
                  
                  `SHIFTL:
                  begin 
                    read <= 0;
                    write <= 0;
                    a[instruction[8:6]] <= a[instruction[8:6]] << a[instruction[5:0]];
                    pc <= pc + 1;
                    $display ("SHIFTL");
                  end
                  
                  `LOAD:
                  begin
                    read <= 1;
                    write <= 0;
                    pc <= pc + 1;
                  end 
                  
                  `LOADC:
                  begin
                    read <= 0;
                    write <= 0;
                    a[instruction[10:8]] <= instruction[10:0];
                    pc <= pc + 1;
                  end 
                  
                  `STORE:
                  begin
                    read <= 0;
                    write <= 1;
                    pc <= pc + 1;
                  end 
                  
                  `JMP:
                  begin
                    read <= 0;
                    write <= 0;
                    pc <= a[instruction[2:0]];
                    $display ("JMP");
                  end 
                  
                  `JMPR:
                  begin
                    read <= 0;
                    write <= 0;
                    pc <= pc + a[instruction[5:0]];
                    $display ("JMPR");
                  end 
                  
                  `JMPcond:
                  begin
                    read <= 0;
                    write <= 0;
                    if (a[instruction[11:9]] == 3'b000) begin
                        if (a[instruction[8:6]] < 0) begin
                            pc <= a[instruction[2:0]];
                        end
                    end
                    
                    else if (a[instruction[11:9]] == 3'b001) begin
                        if (a[instruction[8:6]] >= 0) begin
                            pc <= a[instruction[2:0]];
                        end
                    end
                    
                    else if (a[instruction[11:9]] == 3'b010) begin
                        if (a[instruction[8:6]] == 0) begin
                            pc <= a[instruction[2:0]];
                        end
                    end
                    
                    else if (a[instruction[11:9]] == 3'b011) begin
                        if (a[instruction[8:6]] != 0) begin
                            pc <= a[instruction[2:0]];
                        end
                    end
                    
                    else if (a[instruction[11:9]] == 3'b1xx) begin
                        pc <= pc + 1;
                    end
                    
                    $display ("JMPcond");
                    
                  end 
                  
                  `JMPRcond:
                  begin
                    read <= 0;
                    write <= 0;
                    if (a[instruction[11:9]] == 3'b000) begin
                        if (a[instruction[8:6]] < 0) begin
                            pc <= a[instruction[2:0]] + a[instruction[5:0]];
                        end
                    end
                    
                    else if (a[instruction[11:9]] == 3'b001) begin
                        if (a[instruction[8:6]] >= 0) begin
                            pc <= a[instruction[2:0]] + a[instruction[5:0]];
                        end
                    end
                    
                    else if (a[instruction[11:9]] == 3'b010) begin
                        if (a[instruction[8:6]] == 0) begin
                            pc <= a[instruction[2:0]]+ a[instruction[5:0]];
                        end
                    end
                    
                    else if (a[instruction[11:9]] == 3'b011) begin
                        if (a[instruction[8:6]] != 0) begin
                            pc <= a[instruction[2:0]] + a[instruction[5:0]];
                        end
                    end
                    
                    else if (a[instruction[11:9]] == 3'b1xx) begin
                        pc <= pc + 1;
                    end
                    
                    $display ("JMPRcond");
                    
                  end 
                  
                  `HALT:
                  begin
                    read <= 0;
                    write <= 0;
                    $display ("HALT");
                  end 
        
                  default:
                  begin
                    read <= 0;
                    write <= 0;
                    pc <= pc + 1;
                    $display ("Panik");
                  end
                
            endcase
         end
     end   
endmodule
