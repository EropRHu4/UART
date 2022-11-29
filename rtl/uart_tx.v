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

input                     clk,
input                     rst_n,
input                     enable_clk,   // for baud clock
input                     valid,        // posibility of transmitt
input           [7:0]     data_in,      // data for transmittion
output   reg              tx_ready,     // info has been transmited
output   reg              out

    );

parameter   IDLE   = 2'b00,
            T_DATA = 2'b01;

reg [2:0] state;
reg [10:0] data = 0;
wire parity_bit;

assign parity_bit = ^data_in[7:0] == 1 ? 1 : 0; // EVEN parity

always @(posedge clk) begin
    if (!rst_n) state <= IDLE;
    
    case (state)
    
    IDLE: if (enable_clk && valid)
                         state <= T_DATA;
                
    T_DATA: if (enable_clk && |data == 0)
                         state <= IDLE;
                
    default: if (enable_clk) state <= IDLE;
    
    endcase
end

always @(posedge clk) begin
    if (!rst_n) begin
        data <= 0;
        tx_ready <= 0;
    end
    
    case (state)
    IDLE: if (enable_clk && valid ) begin
            out <= 1;
            data[0] <= 0; // start bit
            data[8:1] <= data_in;
            data[9] <= parity_bit;
            data[10] <= 1; // stop bit
    end
    
    T_DATA: if (enable_clk) begin
                if (|data) begin
                    out <= data[0];
                    data <= data >> 1;
                end
                else begin
                    data <= 0;
                    tx_ready <= 1;
                end
    end
    
    endcase
end

endmodule
