
  module baud_rate_generator(input clk, reset, input [1:0] sel, output reg clkout);
    reg [11:0] count;
    reg [11:0] modulus;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clkout <= 1'b0;
            count <= 0;
        end else if (count == modulus) begin
            count <= 0;
            clkout <= ~clkout;
        end else begin
            count <= count + 1;
        end
    end
    
    always @(sel) begin
        case (sel)
            2'b00: modulus <= 12'd1303;
            2'b01: modulus <= 12'd325;
            2'b10: modulus <= 12'd162;
            2'b11: modulus <= 12'd15;
            default: modulus <= 12'd325;
        endcase
    end
endmodule
