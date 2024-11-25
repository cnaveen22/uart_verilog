
module UART_TX(input start_bit, clk , rst, stop_bit, [7:0] tx_data, output  TX_data_out);

 wire [1:0] selm;
 fsmtx FSM ( start_bit, rst, clk,  shift, selm);
 mux4x1 MUX ( rst,start_bit, data_out,parity,stop_bit,  selm, TX_data_out);
 even_parity_generator epg (tx_data, parity);
 PISO piso (tx_data ,shift, clk, rst, data_out);
  
endmodule




module fsmtx(input start_bit, rst, clk, output reg shift, output reg [1:0] sel );
    parameter [2:0] IDEAL = 3'b000, STARTBIT = 3'b001, DATABIT = 3'b010, PARITYBIT = 3'b011, STOPBIT = 3'b100;
    reg [2:0] state;
    reg [3:0] count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDEAL;
            count <= 0;
            shift <= 0;
            
        end else begin
            case (state)
                IDEAL: if (start_bit)
                          state <= STARTBIT;
                       else
                          sel = 2'bxx ;
                        
                STARTBIT: begin
                    sel <= 2'b00;
                    state <= DATABIT;
                end
                DATABIT: begin
                    if (count !== 4'd8) begin
                        count <= count + 1;
                        sel <= 2'b01;
                        shift <= 1;
                    end else begin
                        count <= 0;
                        state <= STOPBIT;
                        shift <= 0;
                        sel <= 2'b10;
                        
                    end
                end
                
                STOPBIT: begin
                    sel <= 2'b11;
                    state <= IDEAL;
                    
                end
                default: state <= IDEAL;
            endcase
        end
    end
endmodule





module mux4x1(input rst, i1, i2, i3, i4, input [1:0] sel, output reg out);
    always @(*) begin
      if(rst)
        out <= 0;
      else begin
        case (sel)
            2'b00: out <= i1;
            2'b01: out <= i2;
            2'b10: out <= i3;
            2'b11: out <= i4; // Corrected from 14 to i4
            
        endcase
    end
   end
endmodule




module even_parity_generator(input [7:0] data_in, output reg parity);
    always @(*) begin
        parity <= ^data_in[7:0]; // XOR reduction operator for parity
    end
endmodule



module PISO(input [7:0] data_in, input shift, input clk, input rst, output reg data_out);
    
    reg [7:0] tmp ;
    always @(posedge clk or posedge rst) begin
      if(rst) begin
        tmp <= data_in;
        data_out <= data_in[7];  // Initialize data_out to a known value on reset
      end
      else begin
        if (shift) begin
            data_out <= tmp[6];
            tmp <= {tmp[5:0], 1'b0};
        end
      end
    end
endmodule

