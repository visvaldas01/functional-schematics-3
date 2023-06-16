`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2023 14:07:05
// Design Name: 
// Module Name: cbrt
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


module cbrt(
    input clk_i,
    input rst_i,
    
    input [7:0] x_bi,
    input start_i,
    
    output wire [2:0] busy_o,
    output reg [2:0] y_bo
);

    mult mult_1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .a_bi(mult_a),
        .b_bi(mult_b),
        .start_i(mult_start),
        .busy_o(mult_busy),
        .y_bo(mult_out)
    );

    localparam IDLE = 3'b000;
    localparam Y_WORK = 3'b001;
    localparam B_WORK1 = 3'b010;
    localparam B_WORK2 = 3'b011;
    localparam B_WORK3 = 3'b100;
    localparam B_WORK4 = 3'b101;
    localparam X_WORK = 3'b110;
    
    reg [7:0] mult_a;
    reg [7:0] mult_b;
    reg mult_start;
    wire mult_busy;
    wire [15:0] mult_out;
    reg [4:0] s; // счётчик
    reg [7:0] x;
    reg [2:0] y;
    reg [30:0] b;
    reg [2:0] state;
    
    assign busy_o = state;
    assign end_step = (s == 5'b11101);
    assign x_ge_b = (x >= b);
    
    always @(posedge clk_i)
        if (~rst_i) begin
            s <= 5'b11110;
            y <= 0;
            y_bo <= 0;
            
            state <= IDLE;
        end else begin
            case (state)
                IDLE:
                    if (start_i) begin
                        state <= Y_WORK;
                        
                        x <= x_bi;
                        s <= 5'b11110;
                        y <= 0;
                    end
                Y_WORK:
                    begin
                        if (end_step) begin
                            state <= IDLE;
                            y_bo <= y;
                        end
                        else begin
                            y <= y << 1;
                            state <= B_WORK1;
                        end
                    end
                B_WORK1:
                    begin
                        mult_a <= y;
                        mult_b <= y + 1;
                        mult_start <= 1;
                        state <= B_WORK2;
                    end
                B_WORK2:
                    begin
                        if (mult_busy == 0 && mult_start == 0) begin
                            mult_a <= 3;
                            mult_b <= mult_out;
                            mult_start <= 1;
                            state <= B_WORK3;
                        end else begin
                            mult_start <= 0;
                        end
                    end
                B_WORK3:
                    begin
                        if (mult_busy == 0 && mult_start == 0) begin
                            b <= mult_out + 1;
                            state <= B_WORK4;
                        end else begin
                            mult_start <= 0;
                        end
                    end
                B_WORK4:
                    begin
                        b <= b << s;
                        state <= X_WORK;
                    end
                X_WORK:
                    begin                        
                        if (x_ge_b) begin
                            x <= x - b;
                            y <= y + 1;
                        end
                        s <= s - 3;
                        state <= Y_WORK;
                    end
            endcase
        end
        
endmodule
