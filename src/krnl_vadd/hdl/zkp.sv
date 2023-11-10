module zkp 
   #(
    parameter P = 256'h30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47,
    parameter DAT_BITS = 256,
    parameter MULT_LEVEL = 1,
    parameter ADD_LEVEL  = 1,
    parameter b          = 3,
    parameter SUB_LEVEL  = 1
    // parameter 


   ) (
    input aclk,
    input areset,
    input [DAT_BITS-1:0] X1_dat,
    input [DAT_BITS-1:0] Y1_dat,
    input [DAT_BITS-1:0] Z1_dat,
    input [DAT_BITS-1:0] X2_dat,
    input [DAT_BITS-1:0] Y2_dat,
    // input [DAT_BITS-1:0] Z2_dat,
    input                X1_val,
    input                Y1_val,
    input                Z1_val,
    input                X2_val,
    input                Y2_val,
    // input                Z2_val,
    output               X1_rdy,
    output               Y1_rdy,
    output               Z1_rdy,
    output               X2_rdy,
    output               Y2_rdy,
    // output               Z2_rdy,
    
    output[DAT_BITS-1:0] X3_dat,
    output[DAT_BITS-1:0] Y3_dat,
    output[DAT_BITS-1:0] Z3_dat,
    output[DAT_BITS-1:0] X3_val,
    output[DAT_BITS-1:0] Y3_val,
    output[DAT_BITS-1:0] Z3_val,
    input                X3_rdy,
    input                Y3_rdy,
    input                Z3_rdy,
   );
    
    logic [1:0][DAT_BITS-1:0] mult_1_i_dat;
    logic [1:0]               mult_1_i_val;
    logic [1:0]               mult_1_i_rdy;
    logic [1:0][DAT_BITS-1:0] mult_2_i_dat;
    logic [1:0]               mult_2_i_val;
    logic [1:0]               mult_2_i_rdy;
    always_comb begin
    mult_1_i_dat[0] = X1_dat;
    mult_1_i_val[0] = X1_val;
    X1_rdy = mult_1_i_rdy[0];
    mult_1_i_dat[1] = X2_dat;
    mult_1_i_val[1] = X2_val;
    X2_rdy = mult_1_i_rdy[1];
    mult_2_i_dat[0] = Y1_dat;
    mult_2_i_val[0] = Y1_val;
    Y1_rdy = mult_2_i_rdy[0];
    mult_2_i_dat[1] = Y2_dat;
    mult_2_i_val[1] = Y2_val;
    Y2_rdy = mult_2_i_rdy[1];
    end


    logic [DAT_BITS-1:0] t1_dat;
    logic                t1_val;
    logic                t1_rdy;
    logic [DAT_BITS-1:0] t2_dat;
    logic                t2_val;
    logic                t2_rdy;

