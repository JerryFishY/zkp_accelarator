module barret_reduction_wrapper_ofman #(
  parameter                DAT_BITS     = 256,
  parameter                CTL_BITS     = 8,
  parameter                IN_BITS      = DAT_BITS*2,
  parameter [DAT_BITS-1:0] P = 100000000,                     // Input can be in range of 0 <= i_dat < P^2
  parameter                BITS_A       = DAT_BITS,
  parameter                BITS_B       = BITS_A,
  parameter                LEVEL_A      = 1,
  parameter                LEVEL_B      = LEVEL_A
) (               
  input                       i_clk,
  input                       i_rst,
  input [DAT_BITS*2-1:0]      i_dat,
  input                       i_val,
  input [CTL_BITS-1:0]        i_ctl,
  output logic [CTL_BITS-1:0] o_ctl,
  output logic                o_rdy,
  output logic [DAT_BITS-1:0] o_dat,
  output logic                o_val,
  output logic                o_err,
  input                       i_rdy
);

  if_axi_stream #(.DAT_BITS(2*DAT_BITS), .CTL_BITS(CTL_BITS)) o_mult_if_0(.i_clk(i_clk));
  if_axi_stream #(.DAT_BITS(2*DAT_BITS), .CTL_BITS(CTL_BITS)) i_mult_if_0(.i_clk(i_clk));
  if_axi_stream #(.DAT_BITS(2*DAT_BITS), .CTL_BITS(CTL_BITS)) o_mult_if_1(.i_clk(i_clk));
  if_axi_stream #(.DAT_BITS(2*DAT_BITS), .CTL_BITS(CTL_BITS)) i_mult_if_1(.i_clk(i_clk));

  barret_mod_pipe # (
  .DAT_BITS(DAT_BITS),
  .CTL_BITS(CTL_BITS),
  .IN_BITS (IN_BITS ),
  .P       (P       )
  )  barret_mod_pipe_0 ( 
    .i_clk (i_clk   ),
    .i_rst (i_rst   ),
    .i_dat (i_dat   ),
    .i_val (i_val   ),
    .i_ctl (i_ctl   ),
    .o_ctl (o_ctl   ),
    .o_rdy (o_rdy   ),
    .o_dat (o_dat   ),
    .o_val (o_val   ),
    .o_err (o_err   ),
    .i_rdy (i_rdy   ),
    .o_mult_if_0(o_mult_if_0),
    .i_mult_if_0(i_mult_if_0),
    .o_mult_if_1(o_mult_if_1),
    .i_mult_if_1(i_mult_if_1)
  );

  karatsuba_ofman_mult # (
  .BITS        (DAT_BITS),
  .CTL_BITS    (CTL_BITS),
  .LEVEL       (LEVEL_A )
  )   mult_0 (
  .i_clk  (i_clk),
  .i_rst  (i_rst),
  .i_dat_a(o_mult_if_0.dat[  DAT_BITS-1:0       ]),
  .i_dat_b(o_mult_if_0.dat[2*DAT_BITS-1:DAT_BITS]),
  .i_val  (o_mult_if_0.val),
  .o_rdy  (o_mult_if_0.rdy),
  .o_dat  (i_mult_if_0.dat),
  .i_ctl  (),
  .o_ctl  (),
  .o_val  (i_mult_if_0.val),
  .i_rdy  (i_mult_if_0.rdy)
  );

  karatsuba_ofman_mult # (
  .BITS        (DAT_BITS),
  .CTL_BITS    (CTL_BITS),
  .LEVEL       (LEVEL_A )
  )   mult_1 (
  .i_clk  (i_clk),
  .i_rst  (i_rst),
  .i_dat_a(o_mult_if_1.dat[DAT_BITS-1:0]),
  .i_dat_b(o_mult_if_1.dat[2*DAT_BITS-1:DAT_BITS]),
  .i_val  (o_mult_if_1.val),
  .o_rdy  (o_mult_if_1.rdy),
  .o_dat  (i_mult_if_1.dat),
  .i_ctl  (),
  .o_ctl  (),
  .o_val  (i_mult_if_1.val),
  .i_rdy  (i_mult_if_1.rdy)
  );


endmodule