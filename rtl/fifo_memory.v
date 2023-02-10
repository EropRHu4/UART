`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2023 12:50:21
// Design Name: 
// Module Name: fifo_memory
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


module memory
# (
  parameter width = 8, depth = 16
)(

input                             clk,
input                             push,
input                             full,
input   [width - 1 : 0]           data_in,
input   [pointer_width - 1 : 0]   wr_ptr,
input   [pointer_width - 1 : 0]   rd_ptr,
output  [width - 1 : 0]           data_out

    );
    
parameter pointer_width = $clog2 (depth);

reg [width - 1:0] mem [0: depth - 1];

always @(posedge clk) begin
  if (push && !full)
      mem[wr_ptr] <= data_in;
  end
 
  assign data_out = mem[rd_ptr];
  
endmodule