//   Stage 1
    ofman_mult_barret # (
        .P(P),
        .DAT_BITS(DAT_BITS),
        .LEVEL(MULT_LEVEL)
    ) mult_1 (
      .aclk  (aclk),
      .areset  (areset),
      .s_tdata(mult_1_i_dat),
      .s_tvalid(mult_1_i_val),
      .s_tready(mult_1_i_rdy),
      .m_tdata (t1_dat),
      .m_tvalid(t1_val),
      .m_tready(t1_rdy)
  );

    ofman_mult_barret # (
        .P(P),
        .DAT_BITS(DAT_BITS),
        .LEVEL(MULT_LEVEL)
    ) mult_2 (
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (mult_2_i_dat),
      .s_tvalid(mult_2_i_val),
      .s_tready(mult_2_i_rdy),
      .m_tdata (t2_dat),
      .m_tvalid(t2_val),
      .m_tready(t2_rdy)
  );

    logic [1:0][DAT_BITS-1:0] add_3_i_dat;
    logic [1:0]               add_3_i_val;
    logic [1:0]               add_3_i_rdy;
    logic      [DAT_BITS-1:0] t3_dat;
    logic                     t3_val;
    logic                     t3_rdy;
    always_comb begin
    add_3_i_dat[0] = X2_dat;
    add_3_i_val[0] = X2_val;
    X2_rdy = add_3_i_rdy[0];
    add_3_i_dat[1] = Y2_dat;
    add_3_i_val[1] = Y2_val;
    Y2_rdy = add_3_i_rdy[1];
    end
    adder_pipe # (
        .P(P),
        .C_DATA_WIDTH(DAT_BITS),
        .LEVEL(ADD_LEVEL)
    )  add_3(
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (add_3_i_dat),
      .s_tvalid(add_3_i_val),
      .s_tready(add_3_i_rdy),
      .m_tdata (t3_dat),
      .m_tvalid(t3_val),
      .m_tready(t3_rdy)
  );

    logic [1:0][DAT_BITS-1:0] add_4_i_dat;
    logic [1:0]               add_4_i_val;
    logic [1:0]               add_4_i_rdy;
    logic      [DAT_BITS-1:0] t4_dat;
    logic                     t4_val;
    logic                     t4_rdy;
    always_comb begin
    add_4_i_dat[0] = X1_dat;
    add_4_i_val[0] = X1_val;
    X1_rdy = add_4_i_rdy[0];
    add_4_i_dat[1] = Y1_dat;
    add_4_i_val[1] = Y1_val;
    Y1_rdy = add_4_i_rdy[1];
    end
  adder_pipe # (
        .P(P),
        .C_DATA_WIDTH(DAT_BITS),
        .LEVEL(ADD_LEVEL)
    )  add_3(
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (add_4_i_dat),
      .s_tvalid(add_4_i_val),
      .s_tready(add_4_i_rdy),
      .m_tdata (t4_dat),
      .m_tvalid(t4_val),
      .m_tready(t4_rdy)
  );

    logic [1:0][DAT_BITS-1:0] mult_8_i_dat;
    logic [1:0]               mult_8_i_val;
    logic [1:0]               mult_8_i_rdy;
    logic      [DAT_BITS-1:0] t8_dat;
    logic                     t8_val;
    logic                     t8_rdy;
    always_comb begin
    mult_8_i_dat[0] = Y2_dat;
    mult_8_i_val[0] = Y2_val;
    Y2_rdy = mult_8_i_rdy[0];
    mult_8_i_dat[1] = Z1_dat;
    mult_8_i_val[1] = Z1_val;
    Z1_rdy = mult_8_i_rdy[1];
    end
    ofman_mult_barret # (
        .P(P),
        .DAT_BITS(DAT_BITS),
        .LEVEL(MULT_LEVEL)
    ) mult_8 (
      .aclk  (aclk),
      .areset  (areset),
      .s_tdata (mult_8_i_dat),
      .s_tvalid(mult_8_i_val),
      .s_tready(mult_8_i_rdy),
      .m_tdata (t8_dat),
      .m_tvalid(t8_val),
      .m_tready(t8_rdy)
  );

    logic [1:0][DAT_BITS-1:0] mult_10_i_dat;
    logic [1:0]               mult_10_i_val;
    logic [1:0]               mult_10_i_rdy;
    logic      [DAT_BITS-1:0] t10_dat;
    logic                     t10_val;
    logic                     t10_rdy;
    always_comb begin
    mult_10_i_dat[0] = X2_dat;
    mult_10_i_val[0] = X2_val;
    X2_rdy = mult_10_i_rdy[0];
    mult_10_i_dat[1] = Z1_dat;
    mult_10_i_val[1] = Z1_val;
    Z1_rdy = mult_10_i_rdy[1];
    end
    ofman_mult_barret # (
        .P(P),
        .DAT_BITS(DAT_BITS),
        .LEVEL(MULT_LEVEL)
    ) mult_10 (
      .aclk  (aclk),
      .areset  (areset),
      .s_tdata (mult_10_i_dat),
      .s_tvalid(mult_10_i_val),
      .s_tready(mult_10_i_rdy),
      .m_tdata (t10_dat),
      .m_tvalid(t10_val),
      .m_tready(t10_rdy)
  );

    logic [1:0][DAT_BITS-1:0] mult_14_i_dat;
    logic [1:0]               mult_14_i_val;
    logic [1:0]               mult_14_i_rdy;
    logic      [DAT_BITS-1:0] t14_dat;
    logic                     t14_val;
    logic                     t14_rdy;
    always_comb begin
    mult_14_i_dat[0] = 3*b;
    mult_14_i_val[0] = 1;
    // X2_rdy = mult_10_i_rdy[0];
    mult_14_i_dat[1] = Z1_dat;
    mult_14_i_val[1] = Z1_val;
    Z1_rdy = mult_14_i_rdy[1];
    end
    ofman_mult_barret # (
        .P(P),
        .DAT_BITS(DAT_BITS),
        .LEVEL(MULT_LEVEL)
    ) mult_14 (
      .aclk  (aclk),
      .areset  (areset),
      .s_tdata (mult_14_i_dat),
      .s_tvalid(mult_14_i_val),
      .s_tready(mult_14_i_rdy),
      .m_tdata (t14_dat),
      .m_tvalid(t14_val),
      .m_tready(t14_rdy)
  );

