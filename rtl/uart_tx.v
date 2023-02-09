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

input                     clk,
input                     rst_n,
input                     ready,        // smth is ready to recieve byte
input           [7:0]     data_in,      // data for transmittion
output   reg              tx_valid,     // byte has been transmitted
output   reg              out

    );

parameter   IDLE   = 2'b00,
            T_DATA = 2'b01;

reg [2:0] state;
reg [10:0] data = 0;
wire parity_bit;
wire enable_clk;

reg [1:0] readySW = 0;

BaudGenerator   BaudGenerator
(
 .clk           (clk),
 .start_bod     (1'b0),
 .baud_en       (|state),
 .enable_clk    (enable_clk)
);

assign parity_bit = ^data_in[7:0] == 1 ? 1 : 0; // EVEN parity

always @(posedge clk) begin
    readySW <= {readySW[0], ready};
    if (!rst_n) state <= IDLE;
    
    case (state)
    
    IDLE: begin 
            if ( readySW == 2'b01 )
               state <= T_DATA;
            else
               state <= IDLE;
          end
    
    T_DATA: if (enable_clk && |data == 0)
                         state <= IDLE;
    
    default: if (enable_clk) state <= IDLE;
    
    endcase
end

always @(posedge clk) begin
    if (!rst_n) begin
        data <= 0;
        tx_valid <= 0;
        out <= 1;
    end
    
    case (state)
    IDLE: begin
            tx_valid <= 1'b0;
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
                    tx_valid <= 1;
                end
    end
    
    endcase
end

endmodule
