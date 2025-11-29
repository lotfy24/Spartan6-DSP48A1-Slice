module DSP48A1_tb ();
    // DEFINE PARAMETERS 
parameter A0REG_tb =0;
parameter A1REG_tb =1;
parameter B0REG_tb =0;
parameter B1REG_tb =1;
parameter CREG_tb =1;
parameter DREG_tb =1;
parameter MREG_tb =1;
parameter PREG_tb =1;
parameter CARRYINREG_tb =1;
parameter CARRYOUTREG_tb =1;
parameter OPMODEREG_tb =1;
parameter CARRYINSEL_tb ="OPMODE5";
parameter B_INPUT_tb ="DIRECT";
parameter RSTTYPE_tb ="SYNC";
// DEFINE INPUTS
reg [17:0] A_tb,B_tb,D_tb,BCIN_tb;
reg [47:0] C_tb,PCIN_tb;
reg [7:0] OPMODE_tb;
reg CLK_tb,CARRYIN_tb,RSTA_tb,RSTB_tb,RSTC_tb,RSTD_tb,RSTM_tb,RSTCARRYIN_tb
,RSTOPMODE_tb,RSTP_tb,CEA_tb,CEB_tb,CEC_tb,CED_tb,CECARYIN_tb,CEM_tb,CEOPMODE_tb,CEP_tb;
// DEFINE INSTANTIATION optputs
wire [17:0] BCOUT_dut;
wire [47:0] PCOUT_dut,P_dut;
wire [35:0] M_dut;
wire CARRYOUT_dut,CARRYOUTF_dut;
// DEFINE EXPECTED OUTPUT
reg [17:0] BCOUT_expected;
reg [47:0] PCOUT_expected,P_expected;
reg [35:0] M_expected;
reg CARRYOUT_expected,CARRYOUTF_expected;
// MODULE INSTANTIATION
DSP48A1 DUT(A_tb,B_tb,C_tb,D_tb,CARRYIN_tb,M_dut,P_dut,CARRYOUT_dut,CARRYOUTF_dut,CLK_tb,OPMODE_tb,
CEA_tb,CEB_tb,CEC_tb,CED_tb,CECARYIN_tb,CEM_tb,CEOPMODE_tb,CEP_tb,RSTA_tb,RSTB_tb,RSTC_tb,RSTD_tb
,RSTM_tb,RSTCARRYIN_tb,RSTOPMODE_tb,RSTP_tb,PCIN_tb,BCIN_tb,BCOUT_dut,PCOUT_dut);

integer i;
// CLOCK GENERATION
initial begin
    CLK_tb =0;
    forever begin
        #1 CLK_tb =~ CLK_tb;
    end
end

