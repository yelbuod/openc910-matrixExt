// backup

// parameter MAT_ALU_DATA_WIDTH     = 37;
// parameter MAT_ALU_OP             = 36; // 36:26
// parameter MAT_ALU_DSTM_VLD       = 25;
// parameter MAT_ALU_DSTM_IDX       = 24; // 24:22
// parameter MAT_ALU_SRC0M_VLD      = 21;
// parameter MAT_ALU_SRC0M_UNSIGNED = 20;
// parameter MAT_ALU_SRC0M_IDX      = 19; // 19:17
// parameter MAT_ALU_SRC1M_VLD      = 16;
// parameter MAT_ALU_SRC1M_UNSIGNED = 15;
// parameter MAT_ALU_SRC1M_IDX      = 14; // 14:12
// parameter MAT_ALU_SRC0_VLD       = 11;
// parameter MAT_ALU_SRC0_REG       = 10; // 10:6
// parameter MAT_ALU_UIMM3_VLD      = 5 ;
// parameter MAT_ALU_UIMM3          = 4 ; // 4:2
// parameter MAT_ALU_ELM_WIDTH      = 1 ; // 1:0

// parameter MAT_LSU_DATA_WIDTH = 28;
// parameter MAT_LSU_OP         = 27; // 27:26
// parameter MAT_LSU_DSTM_VLD   = 25;
// parameter MAT_LSU_DSTM_IDX   = 24; // 24:22
// parameter MAT_LSU_SRC2M_VLD  = 21;
// parameter MAT_LSU_SRC2M_IDX  = 20; // 20:18
// parameter MAT_LSU_SCR0_VLD   = 17;
// parameter MAT_LSU_SRC0_IDX   = 16; // 16:12
// parameter MAT_LSU_SRC1_VLD   = 11;
// parameter MAT_LSU_SRC1_IDX   = 10; // 10:6
// parameter MAT_LSU_NF_VLD     = 5 ;
// parameter MAT_LSU_NF         = 4 ; // 4:2
// parameter MAT_LSU_ELM_WIDTH  = 1 ; // 1:0

// parameter MAT_CFG_DATA_WIDTH = 25;
// parameter MAT_CFG_OP         = 24; // 24:21
// parameter MAT_CFG_DST_X0     = 20;
// parameter MAT_CFG_DST_VLD    = 19;
// parameter MAT_CFG_DST_REG    = 18; // 18:14
// parameter MAT_CFG_SRC0_VLD   = 13;
// parameter MAT_CFG_SRC0_REG   = 12; // 12:8
// parameter MAT_CFG_UIMM7_VLD  = 7 ;
// parameter MAT_CFG_UIMM7      = 6 ; // 6:0

//     assign id_mat_alu_data[MAT_ALU_OP:MAT_ALU_OP-(MAT_ALU_OP_TYPE_WIDTH-1)] = id_mat_op[MAT_ALU_OP_TYPE_WIDTH-1:0];
//     assign id_mat_alu_data[MAT_ALU_DSTM_VLD]                                = id_dstm_17_15_vld;
//     assign id_mat_alu_data[MAT_ALU_DSTM_IDX:MAT_ALU_DSTM_IDX-2]             = id_dstm_idx_17_15[2:0];
//     assign id_mat_alu_data[MAT_ALU_SRC0M_VLD]                               = id_srcm0_vld;
//     assign id_mat_alu_data[MAT_ALU_SRC0M_UNSIGNED]                          = id_srcm0_unsigned;
//     assign id_mat_alu_data[MAT_ALU_SRC0M_IDX:MAT_ALU_SRC0M_IDX-2]           = id_srcm0_idx[2:0];
//     assign id_mat_alu_data[MAT_ALU_SRC1M_VLD]                               = id_srcm1_vld;
//     assign id_mat_alu_data[MAT_ALU_SRC1M_UNSIGNED]                          = id_srcm1_unsigned;
//     assign id_mat_alu_data[MAT_ALU_SRC1M_IDX:MAT_ALU_SRC1M_IDX-2]           = id_srcm1_idx[2:0];
//     // assign id_mat_alu_data[MAT_ALU_SRC0_VLD]                                = id_inst_src0_vld;
//     // assign id_mat_alu_data[MAT_ALU_SRC0_REG:MAT_ALU_SRC0_REG-4]             = id_inst_src0_reg[4:0];
//     assign id_mat_alu_data[MAT_ALU_UIMM3_VLD]                               = id_uimm3_vld;
//     assign id_mat_alu_data[MAT_ALU_UIMM3:MAT_ALU_UIMM3-2]                   = id_uimm3[2:0];
//     assign id_mat_alu_data[MAT_ALU_ELM_WIDTH:MAT_ALU_ELM_WIDTH-1]           = id_elem_data_width[1:0];

