`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2023 14:07:05
// Design Name: 
// Module Name: func
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


module func(
    input CLK100MHZ,
    input CPU_RESETN,
    
    input [15:0] SW,
    input BTNC,
    
    output [7:0] AN,
    output LED16_B,
    output [15:0] LED,
    output [6:0] SEG
);
    
    wire [7:0] a_bi;
    wire [7:0] b_bi;
    
    wire sq_busy_o;
    wire [15:0] sq_y_bo;
    wire [2:0] cb_busy_o;
    wire [2:0] cb_y_bo;
    reg [15:0] res;
    
    assign LED16_B = sq_busy_o || cb_busy_o;
    assign a_bi = SW[15:8];
    assign b_bi = SW[7:0];
    assign LED = res;
    
    wire seg7_clk;
    
    square square_1(
        .clk_i(CLK100MHZ),
        .rst_i(CPU_RESETN),
        .x_bi(a_bi),
        .start_i(BTNC),
        .busy_o(sq_busy_o),
        .y_bo(sq_y_bo)
    );
    
    freq_div freq_div(
            .clk_i(CLK100MHZ),
            .div_clk_o(seg7_clk)
    );
    
    cbrt cbrt_1(
        .clk_i(CLK100MHZ),
        .rst_i(CPU_RESETN),
        .x_bi(b_bi),
        .start_i(BTNC),
        .busy_o(cb_busy_o),
        .y_bo(cb_y_bo)
    );
    
    segm7 seg(
        .rst_i(CPU_RESETN),
        .clk_i(seg7_clk),
        .start_i(BTNC),
        .res(res),
        .an(AN),
        .seg(SEG)
    );
    
    always @(posedge CLK100MHZ)
        if (LED16_B == 0) begin
            res <= sq_y_bo + cb_y_bo;
        end
    
endmodule

