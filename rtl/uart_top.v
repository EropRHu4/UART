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

/*input         tx_valid,
input  [7:0]  in,
output        tx,
output        tx_ready,*/

/////////// rx //////////////////

/*input          rx_valid,
input          rx,
output  [7:0]  out,
output         rx_ready*/

input  UART_TXD_IN,
output UART_RXD_OUT,
output  [15:0] LED,
output reg           LED16_B
    );

reg valid = 1'b1;
wire [7:0] data_out;


always @(posedge clk) begin
    if (UART_TXD_IN)
       LED16_B <= 1'b1;
    else
       LED16_B <= 1'b0;
end



/*fifo fifo
(
 .clk           (clk),
 .rst_n         (rst_n),
 .data_in       (out),
 .rd_en         (tx_ready),
 .data_out      (data_out),
 .fifo_full     (fifo_full),
 .fifo_empty    (fifo_empty),
 .wr_en         (wr_en)
);*/

uart_tx uart_tx
(
 .tx_clk        (baud_clk),
 .rst_n         (rst_n),
 .data_in       (out),
 .tx_enabled    (1'b0),
 .out           (UART_RXD_OUT),
 .tx_ready      (tx_ready)
);

uart_rx uart_rx
(
 .rx_clk        (baud_clk),
 .clk           (clk),
 .rst_n         (rst_n),
 .rx_enabled    (valid),
 .in            (UART_TXD_IN),
 .data_out      (out),
 .rx_ready      (rx_ready),
 .LED           (LED)
);

BaudGenerator   BaudGenerator
(
 .clk           (clk),
 .baud_en       (valid),
 .baud_clk      (baud_clk)
);

/*led_controller led_controller
(
 .clk           (clk),
 .rst_n         (rst_n),
 .data_in       (out),
 .LED           (LED)
);*/

endmodule
