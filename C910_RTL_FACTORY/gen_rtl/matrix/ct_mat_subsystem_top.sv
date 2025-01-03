module ct_mat_subsystem_top #(
  parameter RLEN = 512
)(
  /* common */
  input        cpurst_b,
  input        forever_cpuclk,
  /* ALU */
  input        idu_mat_rf_alu_sel,
  input        idu_mat_rf_alu_gateclk_sel,
  input [30:0] idu_mat_rf_pipe8_alu_meta,
  input        idu_mat_rf_pipe8_alu_src0_vld,
  input [63:0] idu_mat_rf_pipe8_alu_src0,
  /* LSU */
  input        idu_mat_rf_lsu_sel,
  input        idu_mat_rf_lsu_gateclk_sel,
  input [15:0] idu_mat_rf_pipe8_lsu_meta,
  input [63:0] idu_mat_rf_pipe8_lsu_src0,
  input        idu_mat_rf_pipe8_lsu_src1_vld,
  input [63:0] idu_mat_rf_pipe8_lsu_src1,
  /* CFG */
  input        idu_mat_rf_cfg_sel,
  input        idu_mat_rf_cfg_gateclk_sel,
  input [4 :0] idu_mat_rf_pipe8_cfg_meta,
  input        idu_mat_rf_pipe8_cfg_dst_vld,
  input [6 :0] idu_mat_rf_pipe8_cfg_dst_preg,
  input [63:0] idu_mat_rf_pipe8_cfg_src0,
  /* write back to main pipeline GPR */
  output [63:0] mat_idu_ex1_cfg_wb_data,
  /* sync xmsize csr to main pipeline */
  output [63:0] mat_idu_ex1_cfg_sync_xmsize_csr
);

  logic [15:0] x_sizeK;
  logic [ 7:0] x_sizeM;
  logic [ 7:0] x_sizeN;

  ct_mat_exu_config_unit i_ct_mat_exu_config_unit (
    .cpurst_b                       (cpurst_b                       ),
    .forever_cpuclk                 (forever_cpuclk                 ),
    .idu_mat_rf_cfg_sel             (idu_mat_rf_cfg_sel             ),
    .idu_mat_rf_cfg_gateclk_sel     (idu_mat_rf_cfg_gateclk_sel     ),
    .idu_mat_rf_pipe8_cfg_meta      (idu_mat_rf_pipe8_cfg_meta      ),
    .idu_mat_rf_pipe8_cfg_src0      (idu_mat_rf_pipe8_cfg_src0      ),
    .x_sizeK                        (x_sizeK                        ),
    .x_sizeM                        (x_sizeM                        ),
    .x_sizeN                        (x_sizeN                        ),
    .mat_idu_ex1_cfg_wb_data        (mat_idu_ex1_cfg_wb_data        ),
    .mat_idu_ex1_cfg_sync_xmsize_csr(mat_idu_ex1_cfg_sync_xmsize_csr)
  );


endmodule