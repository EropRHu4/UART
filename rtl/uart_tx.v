`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2022 12:17:39
// Design Name: 
// Module Name: uart_tx
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

module uart_tx(

input         clk,
input         enable,   // posibility of transmitt
input  [7:0]  data_in,  // data for transmittion
input         start,    // start of tx
output   reg     out,
output   reg     done,     // end of tx
output   reg     busy      // tx is going

    );

parameter   IDLE   = 2'b00,
            START  = 2'b01,
            T_DATA = 2'b10,
            STOP   = 2'b11;

reg [2:0] state;
reg [7:0] data;
reg [2:0] bits = 0;


always @(posedge clk) begin
    case(state)
    IDLE: begin
            busy <= 0;
            done <= 0;
            out <= 1;
            bits <= 0;
            data <= 0;
            if (enable && start) begin
                data <= data_in;
                state <= START;
            end
    end
    
    START: begin
            busy <= 1;
            out <= 0; // start-bit
            state <= T_DATA;
    end
    
    T_DATA: begin
            out <= data[bits];
            if (&bits == 0)
                bits <= bits + 1; 
            else begin
                bits <= 0;
                state <= STOP;
            end
    end
    
    STOP: begin
          data <= 0;
          done <= 1;
          busy <= 0;
          out <= 1; // stop-bit
          if (done == 1)
                state <= IDLE;
    end
    
    default : state <= IDLE;
    
endcase
end


endmodule

