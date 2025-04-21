import "DPI-C" function void hart_matrixMemAccess(
  byte unsigned mem_access_type, // memory access type
  byte unsigned matrix_reg_idx, // load dest/store src
  longint unsigned base_addr,
  byte unsigned number_of_rows, // matrix rows to load, sizeM
  longint unsigned row_stride, // matrix row stride to get next startline
  shortint unsigned bytes_per_row, // bytes in each row, sizeK
  byte unsigned whold_reg_mode, // whole register load/store, nf_vld
  byte unsigned nf_filed // how many matrix reg groups to load/store
);

module ct_mat_exu_ldst_unit #(parameter MATRIX_LSIQ_ENTRY = 8) (
  /* common */
  input         cpurst_b                     ,
  input         forever_cpuclk               ,
  input         cp0_mat_icg_en               ,
  input         cp0_yy_clk_en                ,
  input         pad_yy_icg_scan_en           ,
  /* RTU flush */
  input         rtu_yy_xx_flush              ,
  /* from rf issue to LSU */
  input  [ 6:0] idu_mat_rf_pipe8_iid         ,
  input  [11:0] idu_mat_rf_pipe8_iq_entry    ,
  input         idu_mat_rf_lsu_sel           , // 指令有效且成功发射才会使能
  input         idu_mat_rf_lsu_gateclk_sel   , // 指令有效就会使能时钟
  input  [15:0] idu_mat_rf_pipe8_lsu_meta    ,
  input  [63:0] idu_mat_rf_pipe8_lsu_src0    ,
  input         idu_mat_rf_pipe8_lsu_src1_vld,
  input  [63:0] idu_mat_rf_pipe8_lsu_src1    ,
  /* from CFG unit configuration */
  input  [15:0] x_sizeK                      ,
  input  [ 7:0] x_sizeM                      ,
  input  [ 7:0] x_sizeN                      ,
  output mat_lsu_ex_line_wakeup,
  output [3:0] mat_lsu_ex_line_wakeup_entry_idx,
  output mat_lsu_ex_mat_finish,
  output [3:0] mat_lsu_ex_mat_finish_entry_idx,
  output mat_lsu_ex_mat_finish_dstm_vld,
  output [2:0] mat_lsu_ex_mat_finish_dstm_idx,
  /* output to lsu load pipe*/
  output        mat_lsq_lsu_ld_sel  ,
  output [MATRIX_LSIQ_ENTRY-1:0] mat_lsq_lsu_entry,
  output [ 6:0] mat_lsq_lsu_iid ,
  output [63:0] mat_lsq_lsu_addr,
  output [ 1:0] mat_lsq_lsu_size,
  // from lsu
  input [MATRIX_LSIQ_ENTRY-1:0] lsu_mat_lsq_replay,
  input [MATRIX_LSIQ_ENTRY-1:0] lsu_mat_lsq_mat_ld_finish,
  /* commit to rtu retire */
  output        mat_lsu_cbus_ex1_pipe8_sel   ,
  output [ 6:0] mat_lsu_cbus_ex1_pipe8_iid
);

parameter MAT_LSU_OP_TYPE_WIDTH = 2    ;
parameter MAT_LSU_LOAD          = 2'b01;
parameter MAT_LSU_STORE         = 2'b10;

parameter MAT_LSU_OP         = 15; // 15:14
parameter MAT_LSU_DSTM_VLD   = 13;
parameter MAT_LSU_DSTM_IDX   = 12; // 12:10
parameter MAT_LSU_SRC2M_VLD  = 9;
parameter MAT_LSU_SRC2M_IDX  = 8; // 8:6
parameter MAT_LSU_NF_VLD     = 5 ;
parameter MAT_LSU_NF         = 4 ; // 4:2
parameter MAT_LSU_ELM_WIDTH  = 1 ; // 1:0

