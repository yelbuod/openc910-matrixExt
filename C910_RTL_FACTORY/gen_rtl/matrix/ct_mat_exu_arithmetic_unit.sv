module ct_mat_exu_arithmetic_unit (
  /* common */
  input         cpurst_b                     ,
  input         forever_cpuclk               ,
  input         cp0_mat_icg_en               ,
  input         cp0_yy_clk_en                ,
  input         pad_yy_icg_scan_en           ,
  /* RTU flush */
  input         rtu_yy_xx_flush              ,
  /* from rf issue to ALU */
  input  [ 6:0] idu_mat_rf_pipe8_iid         ,
  input         idu_mat_rf_alu_sel           ,
  input         idu_mat_rf_alu_gateclk_sel   ,
  input  [30:0] idu_mat_rf_pipe8_alu_meta    ,
  input         idu_mat_rf_pipe8_alu_src0_vld,
  input  [63:0] idu_mat_rf_pipe8_alu_src0    ,
  /* from CFG unit configuration */
  input  [15:0] x_sizeK                      ,
  input  [ 7:0] x_sizeM                      ,
  input  [ 7:0] x_sizeN                      ,
  /* commit to rtu retire */
  output        mat_alu_cbus_ex1_pipe8_sel   ,
  output [ 6:0] mat_alu_cbus_ex1_pipe8_iid
);

parameter MAT_ALU_OP_TYPE_WIDTH = 11               ;
parameter MAT_CAL_MMOV          = 11'b000_0000_0001;
parameter MAT_CAL_FMMACC        = 11'b000_0000_0010;
parameter MAT_CAL_FWMMACC       = 11'b000_0000_0100;
parameter MAT_CAL_MMAQA         = 11'b000_0000_1000; // pmmaqa for int4 不实现
parameter MAT_CAL_MADD          = 11'b000_0001_0000;
parameter MAT_CAL_MSUB          = 11'b000_0010_0000;
parameter MAT_CAL_MSRA          = 11'b000_0100_0000;
parameter MAT_CAL_MN4CLIP       = 11'b000_1000_0000; // signed clip
parameter MAT_CAL_MN4CLIPU      = 11'b001_0000_0000; // unsigned clip
parameter MAT_CAL_MMUL          = 11'b010_0000_0000;
parameter MAT_CAL_MMULH         = 11'b100_0000_0000;

parameter MAT_ALU_OP             = 30; // 30:20
parameter MAT_ALU_DSTM_VLD       = 19;
parameter MAT_ALU_DSTM_IDX       = 18; // 18:16
parameter MAT_ALU_SRC1M_VLD      = 15;
parameter MAT_ALU_SRC1M_UNSIGNED = 14;
parameter MAT_ALU_SRC1M_IDX      = 13; // 13:11
parameter MAT_ALU_SRC0M_VLD      = 10;
parameter MAT_ALU_SRC0M_UNSIGNED = 9;
parameter MAT_ALU_SRC0M_IDX      = 8; // 8:6
parameter MAT_ALU_UIMM3_VLD      = 5 ;
parameter MAT_ALU_UIMM3          = 4 ; // 4:2
parameter MAT_ALU_ELM_WIDTH      = 1 ; // 1:0

  wire ctrl_clk_en;
  wire ctrl_clk;
  wire ex1_inst_clk_en;
  wire ex1_inst_clk;

  reg        mat_alu_ex1_inst_vld;
  reg [ 6:0] mat_alu_ex1_iid     ;
  reg        mat_alu_ex1_src0_vld;
  reg [63:0] mat_alu_ex1_src0    ;
  // alu execute info meta
  reg [10:0] mat_alu_ex1_optype         ;
  reg        mat_alu_ex1_dstm_17_15_vld ;
  reg [ 2:0] mat_alu_ex1_dstm_idx_17_15 ;
  reg        mat_alu_ex1_srcm1_vld      ;
  reg        mat_alu_ex1_srcm1_unsigned ;
  reg [ 2:0] mat_alu_ex1_srcm1_idx      ;
  reg        mat_alu_ex1_srcm0_vld      ;
  reg        mat_alu_ex1_srcm0_unsigned ;
  reg [ 2:0] mat_alu_ex1_srcm0_idx      ;
  reg        mat_alu_ex1_uimm3_vld      ;
  reg [ 2:0] mat_alu_ex1_uimm3          ;
  reg [ 1:0] mat_alu_ex1_elem_data_width;
  //==========================================================
  //                 RF/EX1 Pipeline Register
  //==========================================================
  //----------------------------------------------------------
  //                 Instance of Gated Cell  
  //----------------------------------------------------------
  // 控制信号需要接收flush, 因此在"创建时"和"有效时"均使能门控时钟
  assign ctrl_clk_en = idu_mat_rf_alu_gateclk_sel || mat_alu_ex1_inst_vld; 
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
  assign ex1_inst_clk_en = idu_mat_rf_alu_gateclk_sel;
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
  always_ff @(posedge ctrl_clk or negedge cpurst_b) begin : proc_mat_alu_ex1_vld
    if(!cpurst_b) begin
      mat_alu_ex1_inst_vld <= 1'b0;
    end else if(rtu_yy_xx_flush) begin
      mat_alu_ex1_inst_vld <= 1'b0;
    end else begin
      mat_alu_ex1_inst_vld <= idu_mat_rf_alu_sel;
    end
  end
