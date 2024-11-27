module ct_mat_idu_top (
    input  [54:0] id_inst0_m_data    ,
    input  [54:0] id_inst1_m_data    ,
    input  [54:0] id_inst2_m_data    ,
    output [ 3:0] id_inst0_mat_type,
    output [36:0] id_inst0_mat_data,
    output [ 3:0] id_inst1_mat_type,
    output [36:0] id_inst1_mat_data,
    output [ 3:0] id_inst2_mat_type,
    output [36:0] id_inst2_mat_data
);

ct_mat_idu_decd i_ct_mat_idu_decd0 (
    .id_inst_m_data  (id_inst0_m_data     ),
    .id_inst_mat_type(id_inst0_mat_type),
    .id_inst_mat_data(id_inst0_mat_data   )
);

ct_mat_idu_decd i_ct_mat_idu_decd1 (
    .id_inst_m_data  (id_inst1_m_data     ),
    .id_inst_mat_type(id_inst1_mat_type),
    .id_inst_mat_data(id_inst1_mat_data   )
);

ct_mat_idu_decd i_ct_mat_idu_decd2 (
    .id_inst_m_data  (id_inst2_m_data     ),
    .id_inst_mat_type(id_inst2_mat_type),
    .id_inst_mat_data(id_inst2_mat_data   )
);

endmodule : ct_mat_idu_top