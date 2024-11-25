
module UART_RX(input data_i, clk, rst, output [7:0] data_out, output parity_error, stopbit_error );

 

  fsmrx FSM (data_i, parity_error, clk ,rst, check, stopbit_check, load);
  sipo SIPO (clk, rst,load, data_i, data_out);
  
  stopbit_checker SC (stopbit, stopbit_check, stopbit_error);
  parity_checker PC (data_out, check, data_i , parity_error);
  
endmodule







module fsmrx(input data_i, paritybit_error, clk, rst, output reg parity_load, stopbit_check,load);
    reg [1:0] state;
    reg [7:0] count;
    parameter [1:0] IDEAL = 2'b00, DATA = 2'b01, PARITY_BIT = 2'b10, STOP_BIT = 2'b11;
 
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            state <= IDEAL;
            
        end else begin
            case (state)
                IDEAL: if (data_i == 1) begin
                      state = DATA;
                      count = 0;
                      $display($time ,"startbit detected"); 
                      load = 1;                 
                      end
                      else
                        state <= IDEAL;
                        
                DATA: if (count !== 4'd7) begin
                    count = count + 1;
                    state = DATA;
                    load = 1;
                    
                end else begin
                    parity_load <= 1'b1;
                    if (paritybit_error)
                      state <= IDEAL;
                    else 
                      state <= STOP_BIT;
                      count <= 0;
                      load <= 0;
                end
                
                STOP_BIT: begin
                    parity_load <= 1'b0;
                    stopbit_check <= 1'b1;
                    state <= IDEAL;
                    
                    $display("stopbit");
                end
             
            endcase
        end
    end
endmodule





module sipo(input clk, rst, input load, input si, output reg[7:0] po);
    reg [7:0] tmp;
    
    always @(posedge clk or posedge rst) begin
       if(rst) 
         po = 8'b0;
       else begin
        if (load) begin
            tmp = {tmp[6:0], si};
            po = tmp;
        end
    end
   end
      
endmodule





module stopbit_checker(input stopbit,check, output reg detect);

 always@(*) begin
 
   if(check) begin
     if(stopbit)
      detect <= 1'b1;
     else 
       detect <= 1'b0 ;
   end  
    
 end
endmodule




module parity_checker(input [7:0] data_in,input check, parity , output reg parity_error);

 always@(*) begin
   if(check)
     if(parity == (^data_in))
       parity_error <= 1'b0;
     else
       parity_error <= 1'b1;
  
 end  
endmodule