//----------------------------------------------------------
//               Matrix Cfg EX1 Instruction Data
//----------------------------------------------------------
  always_ff @(posedge ex1_inst_clk or negedge cpurst_b) begin : proc_mat_alu_ex1_data
    if(!cpurst_b) begin
      mat_alu_ex1_iid[6:0]                          <= 7'b0;
      mat_alu_ex1_src0_vld                          <= 1'b0;
      mat_alu_ex1_src0[63:0]                        <= 64'b0;
      mat_alu_ex1_optype[MAT_ALU_OP_TYPE_WIDTH-1:0] <= {MAT_ALU_OP_TYPE_WIDTH{1'b0}};
      mat_alu_ex1_dstm_17_15_vld                    <= 1'b0;
      mat_alu_ex1_dstm_idx_17_15[2:0]               <= 3'b0;
      mat_alu_ex1_srcm1_vld                         <= 1'b0;
      mat_alu_ex1_srcm1_unsigned                    <= 1'b0;
      mat_alu_ex1_srcm1_idx[2:0]                    <= 3'b0;
      mat_alu_ex1_srcm0_vld                         <= 1'b0;
      mat_alu_ex1_srcm0_unsigned                    <= 1'b0;
      mat_alu_ex1_srcm0_idx[2:0]                    <= 3'b0;
      mat_alu_ex1_uimm3_vld                         <= 1'b0;
      mat_alu_ex1_uimm3[2:0]                        <= 3'b0;
      mat_alu_ex1_elem_data_width[1:0]              <= 2'b0;
    end else if(idu_mat_rf_alu_gateclk_sel) begin
      mat_alu_ex1_iid[6:0]                          <= idu_mat_rf_pipe8_iid[6:0];
      mat_alu_ex1_src0_vld                          <= idu_mat_rf_pipe8_alu_src0_vld;
      mat_alu_ex1_src0[63:0]                        <= idu_mat_rf_pipe8_alu_src0[63:0];
      mat_alu_ex1_optype[MAT_ALU_OP_TYPE_WIDTH-1:0] <= idu_mat_rf_pipe8_alu_meta[MAT_ALU_OP:MAT_ALU_OP-(MAT_ALU_OP_TYPE_WIDTH-1)] ;
      mat_alu_ex1_dstm_17_15_vld                    <= idu_mat_rf_pipe8_alu_meta[MAT_ALU_DSTM_VLD]                                ;
      mat_alu_ex1_dstm_idx_17_15[2:0]               <= idu_mat_rf_pipe8_alu_meta[MAT_ALU_DSTM_IDX:MAT_ALU_DSTM_IDX-2]             ;
      mat_alu_ex1_srcm1_vld                         <= idu_mat_rf_pipe8_alu_meta[MAT_ALU_SRC1M_VLD]                               ;
      mat_alu_ex1_srcm1_unsigned                    <= idu_mat_rf_pipe8_alu_meta[MAT_ALU_SRC1M_UNSIGNED]                          ;
      mat_alu_ex1_srcm1_idx[2:0]                    <= idu_mat_rf_pipe8_alu_meta[MAT_ALU_SRC1M_IDX:MAT_ALU_SRC1M_IDX-2]           ;
      mat_alu_ex1_srcm0_vld                         <= idu_mat_rf_pipe8_alu_meta[MAT_ALU_SRC0M_VLD]                               ;
      mat_alu_ex1_srcm0_unsigned                    <= idu_mat_rf_pipe8_alu_meta[MAT_ALU_SRC0M_UNSIGNED]                          ;
      mat_alu_ex1_srcm0_idx[2:0]                    <= idu_mat_rf_pipe8_alu_meta[MAT_ALU_SRC0M_IDX:MAT_ALU_SRC0M_IDX-2]           ;
      mat_alu_ex1_uimm3_vld                         <= idu_mat_rf_pipe8_alu_meta[MAT_ALU_UIMM3_VLD]                               ;
      mat_alu_ex1_uimm3[2:0]                        <= idu_mat_rf_pipe8_alu_meta[MAT_ALU_UIMM3:MAT_ALU_UIMM3-2]                   ;
      mat_alu_ex1_elem_data_width[1:0]              <= idu_mat_rf_pipe8_alu_meta[MAT_ALU_ELM_WIDTH:MAT_ALU_ELM_WIDTH-1]           ;
    end
  end
  
  // TODO: 暂时不执行直接提交查看通路正确性
  assign mat_alu_cbus_ex1_pipe8_sel      = mat_alu_ex1_inst_vld;
  assign mat_alu_cbus_ex1_pipe8_iid[6:0] = mat_alu_ex1_iid[6:0];

endmodule : ct_mat_exu_arithmetic_unit