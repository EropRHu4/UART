module uart_rx(

input          clk,
input          enable,
input          in,
output  [7:0]  data_out,
output         done,
output         busy,
output         error

    );
    
reg [1:0] state;
reg [3:0] cnt = 0;
// reg [7:0] data;

parameter   IDLE   = 2'b00,
            START  = 2'b01,
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
            if (enable && in) begin
                state <= START;
                busy <= 1;
            end
        end
        
        R_DATA: begin
            if (cnt != 4'b0000 && cnt <= 4'b1000)
                data_out[cnt] <= in;
            
        end
    endcase
end   
    
endmodule
