`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.01.2023 15:17:39
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

input                     tx_clk,
input                     rst_n,
input                     tx_enabled,  //TxEnabled      // posibility of transmitt
input           [7:0]     data_in,      // data for transmittion
output   reg              tx_ready,     // info has been transmited
output   reg              out

    );

parameter   IDLE   = 2'b00,
            T_DATA = 2'b01;

reg [2:0] tx_state;
reg [10:0] tx_data = 0;
reg [10:0]  data;
wire parity_bit;
wire enable_clk;

/*BaudGenerator   BaudGenerator
(
 .clk           (clk),
 .baud_en       (valid),
 .baud_clk    (enable_clk)
);
*/

assign parity_bit = ^data_in[7:0] == 1 ? 1 : 0; // EVEN parity

always @(posedge tx_clk) if (tx_enabled) begin

    if (!rst_n) tx_state <= IDLE;
    
    case (tx_state)
    
    IDLE: 
    //if ( valid )
    begin
                         tx_state <= T_DATA;
    end
    
    T_DATA: if (enable_clk && |data == 0)
                         tx_state <= IDLE;
    
    default: if (enable_clk) tx_state <= IDLE;
    
    endcase
end

always @(posedge tx_clk) if (tx_enabled) begin
    if (!rst_n) begin
        data <= 0;
        tx_ready <= 1;
    end
    
    case (tx_state)
    IDLE: 
//    if ( valid ) 
    begin
            out <= 1;
            data[0] <= 0; // start bit
            data[8:1] <= data_in;
            data[9] <= parity_bit;
            data[10] <= 1; // stop bit
    end
    
    T_DATA: if (enable_clk) begin
            tx_ready <= 1;
                if (|data) begin
                    out <= data[0];
                    data <= data >> 1;
                end
                else begin
                    data <= 0;
                    tx_ready <= 0;
                end
    end
    
    endcase
end

endmodule