//    Stage 2     
    logic [1:0][DAT_BITS-1:0] mult_5_i_dat;
    logic [1:0]               mult_5_i_val;
    logic [1:0]               mult_5_i_rdy;
    logic      [DAT_BITS-1:0] t5_dat;
    logic                     t5_val;
    logic                     t5_rdy;
    always_comb begin
    mult_5_i_dat[0] = t3_dat;
    mult_5_i_val[0] = t3_val;
    t3_rdy = mult_5_i_rdy[0];
    mult_5_i_dat[1] = t4_dat;
    mult_5_i_val[1] = t4_val;
    t4_rdy = mult_5_i_rdy[1];
    end
    ofman_mult_barret # (
        .P(P),
        .DAT_BITS(DAT_BITS),
        .LEVEL(MULT_LEVEL)
    ) mult_5 (
      .aclk  (aclk),
      .areset  (areset),
      .s_tdata (mult_5_i_dat),
      .s_tvalid(mult_5_i_val),
      .s_tready(mult_5_i_rdy),
      .m_tdata (t5_dat),
      .m_tvalid(t5_val),
      .m_tready(t5_rdy)
  );

    logic [1:0][DAT_BITS-1:0] add_6_i_dat;
    logic [1:0]               add_6_i_val;
    logic [1:0]               add_6_i_rdy;
    logic      [DAT_BITS-1:0] t6_dat;
    logic                     t6_val;
    logic                     t6_rdy;
    always_comb begin
    add_6_i_dat[0] = t1_dat;
    add_6_i_val[0] = t1_val;
    t1_rdy = add_6_i_rdy[0];
    add_6_i_dat[1] = t2_dat;
    add_6_i_val[1] = t2_val;
    t2_rdy = add_6_i_rdy[1];
    end
  adder_pipe # (
        .P(P),
        .C_DATA_WIDTH(DAT_BITS),
        .LEVEL(ADD_LEVEL)
    )  add_3(
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (add_6_i_dat),
      .s_tvalid(add_6_i_val),
      .s_tready(add_6_i_rdy),
      .m_tdata (t6_dat),
      .m_tvalid(t6_val),
      .m_tready(t6_rdy)
  );

    logic [1:0][DAT_BITS-1:0] add_9_i_dat;
    logic [1:0]               add_9_i_val;
    logic [1:0]               add_9_i_rdy;
    logic      [DAT_BITS-1:0] t9_dat;
    logic                     t9_val;
    logic                     t9_rdy;
    always_comb begin
    add_9_i_dat[0] = t8_dat;
    add_9_i_val[0] = t8_val;
    t8_rdy = add_9_i_rdy[0];
    add_9_i_dat[1] = Y1_dat;
    add_9_i_val[1] = Y1_val;
    Y1_rdy = add_9_i_rdy[1];
    end
  adder_pipe # (
        .P(P),
        .C_DATA_WIDTH(DAT_BITS),
        .LEVEL(ADD_LEVEL)
    )  add_9(
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (add_9_i_dat),
      .s_tvalid(add_9_i_val),
      .s_tready(add_9_i_rdy),
      .m_tdata (t9_dat),
      .m_tvalid(t9_val),
      .m_tready(t9_rdy)
  );
    
    logic [1:0][DAT_BITS-1:0] add_11_i_dat;
    logic [1:0]               add_11_i_val;
    logic [1:0]               add_11_i_rdy;
    logic      [DAT_BITS-1:0] t11_dat;
    logic                     t11_val;
    logic                     t11_rdy;
    always_comb begin
    add_11_i_dat[0] = t10_dat;
    add_11_i_val[0] = t10_val;
    t10_rdy = add_11_i_rdy[0];
    add_11_i_dat[1] = X1_dat;
    add_11_i_val[1] = X1_val;
    X1_rdy = add_11_i_rdy[1];
    end
  adder_pipe # (
        .P(P),
        .C_DATA_WIDTH(DAT_BITS),
        .LEVEL(ADD_LEVEL)
    )  add_11(
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (add_11_i_dat),
      .s_tvalid(add_11_i_val),
      .s_tready(add_11_i_rdy),
      .m_tdata (t11_dat),
      .m_tvalid(t11_val),
      .m_tready(t11_rdy)
  );

    logic [1:0][DAT_BITS-1:0] add_12_i_dat;
    logic [1:0]               add_12_i_val;
    logic [1:0]               add_12_i_rdy;
    logic      [DAT_BITS-1:0] t12_dat;
    logic                     t12_val;
    logic                     t12_rdy;
    always_comb begin
    add_12_i_dat[0] = t1_dat;
    add_12_i_val[0] = t1_val;
    t1_rdy = add_12_i_rdy[0];
    add_12_i_dat[1] = t1_dat;
    add_12_i_val[1] = t1_val;
    t1_rdy = add_12_i_rdy[1];
    end
  adder_pipe # (
        .P(P),
        .C_DATA_WIDTH(DAT_BITS),
        .LEVEL(ADD_LEVEL)
    )  add_12(
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (add_12_i_dat),
      .s_tvalid(add_12_i_val),
      .s_tready(add_12_i_rdy),
      .m_tdata (t12_dat),
      .m_tvalid(t12_val),
      .m_tready(t12_rdy)
  );

