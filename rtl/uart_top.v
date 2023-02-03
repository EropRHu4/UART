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

/*always @(posedge clk) begin
    if (UART_TXD_IN) begin
        LED[1] <= 1'b1;
        LED[0] <= 1'b0;
    end
    else begin
        LED[1] <= 1'b0;
        LED[0] <= 1'b1;
    end
end
*/

/*reg a;
reg b;*/
reg rx_ready = 1'b1;
wire [7:0] data_out;
wire [7:0] out;

/*initial begin
    a <= |(8'b1100_0000);
    b <= ^(8'b0001_0000);
end*/

/*fifo_tx fifo_tx
(
 .clk           (clk),
 .rst_n         (rst_n),
 .data_in       (in),
 .rd_en         (tx_ready),
 .data_out      (data_out),
 .fifo_full     (fifo_full),
 .fifo_empty    (fifo_empty)
);
*/
uart_tx uart_tx
(
 .clk           (clk),
 .rst_n         (rst_n),
 .data_in       (out),
 .ready         (rx_data_ready),
 .out           (UART_RXD_OUT),
 .tx_valid      (tx_valid)
);

uart_rx uart_rx
(
 .clk                   (clk),
 .rst_n                 (rst_n),
 .data_read             (1'b1),
 .in                    (UART_TXD_IN),
 .data_out              (out),
 .rx_data_ready         (rx_data_ready)
);

/*led_controller led_controller
(
 .clk           (clk),
 .rst_n         (rst_n),
 .data_in       (out),
 .LED           (LED)
);*/

endmodule
