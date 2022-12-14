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


module fifo_tx(

input               clk,
input               rst_n,
input        [7:0]  data_in,
input               rd_en,
output  reg  [7:0]  data_out,
output  reg         fifo_full,
output  reg         fifo_empty

    );


reg [7:0]  fifo_mem  [15:0];
reg [3:0] wr_ptr;
reg [3:0] rd_ptr;
reg wr_en;
//reg rd_en;
reg [1:0] state;

parameter IDLE  = 2'b00;
parameter WRITE = 2'b01;
parameter READ  = 2'b10;

always @(posedge clk) begin
    if (!rst_n) begin
         wr_ptr <= 4'b0000;
         rd_ptr <= 4'b0000;
         fifo_full <= 0;
         fifo_empty <= 1;
         wr_en <= 1'b1;
  //       rd_en <= 1'b0;
         state <= IDLE;
    end
    
    case(state)
    
    IDLE: begin
        if (fifo_full == 1'b0 && wr_en == 1'b1 && ((|data_in == 0) || (|data_in == 1)))
            state <= WRITE;
        else if (fifo_empty == 1'b0 && rd_en == 1'b1)
            state <= READ;
        else 
            state <= IDLE;
    end
    
    WRITE: begin
            if (wr_ptr == 4'b1111) begin
                fifo_mem[wr_ptr] <= data_in;
                wr_en <= 1'b0;
                fifo_full <= 1'b1;
                fifo_empty <= 1'b0;
                state <= READ;
            end
            else begin
                fifo_mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
            end
    end
    
    READ: begin
            if (rd_ptr == 4'b1111) begin
                data_out <= fifo_mem[rd_ptr];
 //               rd_en <= 1'b0;
                fifo_empty <= 1'b1;
                state <= IDLE;
            end
            else begin
                data_out <= fifo_mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
            end
    end
    
    endcase
end

endmodule