//     /* ---------------------------LSU--------------------------- */
//     assign id_mat_lsu_data[MAT_LSU_OP:MAT_LSU_OP-(MAT_LSU_OP_TYPE_WIDTH-1)] = id_mat_op[MAT_LSU_OP_TYPE_WIDTH-1:0];
//     assign id_mat_lsu_data[MAT_LSU_DSTM_VLD]                                = id_dstm_9_7_vld;
//     assign id_mat_lsu_data[MAT_LSU_DSTM_IDX:MAT_LSU_DSTM_IDX-2]             = id_dstm_idx_9_7[2:0];
//     assign id_mat_lsu_data[MAT_LSU_SRC2M_VLD]                               = id_srcm2_vld;
//     assign id_mat_lsu_data[MAT_LSU_SRC2M_IDX:MAT_LSU_SRC2M_IDX-2]           = id_srcm2_idx[2:0];
//     // assign id_mat_lsu_data[MAT_LSU_SCR0_VLD]                                = id_inst_src0_vld;
//     // assign id_mat_lsu_data[MAT_LSU_SRC0_IDX:MAT_LSU_SRC0_IDX-4]             = id_inst_src0_reg[4:0];
//     // assign id_mat_lsu_data[MAT_LSU_SRC1_VLD]                                = id_inst_src1_vld;
//     // assign id_mat_lsu_data[MAT_LSU_SRC1_IDX:MAT_LSU_SRC1_IDX-4]             = id_inst_src1_reg[4:0];
//     assign id_mat_lsu_data[MAT_LSU_NF_VLD]                                  = id_nf_vld;
//     assign id_mat_lsu_data[MAT_LSU_NF:MAT_LSU_NF-2]                         = id_nf[2:0];
//     assign id_mat_lsu_data[MAT_LSU_ELM_WIDTH:MAT_LSU_ELM_WIDTH-1]           = id_elem_data_width[1:0];

//     /* ---------------------------CFG--------------------------- */
//     assign id_mat_cfg_data[MAT_CFG_OP:MAT_CFG_OP-(MAT_CFG_OP_TYPE_WIDTH-1)] = id_mat_op[MAT_CFG_OP_TYPE_WIDTH-1:0];
//     // assign id_mat_cfg_data[MAT_CFG_DST_X0]                                  = id_inst_dst_x0;
//     // assign id_mat_cfg_data[MAT_CFG_DST_VLD]                                 = id_inst_dst_vld;
//     // assign id_mat_cfg_data[MAT_CFG_DST_REG:MAT_CFG_DST_REG-4]               = id_inst_dst_reg[4:0];
//     // assign id_mat_cfg_data[MAT_CFG_SRC0_VLD]                                = id_inst_src0_vld;
//     // assign id_mat_cfg_data[MAT_CFG_SRC0_REG:MAT_CFG_SRC0_REG-4]             = id_inst_src0_reg[4:0];
//     // uimm7 与 uimm3 不同, matrix alu指令可能不使用rs同时也不使用uimm3, 不是非此即彼的关系, 因此不能用rs0 vld来判断,
//     //  而 matrix cfg 指令的 uimm7和rs0是非此即彼的关系, 因此可以不需要通过译码, 只需要通过特定指令类型(CFG)下用rs0 vld来判断即可
//     assign id_mat_cfg_data[MAT_CFG_UIMM7_VLD]                               = id_uimm7_vld;
//     assign id_mat_cfg_data[MAT_CFG_UIMM7:MAT_CFG_UIMM7-6]                   = id_uimm7[6:0];

// module ct_mat_idu_top (
//     input  [54:0] id_inst0_m_data    ,
//     input  [54:0] id_inst1_m_data    ,
//     input  [54:0] id_inst2_m_data    ,
//     output [ 3:0] id_inst0_mat_type,
//     output [36:0] id_inst0_mat_data,
//     output [ 3:0] id_inst1_mat_type,
//     output [36:0] id_inst1_mat_data,
//     output [ 3:0] id_inst2_mat_type,
//     output [36:0] id_inst2_mat_data
// );

// ct_mat_idu_decd i_ct_mat_idu_decd0 (
//     .id_inst_m_data  (id_inst0_m_data     ),
//     .id_inst_mat_type(id_inst0_mat_type),
//     .id_inst_mat_data(id_inst0_mat_data   )
// );

// ct_mat_idu_decd i_ct_mat_idu_decd1 (
//     .id_inst_m_data  (id_inst1_m_data     ),
//     .id_inst_mat_type(id_inst1_mat_type),
//     .id_inst_mat_data(id_inst1_mat_data   )
// );

// ct_mat_idu_decd i_ct_mat_idu_decd2 (
//     .id_inst_m_data  (id_inst2_m_data     ),
//     .id_inst_mat_type(id_inst2_mat_type),
//     .id_inst_mat_data(id_inst2_mat_data   )
// );

// endmodule : ct_mat_idu_top