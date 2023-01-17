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


module fifo_memory(

input           clk,
input           fifo_we,
input   [7:0]   data_in,
input   [3:0]   wr_ptr,
input   [3:0]   rd_ptr,
output  [7:0]   data_out

    );

reg     [7:0]   mem [15:0];

assign data_out = mem[rd_ptr[3:0]];

always @(posedge clk) begin
    if (fifo_we)
        mem[wr_ptr[3:0]] <= data_in ;
end

endmodule
