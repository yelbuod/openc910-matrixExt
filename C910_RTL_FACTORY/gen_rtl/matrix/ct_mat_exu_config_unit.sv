module ct_mat_exu_config_unit (
  /* common */
  input         cpurst_b                             ,
  input         forever_cpuclk                       ,
  input         cp0_mat_icg_en                       ,
  input         cp0_yy_clk_en                        ,
  input         pad_yy_icg_scan_en                   ,
  /* RTU flush */
  input         rtu_yy_xx_flush                      ,
  /* from rf issue to CFG unit*/
  input  [ 6:0] idu_mat_rf_pipe8_iid                 ,
  input         idu_mat_rf_cfg_sel                   ,
  input         idu_mat_rf_cfg_gateclk_sel           ,
  input  [ 3:0] idu_mat_rf_pipe8_cfg_meta            ,
  input         idu_mat_rf_pipe8_cfg_dst_vld         ,
  input  [ 6:0] idu_mat_rf_pipe8_cfg_dst_preg        ,
  input  [63:0] idu_mat_rf_pipe8_cfg_src0            ,
  /* output to LSU/ALU unit */
  output [15:0] x_sizeK                              ,
  output [ 7:0] x_sizeM                              ,
  output [ 7:0] x_sizeN                              ,
  /* commit to rtu retire */
  output        mat_cfg_cbus_ex1_pipe8_sel           ,
  output [ 6:0] mat_cfg_cbus_ex1_pipe8_iid           ,
  /* write back to main pipeline GPR */
  // pipe8 标识矩阵来自/并入主流水线的序号
  output        mat_cfg_idu_ex1_pipe8_wb_preg_vld    , // for pregfile in idu
  output [ 6:0] mat_cfg_idu_ex1_pipe8_wb_preg        ,
  output [95:0] mat_cfg_idu_ex1_pipe8_wb_preg_expand ,
  output [63:0] mat_cfg_idu_ex1_pipe8_wb_preg_data   ,
  output        mat_cfg_rtu_ex1_pipe8_wb_preg_vld    , // for map table in rtu
  output [95:0] mat_cfg_rtu_ex1_pipe8_wb_preg_expand ,
  /* sync xmsize csr to main pipeline */
  output [63:0] mat_cfg_idu_ex1_pipe8_sync_xmsize_csr
);

  parameter MAT_CFG_OP_TYPE_WIDTH = 4      ;
  parameter MAT_CFG_K             = 4'b0001;
  parameter MAT_CFG_M             = 4'b0010;
  parameter MAT_CFG_N             = 4'b0100;
  parameter MAT_CFG_ALL           = 4'b1000;

  parameter MAT_CFG_DATA_WIDTH    = 4;
  parameter MAT_CFG_OP            = 3; // 3:0

  parameter SIZE_K_WIDTH = 16;
  parameter SIZE_M_WIDTH = 8;
  parameter SIZE_N_WIDTH = 8;

  wire ctrl_clk_en    ;
  wire ctrl_clk       ;
  wire ex1_inst_clk_en;
  wire ex1_inst_clk   ;

  reg         mat_cfg_ex1_inst_vld       ;
  reg  [ 6:0] mat_cfg_ex1_iid            ;
  reg  [ 3:0] mat_cfg_ex1_optype         ;
  reg  [63:0] mat_cfg_ex1_src0           ;
  reg         mat_cfg_ex1_dst_vld        ;
  reg  [ 6:0] mat_cfg_ex1_dst_preg       ;
  wire [95:0] mat_cfg_ex1_dst_preg_expand;

  wire        mat_cfg_sizeK;
  wire        mat_cfg_sizeM;
  wire        mat_cfg_sizeN;
  wire        mat_cfg_all  ;
  wire        sizeK_wen    ;
  wire        sizeM_wen    ;
  wire        sizeN_wen    ;
  wire [15:0] sizeK_wdata  ;
  wire [ 7:0] sizeM_wdata  ;
  wire [ 7:0] sizeN_wdata  ;

  reg [15:0] sizeK;
  reg [ 7:0] sizeM;
  reg [ 7:0] sizeN;
  
  wire [63:0] mat_cfg_ex1_xmsize;
  //==========================================================
  //                 RF/EX1 Pipeline Register
  //==========================================================
  //----------------------------------------------------------
  //                 Instance of Gated Cell  
  //----------------------------------------------------------
  // 控制信号需要接收flush, 因此在"创建时"和"有效时"均使能门控时钟
  assign ctrl_clk_en = idu_mat_rf_cfg_gateclk_sel || mat_cfg_ex1_inst_vld; 
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
  assign ex1_inst_clk_en = idu_mat_rf_cfg_gateclk_sel;
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
  always_ff @(posedge ctrl_clk or negedge cpurst_b) begin : proc_mat_cfg_ex1_vld
    if(!cpurst_b) begin
      mat_cfg_ex1_inst_vld <= 1'b0;
      // TODO: 补充CFG写回旁路, mat_cfg_ex1_fwd_vld <= 1'b0;
    end
    else if(rtu_yy_xx_flush) begin
      mat_cfg_ex1_inst_vld <= 1'b0;
    end
    else begin
      mat_cfg_ex1_inst_vld <= idu_mat_rf_cfg_sel;
    end
  end

