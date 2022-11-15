`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2022 17:34:46
// Design Name: 
// Module Name: uart_top_tb
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


module uart_top_tb();

reg clk;

/////////// tx //////////////////
reg         txEnable;
reg         txStart;
reg  [7:0]  in;

wire        tx;
wire        txDone;
wire        txBusy;

/////////// rx //////////////////

reg          rxEnable;
reg          rx;

wire  [7:0]  out;
wire         rxDone;
wire         rxError;
wire         rxBusy;

uart_top uart_top
(
 .clk       (clk),
/////// tx //////////
 .txEnable  (txEnable),
 .txStart   (txStart),
 .in        (in),
 .tx        (tx),
 .txDone    (txDone),
 .txBusy    (txBusy),
/////// rx ///////////
 .rxEnable  (rxEnable),
 .rx        (rx),
 .out       (out),
 .rxDone    (rxDone),
 .rxError   (rxError),
 .rxBusy    (rxBusy)
);


always begin
#10;
clk = ~clk;
end

integer i = 0;

reg [7:0] recieved_data = 8'b1000_1011;

initial begin
    clk = 1'b0;
    txEnable = 1;
    txStart = 1;
    //in = 8'hAB;
    in = 8'b10001111;
  //  #100;
    rxEnable = 1;
    rx = 0;
    #17400;
    rx = recieved_data[0];
    #17400;
    rx = recieved_data[1];
    #17400;
    rx = recieved_data[2];
    #17400;
    rx = recieved_data[3];
    #17400;
    rx = recieved_data[4];
    #17400;
    rx = recieved_data[5];
    #17400;
    rx = recieved_data[6];
    #17400;
    rx = recieved_data[7];
    #17400;
    rx = 1;
end

endmodule
