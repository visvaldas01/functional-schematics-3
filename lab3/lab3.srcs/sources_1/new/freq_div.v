`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.05.2023 17:26:36
// Design Name: 
// Module Name: freq_div
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


`timescale 1ns / 1ps

module freq_div(
    input clk_i,
    output reg div_clk_o = 0
    );

    reg [24:0] cnt = 0;

    always@(posedge clk_i) begin
        if(cnt == 99999) begin
            cnt <= 0;
            div_clk_o <= ~div_clk_o;
        end    
        else cnt <= cnt + 1;
    end  

endmodule
