module Reg_Mux (sel,in,clk,enable,rst,out);
parameter width = 1;
parameter RSTTYPE = "ASYNC";
input [width-1:0] in;
input sel,clk,rst,enable;
output [width-1:0] out;
reg [width-1:0] out_reg;
generate
if(RSTTYPE == "SYNC" )begin
always @(posedge clk) begin
if(rst)begin
out_reg <=0;
end
else if(enable)begin
out_reg <= in;
end
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
end
end
endgenerate
assign out = (sel==1)?out_reg:in;
endmodule