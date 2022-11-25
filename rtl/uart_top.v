`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2022 11:26:56
// Design Name: 
// Module Name: uart_top
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


module uart_top(

input clk,
input rst_n,

/////////// tx //////////////////

input         tx_valid,
input  [7:0]  in,
output        tx,
output        tx_ready,

/////////// rx //////////////////

input          rx_valid,
input          rx,
output  [7:0]  out,
output         rx_ready
    );

wire enable_clk;
wire baud_start;

assign baud_start = tx_valid || rx_valid;

uart_tx uart_tx
(
 .clk           (clk),
 .rst_n         (rst_n),
 .enable_clk    (enable_clk),
 .data_in       (in),
 .valid         (tx_valid),
 .out           (tx),
 .tx_ready      (tx_ready)
);

uart_rx uart_rx
(
 .clk           (clk),
 .rst_n         (rst_n),
 .valid         (rx_valid),
 .enable_clk    (enable_clk),
 .in            (rx),
 .data_out      (out),
 .rx_ready      (rx_ready)
);

BaudGenerator   BaudGenerator
(
 .clk           (clk),
 .baud_en       (baud_start),
 .enable_clk    (enable_clk)
);

endmodule
