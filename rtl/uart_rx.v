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
input                   rx_clk,
input                   rst_n,
input                   rx_enabled,
input                   in,
output   reg  [7:0]     data_out,
output   reg            rx_ready,
output   reg  [15:0]    LED

    );


parameter   RESET    = 2'b00, 
            IDLE     = 2'b01,
            R_DATA   = 2'b10,
            STOP_BIT = 2'b11;


reg [1:0] state = RESET;
reg [1:0] next = RESET;
reg [3:0] cnt = 0; // count of bits;
reg [7:0] data = 0;    // recieved data;
reg rx_parity = 0;
reg [1:0] inputSw = 2'b0;

initial begin
    LED <= 0;
    rx_ready <= 0;
    data_out <= 0;
end

function set_state;                                                                   
    input [1:0] new_state;                                  
    begin                                                                            

    next = new_state;
    LED[15:14] = new_state;       
    if (new_state == IDLE)
        LED[12] = 1'b1;
    else
        LED[12] = 1'b0;
    if (new_state == R_DATA)
        LED[11] = 1'b1;
    else
        LED[11] = 1'b0;

end                                                                                  
endfunction       


always @(posedge rx_clk) 
//if (rx_enabled) 
begin
    if (!rst_n) state <= RESET;
    else state <= next;
end

always @(posedge rx_clk)
 //if (rx_enabled) 
 begin
    if (in)
       LED[9] <= 1'b1;
    else
       LED[8] <= 1'b1;

    inputSw = { inputSw[0], in };
    //LED[15:14] <= state;
    LED[10] <= ~LED[10];
    case(state)

        RESET: begin
            data_out <= 0;
            rx_ready <= 0;
            cnt <= 0;
            data <= 0;
            inputSw = 2'b0;
            rx_parity = 0;
            LED[7:0] <= 0;
//            if (valid)begin
                set_state(IDLE); // next = IDLE:
//            end
        end

        IDLE: begin
                LED[7:0] <= 0;
                data_out <= 0;
                rx_ready <= 0;
                if (inputSw == 2'b10) begin
                    cnt <= 0;
                    set_state(R_DATA); //next = R_DATA;
                end
        end

        R_DATA:
           begin
              data[cnt] <= in;
              if (in)
                LED[cnt] <= 1'b1;
              else
                LED[cnt] <= 1'b0;

              if (cnt == 4'b0111) begin
                  set_state(STOP_BIT);//next = STOP_BIT;
              end
              cnt <= cnt + 1;
           end

       STOP_BIT: begin
              if (cnt == 4'b1000) begin  
                rx_parity = ^data[7:0] == 1 ? 1 : 0; // EVEN parity
                //  check parity, if failed state <= RESET 
                if (in != rx_parity)
                    set_state(RESET);//next = RESET;
              end
              else begin //if (cnt = 4'b1001)
                if (!in) //                in  должен быть 1 иначе - RESET== 0??
                    set_state(RESET);//next = RESET; 
                else begin
                    data_out <= data;
                    rx_ready <= 1;
                    set_state(IDLE);//next = IDLE;
                end
              end
              cnt <= cnt + 1;
       end
    endcase
end

endmodule