//----------------------------------------------------------
//               Matrix Cfg EX1 Instruction Data
//----------------------------------------------------------
  always_ff @(posedge ex1_inst_clk or negedge cpurst_b) begin : proc_mat_cfg_ex1_data
    if(!cpurst_b) begin
      mat_cfg_ex1_iid[6:0]      <= 7'b0;
      mat_cfg_ex1_optype[3:0]   <= 4'b0;
      mat_cfg_ex1_src0[63:0]    <= 64'b0;
      mat_cfg_ex1_dst_vld       <= 1'b0;
      mat_cfg_ex1_dst_preg[6:0] <= 7'b0;
    end else if(idu_mat_rf_cfg_gateclk_sel) begin
      mat_cfg_ex1_iid[6:0]      <= idu_mat_rf_pipe8_iid[6:0];
      mat_cfg_ex1_optype[3:0]   <= idu_mat_rf_pipe8_cfg_meta[MAT_CFG_OP:MAT_CFG_OP-3];
      mat_cfg_ex1_src0[63:0]    <= idu_mat_rf_pipe8_cfg_src0[63:0];
      mat_cfg_ex1_dst_vld       <= idu_mat_rf_pipe8_cfg_dst_vld;
      mat_cfg_ex1_dst_preg[6:0] <= idu_mat_rf_pipe8_cfg_dst_preg[6:0];
    end
  end

