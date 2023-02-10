`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.01.2023 15:16:52
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

//input         tx_valid,
//input  [7:0]  in,
//output        tx,
//output        tx_ready,

/////////// rx //////////////////

//input          rx_valid,
//input          rx,
//output  [7:0]  out,
//output         rx_ready

input  UART_TXD_IN,
output UART_RXD_OUT
//output reg [15:0] LED
    );

reg rx_ready = 1'b1;
wire [7:0] fifo_data_out;
wire [7:0] rx_out;


uart_tx uart_tx
(
 .clk           (clk),
 .rst_n         (rst_n),
 .data_in       (fifo_data_out),
 .ready         (!fifo_empty),
 .out           (UART_RXD_OUT),
 .tx_valid      (tx_valid)
);


fifo fifo
(
 .clk           (clk),
 .rst_n         (rst_n),
 .push          (rx_data_ready),
 .pop           (tx_valid),
 .write_data    (rx_out),
 .read_data     (fifo_data_out),
 .full          (fifo_full),
 .empty         (fifo_empty)
);


uart_rx uart_rx
(
 .clk                   (clk),
 .rst_n                 (rst_n),
 .data_read             (1'b1),
 .in                    (UART_TXD_IN),
 .data_out              (rx_out),
 .rx_data_ready         (rx_data_ready)
);

endmodule
