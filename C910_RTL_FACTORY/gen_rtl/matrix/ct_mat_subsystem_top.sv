module ct_mat_subsystem_top #(parameter RLEN = 512) (
  /* common */
  input         cpurst_b                             ,
  input         forever_cpuclk                       ,
  input         cp0_mat_icg_en                       ,
  input         cp0_yy_clk_en                        ,
  input         pad_yy_icg_scan_en                   ,
  /* RTU flush */
  input         rtu_yy_xx_flush                      ,
  /* all matrix unit */
  input  [ 6:0] idu_mat_rf_pipe8_iid                 ,
  /* ALU */
  input         idu_mat_rf_alu_sel                   ,
  input         idu_mat_rf_alu_gateclk_sel           ,
  input  [30:0] idu_mat_rf_pipe8_alu_meta            ,
  input         idu_mat_rf_pipe8_alu_src0_vld        ,
  input  [63:0] idu_mat_rf_pipe8_alu_src0            ,
  /* LSU */
  input         idu_mat_rf_lsu_sel                   ,
  input         idu_mat_rf_lsu_gateclk_sel           ,
  input  [15:0] idu_mat_rf_pipe8_lsu_meta            ,
  input  [63:0] idu_mat_rf_pipe8_lsu_src0            ,
  input         idu_mat_rf_pipe8_lsu_src1_vld        ,
  input  [63:0] idu_mat_rf_pipe8_lsu_src1            ,
  /* CFG */
  input         idu_mat_rf_cfg_sel                   ,
  input         idu_mat_rf_cfg_gateclk_sel           ,
  input  [ 3:0] idu_mat_rf_pipe8_cfg_meta            ,
  input         idu_mat_rf_pipe8_cfg_dst_vld         ,
  input  [ 6:0] idu_mat_rf_pipe8_cfg_dst_preg        ,
  input  [63:0] idu_mat_rf_pipe8_cfg_src0            ,
  /* write back to main pipeline GPR */
  // pipe8 标识矩阵来自/并入主流水线的序号
  output        mat_cfg_idu_ex1_pipe8_wb_preg_vld    , // for pregfile in idu
  output [ 6:0] mat_cfg_idu_ex1_pipe8_wb_preg        ,
  output [95:0] mat_cfg_idu_ex1_pipe8_wb_preg_expand ,
  output [63:0] mat_cfg_idu_ex1_pipe8_wb_preg_data   ,
  output        mat_cfg_rtu_ex1_pipe8_wb_preg_vld    , // for map table in rtu
  output [95:0] mat_cfg_rtu_ex1_pipe8_wb_preg_expand ,
  output        mat_rtu_pipe8_cmplt                  , // 统一的rtu cmplt接口
  output [ 6:0] mat_rtu_pipe8_iid                    ,
  /* sync xmsize csr to main pipeline */
  output [63:0] mat_cfg_idu_ex1_pipe8_sync_xmsize_csr
);

  logic [15:0] x_sizeK;
  logic [ 7:0] x_sizeM;
  logic [ 7:0] x_sizeN;

  // TODO: 例化新的config_unit, 并尝试构建三类执行单元cmplt信号的合并逻辑, 
  // 因为严格按照scoreboard监控执行, 需要考虑scoreboard是否会同时产生多条完成信号? 
  // 如果会则需要使用拼接合并三条完成信号, 如果不会则可以使用"或"完成拼接:
  // mat_cfg_cbus_ex1_pipe8_sel  mat_alu_cbus_ex1_pipe8_sel  mat_lsu_cbus_ex1_pipe8_sel;
  // 完善matrix子系统连接IDU接收/写回寄存器并提交到RTU
  
  logic mat_cfg_cbus_ex1_pipe8_sel;
  logic [6:0] mat_cfg_cbus_ex1_pipe8_iid;

  logic mat_alu_cbus_ex1_pipe8_sel;
  logic [6:0] mat_alu_cbus_ex1_pipe8_iid;

  logic mat_lsu_cbus_ex1_pipe8_sel;
  logic [6:0] mat_lsu_cbus_ex1_pipe8_iid;

  // TODO: 暂时不会冲突, 待完善各个执行单元具体逻辑后需要考虑错开冲突
  assign mat_rtu_pipe8_cmplt = mat_cfg_cbus_ex1_pipe8_sel 
                            || mat_alu_cbus_ex1_pipe8_sel 
                            || mat_lsu_cbus_ex1_pipe8_sel; 
  assign mat_rtu_pipe8_iid[6:0] = 
      ({7{mat_cfg_cbus_ex1_pipe8_sel}} & mat_cfg_cbus_ex1_pipe8_iid[6:0])
    | ({7{mat_alu_cbus_ex1_pipe8_sel}} & mat_alu_cbus_ex1_pipe8_iid[6:0])
    | ({7{mat_lsu_cbus_ex1_pipe8_sel}} & mat_lsu_cbus_ex1_pipe8_iid[6:0]);

  ct_mat_exu_config_unit x_ct_mat_exu_config_unit (
    .cpurst_b                             (cpurst_b                             ),
    .forever_cpuclk                       (forever_cpuclk                       ),
    .cp0_mat_icg_en                       (cp0_mat_icg_en                       ),
    .cp0_yy_clk_en                        (cp0_yy_clk_en                        ),
    .pad_yy_icg_scan_en                   (pad_yy_icg_scan_en                   ),
    .rtu_yy_xx_flush                      (rtu_yy_xx_flush                      ),
    .idu_mat_rf_pipe8_iid                 (idu_mat_rf_pipe8_iid                 ),
    .idu_mat_rf_cfg_sel                   (idu_mat_rf_cfg_sel                   ),
    .idu_mat_rf_cfg_gateclk_sel           (idu_mat_rf_cfg_gateclk_sel           ),
    .idu_mat_rf_pipe8_cfg_meta            (idu_mat_rf_pipe8_cfg_meta            ),
    .idu_mat_rf_pipe8_cfg_src0            (idu_mat_rf_pipe8_cfg_src0            ),
    .idu_mat_rf_pipe8_cfg_dst_vld         (idu_mat_rf_pipe8_cfg_dst_vld         ),
    .idu_mat_rf_pipe8_cfg_dst_preg        (idu_mat_rf_pipe8_cfg_dst_preg        ),
    .x_sizeK                              (x_sizeK                              ),
    .x_sizeM                              (x_sizeM                              ),
    .x_sizeN                              (x_sizeN                              ),
    .mat_cfg_cbus_ex1_pipe8_sel           (mat_cfg_cbus_ex1_pipe8_sel           ),
    .mat_cfg_cbus_ex1_pipe8_iid           (mat_cfg_cbus_ex1_pipe8_iid           ),
    .mat_cfg_idu_ex1_pipe8_wb_preg_vld    (mat_cfg_idu_ex1_pipe8_wb_preg_vld    ),
    .mat_cfg_idu_ex1_pipe8_wb_preg        (mat_cfg_idu_ex1_pipe8_wb_preg        ),
    .mat_cfg_idu_ex1_pipe8_wb_preg_expand (mat_cfg_idu_ex1_pipe8_wb_preg_expand ),
    .mat_cfg_idu_ex1_pipe8_wb_preg_data   (mat_cfg_idu_ex1_pipe8_wb_preg_data   ),
    .mat_cfg_rtu_ex1_pipe8_wb_preg_vld    (mat_cfg_rtu_ex1_pipe8_wb_preg_vld    ),
    .mat_cfg_rtu_ex1_pipe8_wb_preg_expand (mat_cfg_rtu_ex1_pipe8_wb_preg_expand ),
    .mat_cfg_idu_ex1_pipe8_sync_xmsize_csr(mat_cfg_idu_ex1_pipe8_sync_xmsize_csr)
  );

  ct_mat_exu_arithmetic_unit i_ct_mat_exu_arithmetic_unit (
    .cpurst_b                     (cpurst_b                     ),
    .forever_cpuclk               (forever_cpuclk               ),
    .cp0_mat_icg_en               (cp0_mat_icg_en               ),
    .cp0_yy_clk_en                (cp0_yy_clk_en                ),
    .pad_yy_icg_scan_en           (pad_yy_icg_scan_en           ),
    .rtu_yy_xx_flush              (rtu_yy_xx_flush              ),
    .idu_mat_rf_pipe8_iid         (idu_mat_rf_pipe8_iid         ),
    .idu_mat_rf_alu_sel           (idu_mat_rf_alu_sel           ),
    .idu_mat_rf_alu_gateclk_sel   (idu_mat_rf_alu_gateclk_sel   ),
    .idu_mat_rf_pipe8_alu_meta    (idu_mat_rf_pipe8_alu_meta    ),
    .idu_mat_rf_pipe8_alu_src0_vld(idu_mat_rf_pipe8_alu_src0_vld),
    .idu_mat_rf_pipe8_alu_src0    (idu_mat_rf_pipe8_alu_src0    ),
    .x_sizeK                      (x_sizeK                      ),
    .x_sizeM                      (x_sizeM                      ),
    .x_sizeN                      (x_sizeN                      ),
    .mat_alu_cbus_ex1_pipe8_sel   (mat_alu_cbus_ex1_pipe8_sel   ),
    .mat_alu_cbus_ex1_pipe8_iid   (mat_alu_cbus_ex1_pipe8_iid   )
  );

  ct_mat_exu_ldst_unit i_ct_mat_exu_ldst_unit (
    .cpurst_b                     (cpurst_b                     ),
    .forever_cpuclk               (forever_cpuclk               ),
    .cp0_mat_icg_en               (cp0_mat_icg_en               ),
    .cp0_yy_clk_en                (cp0_yy_clk_en                ),
    .pad_yy_icg_scan_en           (pad_yy_icg_scan_en           ),
    .rtu_yy_xx_flush              (rtu_yy_xx_flush              ),
    .idu_mat_rf_pipe8_iid         (idu_mat_rf_pipe8_iid         ),
    .idu_mat_rf_lsu_sel           (idu_mat_rf_lsu_sel           ),
    .idu_mat_rf_lsu_gateclk_sel   (idu_mat_rf_lsu_gateclk_sel   ),
    .idu_mat_rf_pipe8_lsu_meta    (idu_mat_rf_pipe8_lsu_meta    ),
    .idu_mat_rf_pipe8_lsu_src0    (idu_mat_rf_pipe8_lsu_src0    ),
    .idu_mat_rf_pipe8_lsu_src1_vld(idu_mat_rf_pipe8_lsu_src1_vld),
    .idu_mat_rf_pipe8_lsu_src1    (idu_mat_rf_pipe8_lsu_src1    ),
    .x_sizeK                      (x_sizeK                      ),
    .x_sizeM                      (x_sizeM                      ),
    .x_sizeN                      (x_sizeN                      ),
    .mat_lsu_cbus_ex1_pipe8_sel   (mat_lsu_cbus_ex1_pipe8_sel   ),
    .mat_lsu_cbus_ex1_pipe8_iid   (mat_lsu_cbus_ex1_pipe8_iid   )
  );

endmodule

