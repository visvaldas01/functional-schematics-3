`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2023 18:13:23
// Design Name: 
// Module Name: segm7
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module segm7(
    input rst_i,
    input clk_i,
    input start_i,
    input [15:0] res, 

    output reg [7:0] an,
    output reg [6:0] seg
    );

    reg [1:0] cnt = 2'b00;
    reg [2:0] state = 1'b0;

    localparam IDLE = 1'b0;
    localparam WORK = 1'b1;

    always @(posedge clk_i) begin
        if (~rst_i) begin
            state <= IDLE;
            an <= 8'b11110000;
            seg <= calc(4'b0000);
        end else begin
            case (state)
                IDLE:
                    if (start_i) begin
                        state <= WORK;
                    end
                WORK:
                    case (cnt)
                        0: begin
                            an <= 8'b11111110;
                            seg <= calc(res[3:0]);
                        end    
                        1: begin
                            an <= 8'b11111101;
                            seg <= calc(res[7:4]);
                        end 
                        2: begin
                            an <= 8'b11111011;
                            seg <= calc(res[11:8]);
                        end 
                        3: begin
                            an <= 8'b11110111;
                            seg <= calc(res[15:12]);
                        end
                    endcase
            endcase
        end
    end


    always @(posedge clk_i) begin   
        cnt <= cnt + 1;        
    end  

    function [7:0] calc;
        input [3:0] num_i;
            begin
                case (num_i)
                    4'b0000: begin
                        calc = 7'b0000001;
                    end   

                    4'b0001: begin
                        calc = 7'b1001111;
                    end   
                    
                    4'b0010: begin
                        calc = 7'b0010010;
                    end   

                    4'b0011: begin
                        calc = 7'b0000110;
                    end   
                    
                    4'b0100: begin
                        calc = 7'b1001100;
                    end   
                    
                    4'b0101: begin
                        calc = 7'b0100100;
                    end   
                    
                    4'b0110: begin
                        calc = 7'b0100000;
                    end   
                    
                    4'b0111: begin
                        calc = 7'b0001111;
                    end   

                    4'b1000: begin
                        calc = 7'b0000000;
                    end   

                    4'b1001: begin
                        calc = 7'b0000100;
                    end   

                    4'b1010: begin
                        calc = 7'b0001000;
                    end   

                    4'b1011: begin
                        calc = 7'b1100000;
                    end   

                    4'b1100: begin
                        calc = 7'b0110001;
                    end   

                    4'b1101: begin
                        calc = 7'b1000010;
                    end   

                    4'b1110: begin
                        calc = 7'b0110000;
                    end   

                    4'b1111: begin
                        calc = 7'b0111000;
                    end   
                endcase 
            end    
    endfunction

endmodule
