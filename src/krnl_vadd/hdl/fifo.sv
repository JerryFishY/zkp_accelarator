module fifo #(
    parameter DATA_WIDTH = 8, // 数据位宽
    parameter DEPTH = 4  // 地址位宽
) (
    input   logic clock,   // 时钟信号
    input   logic reset, // 复位信号（低有效�?
    input   logic write_enable, // 写使能信�?
    input   logic [DATA_WIDTH-1:0] data_in, // 写数�?
    output  logic full, // 满状态信�?
    input   logic read_enable, // 读使能信�?
    output  logic [DATA_WIDTH-1:0] data_out, // 读数�?
    // output  logic                               real_full     ,
    output  logic                               data_out_valid,
    // output  logic                              near_full      ,
    output  logic  empty // 空状态信�?
    
);
logic clock_free;
//logic clock;
//  clk_wiz_0 clknetwork (
//  .clk_out1(clock_free),
//  .clk_in1(clock)
//  );
// FIFO深度
localparam FIFO_DEPTH = 1 << DEPTH;
// FIFO存储器（双口RAM�?
reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];
// 写指�?
reg [DEPTH:0] wr_ptr;
reg [DEPTH:0] count;
reg [DEPTH:0] wr_ptr_full;
// 读指�?
(*mark_debug = "TRUE"*) reg [DEPTH:0] rd_ptr;
// 指针差�?�（用于判断空满状�?�）
//reg [DEPTH+1:0] ptr_diff;
// 写操作�?�辑
logic [DEPTH:0] next_wr_ptr;
logic [DEPTH:0] add_wr_ptr;
logic [DEPTH:0] add_rd_ptr;
logic real_full;
always_comb begin
  if(write_enable)
    next_wr_ptr = wr_ptr;
  else
    next_wr_ptr = 0;
  end


always_ff @(posedge clock) begin
    if (reset) begin // 复位时清零写指针
        wr_ptr <= 0;
//        for (int i=0;i<FIFO_DEPTH;i=i+1)
//          fifo_mem[i] <= 0;
    end else if (write_enable&&!real_full) begin // 写使能且非满状�?�时写入数据并增加写指针
        fifo_mem[wr_ptr[DEPTH-1:0]] <= data_in;
        wr_ptr <= wr_ptr+1;
    end
end

//always_ff @(posedge clock) begin
//    if (reset) begin // 复位时清零写指针
//        wr_ptr <= 0;
////        for (int i=0;i<FIFO_DEPTH;i=i+1)
////          fifo_mem[i] <= 0;
//    end else if (write_enable) begin // 写使能且非满状�?�时写入数据并增加写指针
////        fifo_mem[wr_ptr[DEPTH-1:0]] <= data_in;
//        wr_ptr <= wr_ptr + 1;
//    end
//end

// 读操作�?�辑
always_ff @(posedge clock) begin
    if (reset) begin // 复位时清零读指针和读数据
        rd_ptr <= 0;
//        data_out <= 0;
    end else if (read_enable&&!empty) begin // 读使能且非空状�?�时读出数据并增加读指针
//        data_out <= fifo_mem[rd_ptr[DEPTH-1:0]];
        rd_ptr <= rd_ptr + 1;
    end else begin // 其他情况保持读数据不�?
//        data_out <= data_out;
    end
end

// 计算指针差�?�（带符号数�?
always_comb  begin
//    ptr_diff = $signed(wr_ptr) - $signed(rd_ptr);
//    ptr_diff = (wr_ptr) - (rd_ptr);
end

//logic data_out_valid_wait;
//logic [DATA_WIDTH-1:0] data_out_wait;
//logic [DEPTH:0] rd_ptr_wait;

always_ff @ (posedge clock) begin
  if(reset) 
    count <= 0;
  else begin
    if((write_enable&&!real_full)&&(read_enable&&!empty))
      count <= count ;
      else begin
        if(write_enable&&!real_full)
          count <= count +1 ;
        else begin
          if((read_enable&&!empty))
            count <= count -1;
          end
        end
    end
  end

always_comb begin
//     full = (wr_ptr_full[DEPTH] != rd_ptr[DEPTH]) ;
     full   = count > FIFO_DEPTH-2;
//     near_full = ((count>(FIFO_DEPTH-8-16)))||count> FIFO_DEPTH-8;
    //  real_full = (wr_ptr[DEPTH] != rd_ptr[DEPTH]) && (wr_ptr[DEPTH-1:0] == rd_ptr[DEPTH-1:0]);
    real_full = count==FIFO_DEPTH;
//     data_out_wait  = fifo_mem[rd_ptr_wait[DEPTH-1:0]];
     empty = (wr_ptr[DEPTH] == rd_ptr[DEPTH]) && (wr_ptr[DEPTH-1:0] == rd_ptr[DEPTH-1:0]);
//     data_out_valid_wait = !((wr_ptr[DEPTH] == rd_ptr[DEPTH]) && (wr_ptr[DEPTH-1:0] == rd_ptr[DEPTH-1:0]));
end
always_ff @(posedge clock) begin
//   data_out       <= data_out_wait;
//   data_out_valid <=data_out_valid_wait;
    //  near_full <= ((count>(FIFO_DEPTH-2-16)));
//   rd_ptr_wait    <= rd_ptr;
  end
  
always_comb begin
  if(empty||write_enable)
    data_out       = data_in;
  else
    data_out       = fifo_mem[rd_ptr[DEPTH-1:0]];
  data_out_valid = !empty||write_enable;
  wr_ptr_full    = wr_ptr + 4;
end

endmodule