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

/////////// tx //////////////////
input         txEnable,
input         txStart,
input  [7:0]  in,
output        tx,
output        txDone,
output        txBusy,

/////////// rx //////////////////

input          rxEnable,
input          rx,
output  [7:0]  out,
output         rxDone,
output         rxError,
output         rxBusy

    );
    
wire bClk;

uart_tx uart_tx
(
 .clk       (bClk),
 .enable    (txEnable),
 .data_in   (in),
 .start     (txStart),
 .out       (tx),
 .done      (txDone),
 .busy      (txBusy)
);

uart_rx uart_rx
(
 .clk       (bClk),
 .enable    (rxEnable),
 .in        (rx),
 .data_out  (out),
 .done      (rxDone),
 .busy      (rxBusy),
 .error     (rxError)
);

BaudGenerator   BaudGenerator
(
 .clk       (clk),
 .bClk      (bClk)
);

endmodule