// Stage 3
    logic [1:0][DAT_BITS-1:0] sub_7_i_dat;
    logic [1:0]               sub_7_i_val;
    logic [1:0]               sub_7_i_rdy;
    logic      [DAT_BITS-1:0] t7_dat;
    logic                     t7_val;
    logic                     t7_rdy;
    always_comb begin
    sub_7_i_dat[0] = t5_dat;
    sub_7_i_val[0] = t5_val;
    t5_rdy = sub_7_i_rdy[0];
    sub_7_i_dat[1] = t6_dat;
    sub_7_i_val[1] = t6_val;
    t6_rdy = sub_7_i_rdy[1];
    end
  adder_pipe # (
        .P(P),
        .C_DATA_WIDTH(DAT_BITS),
        .LEVEL(ADD_LEVEL)
    )  sub_7(
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (sub_7_i_dat),
      .s_tvalid(sub_7_i_val),
      .s_tready(sub_7_i_rdy),
      .m_tdata (t7_dat),
      .m_tvalid(t7_val),
      .m_tready(t7_rdy)
  );

    logic [1:0][DAT_BITS-1:0] add_13_i_dat;
    logic [1:0]               add_13_i_val;
    logic [1:0]               add_13_i_rdy;
    logic      [DAT_BITS-1:0] t13_dat;
    logic                     t13_val;
    logic                     t13_rdy;
    always_comb begin
    add_13_i_dat[0] = t12_dat;
    add_13_i_val[0] = t12_val;
    t12_rdy = add_13_i_rdy[0];
    add_13_i_dat[1] = t13_dat;
    add_13_i_val[1] = t13_val;
    t13_rdy = add_13_i_rdy[1];
    end
  adder_pipe # (
        .P(P),
        .C_DATA_WIDTH(DAT_BITS),
        .LEVEL(ADD_LEVEL)
    )  add_13(
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (add_13_i_dat),
      .s_tvalid(add_13_i_val),
      .s_tready(add_13_i_rdy),
      .m_tdata (t13_dat),
      .m_tvalid(t13_val),
      .m_tready(t13_rdy)
  );
    
    logic [1:0][DAT_BITS-1:0] add_15_i_dat;
    logic [1:0]               add_15_i_val;
    logic [1:0]               add_15_i_rdy;
    logic      [DAT_BITS-1:0] t15_dat;
    logic                     t15_val;
    logic                     t15_rdy;
    always_comb begin
    add_15_i_dat[0] = t2_dat;
    add_15_i_val[0] = t2_val;
    t2_rdy = add_15_i_rdy[0];
    add_15_i_dat[1] = t14_dat;
    add_15_i_val[1] = t14_val;
    t14_rdy = add_15_i_rdy[1];
    end
  adder_pipe # (
        .P(P),
        .C_DATA_WIDTH(DAT_BITS),
        .LEVEL(ADD_LEVEL)
    )  add_15(
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (add_15_i_dat),
      .s_tvalid(add_15_i_val),
      .s_tready(add_15_i_rdy),
      .m_tdata (t15_dat),
      .m_tvalid(t15_val),
      .m_tready(t15_rdy)
  );
    
    logic [1:0][DAT_BITS-1:0] sub_16_i_dat;
    logic [1:0]               sub_16_i_val;
    logic [1:0]               sub_16_i_rdy;
    logic      [DAT_BITS-1:0] t16_dat;
    logic                     t16_val;
    logic                     t16_rdy;
    always_comb begin
    sub_16_i_dat[0] = t2_dat;
    sub_16_i_val[0] = t2_val;
    t2_rdy = sub_16_i_rdy[0];
    sub_16_i_dat[1] = t14_dat;
    sub_16_i_val[1] = t14_val;
    t14_rdy = sub_16_i_rdy[1];
    end
  adder_pipe # (
        .P(P),
        .C_DATA_WIDTH(DAT_BITS),
        .LEVEL(ADD_LEVEL)
    )  sub_7(
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (sub_16_i_dat),
      .s_tvalid(sub_16_i_val),
      .s_tready(sub_16_i_rdy),
      .m_tdata (t16_dat),
      .m_tvalid(t16_val),
      .m_tready(t16_rdy)
  );

    logic [1:0][DAT_BITS-1:0] mult_17_i_dat;
    logic [1:0]               mult_17_i_val;
    logic [1:0]               mult_17_i_rdy;
    logic      [DAT_BITS-1:0] t17_dat;
    logic                     t17_val;
    logic                     t17_rdy;
    always_comb begin
    mult_17_i_dat[0] = 3*b;
    mult_17_i_val[0] = 1;
    // t3_rdy = mult_5_i_rdy[0];
    mult_17_i_dat[1] = t11_dat;
    mult_17_i_val[1] = t11_val;
    t11_rdy = mult_17_i_rdy[1];
    end
    ofman_mult_barret # (
        .P(P),
        .DAT_BITS(DAT_BITS),
        .LEVEL(MULT_LEVEL)
    ) mult_17 (
      .aclk  (aclk),
      .areset  (areset),
      .s_tdata (mult_17_i_dat),
      .s_tvalid(mult_17_i_val),
      .s_tready(mult_17_i_rdy),
      .m_tdata (t17_dat),
      .m_tvalid(t17_val),
      .m_tready(t17_rdy)
  );

