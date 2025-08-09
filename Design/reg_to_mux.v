module Reg_Mux (in,clk,enable,rst,out);
parameter sel = 1;
parameter width = 1;
parameter RSTTYPE = "SYNC";
input [width-1:0] in;
input clk,rst,enable;
reg [width-1:0] out_reg;
output reg [width-1:0] out;
generate
    if(RSTTYPE == "SYNC" )begin
      always @(posedge clk) begin
          if(rst)begin
          out_reg <=0;
        end
        else if(enable)begin
            out_reg <= in;
        end
        out <= (sel==1)?out_reg:in;
        
      end
    end
    else if(RSTTYPE == "ASYNC")begin
      always @(posedge clk , posedge rst) begin
        if(rst)begin
          out_reg <=0;
        end
        else if(enable) begin
          out_reg <= in;
          
        end
        out <= (sel==1)?out_reg:in;
      end
    end
endgenerate
endmodule