`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2022 11:35:05
// Design Name: 
// Module Name: BaudGenerator
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


module BaudGenerator(

input   wire  clk,
input   wire  start_bod,
input   wire  baud_en,
output  reg   enable_clk

    );

parameter CLOCK_RATE = 100000000;
parameter BAUD_RATE  = 115200;

parameter MAX_RATE = CLOCK_RATE / (BAUD_RATE);
parameter CNT_WIDTH = $clog2(MAX_RATE);

wire [CNT_WIDTH - 1:0] max_value_cnt = (start_bod) ? MAX_RATE/2 : MAX_RATE;

reg [CNT_WIDTH - 1:0] Counter = 0;

initial begin
    enable_clk = 1'b0;
end

always @(posedge clk) begin
    if ( baud_en == 1'b1 ) begin
        if ( Counter == max_value_cnt ) begin
            Counter <= 0;
            enable_clk <= 1'b1;
        end
        else begin
            Counter <= Counter + 1'b1;
            enable_clk <= 1'b0;
        end
    end
    else begin
        enable_clk <= 1'b0;
        Counter <= 0;
    end
end

endmodule
