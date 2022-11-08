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
output  reg   bClk

    );

parameter CLOCK_RATE = 100000000;
parameter BAUD_RATE  = 115200;

parameter MAX_RATE = CLOCK_RATE / (2 * BAUD_RATE);
parameter CNT_WIDTH = $clog2(MAX_RATE);

reg [CNT_WIDTH - 1:0] Counter = 0;

initial begin
    bClk = 1'b0;
end

always @(posedge clk) begin
    if (Counter == MAX_RATE[CNT_WIDTH-1:0]) begin
        Counter <= 0;
        bClk <= ~bClk;
    end else begin
        Counter <= Counter + 1'b1;
    end
end

endmodule
