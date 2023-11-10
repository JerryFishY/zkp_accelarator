module ofman_mult_barret # (
  parameter                DAT_BITS = 256,
  parameter                CTL_BITS = 8,
  parameter                IN_BITS = DAT_BITS*2,
  parameter [DAT_BITS-1:0] P = 60000,
  parameter LEVEL        = 3,
  parameter  C_DATA_WIDTH = DAT_BITS,
  parameter  C_NUM_CHANNELS = 2
)(
//   input                            i_clk  ,
//   input                            i_rst  ,
//   input [BITS_A-1:0]               i_dat_a,
//   input [BITS_B-1:0]               i_dat_b,
//   input                            i_val  ,
//   output logic                     o_rdy  ,

//   output logic [DAT_BITS-1:0] o_dat,
//   output logic                o_val,
//   input                       i_rdy,

  input                aclk,
  input                areset,
  input  logic  [C_NUM_CHANNELS-1:0]                   s_tvalid,
  input  logic  [C_NUM_CHANNELS-1:0][C_DATA_WIDTH-1:0] s_tdata ,
  output logic  [C_NUM_CHANNELS-1:0]                   s_tready,

  output wire                                        m_tvalid,
  output wire [C_DATA_WIDTH-1:0]                     m_tdata,
  input  wire                                        m_tready
);



if_axi_stream #(.DAT_BITS(2*DAT_BITS), .CTL_BITS(CTL_BITS)) i_mult_if_0(.i_clk(aclk));
logic o_rdy ;

always_comb begin
   s_tready[0] = o_rdy&& s_tvalid[0]&&s_tvalid[1];
   s_tready[1] = o_rdy&& s_tvalid[0]&&s_tvalid[1];
end

karatsuba_ofman_mult # (
  .BITS        (DAT_BITS),
  .CTL_BITS    (CTL_BITS),
  .LEVEL       (LEVEL )
  )   mult_0 (
  .i_clk  (aclk),
  .i_rst  (areset),
  .i_dat_a(s_tdata[0]),
  .i_dat_b(s_tdata[1]),
  .i_val  (s_tvalid[0]&&s_tvalid[1]),
  .o_rdy  (o_rdy),
  .o_dat  (i_mult_if_0.dat),
  .o_val  (i_mult_if_0.val),
  .i_ctl  (),
  .o_ctl  (),
  .i_rdy  (i_mult_if_0.rdy)
  );

barret_reduction_wrapper_ofman # (
  .DAT_BITS    (DAT_BITS    ),
  .CTL_BITS    (CTL_BITS    ),
  .IN_BITS     (IN_BITS     ),
  .P           (P           ),
  .BITS_A      (DAT_BITS      ),
  .BITS_B      (DAT_BITS      ),
  .LEVEL_A     (LEVEL     ),
  .LEVEL_B     (LEVEL     )
) barret_reduction_module (
  .i_clk       (aclk),
  .i_rst       (areset),
  .i_dat       (i_mult_if_0.dat),
  .i_val       (i_mult_if_0.val),
  .i_ctl       (0),
  .o_ctl       (     ),
  .o_rdy       (i_mult_if_0.rdy),
  .o_dat       (m_tdata),
  .o_val       (m_tvalid),
  .o_err       (     ),
  .i_rdy       (m_tready)
);

endmodule