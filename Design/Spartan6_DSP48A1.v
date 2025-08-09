module DSP48A1 (A,B,C,D,CARRYIN,M,P,CARRYOUT,CARRYOUTF,CLK,OPMODE,
CEA,CEB,CEC,CED,CECARYIN,CEM,CEOPMODE,CEP,RSTA,RSTB,RSTC,RSTD
,RSTM,RSTCARRYIN,RSTOPMODE,RSTP,PCIN,BCIN,BCOUT,PCOUT);
// DEFINE PARAMETERS 
parameter A0REG =0;
parameter A1REG =1;
parameter B0REG =0;
parameter B1REG =1;
parameter CREG =1;
parameter DREG =1;
parameter MREG =1;
parameter PREG =1;
parameter CARRYINREG =1;
parameter CARRYOUTREG =1;
parameter OPMODEREG =1;
parameter CARRYINSEL ="OPMODE5";
parameter B_INPUT ="DIRECT";
parameter RSTTYPE ="SYNC";
// DEFINE INPUTS
input [17:0] A,B,D,BCIN;
input [47:0] C,PCIN;
input [7:0] OPMODE;
input CLK,CARRYIN,RSTA,RSTB,RSTC,RSTD,RSTM,RSTCARRYIN,RSTOPMODE,RSTP,CEA,CEB,CEC,CED,CECARYIN,CEM,CEOPMODE,CEP;
// DEFINE OUTPUTS
output [17:0] BCOUT;
output [47:0] PCOUT,P;
output [35:0] M;
output CARRYOUT,CARRYOUTF;
// DEFINE INTERNAL WIRES 
wire [17:0] A0_out,A1_out,B_out,B0_out,B1_out,D_out,Adder1_out,Adder1_mux_out;
wire [47:0] C_out,x_out,z_out,Adder_2_out;
wire [7:0] OPMODE_reg;
wire [35:0] mull_out;
wire cout_ADDER,CI_reg,CI_mux;

// INSTANTIATIONS
// A REG INSTANTIATION
Reg_Mux #(.sel(A0REG),.width(18)) A0_REG(A,CLK,CEA,RSTA,A0_out);
Reg_Mux #(.sel(A1REG),.width(18)) A1_REG(A0_out,CLK,CEA,RSTA,A1_out);
// B REG INSTANTIATION
Reg_Mux #(.sel(B0REG),.width(18)) B0_REG(B_out,CLK,CEB,RSTB,B0_out);
Reg_Mux #(.sel(B1REG),.width(18)) B1_REG(Adder1_mux_out,CLK,CEB,RSTB,B1_out);
// C REG INSTANTIATION
Reg_Mux #(.sel(CREG),.width(48)) C_REG(C,CLK,CEC,RSTC,C_out);
// D REG INSTANTIATION
Reg_Mux #(.sel(DREG),.width(18)) D_REG(D,CLK,CED,RSTD,D_out);
// M REG INSTANTIATION
Reg_Mux #(.sel(MREG),.width(36)) M_REG(mull_out,CLK,CEM,RSTM,M);
// CYI INSTANTIATION
Reg_Mux #(.sel(CARRYINREG),.width(1)) CYI_REG(CI_mux,CLK,CECARYIN,RSTCARRYIN,CI_reg);
// CYO INSTANTATION
Reg_Mux #(.sel(CARRYOUTREG),.width(1)) CYO_REG(cout_ADDER,CLK,CECARYIN,RSTCARRYIN,CARRYOUT);
// P REG INSTANTIATION
Reg_Mux #(.sel(PREG),.width(48)) P_REG(Adder_2_out,CLK,CEP,RSTP,P);
// OPMODE REG INSTANTIATION
Reg_Mux #(.sel(OPMODEREG),.width(8)) OPMODE_REG(OPMODE[7:0],CLK,CEOPMODE,RSTOPMODE,OPMODE_reg[7:0]);
    // SELECT THE INPUT OF B 
    assign B_out =(B_INPUT=="DIRECT")?B:(B_INPUT=="CASCADE")?BCIN:0;
    // SELECT BETWEEN ADDATION & SUBTRACTION OPERATIONS AT THE FIRST ADDER
    assign Adder1_out =(OPMODE_reg[6]==1)?D_out - B0_out:D_out + B0_out;
    // SELECT THE OUTPUT OF THE MUX WHICH IS INFRONT OF  THE FIRST ADDER
    assign  Adder1_mux_out = (OPMODE_reg[4]==1)?Adder1_out:B0_out;
    assign  mull_out = B1_out * A1_out;
    assign M = ~(~M);
    // SELECT THE OUTPUT OF MUX (X)
    assign x_out= (OPMODE_reg[1:0]==0)?48'b0:(OPMODE_reg[1:0]==1)?{12'b0,M}:(OPMODE_reg[1:0]==2)?P:{D[11:0],A[17:0],B[17:0]};
    // SELECT THE OUTPUT OF MUX (Z)
    assign z_out= (OPMODE_reg[3:2]==0)?48'b0:(OPMODE_reg[3:2]==1)?PCIN:(OPMODE_reg[3:2]==2)?P:C_out;
    // SELECT THE OF THE CARRY IN MUX
    assign CI_mux=(CARRYINSEL == "OPMODE5")?OPMODE_reg[5]:(CARRYINSEL == "CARRYIN")?CARRYIN:0;
    assign  {cout_ADDER,Adder_2_out} = (OPMODE_reg[7]==1)?z_out-(x_out+CI_reg):z_out + x_out + CI_reg;
    assign  CARRYOUTF = CARRYOUT;
    assign  BCOUT =B1_out;
    assign  PCOUT= P; 
endmodule