//Stage 4
    logic [1:0][DAT_BITS-1:0] mult_18_i_dat;
    logic [1:0]               mult_18_i_val;
    logic [1:0]               mult_18_i_rdy;
    logic      [DAT_BITS-1:0] t18_dat;
    logic                     t18_val;
    logic                     t18_rdy;
    always_comb begin
    mult_18_i_dat[0] = t9_dat;
    mult_18_i_val[0] = t9_val;
    t9_rdy = mult_18_i_rdy[0];
    mult_18_i_dat[1] = t17_dat;
    mult_18_i_val[1] = t17_val;
    t17_rdy = mult_18_i_rdy[1];
    end
    ofman_mult_barret # (
        .P(P),
        .DAT_BITS(DAT_BITS),
        .LEVEL(MULT_LEVEL)
    ) mult_18 (
      .aclk  (aclk),
      .areset  (areset),
      .s_tdata (mult_18_i_dat),
      .s_tvalid(mult_18_i_val),
      .s_tready(mult_18_i_rdy),
      .m_tdata (t18_dat),
      .m_tvalid(t18_val),
      .m_tready(t18_rdy)
  );

    logic [1:0][DAT_BITS-1:0] mult_19_i_dat;
    logic [1:0]               mult_19_i_val;
    logic [1:0]               mult_18_i_rdy;
    logic      [DAT_BITS-1:0] t19_dat;
    logic                     t19_val;
    logic                     t19_rdy;
    always_comb begin
    mult_19_i_dat[0] = t7_dat;
    mult_19_i_val[0] = t7_val;
    t7_rdy = mult_19_i_rdy[0];
    mult_19_i_dat[1] = t16_dat;
    mult_19_i_val[1] = t16_val;
    t16_rdy = mult_19_i_rdy[1];
    end
    ofman_mult_barret # (
        .P(P),
        .DAT_BITS(DAT_BITS),
        .LEVEL(MULT_LEVEL)
    ) mult_19 (
      .aclk  (aclk),
      .areset  (areset),
      .s_tdata (mult_19_i_dat),
      .s_tvalid(mult_19_i_val),
      .s_tready(mult_19_i_rdy),
      .m_tdata (t19_dat),
      .m_tvalid(t19_val),
      .m_tready(t19_rdy)
  );

    logic [1:0][DAT_BITS-1:0] mult_21_i_dat;
    logic [1:0]               mult_21_i_val;
    logic [1:0]               mult_21_i_rdy;
    logic      [DAT_BITS-1:0] t21_dat;
    logic                     t21_val;
    logic                     t21_rdy;
    always_comb begin
    mult_21_i_dat[0] = t17_dat;
    mult_21_i_val[0] = t17_val;
    t17_rdy = mult_21_i_rdy[0];
    mult_21_i_dat[1] = t13_dat;
    mult_21_i_val[1] = t13_val;
    t13_rdy = mult_21_i_rdy[1];
    end
    ofman_mult_barret # (
        .P(P),
        .DAT_BITS(DAT_BITS),
        .LEVEL(MULT_LEVEL)
    ) mult_21 (
      .aclk  (aclk),
      .areset  (areset),
      .s_tdata (mult_21_i_dat),
      .s_tvalid(mult_21_i_val),
      .s_tready(mult_21_i_rdy),
      .m_tdata (t21_dat),
      .m_tvalid(t21_val),
      .m_tready(t21_rdy)
  );
    
    logic [1:0][DAT_BITS-1:0] mult_22_i_dat;
    logic [1:0]               mult_22_i_val;
    logic [1:0]               mult_22_i_rdy;
    logic      [DAT_BITS-1:0] t22_dat;
    logic                     t22_val;
    logic                     t22_rdy;
    always_comb begin
    mult_22_i_dat[0] = t16_dat;
    mult_22_i_val[0] = t16_val;
    t16_rdy = mult_22_i_rdy[0];
    mult_22_i_dat[1] = t15_dat;
    mult_22_i_val[1] = t15_val;
    t15_rdy = mult_22_i_rdy[1];
    end
    ofman_mult_barret # (
        .P(P),
        .DAT_BITS(DAT_BITS),
        .LEVEL(MULT_LEVEL)
    ) mult_21 (
      .aclk  (aclk),
      .areset  (areset),
      .s_tdata (mult_21_i_dat),
      .s_tvalid(mult_21_i_val),
      .s_tready(mult_21_i_rdy),
      .m_tdata (t21_dat),
      .m_tvalid(t21_val),
      .m_tready(t21_rdy)
  );
    
    logic [1:0][DAT_BITS-1:0] mult_24_i_dat;
    logic [1:0]               mult_24_i_val;
    logic [1:0]               mult_24_i_rdy;
    logic      [DAT_BITS-1:0] t24_dat;
    logic                     t24_val;
    logic                     t24_rdy;
    always_comb begin
    mult_24_i_dat[0] = t13_dat;
    mult_24_i_val[0] = t13_val;
    t13_rdy = mult_24_i_rdy[0];
    mult_24_i_dat[1] = t7_dat;
    mult_24_i_val[1] = t7_val;
    t7_rdy = mult_24_i_rdy[1];
    end
    ofman_mult_barret # (
        .P(P),
        .DAT_BITS(DAT_BITS),
        .LEVEL(MULT_LEVEL)
    ) mult_24 (
      .aclk  (aclk),
      .areset  (areset),
      .s_tdata (mult_24_i_dat),
      .s_tvalid(mult_24_i_val),
      .s_tready(mult_24_i_rdy),
      .m_tdata (t24_dat),
      .m_tvalid(t24_val),
      .m_tready(t24_rdy)
  );

    logic [1:0][DAT_BITS-1:0] mult_25_i_dat;
    logic [1:0]               mult_25_i_val;
    logic [1:0]               mult_25_i_rdy;
    logic      [DAT_BITS-1:0] t25_dat;
    logic                     t25_val;
    logic                     t25_rdy;
    always_comb begin
    mult_25_i_dat[0] = t15_dat;
    mult_25_i_val[0] = t15_val;
    t15_rdy = mult_24_i_rdy[0];
    mult_24_i_dat[1] = t9_dat;
    mult_24_i_val[1] = t9_val;
    t9_rdy = mult_24_i_rdy[1];
    end
    ofman_mult_barret # (
        .P(P),
        .DAT_BITS(DAT_BITS),
        .LEVEL(MULT_LEVEL)
    ) mult_25 (
      .aclk  (aclk),
      .areset  (areset),
      .s_tdata (mult_25_i_dat),
      .s_tvalid(mult_25_i_val),
      .s_tready(mult_25_i_rdy),
      .m_tdata (t25_dat),
      .m_tvalid(t25_val),
      .m_tready(t25_rdy)
  );

