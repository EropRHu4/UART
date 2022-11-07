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

input          clk,
input          enable,
input          in,
output   reg  [7:0]  data_out,
output   reg      done,
output   reg      busy,
output   reg      error

    );

reg [1:0] state;
reg [3:0] cnt = 0;
reg [7:0] data;

parameter   IDLE   = 2'b00,
            R_DATA = 2'b10,
            STOP   = 2'b11;

always @(posedge clk) begin
    case(state)
        
        IDLE: begin
            data_out <= 0;
            data <= 0;
            done <= 0;
            busy <= 0;
            error <= 0;
            cnt <= 0;
            if (enable) begin
                if (in == 1) begin
                    error <= 1;
                    state <= IDLE;
                end
                else begin
                    state <= R_DATA;
                    busy <= 1;
                end
            end
        end
        
        R_DATA: begin
            data[cnt] <= in;
            if (&cnt == 0)
                cnt <= cnt + 1;
            else begin
                cnt <= 0;
                state <= STOP;
            end
        end
            
        STOP: begin
            if (in == 0)
                error <= 1;
            else begin
                busy <= 0;
                done <= 1;
                state <= IDLE;
                data <= 0;
                data_out <= data;
            end
        end
        
        default: state <= IDLE;
        
    endcase
end   
    
endmodule
