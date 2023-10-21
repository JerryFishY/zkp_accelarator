`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/18 19:27:24
// Design Name: 
// Module Name: tb_krnl_vadd_rtl
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


// module tb_krnl_vadd_rtl #( 
//   parameter integer  C_S_AXI_CONTROL_DATA_WIDTH = 32,
//   parameter integer  C_S_AXI_CONTROL_ADDR_WIDTH = 6,
//   parameter integer  C_M_AXI_GMEM_ID_WIDTH      = 1,
//   parameter integer  C_M_AXI_GMEM_ADDR_WIDTH    = 64,
//   parameter integer  C_M_AXI_GMEM_DATA_WIDTH    = 32
// )(
//     );
//     logic ap_clk;
//     logic ap_reset;
//     logic m_axi_gmem_AWVALID   ;
//     logic m_axi_gmem_AWREADY   ;
//     logic m_axi_gmem_AWADDR    ;
//     logic m_axi_gmem_AWID      ;
//     logic m_axi_gmem_AWLEN     ;
//     logic m_axi_gmem_AWSIZE    ;
//     logic m_axi_gmem_AWBURST   ;
//     logic m_axi_gmem_AWLOCK    ;
//     logic m_axi_gmem_AWCACHE   ;
//     logic m_axi_gmem_AWPROT    ;
//     logic m_axi_gmem_AWQOS     ;
//     logic m_axi_gmem_AWREGION  ;
//     logic m_axi_gmem_WVALID    ;
//     logic m_axi_gmem_WREADY    ;
//     logic [C_S_AXI_CONTROL_DATA_WIDTH-1:0] m_axi_gmem_WDATA     ;
//     logic m_axi_gmem_WSTRB     ;
//     logic m_axi_gmem_WLAST     ;
//     logic m_axi_gmem_ARVALID   ;
//     logic m_axi_gmem_ARREADY   ;
//     logic m_axi_gmem_ARADDR    ;
//     logic m_axi_gmem_ARID      ;
//     logic m_axi_gmem_ARLEN     ;
//     logic m_axi_gmem_ARSIZE    ;
//     logic m_axi_gmem_ARBURST   ;
//     logic m_axi_gmem_ARLOCK    ;
//     logic m_axi_gmem_ARCACHE   ;
//     logic m_axi_gmem_ARPROT    ;
//     logic m_axi_gmem_ARQOS     ;
//     logic m_axi_gmem_ARREGION  ;
//     logic m_axi_gmem_RVALID    ;
//     logic m_axi_gmem_RREADY    ;
//     logic [C_S_AXI_CONTROL_DATA_WIDTH-1:0] m_axi_gmem_RDATA     ;
//     logic m_axi_gmem_RLAST     ;
//     logic m_axi_gmem_RID       ;
//     logic m_axi_gmem_RRESP     ;
//     logic m_axi_gmem_BVALID    ;
//     logic m_axi_gmem_BREADY    ;
//     logic m_axi_gmem_BRESP     ;
//     logic m_axi_gmem_BID       ;
//     logic s_axi_control_AWVALID;
//     logic s_axi_control_AWREADY;
//     logic s_axi_control_AWADDR ;
//     logic s_axi_control_WVALID ;
//     logic s_axi_control_WREADY ;
//     logic s_axi_control_WDATA  ;
//     logic s_axi_control_WSTRB  ;
//     logic s_axi_control_ARVALID;
//     logic s_axi_control_ARREADY;
//     logic s_axi_control_ARADDR ;
//     logic s_axi_control_RVALID ;
//     logic s_axi_control_RREADY ;
//     logic s_axi_control_RDATA  ;
//     logic s_axi_control_RRESP  ;
//     logic s_axi_control_BVALID ;
//     logic s_axi_control_BREADY ;
//     logic s_axi_control_BRESP  ;
//     logic interrupt            ;
//     krnl_vadd_rtl # (
//     .C_S_AXI_CONTROL_DATA_WIDTH(C_S_AXI_CONTROL_DATA_WIDTH),
//     .C_S_AXI_CONTROL_ADDR_WIDTH(C_S_AXI_CONTROL_ADDR_WIDTH),
//     .C_M_AXI_GMEM_ID_WIDTH     (C_M_AXI_GMEM_ID_WIDTH     ),
//     .C_M_AXI_GMEM_ADDR_WIDTH   (C_M_AXI_GMEM_ADDR_WIDTH   ),
//     .C_M_AXI_GMEM_DATA_WIDTH   (C_M_AXI_GMEM_DATA_WIDTH   )
//     )    dut   (
//     .ap_clk               (ap_clk  ),
//     .ap_rst_n             (ap_reset),
//     .m_axi_gmem_AWVALID   (m_axi_gmem_AWVALID   ),
//     .m_axi_gmem_AWREADY   (m_axi_gmem_AWREADY   ),
//     .m_axi_gmem_AWADDR    (m_axi_gmem_AWADDR    ),
//     .m_axi_gmem_AWID      (m_axi_gmem_AWID      ),
//     .m_axi_gmem_AWLEN     (m_axi_gmem_AWLEN     ),
//     .m_axi_gmem_AWSIZE    (m_axi_gmem_AWSIZE    ),
//     .m_axi_gmem_AWBURST   (m_axi_gmem_AWBURST   ),
//     .m_axi_gmem_AWLOCK    (m_axi_gmem_AWLOCK    ),
//     .m_axi_gmem_AWCACHE   (m_axi_gmem_AWCACHE   ),
//     .m_axi_gmem_AWPROT    (m_axi_gmem_AWPROT    ),
//     .m_axi_gmem_AWQOS     (m_axi_gmem_AWQOS     ),
//     .m_axi_gmem_AWREGION  (m_axi_gmem_AWREGION  ),
//     .m_axi_gmem_WVALID    (m_axi_gmem_WVALID    ),
//     .m_axi_gmem_WREADY    (m_axi_gmem_WREADY    ),
//     .m_axi_gmem_WDATA     (m_axi_gmem_WDATA     ),
//     .m_axi_gmem_WSTRB     (m_axi_gmem_WSTRB     ),
//     .m_axi_gmem_WLAST     (m_axi_gmem_WLAST     ),
//     .m_axi_gmem_ARVALID   (m_axi_gmem_ARVALID   ),
//     .m_axi_gmem_ARREADY   (m_axi_gmem_ARREADY   ),
//     .m_axi_gmem_ARADDR    (m_axi_gmem_ARADDR    ),
//     .m_axi_gmem_ARID      (m_axi_gmem_ARID      ),
//     .m_axi_gmem_ARLEN     (m_axi_gmem_ARLEN     ),
//     .m_axi_gmem_ARSIZE    (m_axi_gmem_ARSIZE    ),
//     .m_axi_gmem_ARBURST   (m_axi_gmem_ARBURST   ),
//     .m_axi_gmem_ARLOCK    (m_axi_gmem_ARLOCK    ),
//     .m_axi_gmem_ARCACHE   (m_axi_gmem_ARCACHE   ),
//     .m_axi_gmem_ARPROT    (m_axi_gmem_ARPROT    ),
//     .m_axi_gmem_ARQOS     (m_axi_gmem_ARQOS     ),
//     .m_axi_gmem_ARREGION  (m_axi_gmem_ARREGION  ),
//     .m_axi_gmem_RVALID    (m_axi_gmem_RVALID    ),
//     .m_axi_gmem_RREADY    (m_axi_gmem_RREADY    ),
//     .m_axi_gmem_RDATA     (m_axi_gmem_RDATA     ),
//     .m_axi_gmem_RLAST     (m_axi_gmem_RLAST     ),
//     .m_axi_gmem_RID       (m_axi_gmem_RID       ),
//     .m_axi_gmem_RRESP     (m_axi_gmem_RRESP     ),
//     .m_axi_gmem_BVALID    (m_axi_gmem_BVALID    ),
//     .m_axi_gmem_BREADY    (m_axi_gmem_BREADY    ),
//     .m_axi_gmem_BRESP     (m_axi_gmem_BRESP     ),
//     .m_axi_gmem_BID       (m_axi_gmem_BID       ),
//     .s_axi_control_AWVALID(s_axi_control_AWVALID),
//     .s_axi_control_AWREADY(s_axi_control_AWREADY),
//     .s_axi_control_AWADDR (s_axi_control_AWADDR ),
//     .s_axi_control_WVALID (s_axi_control_WVALID ),
//     .s_axi_control_WREADY (s_axi_control_WREADY ),
//     .s_axi_control_WDATA  (s_axi_control_WDATA  ),
//     .s_axi_control_WSTRB  (s_axi_control_WSTRB  ),
//     .s_axi_control_ARVALID(s_axi_control_ARVALID),
//     .s_axi_control_ARREADY(s_axi_control_ARREADY),
//     .s_axi_control_ARADDR (s_axi_control_ARADDR ),
//     .s_axi_control_RVALID (s_axi_control_RVALID ),
//     .s_axi_control_RREADY (s_axi_control_RREADY ),
//     .s_axi_control_RDATA  (s_axi_control_RDATA  ),
//     .s_axi_control_RRESP  (s_axi_control_RRESP  ),
//     .s_axi_control_BVALID (s_axi_control_BVALID ),
//     .s_axi_control_BREADY (s_axi_control_BREADY ),
//     .s_axi_control_BRESP  (s_axi_control_BRESP  ),
//     .interrupt            (interrupt            )
//     );
    
//     assign #5  ap_clk = !ap_clk;
//     assign #50 m_axi_gmem_RID = !m_axi_gmem_RID;
//     logic [31:0]  count;
//     assign #10  count = count + 1;
//     assign #500 m_axi_gmem_RVALID = !m_axi_gmem_RVALID;
//     assign m_axi_gmem_RDATA = count;
//     initial begin
//       ap_clk = 1;
//       ap_reset = 0;
//       m_axi_gmem_RID = 1;
//       m_axi_gmem_RVALID = 0;
//       m_axi_gmem_WREADY = 1;
//       count = 0;
//  #100 ap_reset = 1;
      
//       end
    
    
    
// endmodule
