
module UART( input start_bit, clk , rst, stop_bit,[1:0] sel , [7:0] tx_data, output [7:0] data_out, output parity_error, stopbit_error );

 baud_rate_generator brg ( clk, rst, sel, clkout);
 
 UART_TX uut_tx (
        .start_bit(start_bit),
        .stop_bit(stop_bit),
        .clk(clkout),
        .rst(rst),
        .tx_data(tx_data),
        .TX_data_out(data)
        
    );
    
 UART_RX uut_rx (
        .data_i(data),
        .clk(clkout),
        .rst(rst),
        .data_out(data_out),
        .parity_error(parity_error),
        .stopbit_error(stopbit_error)
        );
 
endmodule
