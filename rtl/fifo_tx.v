`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2022 13:05:40
// Design Name: 
// Module Name: fifo_tx
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


module fifo
# (
  parameter width = 8, depth = 10
)
(
  input                clk,
  input                rst_n,
  input                push,
  input                pop,
  input  [width - 1:0] write_data,
  output [width - 1:0] read_data,
  output               empty,
  output               full
  /*`ifdef SYNTHESIS
  ,
  output [31:0] debug
  `endif*/
);

  //--------------------------------------------------------------------------
  parameter pointer_width = $clog2 (depth),
            counter_width = $clog2 (depth + 1);

  parameter [counter_width - 1:0] max_ptr =  4'b1111; //counter_width(depth - 1);
  //--------------------------------------------------------------------------
  reg [pointer_width - 1:0] wr_ptr, rd_ptr;
  reg [counter_width - 1:0] cnt;
  reg [width - 1:0] data [0: depth - 1];
  
  //--------------------------------------------------------------------------
  
 /* `ifdef SYNTHESIS
  assign debug [31:16] = 16' (wr_ptr);
  assign debug [15:00] = 16' (rd_ptr);
  `endif*/
  
  //--------------------------------------------------------------------------
  always @(posedge clk or posedge rst_n)
    if (rst_n)
      wr_ptr <= 0;
    else if (push)
      wr_ptr <= wr_ptr == max_ptr ? 0 : wr_ptr + 1'b1;
  // TODO: Add logic for rd_ptr
  always @(posedge clk or posedge rst_n)
    if (rst_n)
      rd_ptr <= 0;
    else if (pop)
      rd_ptr <= rd_ptr == max_ptr ? 0 : rd_ptr + 1'b1;
  //--------------------------------------------------------------------------
  always @(posedge clk)
    if (push)
      data[wr_ptr] <= write_data;
  assign read_data = data[rd_ptr];
  
  //--------------------------------------------------------------------------
  always @(posedge clk or posedge rst_n)
    if (rst_n)
      cnt <= 0;
    else if (push && ~ pop)
      cnt <= cnt + 1'b1;
    else if (pop && ~ push)
      cnt <= cnt - 1'b1;
      
  //--------------------------------------------------------------------------
  assign empty = (cnt == 0);  // Same as "~| cnt"
  // TODO: Add logic for full output
  assign full = (cnt == depth);
  
endmodule

