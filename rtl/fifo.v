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
  parameter width = 8, depth = 4
)
(
  input                clk,
  input                rst_n,
  input                push,
  input                pop,
  input  [width - 1:0] write_data,
  output [width - 1:0] read_data,
  output               empty,
  output            full
 
);


  //--------------------------------------------------------------------------
  parameter pointer_width = $clog2 (depth),
            counter_width = $clog2 (depth + 1);

  parameter [counter_width - 1:0] max_ptr =  2'b11; //counter_width(depth - 1);
  //--------------------------------------------------------------------------
  reg [pointer_width - 1:0] wr_ptr, rd_ptr = 0;
  reg [counter_width - 1:0] cnt = 0;
  reg [width - 1:0] data [0: depth - 1];
  
  //--------------------------------------------------------------------------
  always @(posedge clk) begin
    if (!rst_n)
      wr_ptr <= 0;
    else if (push && !full)
      wr_ptr <= wr_ptr == max_ptr ? 0 : wr_ptr + 1'b1;
  end
  // TODO: Add logic for rd_ptr
  always @(posedge clk) begin
    if (!rst_n)
      rd_ptr <= 0;
    else if (pop && !empty )
      rd_ptr <= rd_ptr == max_ptr ? 0 : rd_ptr + 1'b1;
  end
  //--------------------------------------------------------------------------
  always @(posedge clk) begin
    if (push && !full)
      data[wr_ptr] <= write_data;
  end
 
  
  assign read_data = data[rd_ptr];
  
  //--------------------------------------------------------------------------
  always @(posedge clk) begin
    if (!rst_n)
      cnt <= 0;
    else if (push && ~pop )
      cnt <= cnt + 1'b1;
    else if (pop && ~push )
      cnt <= cnt - 1'b1;
  end
      
  //--------------------------------------------------------------------------
  assign empty = (wr_ptr == rd_ptr);  // Same as "~| cnt"
  // TODO: Add logic for full output
  assign full = (cnt == depth);
  
endmodule

