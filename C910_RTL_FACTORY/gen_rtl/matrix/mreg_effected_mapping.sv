module mreg_effected_mapping (
  input forever_cpuclk,    // Clock
  input cpurst_b,  // Asynchronous reset active low
  input [7:0] mreg_effected_mapping_wen_0,
  input [7:0] mreg_effected_mapping_wen_1,
  input [3:0] mreg_effected_mapping_widx_0,
  input [3:0] mreg_effected_mapping_widx_1,
  input [7:0] mreg_effected_mapping_src0_create0_ren,
  input [7:0] mreg_effected_mapping_src1_create0_ren,
  input [7:0] mreg_effected_mapping_src2_create0_ren,
  input [7:0] mreg_effected_mapping_src0_create1_ren,
  input [7:0] mreg_effected_mapping_src1_create1_ren,
  input [7:0] mreg_effected_mapping_src2_create1_ren,
  output [4:0] mreg_effected_mapping_src0_create0_ridx_vld,
  output [4:0] mreg_effected_mapping_src1_create0_ridx_vld,
  output [4:0] mreg_effected_mapping_src2_create0_ridx_vld,
  output [4:0] mreg_effected_mapping_src0_create1_ridx_vld,
  output [4:0] mreg_effected_mapping_src1_create1_ridx_vld,
  output [4:0] mreg_effected_mapping_src2_create1_ridx_vld
);

  logic [4:0] mreg_effected_map_table[0:7];

ct_mat_mux_onehot #(.KEY_LEN(8), .DATA_LEN(5)) u_src0_crt0_mux_ridx_vld (
  .data_out   (mreg_effected_mapping_src0_create0_ridx_vld),
  .onehot_key (mreg_effected_mapping_src0_create0_ren ),
  .default_out(5'b0                                   ),
  .data_list  (mreg_effected_map_table                )
);

ct_mat_mux_onehot #(.KEY_LEN(8), .DATA_LEN(5)) u_src1_crt0_mux_ridx_vld (
  .data_out   (mreg_effected_mapping_src1_create0_ridx_vld),
  .onehot_key (mreg_effected_mapping_src1_create0_ren ),
  .default_out(5'b0                                   ),
  .data_list  (mreg_effected_map_table                )
);

ct_mat_mux_onehot #(.KEY_LEN(8), .DATA_LEN(5)) u_src2_crt0_mux_ridx_vld (
  .data_out   (mreg_effected_mapping_src2_create0_ridx_vld),
  .onehot_key (mreg_effected_mapping_src2_create0_ren ),
  .default_out(5'b0                                   ),
  .data_list  (mreg_effected_map_table                )
);

ct_mat_mux_onehot #(.KEY_LEN(8), .DATA_LEN(5)) u_src0_crt1_mux_ridx_vld (
  .data_out   (mreg_effected_mapping_src0_create1_ridx_vld),
  .onehot_key (mreg_effected_mapping_src0_create1_ren ),
  .default_out(5'b0                                   ),
  .data_list  (mreg_effected_map_table                )
);

ct_mat_mux_onehot #(.KEY_LEN(8), .DATA_LEN(5)) u_src1_crt1_mux_ridx_vld (
  .data_out   (mreg_effected_mapping_src1_create1_ridx_vld),
  .onehot_key (mreg_effected_mapping_src1_create1_ren ),
  .default_out(5'b0                                   ),
  .data_list  (mreg_effected_map_table                )
);

ct_mat_mux_onehot #(.KEY_LEN(8), .DATA_LEN(5)) u_src2_crt1_mux_ridx_vld (
  .data_out   (mreg_effected_mapping_src2_create1_ridx_vld),
  .onehot_key (mreg_effected_mapping_src2_create1_ren ),
  .default_out(5'b0                                   ),
  .data_list  (mreg_effected_map_table                )
);

  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_0
    if(~cpurst_b) begin
      mreg_effected_map_table[0] <= 5'b0;
    end else if(mreg_effected_mapping_wen_1[0]) begin
      mreg_effected_map_table[0] <= {1'b1, mreg_effected_mapping_widx_1};
    end else if(mreg_effected_mapping_wen_0[0]) begin
      mreg_effected_map_table[0] <= {1'b1, mreg_effected_mapping_widx_0};
    end 
  end

  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_1
    if(~cpurst_b) begin
      mreg_effected_map_table[1] <= 5'b0;
    end else if(mreg_effected_mapping_wen_1[1]) begin
      mreg_effected_map_table[1] <= {1'b1, mreg_effected_mapping_widx_1};
    end else if(mreg_effected_mapping_wen_0[1]) begin
      mreg_effected_map_table[1] <= {1'b1, mreg_effected_mapping_widx_0};
    end 
  end

  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_2
    if(~cpurst_b) begin
      mreg_effected_map_table[2] <= 5'b0;
    end else if(mreg_effected_mapping_wen_1[2]) begin
      mreg_effected_map_table[2] <= {1'b1, mreg_effected_mapping_widx_1};
    end else if(mreg_effected_mapping_wen_0[2]) begin
      mreg_effected_map_table[2] <= {1'b1, mreg_effected_mapping_widx_0};
    end 
  end

  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_3
    if(~cpurst_b) begin
      mreg_effected_map_table[3] <= 5'b0;
    end else if(mreg_effected_mapping_wen_1[3]) begin
      mreg_effected_map_table[3] <= {1'b1, mreg_effected_mapping_widx_1};
    end else if(mreg_effected_mapping_wen_0[3]) begin
      mreg_effected_map_table[3] <= {1'b1, mreg_effected_mapping_widx_0};
    end 
  end

  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_4
    if(~cpurst_b) begin
      mreg_effected_map_table[4] <= 5'b0;
    end else if(mreg_effected_mapping_wen_1[4]) begin
      mreg_effected_map_table[4] <= {1'b1, mreg_effected_mapping_widx_1};
    end else if(mreg_effected_mapping_wen_0[4]) begin
      mreg_effected_map_table[4] <= {1'b1, mreg_effected_mapping_widx_0};
    end 
  end

  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_5
    if(~cpurst_b) begin
      mreg_effected_map_table[5] <= 5'b0;
    end else if(mreg_effected_mapping_wen_1[5]) begin
      mreg_effected_map_table[5] <= {1'b1, mreg_effected_mapping_widx_1};
    end else if(mreg_effected_mapping_wen_0[5]) begin
      mreg_effected_map_table[5] <= {1'b1, mreg_effected_mapping_widx_0};
    end 
  end

  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_6
    if(~cpurst_b) begin
      mreg_effected_map_table[6] <= 5'b0;
    end else if(mreg_effected_mapping_wen_1[6]) begin
      mreg_effected_map_table[6] <= {1'b1, mreg_effected_mapping_widx_1};
    end else if(mreg_effected_mapping_wen_0[6]) begin
      mreg_effected_map_table[6] <= {1'b1, mreg_effected_mapping_widx_0};
    end 
  end

  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_7
    if(~cpurst_b) begin
      mreg_effected_map_table[7] <= 5'b0;
    end else if(mreg_effected_mapping_wen_1[7]) begin
      mreg_effected_map_table[7] <= {1'b1, mreg_effected_mapping_widx_1};
    end else if(mreg_effected_mapping_wen_0[7]) begin
      mreg_effected_map_table[7] <= {1'b1, mreg_effected_mapping_widx_0};
    end 
  end


endmodule : mreg_effected_mapping