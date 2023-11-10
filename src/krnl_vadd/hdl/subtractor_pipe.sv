module subtractor_pipe # (
  parameter  P = 100,
  parameter  BITS = $clog2(P),
  parameter  C_DATA_WIDTH = 32,
  parameter  C_NUM_CHANNELS = 2,
  parameter  CTL_BITS = 8,
  parameter  LEVEL = 1      // If LEVEL == 1 this is just an add with registered output
) (
  input                aclk,
  input                areset,
  input  logic  [C_NUM_CHANNELS-1:0]                   s_tvalid,
  input  logic  [C_NUM_CHANNELS-1:0][C_DATA_WIDTH-1:0] s_tdata ,
  output logic  [C_NUM_CHANNELS-1:0]                   s_tready,

  output wire                                        m_tvalid,
  output wire [C_DATA_WIDTH-1:0]                     m_tdata,
  input  wire                                        m_tready
//   if_axi_stream.sink   i_add,
//   if_axi_stream.source o_add
);


// Internally we want to use a even divisor for BITS of BITS/LEVEL
localparam DAT_BITS = BITS + (BITS % LEVEL);
localparam BITS_LEVEL = DAT_BITS/LEVEL;

logic [DAT_BITS-1:0] P_;

logic [LEVEL:0][DAT_BITS:0] result0, result1;
logic [LEVEL:0][DAT_BITS:0] a, b;
// logic [LEVEL:0][1:0] sop_eop;
logic [LEVEL:0][CTL_BITS-1:0] ctl;   // Top ctl bit we use to check if this needs a subtraction in P
logic [LEVEL:0] val, rdy;
logic [LEVEL:0] carry_neg0, carry_neg1;;
always_comb begin
 s_tready[0] = rdy[0]&&val[0];
 s_tready[1] = rdy[0]&&val[0];
end
assign m_tdata = carry_neg1[LEVEL] ? result0[LEVEL] : result1[LEVEL];
assign m_tvalid = val[LEVEL];


always_comb begin
  P_ = 0;
  P_ = P;
  carry_neg0[0] = 0;
  carry_neg1[0] = 0;
  val[0] = s_tvalid[0]&&s_tvalid[1];
//   ctl[0] = i_add.ctl;
  a[0] = 0;
  a[0] = s_tdata[0][0 +: BITS];
  b[0] = 0;
  b[0] = s_tdata[1][0 +: BITS];
//   sop_eop[0][0] = i_add.sop;
//   sop_eop[0][1] = i_add.eop;
  result0[0] = 0;
  result1[0] = 0;
  rdy[LEVEL] = m_tready;
//  s_tready[0] = rdy[0];
//  s_tready[1] = rdy[0];
//   o_add.copy_if_comb(carry_neg[LEVEL] ? result0[LEVEL] : result1[LEVEL], val[LEVEL], 1, 1, 0, 0, ctl[LEVEL]);

//   o_add.sop = sop_eop[LEVEL][0];
//   o_add.eop = sop_eop[LEVEL][1];
end


generate
genvar g;
  for (g = 0; g < LEVEL; g++) begin: ADDER_GEN

    logic [BITS_LEVEL:0] sub_res0, sub_res0_, sub_res0__, sub_res1, sub_res1_, sub_res1__;
    logic cn0, cn1;

    always_comb begin
      rdy[g] = ~val[g+1] || (val[g+1] && rdy[g+1]);

      sub_res0_ = a[g][g*BITS_LEVEL +: BITS_LEVEL] + P_[g*BITS_LEVEL +: BITS_LEVEL] + result0[g][g*BITS_LEVEL];
      sub_res0__ = b[g][g*BITS_LEVEL +: BITS_LEVEL] + carry_neg0[g];

      if (sub_res0_ < sub_res0__) begin
         cn0 = 1;
         sub_res0 = sub_res0_ - sub_res0__ + (1 << BITS_LEVEL);
       end else begin
         cn0 = 0;
         sub_res0 = sub_res0_ - sub_res0__;
       end

      sub_res1_ = a[g][g*BITS_LEVEL +: BITS_LEVEL] + result1[g][g*BITS_LEVEL];
      sub_res1__ = b[g][g*BITS_LEVEL +: BITS_LEVEL] + carry_neg1[g];

      if (sub_res1_ < sub_res1__) begin
        cn1 = 1;
        sub_res1 = sub_res1_ - sub_res1__ + (1 << BITS_LEVEL);
      end else begin
        cn1 = 0;
        sub_res1 = sub_res1_ - sub_res1__;
      end
    end

    always_ff @ (posedge aclk) begin
      if (areset) begin
        val[g+1] <= 0;
        result0[g+1] <= 0;
        result1[g+1] <= 0;
        a[g+1] <= 0;
        b[g+1] <= 0;
        ctl[g+1] <= 0;
//        sop_eop[g+1] <= 0;
        carry_neg0[g+1] <= 0;
        carry_neg1[g+1] <= 0;
      end else begin
        if (rdy[g]) begin
          val[g+1] <= val[g];
          ctl[g+1] <= ctl[g];
//          sop_eop[g+1] <= sop_eop[g];
          
          a[g+1] <= a[g];
          b[g+1] <= b[g];

          result0[g+1] <= result0[g];
          result0[g+1][g*BITS_LEVEL +: BITS_LEVEL + 1] <= sub_res0;

          result1[g+1] <= result1[g];
          result1[g+1][g*BITS_LEVEL +: BITS_LEVEL + 1] <= sub_res1;

          carry_neg0[g+1] <= cn0;
          carry_neg1[g+1] <= cn1;
        end
      end
    end
  end
endgenerate
endmodule