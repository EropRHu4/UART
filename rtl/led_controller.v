`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.12.2022 14:18:03
// Design Name: 
// Module Name: led_controller
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


module led_controller(

input            clk,
input            enable_clk,
input            rst_n,
input   [7:0]    data_in,
output reg [9:0] LED

    );

reg [7:0] buffer [7:0];
reg [2:0] pnt = 3'b000;

always @(posedge clk) begin
    if (pnt != 3'b111) begin
        buffer[pnt] <= data_in;
        pnt <= pnt + 1;
    end
    else begin
        LED[buffer[3'b111][3:0]] <= buffer[3'b101] == 8'b01101110 ? 1'b1 : 1'b0;
    end
end

endmodule