// DIRECTED Testbench
initial begin
    // ASSERT ALL RESET SIGNALS
    RSTA_tb = 1;
    RSTB_tb = 1;
    RSTC_tb = 1;
    RSTD_tb = 1;
    RSTM_tb = 1;
    RSTCARRYIN_tb = 1;
    RSTOPMODE_tb = 1;
    RSTP_tb = 1;
    // ENABLE ALL NECESSARY CLOCK ENABLES
    CEA_tb = 1;
    CEB_tb = 1;
    CEC_tb = 1;
    CED_tb = 1;
    CECARYIN_tb = 1;
    CEM_tb = 1;
    CEOPMODE_tb = 1;
    CEP_tb = 1;
    // INITIALIZE ALL INPUT SIGNALS TO ZERO
    A_tb = 0;
    B_tb = 0;
    C_tb = 0;
    D_tb = 0;
    PCIN_tb = 0;
    BCIN_tb = 0;
    CARRYIN_tb = 0;
    OPMODE_tb = 0;
    // INITIALIZE ALL EXPECTED OUTPUT VALUES TO ZERO
    P_expected = 0;
    M_expected = 0;
    CARRYOUT_expected = 0;
    CARRYOUTF_expected = 0;
    BCOUT_expected = 0;
    PCOUT_expected = 0;

    @(negedge CLK_tb);

    // RELEASE ALL RESET SIGNALS
    RSTA_tb = 0;
    RSTB_tb = 0;
    RSTC_tb = 0;
    RSTD_tb = 0;
    RSTM_tb = 0;
    RSTCARRYIN_tb = 0;
    RSTOPMODE_tb = 0;
    RSTP_tb = 0;
    for(i=0;i<99;i=i+1)begin
        OPMODE_tb =$random;
        A_tb = $urandom_range(1,500);
        B_tb = $urandom_range(1,500);
        C_tb = $urandom_range(1,500);
        D_tb = $urandom_range(1,500);
        PCIN_tb = $urandom_range(1,500);
        BCIN_tb = $urandom_range(1,500);
        CARRYIN_tb = $random;
         repeat(3) @(negedge CLK_tb);
        // TEST BOUT OUTPUT
        if(OPMODE_tb[4])begin
            if(OPMODE_tb[6])
              BCOUT_expected = D_tb - B_tb;
            else
              BCOUT_expected =  D_tb + B_tb;
        end
        else begin
          BCOUT_expected = B_tb;
        end
        // TEST MULTIPLICATION OUTPUT
         M_expected = BCOUT_expected * A_tb;
        #20;
        if((M_expected != M_dut) || (BCOUT_expected != BCOUT_dut))begin
          $display("Error");
          $stop;
        end
    end
    //  TEST P AND CARRYOUT AT OPMODE 0000_0010
    OPMODE_tb = 2;
    for(i=0;i<49;i=i+1)begin
        A_tb = $urandom_range(1,500);
        B_tb = $urandom_range(1,500);
        C_tb = $urandom_range(1,500);
        D_tb = $urandom_range(1,500);
        PCIN_tb = $urandom_range(1,500);
        BCIN_tb = $urandom_range(1,500);
         {CARRYOUT_expected,P_expected} = P_expected;
            repeat(4) @(negedge CLK_tb);
            if((P_expected != P_dut) && (CARRYOUT_expected != CARRYOUT_dut))begin
              $display("Error");
              $stop;
            end
    end
    //  TEST P AND CARRYOUT WHEN OUTPUT OF X_MUX IS {D_tb[11:0],A_tb,B_tb} AND Z_MUX IS ZERO
    OPMODE_tb = 3;
    for(i=0;i<49;i=i+1)begin
        A_tb = $urandom_range(1,500);
        B_tb = $urandom_range(1,500);
        C_tb = $urandom_range(1,500);
        D_tb = $urandom_range(1,500);
        PCIN_tb = $urandom_range(1,500);
        BCIN_tb = $urandom_range(1,500);
             {CARRYOUT_expected,P_expected} = {D_tb[11:0],A_tb,B_tb};
              repeat(4) @(negedge CLK_tb);
              if((P_expected != P_dut) && (CARRYOUT_expected != CARRYOUT_dut))begin
                $display("Error");
                $stop;
              end
    end
    //  TEST P AND CARRYOUT WHEN OUTPUT OF X_MUX IS ZERO AND Z_MUX IS ZERO
    OPMODE_tb = 0;
    for(i=0;i<49;i=i+1)begin
        A_tb = $urandom_range(1,500);
        B_tb = $urandom_range(1,500);
        C_tb = $urandom_range(1,500);
        D_tb = $urandom_range(1,500);
        PCIN_tb = $urandom_range(1,500);
        BCIN_tb = $urandom_range(1,500);

             {CARRYOUT_expected,P_expected} = 0;

              repeat(4) @(negedge CLK_tb);
              if((P_expected != P_dut) && (CARRYOUT_expected != CARRYOUT_dut))begin
                $display("Error");
                $stop;
              end
    end
    //  TEST P AND CARRYOUT WHEN OUTPUT OF X_MUX IS MULTIPLICATION AND Z_MUX IS ZERO
     OPMODE_tb = 1;
    for(i=0;i<49;i=i+1)begin
        A_tb = $urandom_range(1,500);
        B_tb = $urandom_range(1,500);
        C_tb = $urandom_range(1,500);
        D_tb = $urandom_range(1,500);
        PCIN_tb = $urandom_range(1,500);
        BCIN_tb = $urandom_range(1,500);
        if(OPMODE_tb[4])begin
            if(OPMODE_tb[6])
              BCOUT_expected = D_tb - B_tb;
            else
              BCOUT_expected =  D_tb + B_tb;
        end
        else begin
          BCOUT_expected = B_tb;
        end
         M_expected = BCOUT_expected * A_tb;
        {CARRYOUT_expected,P_expected} = M_expected;
            repeat(4) @(negedge CLK_tb);
            if((P_expected != P_dut) && (CARRYOUT_expected != CARRYOUT_dut))begin
              $display("Error");
              $stop;
            end
    end
    //  TEST P AND CARRYOUT WHEN OUTPUT OF X_MUX IS ZERO AND Z_MUX IS PCIN
    OPMODE_tb = 8'b0000_0100;
    for(i=0;i<49;i=i+1)begin
        A_tb = $urandom_range(1,500);
        B_tb = $urandom_range(1,500);
        C_tb = $urandom_range(1,500);
        D_tb = $urandom_range(1,500);
        PCIN_tb = $urandom_range(1,500);
        BCIN_tb = $urandom_range(1,500);
        {CARRYOUT_expected,P_expected} = PCIN_tb;
            repeat(4) @(negedge CLK_tb);
            if((P_expected != P_dut) && (CARRYOUT_expected != CARRYOUT_dut))begin
              $display("error");
              $stop;
            end
    end
    //  TEST P AND CARRYOUT WHEN OUTPUT OF X_MUX IS ZERO AND Z_MUX IS C
    OPMODE_tb = 8'b0000_1100;
    for(i=0;i<49;i=i+1)begin
        A_tb = $urandom_range(1,500);
        B_tb = $urandom_range(1,500);
        C_tb = $urandom_range(1,500);
        D_tb = $urandom_range(1,500);
        PCIN_tb = $urandom_range(1,500);
        BCIN_tb = $urandom_range(1,500);
        {CARRYOUT_expected,P_expected} = C_tb;
            repeat(4) @(negedge CLK_tb);
            if((P_expected != P_dut) && (CARRYOUT_expected != CARRYOUT_dut))begin
              $display("error");
              $stop;
            end
    end

     $stop;
end
initial begin
    $monitor("A=%d,B=%d,C=%d,D=%d,BCOUT=%d,M=%d,P=%d,P_dut=%d",A_tb,B_tb,C_tb,D_tb,BCOUT_expected,M_expected,P_expected,P_dut);
end
endmodule
