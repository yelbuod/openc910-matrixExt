import "DPI-C" function void hart_matrixMemLoadWriteBack(
  byte unsigned ld_mreg_row_wen, // memory access type
  byte unsigned ld_mreg_idx_wen, // load dest/store src
  longint unsigned ld_mreg_wstride,
  byte unsigned ld_mreg_nf_mode, // matrix rows to load, sizeM
  longint unsigned lsu_mat_reg_ld_data // matrix row stride to get next startline
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
    hart_matrixMemLoadWriteBack(ld_mreg_row_wen[7:0], ld_mreg_idx_wen[2:0], 
                                ld_mreg_wstride[63:0], ld_mreg_nf_mode, lsu_mat_reg_ld_data)
  end
end

endmodule : ct_mat_registerfile