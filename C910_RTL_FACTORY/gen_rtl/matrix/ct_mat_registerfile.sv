import "DPI-C" function void hart_matrixMemLoadWriteBack(
  byte unsigned ld_mreg_row_wen, 
  byte unsigned ld_mreg_idx_wen, 
  longint unsigned ld_mreg_wstride,
  byte unsigned ld_mreg_nf_mode, 
  longint unsigned lsu_mat_reg_ld_data_highbits,
  longint unsigned lsu_mat_reg_ld_data_lowbits
);

module ct_mat_registerfile (
  input        cpurst_b           ,
  input        forever_cpuclk     ,
  input        ld_mreg_wb_en      ,
  input [ 7:0] ld_mreg_row_wen    ,
  input [ 2:0] ld_mreg_idx_wen    ,
  input [63:0] ld_mreg_wstride    ,
  input        ld_mreg_nf_mode    ,
  input [63:0] lsu_mat_reg_ld_data
);

always@(posedge forever_cpuclk) begin
  if(|ld_mreg_wb_en) begin
    // $display("high bits:%x, low bits:%x", lsu_mat_reg_ld_data[63:32], lsu_mat_reg_ld_data[31:0]);
    hart_matrixMemLoadWriteBack(ld_mreg_row_wen[7:0], ld_mreg_idx_wen[2:0], 
                                ld_mreg_wstride[63:0], ld_mreg_nf_mode, 
                                lsu_mat_reg_ld_data[63:32], lsu_mat_reg_ld_data[31:0]);
  end
end

endmodule : ct_mat_registerfile