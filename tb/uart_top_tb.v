`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2022 17:34:46
// Design Name: 
// Module Name: uart_top_tb
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


module uart_top_tb();                   
                                        
reg clk;                                
reg rst_n;                              
                                        
/////////// tx //////////////////       
reg         tx_valid;                   
reg  [7:0]  in;                         
                                        
wire        tx;                         
wire        tx_ready;                   
/////////// rx //////////////////       
                                        
reg          rx_valid;                  
reg          rx;                        
                                        
wire  [7:0]  out;                       
wire         rx_ready;                  
                                        
uart_top uart_top                       
(                                       
 .clk          (clk),                   
 .rst_n        (rst_n),                 
/////// tx //////////                   
 .tx_valid     (tx_valid),              
 .in           (in),                    
 .tx           (tx),                    
 .tx_ready     (tx_ready),              
/////// rx ///////////                  
 .rx_valid     (rx_valid),              
 .rx           (rx),                    
 .out          (out),                   
 .rx_ready     (rx_ready)               
);                                      
                                        
                                        
always begin                            
#10;                                    
clk = ~clk;                             
end                                     
                                        
//reg [7:0] recieved_data = 8'b1110_1011
                                        
initial begin                           
    clk = 1'b1;                         
    rst_n = 0;                          
    #17000;                             
    rst_n = 1;                          
    tx_valid = 1;                       
    rx_valid = 1;                       
    #17400;                             
    in = 8'b1100_0001;                  
    #40;                                
    in = 8'b0000_0010;                  
    #20;                                
    in = 8'b0000_0011;                  
    #20;                                
    in = 8'b0000_0100;                  
    #20;                                
    in = 8'b0000_0101;                  
    #20;                                
    in = 8'b0000_0110;                  
    #20;                                
    in = 8'b0000_0111;                  
    #20;                                
    in = 8'b0000_1000;                  
    #20;                                
    in = 8'b0000_1001;                  
    #20;                                
    in = 8'b0000_1010;                  
    #20;                                
    in = 8'b0000_1011;                  
    #20;                                
    in = 8'b0000_1100;                  
    #20;                                
    in = 8'b0000_1101;                  
    #20;                                
    in = 8'b0000_1110;                  
    #20;                                
    in = 8'b0000_1111;                  
    #20;                                
    in = 8'b1111_1111;                  
    #20;                                
    /*in = 8'b1110_1011;                
    #500000;                            
    in = 8'b1000_1011;*/                
    /*rx_valid = 1;                     
    #17400;                             
    rx = 0;                             
    #17400;                             
    rx = recieved_data[0];              
    #17400;                             
    rx = recieved_data[1];              
    #17400;                             
    rx = recieved_data[2];              
    #17400;                             
    rx = recieved_data[3];              
    #17400;                             
    rx = recieved_data[4];              
    #17400;                             
    rx = recieved_data[5];              
    #17400;                             
    rx = recieved_data[6];              
    #17400;                             
    rx = recieved_data[7];              
    #17400;                             
    rx = 1;*/                           
end                                     
                                        
endmodule                               
                                        
