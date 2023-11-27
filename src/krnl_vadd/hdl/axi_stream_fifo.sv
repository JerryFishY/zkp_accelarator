`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/19 15:08:59
// Design Name: 
// Module Name: axi_stream_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axi_stream_fifo #(
  parameter SIZE,           // Number of entries
  parameter DAT_BITS,
  parameter MOD_BITS = $clog2(DAT_BITS/8),
  parameter CTL_BITS = 8,
  parameter USE_BRAM = 0  // If using BRAM there is an extra cycle delay between reads
) (
  input i_clk, i_rst,
  if_axi_stream.master  i_axi,
  if_axi_stream.slave  o_axi,
  output logic         o_full,
  output logic         o_emp
);
  
logic [$clog2(SIZE)-1:0] rd_ptr, wr_ptr;
localparam RAM_WIDTH = DAT_BITS + CTL_BITS + MOD_BITS + 3;
logic [RAM_WIDTH-1:0] data_out;

generate
  if (USE_BRAM == 0) begin: BRAM_GEN
  
    logic [SIZE-1:0][DAT_BITS + CTL_BITS + MOD_BITS + 3 -1:0] ram;  

    always_ff @ (posedge i_clk) begin
      if (i_axi.val && i_axi.rdy) begin
        ram [wr_ptr] <= {i_axi.err, i_axi.eop, i_axi.sop, i_axi.mod, i_axi.ctl, i_axi.dat};
      end
    end
    
    always_comb begin
      data_out = ram [rd_ptr];
      o_axi.val = ~o_emp;
    end
  
  end else begin
  
    if_ram #(.RAM_WIDTH(RAM_WIDTH), .RAM_DEPTH($clog2(SIZE))) bram_if_rd (i_clk, i_rst);
    if_ram #(.RAM_WIDTH(RAM_WIDTH), .RAM_DEPTH($clog2(SIZE))) bram_if_wr (i_clk, i_rst);
    
    bram #(
      .RAM_WIDTH       ( RAM_WIDTH     ),
      .RAM_DEPTH       ( $clog2(SIZE)  ),
      .RAM_PERFORMANCE ( "LOW_LATENCY" )
    ) bram_i (
      .a ( bram_if_rd ),
      .b ( bram_if_wr )
    );
  
    always_ff @ (posedge i_clk) begin
      o_axi.val <= 0;
      if (~o_emp) o_axi.val <= 1;
      if (o_axi.val && o_axi.rdy) o_axi.val <= 0;
    end
    
    always_comb begin
      bram_if_rd.re = 1;
      bram_if_rd.a = rd_ptr;
      bram_if_rd.d = 0;
      bram_if_rd.we = 0;
      bram_if_rd.en = 1;
      
      bram_if_wr.re = 0;
      bram_if_wr.a = wr_ptr;
      bram_if_wr.d = {i_axi.err, i_axi.eop, i_axi.sop, i_axi.mod, i_axi.ctl, i_axi.dat};
      bram_if_wr.we  = i_axi.val && i_axi.rdy;
      bram_if_wr.en = 1;
      
      data_out = bram_if_rd.q;
    end
  end
endgenerate

// Control for full and empty, and assigning outputs from the ram
always_comb begin
  i_axi.rdy = ~o_full && ~i_rst;
  
  o_axi.dat = data_out[0 +: DAT_BITS];
  o_axi.ctl = data_out[DAT_BITS +: CTL_BITS];
  o_axi.mod = data_out[CTL_BITS+DAT_BITS +: MOD_BITS];
  o_axi.sop = data_out[CTL_BITS+DAT_BITS+MOD_BITS +: 1];
  o_axi.eop = data_out[CTL_BITS+DAT_BITS+MOD_BITS+1 +: 1];
  o_axi.err = data_out[CTL_BITS+DAT_BITS+MOD_BITS+2 +: 1];

end

// Control logic which requires a reset
always_ff @ (posedge i_clk) begin
  if (i_rst) begin
    rd_ptr <= 0;
    wr_ptr <= 0;
    o_emp <= 1;
    o_full <= 0;
  end else begin
  
    // Write and read
    if (i_axi.val && i_axi.rdy && o_axi.val && o_axi.rdy) begin
      wr_ptr <= (wr_ptr + 1) % SIZE;
      rd_ptr <= (rd_ptr + 1) % SIZE;
    // Write
    end else if(~o_full && i_axi.val && i_axi.rdy) begin
      o_emp <= 0;
      wr_ptr <= (wr_ptr + 1) % SIZE;
      if ((wr_ptr + 1) % SIZE == rd_ptr) o_full <= 1;
    // Read
    end else if (~o_emp && o_axi.val && o_axi.rdy) begin
      o_full <= 0;
      rd_ptr <= (rd_ptr + 1) % SIZE;
      if ((rd_ptr + 1) % SIZE == wr_ptr) o_emp <= 1;
    end
    
  end
end
  
endmodule