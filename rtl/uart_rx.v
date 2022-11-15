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
reg [2:0] cnt = 0; // count of bits;
reg [7:0] data;    // recieved data;
reg [1:0] shiftReg = 'b00;


parameter   IDLE   = 2'b00,
            R_DATA = 2'b01,
            STOP   = 2'b10;


always @(posedge clk) begin
    shiftReg = {shiftReg[0], in};
    case(state)
        
        IDLE: begin
            data_out <= 0;
            data <= 0;
            done <= 0;
            busy <= 0;
            error <= 0;
            cnt <= 0;
            if (enable) begin
                if (shiftReg[1] == 1'b1) begin
                    error <= 1;
                    state <= IDLE;
                end
                else if (shiftReg[1] == 1'b0) begin
                    state <= R_DATA;
                    busy <= 1;
                end
            end
        end

        R_DATA: begin
                data[cnt] <= shiftReg[1];
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

