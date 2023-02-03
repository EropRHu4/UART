`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.01.2023 15:18:22
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(

input                   clk,
input                   rst_n,
input                   ready,    // transmitter is ready to take byte
input                   in,
output   reg  [7:0]     data_out,
output   reg            rx_valid  // byte has been recieved

    );


parameter   IDLE     = 2'b00,
            R_DATA   = 2'b01,
            STOP_BIT = 2'b10;


reg [1:0] state = IDLE;
reg [3:0] cnt = 0; // count of bits;
reg [9:0] data = 0;    // recieved data;
reg rx_parity = 0;
wire enable_clk;


BaudGenerator   BaudGenerator
(
 .clk           (clk),
 .start_bod     ((cnt == 'b0)),
 .baud_en       (|state),
 .enable_clk    (enable_clk)
);

always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
    end
    
    case(state)
    
    IDLE: begin
                if (in == 0) begin
                    state <= R_DATA;
                end
                else state <= IDLE;
          end
    
    R_DATA: if (enable_clk && cnt == 4'b1001) begin
                state <= STOP_BIT;
            end
    
    STOP_BIT: if (enable_clk) begin
                state <= IDLE;
              end
    
    default: state <= IDLE;
    
    endcase
end

always @(posedge clk) begin 
    if (!rst_n) begin
        data_out <= 0;
        rx_valid <= 0;
        cnt <= 0;
    end   
    
    case(state)

        IDLE: begin
                cnt <= 0;
                data <= 0;
                if( ready ||  in == 0 ) rx_valid <= 0;
        end

        R_DATA: if (enable_clk) begin
                    data[cnt] <= in;
                    if (cnt != 4'b1001)
                        cnt <= cnt + 1;
        end

        STOP_BIT: if (enable_clk) begin
                    if (in != |data[8:1]) rx_valid <= 0;
                    else                  rx_valid <= 1;
                    data_out <= data[8:1];
                  end

    endcase
end

endmodule
