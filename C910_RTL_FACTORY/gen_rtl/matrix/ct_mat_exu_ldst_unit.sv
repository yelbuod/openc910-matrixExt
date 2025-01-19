module ct_mat_exu_ldst_unit (
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
  input         idu_mat_rf_lsu_sel           ,
  input         idu_mat_rf_lsu_gateclk_sel   ,
  input  [15:0] idu_mat_rf_pipe8_lsu_meta    ,
  input  [63:0] idu_mat_rf_pipe8_lsu_src0    ,
  input         idu_mat_rf_pipe8_lsu_src1_vld,
  input  [63:0] idu_mat_rf_pipe8_lsu_src1    ,
  /* from CFG unit configuration */
  input  [15:0] x_sizeK                      ,
  input  [ 7:0] x_sizeM                      ,
  input  [ 7:0] x_sizeN                      ,
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

  wire ctrl_clk_en;
  wire ctrl_clk;
  wire ex1_inst_clk_en;
  wire ex1_inst_clk;

  reg        mat_lsu_ex1_inst_vld;
  reg [ 6:0] mat_lsu_ex1_iid     ;
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

  assign mat_lsu_cbus_ex1_pipe8_sel      = mat_lsu_ex1_inst_vld;
  assign mat_lsu_cbus_ex1_pipe8_iid[6:0] = mat_lsu_ex1_iid[6:0];

endmodule : ct_mat_exu_ldst_unit