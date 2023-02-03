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
input                   data_read,    // transmitter is ready to take byte
input                   in,
output   reg  [7:0]     data_out,
output   reg            rx_data_ready  // byte has been recieved

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
                if (in == 0) state <= R_DATA;
                else         state <= IDLE;
          end
    
    R_DATA: if (enable_clk && cnt == 4'b1001) begin
                state <= STOP_BIT;
            end
    
    STOP_BIT: if (enable_clk && cnt == 4'b1010) begin
                state <= IDLE;
              end
    
    default: state <= IDLE;
    
    endcase
end

always @(posedge clk) begin 
    if (!rst_n) begin
        data_out <= 0;
        rx_data_ready <= 0;
        cnt <= 0;
    end   
    
    case(state)

        IDLE: begin
                cnt <= 0;
                data <= 0;
                if( data_read ) rx_data_ready <= 0;
                if(  in == 0 ) rx_data_ready <= 0;
        end

        R_DATA: if (enable_clk) begin
                    
                    if (cnt != 4'b1001) begin
                        data[cnt] <= in;
                        cnt <= cnt + 1;
                    end
//                    else 
//                        rx_parity <= ^data[8:1];
                    else data[9] <= in;
        end

        STOP_BIT: if (enable_clk) begin
                    if (cnt == 4'b1001) begin
                        rx_parity <= ^data[8:1];
                        //data[9] <= in;
                        cnt <= cnt + 1;
                    end
                    else begin
                        if (in && (data[9] == rx_parity)) begin
                            rx_data_ready <= 1;
                            data_out <= data[8:1];
                        end
                    end
                  end
    endcase
end

endmodule