//----------------------------------------------------------
//               Matrix Cfg EX1 Execute
//----------------------------------------------------------
  assign mat_cfg_sizeK = mat_cfg_ex1_optype[0];
  assign mat_cfg_sizeM = mat_cfg_ex1_optype[1];
  assign mat_cfg_sizeN = mat_cfg_ex1_optype[2];
  assign mat_cfg_all   = mat_cfg_ex1_optype[3];

  assign sizeK_wen = mat_cfg_sizeK || mat_cfg_all; // MAT_CFG_K or MAT_CFG_ALL
  assign sizeM_wen = mat_cfg_sizeM || mat_cfg_all; // MAT_CFG_M or MAT_CFG_ALL
  assign sizeN_wen = mat_cfg_sizeN || mat_cfg_all; // MAT_CFG_N or MAT_CFG_ALL

  assign sizeK_wdata[15:0] =  
      ({SIZE_K_WIDTH{mat_cfg_sizeK}} & mat_cfg_ex1_src0[15:0])
    | ({SIZE_K_WIDTH{mat_cfg_all}}   & mat_cfg_ex1_src0[31:16]);

  assign sizeM_wdata[7:0] = 
      ({SIZE_M_WIDTH{mat_cfg_sizeM}} & mat_cfg_ex1_src0[7:0])
    | ({SIZE_M_WIDTH{mat_cfg_all}}   & mat_cfg_ex1_src0[7:0]);

  assign sizeN_wdata[7:0] = 
      ({SIZE_N_WIDTH{mat_cfg_sizeN}} & mat_cfg_ex1_src0[7:0]) 
    | ({SIZE_N_WIDTH{mat_cfg_all}}   & mat_cfg_ex1_src0[15:8]);    

  // TODO : gate clk
  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_configure_sizeK
    if(!cpurst_b) begin
      sizeK[SIZE_K_WIDTH-1:0] <= {SIZE_K_WIDTH{1'b0}};
    end 
    else if(sizeK_wen) begin
      sizeK[SIZE_K_WIDTH-1:0] <= sizeK_wdata[SIZE_K_WIDTH-1:0];
    end
  end

  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_configure_sizeM
    if(!cpurst_b) begin
      sizeM[SIZE_M_WIDTH-1:0] <= {SIZE_M_WIDTH{1'b0}};
    end 
    else if(sizeM_wen) begin
      sizeM[SIZE_M_WIDTH-1:0] <= sizeM_wdata[SIZE_M_WIDTH-1:0];
    end
  end

  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_configure_sizeN
    if(!cpurst_b) begin
      sizeN[SIZE_N_WIDTH-1:0] <= {SIZE_N_WIDTH{1'b0}};
    end 
    else if(sizeN_wen) begin
      sizeN[SIZE_N_WIDTH-1:0] <= sizeN_wdata[SIZE_N_WIDTH-1:0];
    end
  end

  assign x_sizeK[15:0] = sizeK[15:0];
  assign x_sizeM[ 7:0] = sizeM[ 7:0];
  assign x_sizeN[ 7:0] = sizeN[ 7:0];

  assign mat_cfg_ex1_xmsize[63:0] = {32'd0, sizeK[15:0], sizeN[7:0], sizeM[7:0]};

  ct_rtu_expand_96  x_ct_rtu_expand_96_rbus_pipe8_wb_preg (
    .x_num                       (mat_cfg_ex1_dst_preg       ),
    .x_num_expand                (mat_cfg_ex1_dst_preg_expand)
  );

//----------------------------------------------------------
//  Matrix Cfg Interface to Complete Bus(cbus) & Reg Bus(rbus)
//----------------------------------------------------------
  // CFG指令在 EX1 stage 执行完毕, 使能写回(wb)和提交(cmplt)
  // TODO: 旁路和增加mat_cfg_ex1_inst_vld寄存器驱动以减小fanout压力
  assign mat_cfg_cbus_ex1_pipe8_sel      = mat_cfg_ex1_inst_vld;
  assign mat_cfg_cbus_ex1_pipe8_iid[6:0] = mat_cfg_ex1_iid[6:0];

  assign mat_cfg_idu_ex1_pipe8_wb_preg_vld = mat_cfg_ex1_inst_vld & mat_cfg_ex1_dst_vld;
  assign mat_cfg_rtu_ex1_pipe8_wb_preg_vld = mat_cfg_ex1_inst_vld & mat_cfg_ex1_dst_vld;

  assign mat_cfg_idu_ex1_pipe8_wb_preg[6:0] = mat_cfg_ex1_dst_preg[6:0];
  assign mat_cfg_idu_ex1_pipe8_wb_preg_expand[95:0] = mat_cfg_ex1_dst_preg_expand[95:0];
  assign mat_cfg_rtu_ex1_pipe8_wb_preg_expand[95:0] = mat_cfg_ex1_dst_preg_expand[95:0];

  assign mat_cfg_idu_ex1_pipe8_wb_preg_data[63:0] = mat_cfg_ex1_xmsize[63:0];
  assign mat_cfg_idu_ex1_pipe8_sync_xmsize_csr[63:0] = mat_cfg_ex1_xmsize[63:0];

endmodule : ct_mat_exu_config_unit