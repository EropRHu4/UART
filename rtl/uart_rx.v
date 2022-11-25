`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2022 11:33:20
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
input                   enable_clk,
input                   valid,
input                   in,
output   reg  [7:0]     data_out,
output   reg            rx_ready

    );

reg [1:0] state;
reg [2:0] cnt = 0; // count of bits;
reg [7:0] data;    // recieved data;


parameter   IDLE   = 2'b00,
            R_DATA = 2'b01,
            STOP   = 2'b10;

always @(posedge clk) begin
    case(state)
    
    IDLE: if (enable_clk) begin
                if (valid && in == 0) begin
                    state <= R_DATA;
                end
                else state <= IDLE;
          end
    
    R_DATA: if (enable_clk && &cnt) begin
                state <= STOP;
            end
            
    STOP: if (enable_clk) begin
                state <= IDLE;
          end
          
    default: if (enable_clk) state <= IDLE;
    
    endcase
end

always @(posedge clk) begin
    if (!rst_n)
        state <= IDLE;
        
    case(state)
        
        IDLE: if (enable_clk) begin
                data_out <= 0;
                rx_ready <= 0;
                cnt <= 0;
                data <= 0;
        end

        R_DATA: if (enable_clk) begin
                data[cnt] <= in;
                if (&cnt == 0)
                    cnt <= cnt + 1;
                else begin
                    cnt <= 0;
                end
        end

        STOP: if (enable_clk) begin
                data <= 0;
                data_out <= data;
                rx_ready <= 1;
        end

    endcase
end   

endmodule