//Stage 5
    logic [1:0][DAT_BITS-1:0] sub_20_i_dat;
    logic [1:0]               sub_20_i_val;
    logic [1:0]               sub_20_i_rdy;
    logic      [DAT_BITS-1:0] t20_dat;
    logic                     t20_val;
    logic                     t20_rdy;
    always_comb begin
    sub_20_i_dat[0] = t19_dat;
    sub_20_i_val[0] = t19_val;
    t19_rdy = sub_20_i_rdy[0];
    sub_7_i_dat[1] = t18_dat;
    sub_7_i_val[1] = t18_val;
    t18_rdy = sub_20_i_rdy[1];
    end
  adder_pipe # (
        .P(P),
        .C_DATA_WIDTH(DAT_BITS),
        .LEVEL(ADD_LEVEL)
    )  sub_20(
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (sub_20_i_dat),
      .s_tvalid(sub_20_i_val),
      .s_tready(sub_20_i_rdy),
      .m_tdata (t20_dat),
      .m_tvalid(t20_val),
      .m_tready(t20_rdy)
  );

    logic [1:0][DAT_BITS-1:0] add_23_i_dat;
    logic [1:0]               add_23_i_val;
    logic [1:0]               add_23_i_rdy;
    logic      [DAT_BITS-1:0] t23_dat;
    logic                     t23_val;
    logic                     t23_rdy;
    always_comb begin
    add_23_i_dat[0] = t22_dat;
    add_23_i_val[0] = t22_val;
    t22_rdy = add_23_i_rdy[0];
    add_23_i_dat[1] = t21_dat;
    add_23_i_val[1] = t21_val;
    t21_rdy = add_23_i_rdy[1];
    end
  adder_pipe # (
        .P(P),
        .C_DATA_WIDTH(DAT_BITS),
        .LEVEL(ADD_LEVEL)
    )  add_23(
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (add_23_i_dat),
      .s_tvalid(add_23_i_val),
      .s_tready(add_23_i_rdy),
      .m_tdata (t23_dat),
      .m_tvalid(t23_val),
      .m_tready(t23_rdy)
  );
    

    logic [1:0][DAT_BITS-1:0] add_26_i_dat;
    logic [1:0]               add_26_i_val;
    logic [1:0]               add_26_i_rdy;
    logic      [DAT_BITS-1:0] t26_dat;
    logic                     t26_val;
    logic                     t26_rdy;
    always_comb begin
    add_26_i_dat[0] = t25_dat;
    add_26_i_val[0] = t25_val;
    t25_rdy = add_26_i_rdy[0];
    add_26_i_dat[1] = t24_dat;
    add_26_i_val[1] = t24_val;
    t24_rdy = add_26_i_rdy[1];
    end
  adder_pipe # (
        .P(P),
        .C_DATA_WIDTH(DAT_BITS),
        .LEVEL(ADD_LEVEL)
    )  add_26(
      .aclk    (aclk),
      .areset  (areset),
      .s_tdata (add_26_i_dat),
      .s_tvalid(add_26_i_val),
      .s_tready(add_26_i_rdy),
      .m_tdata (t26_dat),
      .m_tvalid(t26_val),
      .m_tready(t26_rdy)
  );
    
  endmodule