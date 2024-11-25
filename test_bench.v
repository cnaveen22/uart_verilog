
module testbench;
    reg [7:0] data_in;
    reg clk, rst;
    reg [1:0] sel;
    reg start_bit;
    reg stop_bit;
    wire data;
    wire [7:0] data_out;
    wire parity_error, stopbit_error;
    
    always #1 clk = ~clk;
                // Adjust the clock period as needed
    
    baud_rate_generator brg ( clk, rst, sel, clkout);
    
    UART_TX uut_tx (
        .start_bit(start_bit),
        .stop_bit(stop_bit),
        .clk(clkout),
        .rst(rst),
        .tx_data(data_in),
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
    
    initial begin
        clk = 0;
        rst = 1;
        sel = 2'b11;
        start_bit = 1'b1;
        data_in = 8'b01101001;
        stop_bit = 1'b0;
        
        #10 rst = 0;
        #320 start_bit = 1'b0;
             stop_bit  = 1'b1;
             
        
        // Add more test cases as needed
    end
endmodule
