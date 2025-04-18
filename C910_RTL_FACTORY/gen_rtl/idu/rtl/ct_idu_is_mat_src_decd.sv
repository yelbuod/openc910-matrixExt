parameter MAT_SRC2M_VLD = 12;
parameter MAT_DSTM_VLD  = 11;
parameter MAT_DSTM_IDX  = 10; // 10:8
parameter MAT_SRC1M_VLD = 7 ;
parameter MAT_SRC1M_IDX = 6 ; // 6:4
parameter MAT_SRC0M_VLD = 3 ;
parameter MAT_SRC0M_IDX = 2 ; // 2:0

parameter MAT_CAL         = 4'b0001;
parameter MAT_LSU         = 4'b0010;
parameter MAT_CFG         = 4'b0100;
parameter MAT_SPECIAL_MOV = 4'b1000;

module ct_idu_is_mat_src_decd (
  input  [31:0] is_mat_decd_opcode,
  input  [ 3:0] is_mat_decd_type  ,
  output [12:0] is_mat_src_info   
);

  logic [3:0] id_inst_func;
  logic [2:0] id_inst_uop;
  logic [2:0] id_srcm_idx_20_18;
  logic [2:0] id_dstm_idx_17_15   ;
  logic [2:0] id_dstm_srcm_idx_9_7;

  logic       id_dstm_vld ;
  logic [2:0] id_dstm_idx ;
  logic       id_srcm0_vld;
  logic [2:0] id_srcm0_idx;
  logic       id_srcm1_vld;
  logic [2:0] id_srcm1_idx;
  logic       id_srcm2_vld;

  assign is_mat_src_info = {id_dstm_vld, id_dstm_idx, id_srcm0_vld, id_srcm0_idx,
  id_srcm1_vld, id_srcm1_idx, id_srcm2_vld};

  assign id_inst_func[3:0]     = is_mat_decd_opcode[31:28];
  assign id_inst_uop[2:0]      = is_mat_decd_opcode[27:25];
  assign id_inst_uop_0 = id_inst_uop[0];
  // alu dst or src2
  assign id_dstm_idx_17_15[2:0]  = is_mat_decd_opcode[17:15];
  assign id_srcm1_idx[2:0]       = is_mat_decd_opcode[23:21];
  assign id_srcm_idx_20_18[2:0] = is_mat_decd_opcode[20:18];
  // lsu dst or src2
  assign id_dstm_srcm_idx_9_7[2:0]    = is_mat_decd_opcode[9:7];

  always_comb begin
    case ({is_mat_decd_type, id_inst_uop_0})
      {MAT_CAL, 1'b0}: begin
        id_dstm_idx  = id_dstm_idx_17_15;
        id_dstm_vld  = 1'b1;
        id_srcm0_idx = id_srcm_idx_20_18;
        id_srcm0_vld = 1'b1;
        id_srcm1_vld = 1'b1;
      end
      {MAT_CAL, 1'b1}: begin
        id_dstm_idx  = id_dstm_idx_17_15;
        id_dstm_vld  = 1'b1;
        id_srcm0_idx = id_srcm_idx_20_18;
        id_srcm0_vld = 1'b1;
        id_srcm1_vld = 1'b1;
      end
      {MAT_LSU, 1'b0}: begin // load
        id_dstm_idx  = id_dstm_srcm_idx_9_7;
        id_dstm_vld  = 1'b1;
        id_srcm0_idx = 3'b0;
        id_srcm0_vld = 1'b0;
        id_srcm1_vld = 1'b0;
      end
      {MAT_LSU, 1'b1}: begin // store
        id_dstm_idx  = 3'b0;
        id_dstm_vld  = 1'b0;
        id_srcm0_idx = id_dstm_srcm_idx_9_7;
        id_srcm0_vld = 1'b1;
        id_srcm1_vld = 1'b0;
      end
      default : begin
        id_dstm_idx  = 3'd0;
        id_dstm_vld  = 1'b0;
        id_srcm0_idx = 3'b0;
        id_srcm0_vld = 1'b0;
        id_srcm1_vld = 1'b0;
      end
    endcase
  end

  always_comb begin
    if(is_mat_decd_type == MAT_CAL && 
       (id_inst_func == 4'b0001 || id_inst_func == 4'b0010)) begin
      id_srcm2_vld = 1'b1;
    end
    else 
      id_srcm2_vld = 1'b0;
  end

endmodule : ct_idu_is_mat_src_decd