genvar i;

  wire ctrl_clk_en;
  wire ctrl_clk;
  wire ex1_inst_clk_en;
  wire ex1_inst_clk;

  reg        mat_lsu_ex1_inst_vld;
  reg [ 6:0] mat_lsu_ex1_iid     ;
  reg [11:0] mat_lsu_ex1_iq_entry;
  reg [63:0] mat_lsu_ex1_src0    ;
  reg        mat_lsu_ex1_src1_vld;
  reg [63:0] mat_lsu_ex1_src1    ;
  // lsu execution info meta
  reg [1:0] mat_lsu_ex1_optype         ;
  reg       mat_lsu_ex1_dstm_9_7_vld   ;
  reg [2:0] mat_lsu_ex1_dstm_idx_9_7   ;
  reg       mat_lsu_ex1_srcm2_vld      ;
  reg [2:0] mat_lsu_ex1_srcm2_idx      ;
  reg       mat_lsu_ex1_nf_vld         ;
  reg [2:0] mat_lsu_ex1_nf             ;
  reg [1:0] mat_lsu_ex1_elem_data_width;
  //==========================================================
  //                 RF/EX1 Pipeline Register
  //==========================================================
  //----------------------------------------------------------
  //                 Instance of Gated Cell  
  //----------------------------------------------------------
  // 用于控制信号mat_cfg_ex1_inst_vld从rf->ex1的使能以及ex1->ex2的传递,
  //  因此在"创建时"和"有效时"均使能门控时钟
  assign ctrl_clk_en = idu_mat_rf_lsu_gateclk_sel || mat_lsu_ex1_inst_vld; 
  gated_clk_cell  x_ctrl_gated_clk (
    .clk_in             (forever_cpuclk    ),
    .clk_out            (ctrl_clk          ),
    .external_en        (1'b0              ),
    .global_en          (cp0_yy_clk_en     ),
    .local_en           (ctrl_clk_en       ),
    .module_en          (cp0_mat_icg_en    ),
    .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
  );

  // 用于数据流水时钟, 数据信号不需要flush, 因此在"创建时"使能门控时钟即可
  assign ex1_inst_clk_en = idu_mat_rf_lsu_gateclk_sel;
  gated_clk_cell  x_ex1_inst_gated_clk (
    .clk_in             (forever_cpuclk    ),
    .clk_out            (ex1_inst_clk      ),
    .external_en        (1'b0              ),
    .global_en          (cp0_yy_clk_en     ),
    .local_en           (ex1_inst_clk_en   ),
    .module_en          (cp0_mat_icg_en    ),
    .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
  );
//----------------------------------------------------------
//              Matrix Cfg EX1 Instruction valid
//----------------------------------------------------------
  always_ff @(posedge ctrl_clk or negedge cpurst_b) begin : proc_mat_lsu_ex1_vld
    if(!cpurst_b) begin
      mat_lsu_ex1_inst_vld <= 1'b0;
    end else if(rtu_yy_xx_flush) begin
      mat_lsu_ex1_inst_vld <= 1'b0;
    end else begin
      mat_lsu_ex1_inst_vld <= idu_mat_rf_lsu_sel;
    end
  end
//----------------------------------------------------------
//               Matrix Cfg EX1 Instruction Data
//----------------------------------------------------------
  always_ff @(posedge ex1_inst_clk or negedge cpurst_b) begin : proc_mat_lsu_ex1_data
    if(!cpurst_b) begin
      mat_lsu_ex1_iid[6:0]                          <= 7'b0;
      mat_lsu_ex1_iq_entry[11:0]                    <= 12'b0;
      mat_lsu_ex1_src0[63:0]                        <= 64'b0;
      mat_lsu_ex1_src1_vld                          <= 1'b0;
      mat_lsu_ex1_src1[63:0]                        <= 64'b0;
      mat_lsu_ex1_optype[MAT_LSU_OP_TYPE_WIDTH-1:0] <= {MAT_LSU_OP_TYPE_WIDTH{1'b0}};
      mat_lsu_ex1_dstm_9_7_vld                      <= 1'b0;
      mat_lsu_ex1_dstm_idx_9_7[2:0]                 <= 3'b0;
      mat_lsu_ex1_srcm2_vld                         <= 1'b0;
      mat_lsu_ex1_srcm2_idx[2:0]                    <= 3'b0;
      mat_lsu_ex1_nf_vld                            <= 1'b0;
      mat_lsu_ex1_nf[2:0]                           <= 3'b0;
      mat_lsu_ex1_elem_data_width[1:0]              <= 2'b0;
    end else if(idu_mat_rf_lsu_gateclk_sel) begin
      mat_lsu_ex1_iid[6:0]                          <= idu_mat_rf_pipe8_iid[6:0];
      mat_lsu_ex1_iq_entry[11:0]                    <= idu_mat_rf_pipe8_iq_entry[11:0];
      mat_lsu_ex1_src0[63:0]                        <= idu_mat_rf_pipe8_lsu_src0[63:0];
      mat_lsu_ex1_src1_vld                          <= idu_mat_rf_pipe8_lsu_src1_vld;
      mat_lsu_ex1_src1[63:0]                        <= idu_mat_rf_pipe8_lsu_src1[63:0];
      mat_lsu_ex1_optype[MAT_LSU_OP_TYPE_WIDTH-1:0] <= idu_mat_rf_pipe8_lsu_meta[MAT_LSU_OP:MAT_LSU_OP-(MAT_LSU_OP_TYPE_WIDTH-1)] ;
      mat_lsu_ex1_dstm_9_7_vld                      <= idu_mat_rf_pipe8_lsu_meta[MAT_LSU_DSTM_VLD]                                ;
      mat_lsu_ex1_dstm_idx_9_7[2:0]                 <= idu_mat_rf_pipe8_lsu_meta[MAT_LSU_DSTM_IDX:MAT_LSU_DSTM_IDX-2]             ;
      mat_lsu_ex1_srcm2_vld                         <= idu_mat_rf_pipe8_lsu_meta[MAT_LSU_SRC2M_VLD]                               ;
      mat_lsu_ex1_srcm2_idx[2:0]                    <= idu_mat_rf_pipe8_lsu_meta[MAT_LSU_SRC2M_IDX:MAT_LSU_SRC2M_IDX-2]           ;
      mat_lsu_ex1_nf_vld                            <= idu_mat_rf_pipe8_lsu_meta[MAT_LSU_NF_VLD]                                  ;
      mat_lsu_ex1_nf[2:0]                           <= idu_mat_rf_pipe8_lsu_meta[MAT_LSU_NF:MAT_LSU_NF-2]                         ;
      mat_lsu_ex1_elem_data_width[1:0]              <= idu_mat_rf_pipe8_lsu_meta[MAT_LSU_ELM_WIDTH:MAT_LSU_ELM_WIDTH-1]           ;
    end
  end

  // TODO: 暂时不执行直接提交查看通路正确性
  assign mat_lsu_cbus_ex1_pipe8_sel      = mat_lsu_ex1_inst_vld;
  assign mat_lsu_cbus_ex1_pipe8_iid[6:0] = mat_lsu_ex1_iid[6:0];

  logic [3:0] mat_lsu_ex1_iq_entry_idx;
  ct_mat_src_oh_binary i_ct_mat_src_oh_binary (
    .x_num_oh(mat_lsu_ex1_iq_entry), 
    .x_num_binary(mat_lsu_ex1_iq_entry_idx)
  );

  assign mat_lsu_ex_line_wakeup = mat_lsu_ex1_inst_vld;
  assign mat_lsu_ex_mat_finish = mat_lsu_ex1_inst_vld;
  assign mat_lsu_ex_line_wakeup_entry_idx[3:0] = mat_lsu_ex1_iq_entry_idx[3:0];
  assign mat_lsu_ex_mat_finish_entry_idx[3:0] = mat_lsu_ex1_iq_entry_idx[3:0];

  assign mat_lsu_ex_mat_finish_dstm_vld = mat_lsu_ex1_dstm_9_7_vld;
  assign mat_lsu_ex_mat_finish_dstm_idx[2:0] = mat_lsu_ex1_dstm_idx_9_7[2:0];



  //==========================================================
  //                 matrix load store queue
  //==========================================================

  // 相关逻辑
  logic [MATRIX_LSIQ_ENTRY-1:0] mat_lsq_create_in;
  logic [MATRIX_LSIQ_ENTRY-1:0] mat_lsq_agevec   ;
  logic                         mat_lsq_bypass_en;
  
  // input
  logic [MATRIX_LSIQ_ENTRY-1:0] mat_lsq_create_gateclk_en;
  logic [MATRIX_LSIQ_ENTRY-1:0] mat_lsq_create_en;

  // 统一输入
  logic                  mat_lsq_create_frz     ;
  logic                  ctrl_entry_finish_exist;
  logic [           6:0] mat_lsq_rf_iid         ;
  logic [          11:0] mat_lsq_rf_iq_entry    ;
  logic [          63:0] mat_lsq_rf_lsu_src0    ;
  logic                  mat_lsq_rf_lsu_src1_vld;
  logic [          63:0] mat_lsq_rf_lsu_src1    ;
  logic [MAT_LSU_OP:0] mat_lsq_rf_lsu_meta    ;
  // 不同entry不同通路
  logic [6:0] mat_lsq_other_raw_rdy[0:MATRIX_LSIQ_ENTRY-1];
  logic [6:0] mat_lsq_create_agevec[0:MATRIX_LSIQ_ENTRY-1];
  logic [6:0] mat_lsq_other_finish_entry[0:MATRIX_LSIQ_ENTRY-1];
  // arbiter
  logic [MATRIX_LSIQ_ENTRY-1:0] mat_lsq_issue_en;

  // output
  logic [MATRIX_LSIQ_ENTRY-1:0] mat_lsq_vld;
  logic [MATRIX_LSIQ_ENTRY-1:0] mat_lsq_rdy;
  logic [MATRIX_LSIQ_ENTRY-1:0] mat_lsq_raw_rdy;
  logic [MATRIX_LSIQ_ENTRY-1:0] mat_lsq_ctrl_entry_finish;
  // mux to output
  logic [ 6:0] mat_lsq_mat_iid [0:MATRIX_LSIQ_ENTRY-1];
  logic        mat_lsq_mat_ld  [0:MATRIX_LSIQ_ENTRY-1];
  logic        mat_lsq_mat_st  [0:MATRIX_LSIQ_ENTRY-1];
  logic [63:0] mat_lsq_mat_addr[0:MATRIX_LSIQ_ENTRY-1];
  logic [ 1:0] mat_lsq_mat_size[0:MATRIX_LSIQ_ENTRY-1];

  always @(*)
  begin
    if(!mat_lsq_vld[0])
      mat_lsq_create_in[MATRIX_LSIQ_ENTRY-1:0] = 8'b0000_0001;
    else if(!mat_lsq_vld[1])
      mat_lsq_create_in[MATRIX_LSIQ_ENTRY-1:0] = 8'b0000_0010;
    else if(!mat_lsq_vld[2])
      mat_lsq_create_in[MATRIX_LSIQ_ENTRY-1:0] = 8'b0000_0100;
    else if(!mat_lsq_vld[3])
      mat_lsq_create_in[MATRIX_LSIQ_ENTRY-1:0] = 8'b0000_1000;
    else if(!mat_lsq_vld[4])
      mat_lsq_create_in[MATRIX_LSIQ_ENTRY-1:0] = 8'b0001_0000;
    else if(!mat_lsq_vld[5])
      mat_lsq_create_in[MATRIX_LSIQ_ENTRY-1:0] = 8'b0010_0000;
    else if(!mat_lsq_vld[6])
      mat_lsq_create_in[MATRIX_LSIQ_ENTRY-1:0] = 8'b0100_0000;
    else if(!mat_lsq_vld[7])
      mat_lsq_create_in[MATRIX_LSIQ_ENTRY-1:0] = 8'b1000_0000;
    else
      mat_lsq_create_in[MATRIX_LSIQ_ENTRY-1:0] = 8'b0000_0000;
  end

  assign mat_lsq_agevec[MATRIX_LSIQ_ENTRY-1:0] = mat_lsq_vld[MATRIX_LSIQ_ENTRY-1:0] &
                                                  ~mat_lsq_ctrl_entry_finish[MATRIX_LSIQ_ENTRY-1:0];

  assign mat_lsq_bypass_en = ~(|mat_lsq_raw_rdy) && idu_mat_rf_lsu_sel;

  assign mat_lsq_create_gateclk_en[MATRIX_LSIQ_ENTRY-1:0] = mat_lsq_create_in[MATRIX_LSIQ_ENTRY-1:0] & 
                                                            {MATRIX_LSIQ_ENTRY{idu_mat_rf_lsu_gateclk_sel}};
  assign mat_lsq_create_en[MATRIX_LSIQ_ENTRY-1:0] = mat_lsq_create_in[MATRIX_LSIQ_ENTRY-1:0] & 
                                                    {MATRIX_LSIQ_ENTRY{idu_mat_rf_lsu_sel}};

  assign mat_lsq_create_frz                  = mat_lsq_bypass_en & (~|lsu_mat_lsq_replay[MATRIX_LSIQ_ENTRY-1:0]); // 存在replay则当前旁路发射失败

  assign mat_lsq_rf_iid[6:0]                 = idu_mat_rf_pipe8_iid[6:0];
  assign mat_lsq_rf_iq_entry[11:0]           = idu_mat_rf_pipe8_iq_entry[11:0];
  assign mat_lsq_rf_lsu_src0[63:0]           = idu_mat_rf_pipe8_lsu_src0[63:0];
  assign mat_lsq_rf_lsu_src1_vld             = idu_mat_rf_pipe8_lsu_src1_vld;
  assign mat_lsq_rf_lsu_src1[63:0]           = idu_mat_rf_pipe8_lsu_src1[63:0];
  assign mat_lsq_rf_lsu_meta[MAT_LSU_OP:0] = idu_mat_rf_pipe8_lsu_meta[MAT_LSU_OP:0];

  generate
  for (i = 0; i < MATRIX_LSIQ_ENTRY; i++) begin
    if (i == 0) begin
      assign mat_lsq_other_raw_rdy[i] = mat_lsq_raw_rdy[MATRIX_LSIQ_ENTRY-1 : i+1];
    end
    else if (i == MATRIX_LSIQ_ENTRY-1) begin
      assign mat_lsq_other_raw_rdy[i] = mat_lsq_raw_rdy[i-1 : 0];
    end
    else begin
      assign mat_lsq_other_raw_rdy[i] = {mat_lsq_raw_rdy[MATRIX_LSIQ_ENTRY-1 : i+1],
                                         mat_lsq_raw_rdy[i-1:0]};
    end
  end
  endgenerate

  generate
  for (i = 0; i < MATRIX_LSIQ_ENTRY; i++) begin
    if (i == 0) begin
      assign mat_lsq_create_agevec[i] = mat_lsq_agevec[MATRIX_LSIQ_ENTRY-1 : i+1];
    end
    else if (i == MATRIX_LSIQ_ENTRY-1) begin
      assign mat_lsq_create_agevec[i] = mat_lsq_agevec[i-1 : 0];
    end
    else begin
      assign mat_lsq_create_agevec[i] = {mat_lsq_agevec[MATRIX_LSIQ_ENTRY-1 : i+1],
                                         mat_lsq_agevec[i-1:0]};
    end
  end
  endgenerate

  assign ctrl_entry_finish_exist = |mat_lsq_ctrl_entry_finish[MATRIX_LSIQ_ENTRY-1:0];
  generate
    for (i = 0; i < MATRIX_LSIQ_ENTRY; i++) begin
      if (i == 0) begin
        assign mat_lsq_other_finish_entry[i] = mat_lsq_ctrl_entry_finish[MATRIX_LSIQ_ENTRY-1 : i+1];
      end
      else if (i == MATRIX_LSIQ_ENTRY-1) begin
        assign mat_lsq_other_finish_entry[i] = mat_lsq_ctrl_entry_finish[i-1 : 0];
      end
      else begin
        assign mat_lsq_other_finish_entry[i] = {mat_lsq_ctrl_entry_finish[MATRIX_LSIQ_ENTRY-1 : i+1],
                                                mat_lsq_ctrl_entry_finish[i-1:0]};
      end
    end
  endgenerate

  assign mat_lsq_issue_en[MATRIX_LSIQ_ENTRY-1:0] = mat_lsq_rdy[MATRIX_LSIQ_ENTRY-1:0];

  logic [ 6:0] mat_lsq_iid_sel ;
  logic        mat_lsq_ld_sel  ;
  logic [63:0] mat_lsq_addr_sel;
  logic [ 1:0] mat_lsq_size_sel;

  ct_mat_mux_onehot #(.KEY_LEN(MATRIX_LSIQ_ENTRY), .DATA_LEN(7)) i_mat_lsq_iid_mux (
    .data_out   (mat_lsq_iid_sel ),
    .onehot_key (mat_lsq_issue_en),
    .default_out(7'b0            ),
    .data_list  (mat_lsq_mat_iid )
  );

  ct_mat_mux_onehot #(.KEY_LEN(MATRIX_LSIQ_ENTRY), .DATA_LEN(1)) i_mat_lsq_ld_mux (
    .data_out   (mat_lsq_ld_sel  ),
    .onehot_key (mat_lsq_issue_en),
    .default_out(1'b0            ),
    .data_list  (mat_lsq_mat_ld  )
  );

  ct_mat_mux_onehot #(.KEY_LEN(MATRIX_LSIQ_ENTRY), .DATA_LEN(64)) i_mat_lsq_addr_mux (
    .data_out   (mat_lsq_addr_sel),
    .onehot_key (mat_lsq_issue_en),
    .default_out(63'b0           ),
    .data_list  (mat_lsq_mat_addr)
  );

  ct_mat_mux_onehot #(.KEY_LEN(MATRIX_LSIQ_ENTRY), .DATA_LEN(2)) i_mat_lsq_size_mux (
    .data_out   (mat_lsq_size_sel),
    .onehot_key (mat_lsq_issue_en),
    .default_out(63'b0           ),
    .data_list  (mat_lsq_mat_size)
  );

  assign mat_lsq_lsu_entry[MATRIX_LSIQ_ENTRY-1:0] = mat_lsq_bypass_en ? mat_lsq_create_in[MATRIX_LSIQ_ENTRY-1:0] :
                                                                          mat_lsq_issue_en[MATRIX_LSIQ_ENTRY-1:0];
  
  assign mat_lsq_lsu_ld_sel     = mat_lsq_bypass_en ? idu_mat_rf_pipe8_lsu_meta[MAT_LSU_OP-1] : mat_lsq_ld_sel;
  assign mat_lsq_lsu_iid[6:0]   = mat_lsq_bypass_en ? idu_mat_rf_pipe8_iid[6:0] : mat_lsq_iid_sel[6:0];
  assign mat_lsq_lsu_addr[63:0] = mat_lsq_bypass_en ? idu_mat_rf_pipe8_lsu_src0[63:0] : mat_lsq_addr_sel[63:0];
  assign mat_lsq_lsu_size[1:0]  = mat_lsq_bypass_en ? 2'b11 : mat_lsq_size_sel[1:0];

  generate
    for (i = 0; i < MATRIX_LSIQ_ENTRY; i++) begin
    mat_lsu_queue #(
      .MAT_LSU_OP_TYPE_WIDTH(MAT_LSU_OP_TYPE_WIDTH),
      .MAT_LSU_OP           (MAT_LSU_OP           )
    ) i_mat_lsu_queue (
      .forever_cpuclk         (forever_cpuclk               ),
      .cpurst_b               (cpurst_b                     ),
      .cp0_mat_icg_en         (cp0_mat_icg_en               ),
      .cp0_yy_clk_en          (cp0_yy_clk_en                ),
      .pad_yy_icg_scan_en     (pad_yy_icg_scan_en           ),
      .rtu_yy_xx_flush        (rtu_yy_xx_flush              ),
      .x_create_gateclk_en    (mat_lsq_create_gateclk_en[i] ),
      .x_create_en            (mat_lsq_create_en[i]         ),
      .x_create_frz           (mat_lsq_create_frz           ),
      .x_other_raw_rdy        (mat_lsq_other_raw_rdy[i]     ),
      .x_issue_en             (mat_lsq_issue_en[i]          ),
      .x_replay               (lsu_mat_lsq_replay[i]            ),
      .x_mat_ld_finish        (lsu_mat_lsq_mat_ld_finish[i]     ),
      .x_create_agevec        (mat_lsq_create_agevec[i]     ),
      .ctrl_entry_finish_exist(ctrl_entry_finish_exist      ),
      .x_other_finish_entry   (mat_lsq_other_finish_entry[i]),
      .x_sizeK                (x_sizeK                      ),
      .x_sizeM                (x_sizeM                      ),
      .x_rf_iid               (mat_lsq_rf_iid               ),
      .x_rf_iq_entry          (mat_lsq_rf_iq_entry          ),
      .x_rf_lsu_src0          (mat_lsq_rf_lsu_src0          ),
      .x_rf_lsu_src1_vld      (mat_lsq_rf_lsu_src1_vld      ),
      .x_rf_lsu_src1          (mat_lsq_rf_lsu_src1          ),
      .x_rf_lsu_meta          (mat_lsq_rf_lsu_meta          ),
      .o_vld                  (mat_lsq_vld[i]               ),
      .o_rdy                  (mat_lsq_rdy[i]               ),
      .o_raw_rdy              (mat_lsq_raw_rdy[i]           ),
      .o_ctrl_entry_finish    (mat_lsq_ctrl_entry_finish[i] ),
      .o_mat_iid              (mat_lsq_mat_iid[i]           ),
      .o_mat_ld               (mat_lsq_mat_ld[i]            ),
      .o_mat_st               (mat_lsq_mat_st[i]            ),
      .o_mat_addr             (mat_lsq_mat_addr[i]          ),
      .o_mat_size             (mat_lsq_mat_size[i]          )
    );
    end
  endgenerate







  // 计算总共需要load/store的byte数
  always@(posedge ex1_inst_clk) begin
    if(mat_lsu_ex1_inst_vld) begin
    case ({mat_lsu_ex1_optype[1:0], mat_lsu_ex1_nf_vld})
      {MAT_LSU_LOAD, 1'b0} : begin
        assert (mat_lsu_ex1_src1_vld) 
        else   $error("single matrix reg load: rs2(src1) must be valid");
        // mem_access_type: load/store, 0/1
        // matrix_reg_idx: load dest/store src->mat_lsu_ex1_dstm_idx_9_7[2:0] or mat_lsu_ex1_srcm2_idx[2:0]
        // base_addr: mat_lsu_ex1_src0[63:0]
        // number_of_rows: x_sizeM[7:0]
        // row_stride: mat_lsu_ex1_src1[63:0]
        // bytes_per_row: x_sizeK[15:0]
        // whold_reg_mode: mat_lsu_ex1_nf_vld
        // nf_filed: mat_lsu_ex1_nf[2:0]
        hart_matrixMemAccess(0, mat_lsu_ex1_dstm_idx_9_7[2:0], mat_lsu_ex1_src0[63:0], 
                            x_sizeM[7:0], mat_lsu_ex1_src1[63:0],
                            x_sizeK[15:0], mat_lsu_ex1_nf_vld, mat_lsu_ex1_nf[2:0]);
      end
      {MAT_LSU_LOAD, 1'b1} : begin
        assert (mat_lsu_ex1_src1_vld==0) 
        else   $error("whold matrix reg load: rs2(src1) must not be valid");
        hart_matrixMemAccess(0, mat_lsu_ex1_dstm_idx_9_7[2:0],mat_lsu_ex1_src0[63:0], 
                            x_sizeM[7:0], mat_lsu_ex1_src1[63:0],
                            x_sizeK[15:0], mat_lsu_ex1_nf_vld, mat_lsu_ex1_nf[2:0]);
      end
      {MAT_LSU_STORE, 1'b0} : begin
        assert (mat_lsu_ex1_src1_vld) 
        else   $error("single matrix reg store: rs2(src1) must be valid");
        hart_matrixMemAccess(1, mat_lsu_ex1_srcm2_idx[2:0], mat_lsu_ex1_src0[63:0], 
                            x_sizeM[7:0], mat_lsu_ex1_src1[63:0],
                            x_sizeK[15:0], mat_lsu_ex1_nf_vld, mat_lsu_ex1_nf[2:0]);
      end
      {MAT_LSU_STORE, 1'b1} : begin
        assert (mat_lsu_ex1_src1_vld==0) 
        else   $error("whold matrix reg store: rs2(src1) must not be valid");
        hart_matrixMemAccess(1, mat_lsu_ex1_srcm2_idx[2:0], mat_lsu_ex1_src0[63:0], 
                            x_sizeM[7:0], mat_lsu_ex1_src1[63:0],
                            x_sizeK[15:0], mat_lsu_ex1_nf_vld, mat_lsu_ex1_nf[2:0]);
      end
    endcase
    end
  end 

endmodule : ct_mat_exu_ldst_unit

module mat_lsu_queue #(
  parameter MAT_LSU_OP_TYPE_WIDTH = 2 ,
  parameter MAT_LSU_OP            = 15
) (
  input                 forever_cpuclk         ,
  input                 cpurst_b               ,
  input                 cp0_mat_icg_en         ,
  input                 cp0_yy_clk_en          ,
  input                 pad_yy_icg_scan_en     ,
  input                 rtu_yy_xx_flush        ,
  input                 x_create_gateclk_en    ,
  input                 x_create_en            ,
  input                 x_create_frz           , // bypass时为1
  input                 x_issue_en             ,
  input  [         6:0] x_create_agevec        ,
  input                 ctrl_entry_finish_exist, // 其他指令表项失效信息, 维护agevec
  input  [         6:0] x_other_finish_entry   , // 其他指令表项失效信息, 维护agevec
  input  [        15:0] x_sizeK                ,
  input  [         7:0] x_sizeM                ,
  input  [         6:0] x_rf_iid               ,
  input  [        11:0] x_rf_iq_entry          ,
  input  [        63:0] x_rf_lsu_src0          ,
  input                 x_rf_lsu_src1_vld      ,
  input  [        63:0] x_rf_lsu_src1          ,
  input  [MAT_LSU_OP:0] x_rf_lsu_meta          ,
  // from lsu
  input                 x_mat_ld_finish        ,
  input                 x_replay               ,
  // for arbiter
  input  [         6:0] x_other_raw_rdy        ,
  // output
  output                o_vld                  ,
  output                o_ctrl_entry_finish    , // 指令表项失效信息, 维护agevec
  output                o_rdy                  ,
  output                o_raw_rdy              , // for arbiter
  output [         6:0] o_mat_iid              ,
  output                o_mat_ld               ,
  output                o_mat_st               ,
  output [        63:0] o_mat_addr             ,
  output [         1:0] o_mat_size
);

  localparam TYPE_W = MAT_LSU_OP_TYPE_WIDTH;

  logic       entry_ctrl_clk      ;
  logic       create_clk          ;
  logic       vld                 ;
  logic       frz                 ;
  logic       ctrl_entry_finish   ;
  logic [6:0] agevec              ;
  logic       older_entry_rdy_mask;

  logic [      15:0] sizeK          ;
  logic [       7:0] sizeM          ;
  logic [       6:0] iid            ;
  logic [      11:0] iq_entry       ;
  logic [      63:0] src0           ;
  logic              src1_vld       ;
  logic [      63:0] src1           ;
  logic [TYPE_W-1:0] optype         ;
  logic              dstm_vld   ;
  logic [       2:0] dstm_idx   ;
  logic              srcm_vld      ;
  logic [       2:0] srcm_idx      ;
  logic              nf_vld         ;
  logic [       2:0] nf             ;
  logic [       1:0] elem_data_width;

  logic        move_to_next;
  logic [63:0] curr_addr   ;
  logic [ 1:0] curr_size   ;

  // 用于控制信号mat_cfg_ex1_inst_vld从rf->ex1的使能以及ex1->ex2的传递,
  //  因此在"创建时"和"有效时"均使能门控时钟
  assign ctrl_clk_en = x_create_gateclk_en || vld;
  gated_clk_cell x_ctrl_gated_clk (
    .clk_in            (forever_cpuclk    ),
    .clk_out           (entry_ctrl_clk    ),
    .external_en       (1'b0              ),
    .global_en         (cp0_yy_clk_en     ),
    .local_en          (ctrl_clk_en       ),
    .module_en         (cp0_mat_icg_en    ),
    .pad_yy_icg_scan_en(pad_yy_icg_scan_en)
  );

  // 用于数据流水时钟, 数据信号不需要flush, 因此在"创建时"使能门控时钟即可
  assign create_clk_en = x_create_gateclk_en;
  gated_clk_cell x_ex1_inst_gated_clk (
    .clk_in            (forever_cpuclk    ),
    .clk_out           (create_clk        ),
    .external_en       (1'b0              ),
    .global_en         (cp0_yy_clk_en     ),
    .local_en          (create_clk_en     ),
    .module_en         (cp0_mat_icg_en    ),
    .pad_yy_icg_scan_en(pad_yy_icg_scan_en)
  );

//==========================================================
//                      Entry Valid
//==========================================================
  assign o_vld = vld;
  always @(posedge entry_ctrl_clk or negedge cpurst_b)
  begin
    if(!cpurst_b)
      vld <= 1'b0;
    else if(rtu_yy_xx_flush)
      vld <= 1'b0;
    else if(x_create_en)
      vld <= 1'b1;
    else if(ctrl_entry_finish) // 根据执行情况决定表项生命周期
      vld <= 1'b0;
    else
      vld <= vld;
  end
  
  assign older_entry_rdy_mask = |(agevec[6:0] & x_other_raw_rdy[6:0]);

  assign o_raw_rdy = vld && !frz;
  assign o_rdy = o_raw_rdy && !older_entry_rdy_mask;

  always @(posedge entry_ctrl_clk or negedge cpurst_b)
  begin
    if(!cpurst_b)
      frz <= 1'b0;
    else if(x_create_en)
      frz <= x_create_frz; // bypass create意为create同时issue, 因此可能会在create初始化时就freeze
    else if(x_replay) // 访存重发
      frz <= 1'b0;
    else if(move_to_next) // 进入下一次访存
      frz <= 1'b0;
    else if(x_issue_en)
      frz <= 1'b1;
    else
      frz <= frz;
  end

//==========================================================
//                        Age Vector
//==========================================================
// 维护年龄用于仲裁oldest表项to issue, 每bit为1表示对应位置的表项older than itself, 为0则反之.
  always @(posedge entry_ctrl_clk or negedge cpurst_b)
    begin
      if(!cpurst_b)
        agevec[6:0] <= 8'b0;
      else if(x_create_en)
        agevec[6:0] <= x_create_agevec[6:0];
      else if(ctrl_entry_finish_exist)
        agevec[6:0] <= agevec[6:0] & ~x_other_finish_entry[6:0]; // 其他表项执行结束, 对应的older-bit被清零
      else
        agevec[6:0] <= agevec[6:0];
    end

//==========================================================
//                 Instruction Information
//==========================================================
  always_ff @(posedge create_clk or negedge cpurst_b) begin
    if(!cpurst_b) begin
      sizeK                <= 16'b0;
      sizeM                <= 8'b0;
      iid[6:0]             <= 7'b0;
      iq_entry[11:0]       <= 12'b0;
      src0[63:0]           <= 64'b0;
      src1_vld             <= 1'b0;
      src1[63:0]           <= 64'b0;
      optype[TYPE_W-1:0]   <= {TYPE_W{1'b0}};
      dstm_vld         <= 1'b0;
      dstm_idx[2:0]    <= 3'b0;
      srcm_vld            <= 1'b0;
      srcm_idx[2:0]       <= 3'b0;
      nf_vld               <= 1'b0;
      nf[2:0]              <= 3'b0;
      elem_data_width[1:0] <= 2'b0;
    end else if(x_create_gateclk_en) begin
      sizeK[15:0]          <= x_sizeK[15:0];
      sizeM[7:0]           <= x_sizeM[7:0];
      iid[6:0]             <= x_rf_iid[6:0];
      iq_entry[11:0]       <= x_rf_iq_entry[11:0];
      src0[63:0]           <= x_rf_lsu_src0[63:0];
      src1_vld             <= x_rf_lsu_src1_vld;
      src1[63:0]           <= x_rf_lsu_src1[63:0];
      optype[TYPE_W-1:0]   <= x_rf_lsu_meta[MAT_LSU_OP:MAT_LSU_OP-(MAT_LSU_OP_TYPE_WIDTH-1)];
      dstm_vld             <= x_rf_lsu_meta[MAT_LSU_DSTM_VLD]                               ;
      dstm_idx[2:0]        <= x_rf_lsu_meta[MAT_LSU_DSTM_IDX:MAT_LSU_DSTM_IDX-2]            ;
      srcm_vld             <= x_rf_lsu_meta[MAT_LSU_SRC2M_VLD]                              ;
      srcm_idx[2:0]        <= x_rf_lsu_meta[MAT_LSU_SRC2M_IDX:MAT_LSU_SRC2M_IDX-2]          ;
      nf_vld               <= x_rf_lsu_meta[MAT_LSU_NF_VLD]                                 ;
      nf[2:0]              <= x_rf_lsu_meta[MAT_LSU_NF:MAT_LSU_NF-2]                        ;
      elem_data_width[1:0] <= x_rf_lsu_meta[MAT_LSU_ELM_WIDTH:MAT_LSU_ELM_WIDTH-1]          ;
    end
  end

  logic [15:0] col_byte_cnt;
  logic [7:0] row_cnt;

  logic row_cnt_neq_0;
  logic col_byte_neq_0;
  logic row_cnt_equal_0;
  logic col_byte_equal_0;
  logic row_cnt_neq_1;
  logic col_byte_gt_eq_8; // great or equal
  logic col_byte_gt_8;

  assign row_cnt_neq_0 = row_cnt != 0;
  assign col_byte_neq_0 = col_byte_cnt != 0; 
  assign row_cnt_equal_0 = row_cnt == 0;
  assign col_byte_equal_0 = col_byte_cnt == 0;
  assign row_cnt_neq_1 = row_cnt != 1; 
  assign col_byte_gt_eq_8 = col_byte_cnt >= 8;
  assign col_byte_gt_8 = col_byte_cnt > 8;

  always @(posedge entry_ctrl_clk or negedge cpurst_b)
  begin
    if(!cpurst_b)
      row_cnt[7:0] <= 8'b0;
    else if(rtu_yy_xx_flush)
      row_cnt[7:0] <= 8'b0;
    else if(x_create_en && x_create_frz)
      row_cnt[7:0] <= (x_sizeK >= 8) ? x_sizeM[15:0] : x_sizeM - 1;
    else if(x_create_en)
      row_cnt[7:0] <= x_sizeM[15:0];
    else if(x_mat_ld_finish && row_cnt_neq_0 && !col_byte_gt_8)
      row_cnt[7:0] <= row_cnt[7:0] - 1; // 减去 stribe row
  end

  always @(posedge entry_ctrl_clk or negedge cpurst_b)
  begin
    if(!cpurst_b)
      col_byte_cnt[15:0] <= 16'b0;
    else if(rtu_yy_xx_flush)
      col_byte_cnt[15:0] <= 16'b0;
    else if(x_create_en && x_create_frz)
      col_byte_cnt[15:0] <= (x_sizeK >= 8) ? x_sizeK - 8 : 0;
    else if(x_create_en)
      col_byte_cnt[15:0] <= x_sizeK[15:0];
    else if(x_mat_ld_finish && col_byte_gt_eq_8)
      col_byte_cnt[15:0] <= col_byte_cnt[15:0] - 8;
    // else if(x_mat_ld_finish && col_byte_neq_0)
    //   col_byte_cnt[15:0] <= 16'b0;
    else if(x_mat_ld_finish && row_cnt_neq_0 && !col_byte_gt_8)
      col_byte_cnt[15:0] <= x_sizeK[15:0];
  end

  // row_cnt和col_cnt均为0时说明最后一行矩阵访存的数据已返回, 访存生命周期结束
  assign ctrl_entry_finish = x_mat_ld_finish && row_cnt_equal_0 && col_byte_equal_0;
  assign o_ctrl_entry_finish = ctrl_entry_finish;
  
  always @(posedge entry_ctrl_clk or negedge cpurst_b)
  begin
    if(!cpurst_b)
      move_to_next <= 1'b0;
    else if(rtu_yy_xx_flush)
      move_to_next <= 1'b0;
    else if(x_mat_ld_finish && col_byte_gt_8) // 数据返回时看到col_cnt大于8说明这一行还未结束,继续发送
      move_to_next <= 1'b1;
    else if(x_mat_ld_finish && row_cnt_neq_1) // 数据返回时col_cnt小于8但是row_cnt大于1说明还有下一行,继续发送
      move_to_next <= 1'b1;
    // 数据返回时看到col_cnt小于8且row_cnt等于1, 说明发出请求并收到返回的已经是最后一行, 结束
    else if(move_to_next == 1'b1) // 拉高后解冻frz, 随后立即拉低, 防止重复发出请求
      move_to_next <= 1'b0;
  end

  always @(posedge entry_ctrl_clk or negedge cpurst_b)
  begin
    if(!cpurst_b)
      curr_addr[63:0] <= 64'b0;
    else if(rtu_yy_xx_flush)
      curr_addr[63:0] <= 64'b0;
    // else if(x_create_en && x_create_frz)
    //   curr_addr[63:0] <= (x_sizeK >= 8) ? x_rf_lsu_src0[63:0] + 8 : x_rf_lsu_src0[63:0] + x_sizeK[15:0];
    else if(x_create_en)
      curr_addr[63:0] <= x_rf_lsu_src0[63:0];
    else if(move_to_next)
      curr_addr[63:0] <= curr_addr[63:0] + 8; // 应该加实际字节数否则地址偏差, 这里简化成每次都发出8字节
    // else if(x_mat_ld_finish && col_byte_neq_0)
    //   curr_addr[63:0] <= curr_addr[63:0] + 8; // 应该加实际字节数否则地址偏差, 这里简化成每次都发出8字节
    // else if(x_mat_ld_finish && row_cnt_neq_0 && col_byte_equal_0)
    //   curr_addr[63:0] <= curr_addr[63:0] + 8;
  end

  assign o_mat_iid[6:0]   = iid[6:0];
  assign o_mat_ld         = optype[0];
  assign o_mat_st         = optype[1];
  assign o_mat_addr[63:0] = curr_addr[63:0];
  assign o_mat_size[1:0]  = 2'b11; // curr_size[1:0]; // 简化成每次都发出8字节


endmodule : mat_lsu_queue