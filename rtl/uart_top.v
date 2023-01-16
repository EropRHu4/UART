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

/*input  UART_TXD_IN,
output UART_RXD_OUT*/
//output  [9:0] LED
    );


reg valid = 1'b1;
wire [7:0] data_out;

fifo_tx fifo_tx
(
 .clk           (clk),
 .rst_n         (rst_n),
 .data_in       (in),
 .rd_en         (tx_ready),
 .data_out      (data_out),
 .fifo_full     (fifo_full),
 .fifo_empty    (fifo_empty)
);

uart_tx uart_tx
(
 .clk           (clk),
 .rst_n         (rst_n),
 .data_in       (data_out),
 .valid         (valid),
 .out           (tx),
 .tx_ready      (tx_ready)
);

uart_rx uart_rx
(
 .clk           (clk),
 .rst_n         (rst_n),
 .valid         (valid),
 .in            (tx),
 .data_out      (out),
 .rx_ready      (rx_ready)
);

/*led_controller led_controller
(
 .clk           (clk),
 .rst_n         (rst_n),
 .data_in       (out),
 .LED           (LED)
);*/

endmodule
