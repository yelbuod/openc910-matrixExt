// matrix decode type
parameter MAT_TYPE_WIDTH  = 4      ;
parameter MAT_CAL         = 4'b0001;
parameter MAT_LSU         = 4'b0010;
parameter MAT_CFG         = 4'b0100;
parameter MAT_SPECIAL_MOV = 4'b1000;

// matrix op type
parameter MAT_OP_TYPE_WIDTH = 11;
// Calculation
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
// LSU
parameter MAT_LSU_OP_TYPE_WIDTH = 2    ;
parameter MAT_LSU_LOAD          = 2'b01;
parameter MAT_LSU_STORE         = 2'b10;
// CFG
parameter MAT_CFG_OP_TYPE_WIDTH = 4      ;
parameter MAT_CFG_K             = 4'b0001;
parameter MAT_CFG_M             = 4'b0010;
parameter MAT_CFG_N             = 4'b0100;
parameter MAT_CFG_ALL           = 4'b1000;

parameter MAT_ALU_DATA_WIDTH     = 31;
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

parameter MAT_LSU_DATA_WIDTH = 16;
parameter MAT_LSU_OP         = 15; // 15:14
parameter MAT_LSU_DSTM_VLD   = 13;
parameter MAT_LSU_DSTM_IDX   = 12; // 12:10
parameter MAT_LSU_SRC2M_VLD  = 9;
parameter MAT_LSU_SRC2M_IDX  = 8; // 8:6
parameter MAT_LSU_NF_VLD     = 5 ;
parameter MAT_LSU_NF         = 4 ; // 4:2
parameter MAT_LSU_ELM_WIDTH  = 1 ; // 1:0

parameter MAT_CFG_DATA_WIDTH = 4;
parameter MAT_CFG_OP         = 3; // 3:0

module ct_idu_rf_pipe8_mat_decd (
    input [31:0] pipe8_mat_decd_opcode  ,
    input [ 3:0] pipe8_mat_decd_type    ,
    output [MAT_ALU_DATA_WIDTH-1:0] pipe8_mat_alu_meta,
    output [MAT_LSU_DATA_WIDTH-1:0] pipe8_mat_lsu_meta,
    output [MAT_CFG_DATA_WIDTH-1:0] pipe8_mat_cfg_meta,
    output [6:0] pipe8_mat_decd_cfg_src0_uimm7
);

    logic [31:0] id_inst         ;
    logic [ 3:0] id_inst_mat_type;
    logic [ 3:0] id_inst_func    ;
    logic [ 2:0] id_inst_uop     ;
    logic        id_size         ;

    logic       id_dstm_17_15_vld ; // md 17:15 for arithmetic
    logic [2:0] id_dstm_idx_17_15 ; // md for arithmetic
    logic       id_dstm_9_7_vld   ; // md 9:7 for load
    logic [2:0] id_dstm_idx_9_7   ; // md for load
    logic       id_srcm0_vld      ; // ms1
    logic [2:0] id_srcm0_idx      ;
    logic       id_srcm1_vld      ; // ms2
    logic [2:0] id_srcm1_idx      ;
    logic       id_srcm2_vld      ; // ms3 for store
    logic [2:0] id_srcm2_idx      ;
    logic       id_uimm3_vld      ; // uimm3 (arithmetic)
    logic [2:0] id_uimm3          ;
    
    logic       id_nf_vld         ; // load/store instr 组合多个matrix reg一起load/store
    logic [2:0] id_nf             ; // 000/001/011/111 -> 1/2/4/8
    logic [1:0] id_elem_data_width; // 00/01/10/11 -> 8/16/32/64

    logic                         id_srcm0_unsigned; // 用于 int 类型位宽扩展
    logic                         id_srcm1_unsigned; // 用于 int 类型位宽扩展
    logic [MAT_OP_TYPE_WIDTH-1:0] id_mat_op        ; // 操作类型
    
    // use for decode
    assign id_inst[31:0]         = pipe8_mat_decd_opcode[31:0];
    assign id_inst_mat_type[3:0] = pipe8_mat_decd_type[3:0];
    assign id_inst_func[3:0]     = id_inst[31:28];
    assign id_inst_uop[2:0]      = id_inst[27:25];
    assign id_size               = id_inst[24];
    // information
    assign id_dstm_idx_17_15[2:0]  = id_inst[17:15];
    assign id_dstm_idx_9_7[2:0]    = id_inst[9:7];
    assign id_srcm0_idx[2:0]       = id_inst[20:18];
    assign id_srcm1_idx[2:0]       = id_inst[23:21];
    assign id_srcm2_idx[2:0]       = id_inst[9:7]; // ms3
    assign id_uimm3[2:0]           = id_inst[9:7];
    assign id_nf[2:0]              = id_inst[22:20];
    assign id_elem_data_width[1:0] = id_inst[11:10];

    assign pipe8_mat_decd_cfg_src0_uimm7[6:0] = id_inst[24:18];

    /* --------------------------------------------------------------------- */
    /* ------------------------------ Matrix Data--------------------------- */
    /* --------------------------------------------------------------------- */
    // ALU/LSU/CFG 三类指令不同的译码信息组合
    /* ---------------------------ALU--------------------------- */
    assign pipe8_mat_alu_meta[MAT_ALU_OP:MAT_ALU_OP-(MAT_ALU_OP_TYPE_WIDTH-1)] = id_mat_op[MAT_ALU_OP_TYPE_WIDTH-1:0];
    assign pipe8_mat_alu_meta[MAT_ALU_DSTM_VLD]                                = id_dstm_17_15_vld;
    assign pipe8_mat_alu_meta[MAT_ALU_DSTM_IDX:MAT_ALU_DSTM_IDX-2]             = id_dstm_idx_17_15[2:0];
    assign pipe8_mat_alu_meta[MAT_ALU_SRC1M_VLD]                               = id_srcm1_vld;
    assign pipe8_mat_alu_meta[MAT_ALU_SRC1M_UNSIGNED]                          = id_srcm1_unsigned;
    assign pipe8_mat_alu_meta[MAT_ALU_SRC1M_IDX:MAT_ALU_SRC1M_IDX-2]           = id_srcm1_idx[2:0];
    assign pipe8_mat_alu_meta[MAT_ALU_SRC0M_VLD]                               = id_srcm0_vld;
    assign pipe8_mat_alu_meta[MAT_ALU_SRC0M_UNSIGNED]                          = id_srcm0_unsigned;
    assign pipe8_mat_alu_meta[MAT_ALU_SRC0M_IDX:MAT_ALU_SRC0M_IDX-2]           = id_srcm0_idx[2:0];
    assign pipe8_mat_alu_meta[MAT_ALU_UIMM3_VLD]                               = id_uimm3_vld;
    assign pipe8_mat_alu_meta[MAT_ALU_UIMM3:MAT_ALU_UIMM3-2]                   = id_uimm3[2:0];
    assign pipe8_mat_alu_meta[MAT_ALU_ELM_WIDTH:MAT_ALU_ELM_WIDTH-1]           = id_elem_data_width[1:0];

    /* ---------------------------LSU--------------------------- */
    assign pipe8_mat_lsu_meta[MAT_LSU_OP:MAT_LSU_OP-(MAT_LSU_OP_TYPE_WIDTH-1)] = id_mat_op[MAT_LSU_OP_TYPE_WIDTH-1:0];
    assign pipe8_mat_lsu_meta[MAT_LSU_DSTM_VLD]                                = id_dstm_9_7_vld;
    assign pipe8_mat_lsu_meta[MAT_LSU_DSTM_IDX:MAT_LSU_DSTM_IDX-2]             = id_dstm_idx_9_7[2:0];
    assign pipe8_mat_lsu_meta[MAT_LSU_SRC2M_VLD]                               = id_srcm2_vld;
    assign pipe8_mat_lsu_meta[MAT_LSU_SRC2M_IDX:MAT_LSU_SRC2M_IDX-2]           = id_srcm2_idx[2:0];
    assign pipe8_mat_lsu_meta[MAT_LSU_NF_VLD]                                  = id_nf_vld;
    assign pipe8_mat_lsu_meta[MAT_LSU_NF:MAT_LSU_NF-2]                         = id_nf[2:0];
    assign pipe8_mat_lsu_meta[MAT_LSU_ELM_WIDTH:MAT_LSU_ELM_WIDTH-1]           = id_elem_data_width[1:0];

    /* ---------------------------CFG--------------------------- */
    assign pipe8_mat_cfg_meta[MAT_CFG_OP:MAT_CFG_OP-(MAT_CFG_OP_TYPE_WIDTH-1)] = id_mat_op[MAT_CFG_OP_TYPE_WIDTH-1:0];

    always_comb begin
        // uimm3位置信息被复用为1.立即数, 2.{p}mmaqa指令下两ms的有/无符号
        case (id_uimm3) // 后者仅在 {p}mmaqa 指令下使用, 因此无需进行指令类型的判断
            3'b000 : // both signed
                begin
                    id_srcm0_unsigned = 1'b0;
                    id_srcm1_unsigned = 1'b0;
                end
            3'b001 : // both unsigned
                begin
                    id_srcm0_unsigned = 1'b1;
                    id_srcm1_unsigned = 1'b1;
                end
            3'b010 : // unsigned - signed
                begin
                    id_srcm0_unsigned = 1'b1;
                    id_srcm1_unsigned = 1'b0;
                end
            3'b011 : // signed - unsigned
                begin
                    id_srcm0_unsigned = 1'b0;
                    id_srcm1_unsigned = 1'b1;
                end
            default :
                begin
                    id_srcm0_unsigned = 1'b0;
                    id_srcm1_unsigned = 1'b0;
                end
        endcase
    end

    always_comb begin : proc_matrix_inst_decode
        id_mat_op         = {MAT_OP_TYPE_WIDTH{1'b0}};
        id_dstm_17_15_vld = 1'b0;
        id_dstm_9_7_vld   = 1'b0;
        id_srcm0_vld      = 1'b0;
        id_srcm1_vld      = 1'b0;
        id_srcm2_vld      = 1'b0;
        id_uimm3_vld      = 1'b0;
        id_nf_vld         = 1'b0;
        case ({id_inst_mat_type, id_inst_func, id_inst_uop, id_size})
            {MAT_CAL, 4'b0000, 3'b000, 1'b0} : // mmov.mm
                begin
                    id_mat_op         = MAT_CAL_MMOV;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0000, 3'b001, 1'b0} : // mmov.mv.x
                begin
                    id_mat_op         = MAT_CAL_MMOV;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0000, 3'b010, 1'b0} : // mmov.mv.i
                begin
                    id_mat_op         = MAT_CAL_MMOV;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_uimm3_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0001, 3'b000, 1'b0} : // fmmacc.{h/s/d}
                begin
                    id_mat_op         = MAT_CAL_FMMACC;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0001, 3'b000, 1'b1} : // fwmmacc.{h/s} : widen to dest
                begin
                    id_mat_op         = MAT_CAL_FWMMACC;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0010, 3'b000, 1'b0} : // mmaqa/mmaqau/mmaqaus/mmaqasu.{b/h}
                // 两个source signed/unsigned属性由id_srcm0/1_unsigned信号得到,
                // src元素宽度b/h以及dest元素宽度由id_elem_data_width得到, 此处无需判断
                begin
                    id_mat_op         = MAT_CAL_MMAQA;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                end
            // Integer pointwise arithmetic instr: 元素宽度(s/d)由id_elem_data_width得到
            {MAT_CAL, 4'b0011, 3'b000, 1'b0} : // madd.{s/d}.mm
                begin
                    id_mat_op         = MAT_CAL_MADD;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0011, 3'b001, 1'b0} : // madd.{s/d}.mv.x
                begin
                    id_mat_op         = MAT_CAL_MADD;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1; // 后级电路结合srcm0 vld和src0 vld 可知是 mv.x 类型
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0011, 3'b010, 1'b0} : // madd.{s/d}.mv.i
                begin
                    id_mat_op         = MAT_CAL_MADD;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                    id_uimm3_vld      = 1'b1; // 后级电路结合srcm0 vld和uimm3 vld 可知是 mv.i 类型
                end
            {MAT_CAL, 4'b0011, 3'b011, 1'b0} : // madd.{s/d}.mx
                begin
                    id_mat_op         = MAT_CAL_MADD;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b0; // 后级电路结合srcm0 vld(==0)和src0 vld 可知是 mx 类型
                    id_srcm1_vld      = 1'b1;
                end

            {MAT_CAL, 4'b0100, 3'b000, 1'b0} : // msub.{s/d}.mm
                begin
                    id_mat_op         = MAT_CAL_MSUB;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0100, 3'b001, 1'b0} : // msub.{s/d}.mv.x
                begin
                    id_mat_op         = MAT_CAL_MSUB;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1; // 后级电路结合srcm0 vld和src0 vld 可知是 mv.x 类型
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0100, 3'b010, 1'b0} : // msub.{s/d}.mv.i
                begin
                    id_mat_op         = MAT_CAL_MSUB;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                    id_uimm3_vld      = 1'b1; // 后级电路结合srcm0 vld和uimm3 vld 可知是 mv.i 类型
                end
            {MAT_CAL, 4'b0100, 3'b011, 1'b0} : // msub.{s/d}.mx
                begin
                    id_mat_op         = MAT_CAL_MSUB;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b0; // 后级电路结合srcm0 vld(==0)和src0 vld 可知是 mx 类型
                    id_srcm1_vld      = 1'b1;
                end

            {MAT_CAL, 4'b0101, 3'b000, 1'b0} : // msra.{s/d}.mm
                begin
                    id_mat_op         = MAT_CAL_MSRA;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0101, 3'b001, 1'b0} : // msra.{s/d}.mv.x
                begin
                    id_mat_op         = MAT_CAL_MSRA;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1; // 后级电路结合srcm0 vld和src0 vld 可知是 mv.x 类型
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0101, 3'b010, 1'b0} : // msra.{s/d}.mv.i
                begin
                    id_mat_op         = MAT_CAL_MSRA;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                    id_uimm3_vld      = 1'b1; // 后级电路结合srcm0 vld和uimm3 vld 可知是 mv.i 类型
                end
            {MAT_CAL, 4'b0101, 3'b011, 1'b0} : // msra.{s/d}.mx
                begin
                    id_mat_op         = MAT_CAL_MSRA;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b0; // 后级电路结合srcm0 vld(==0)和src0 vld 可知是 mx 类型
                    id_srcm1_vld      = 1'b1;
                end

            {MAT_CAL, 4'b0110, 3'b000, 1'b0} : // mn4clip.{s/d}.mm
                begin
                    id_mat_op         = MAT_CAL_MN4CLIP;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0110, 3'b001, 1'b0} : // mn4clip.{s/d}.mv.x
                begin
                    id_mat_op         = MAT_CAL_MN4CLIP;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1; // 后级电路结合srcm0 vld和src0 vld 可知是 mv.x 类型
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0110, 3'b010, 1'b0} : // mn4clip.{s/d}.mv.i
                begin
                    id_mat_op         = MAT_CAL_MN4CLIP;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                    id_uimm3_vld      = 1'b1; // 后级电路结合srcm0 vld和uimm3 vld 可知是 mv.i 类型
                end
            {MAT_CAL, 4'b0110, 3'b011, 1'b0} : // mn4clip.{s/d}.mx
                begin
                    id_mat_op         = MAT_CAL_MN4CLIP;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b0; // 后级电路结合srcm0 vld(==0)和src0 vld 可知是 mx 类型
                    id_srcm1_vld      = 1'b1;
                end

            {MAT_CAL, 4'b0111, 3'b000, 1'b0} : // mn4clipu.{s/d}.mm
                begin
                    id_mat_op         = MAT_CAL_MN4CLIPU;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0111, 3'b001, 1'b0} : // mn4clipu.{s/d}.mv.x
                begin
                    id_mat_op         = MAT_CAL_MN4CLIPU;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1; // 后级电路结合srcm0 vld和src0 vld 可知是 mv.x 类型
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b0111, 3'b010, 1'b0} : // mn4clipu.{s/d}.mv.i
                begin
                    id_mat_op         = MAT_CAL_MN4CLIPU;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                    id_uimm3_vld      = 1'b1; // 后级电路结合srcm0 vld和uimm3 vld 可知是 mv.i 类型
                end
            {MAT_CAL, 4'b0111, 3'b011, 1'b0} : // mn4clipu.{s/d}.mx
                begin
                    id_mat_op         = MAT_CAL_MN4CLIPU;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b0; // 后级电路结合srcm0 vld(==0)和src0 vld 可知是 mx 类型
                    id_srcm1_vld      = 1'b1;
                end

            {MAT_CAL, 4'b1000, 3'b000, 1'b0} : // mmul.{s/d}.mm
                begin
                    id_mat_op         = MAT_CAL_MMUL;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b1000, 3'b001, 1'b0} : // mmul.{s/d}.mv.x
                begin
                    id_mat_op         = MAT_CAL_MMUL;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1; // 后级电路结合srcm0 vld和src0 vld 可知是 mv.x 类型
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b1000, 3'b010, 1'b0} : // mmul.{s/d}.mv.i
                begin
                    id_mat_op         = MAT_CAL_MMUL;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                    id_uimm3_vld      = 1'b1; // 后级电路结合srcm0 vld和uimm3 vld 可知是 mv.i 类型
                end
            {MAT_CAL, 4'b1000, 3'b011, 1'b0} : // mmul.{s/d}.mx
                begin
                    id_mat_op         = MAT_CAL_MMUL;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b0; // 后级电路结合srcm0 vld(==0)和src0 vld 可知是 mx 类型
                    id_srcm1_vld      = 1'b1;
                end

            {MAT_CAL, 4'b1001, 3'b000, 1'b0} : // mmulh.{s/d}.mm
                begin
                    id_mat_op         = MAT_CAL_MMULH;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b1001, 3'b001, 1'b0} : // mmulh.{s/d}.mv.x
                begin
                    id_mat_op         = MAT_CAL_MMULH;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1; // 后级电路结合srcm0 vld和src0 vld 可知是 mv.x 类型
                    id_srcm1_vld      = 1'b1;
                end
            {MAT_CAL, 4'b1001, 3'b010, 1'b0} : // mmulh.{s/d}.mv.i
                begin
                    id_mat_op         = MAT_CAL_MMULH;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b1;
                    id_srcm1_vld      = 1'b1;
                    id_uimm3_vld      = 1'b1; // 后级电路结合srcm0 vld和uimm3 vld 可知是 mv.i 类型
                end
            {MAT_CAL, 4'b1001, 3'b011, 1'b0} : // mmulh.{s/d}.mx
                begin
                    id_mat_op         = MAT_CAL_MMULH;
                    id_dstm_17_15_vld = 1'b1;
                    id_srcm0_vld      = 1'b0; // 后级电路结合srcm0 vld(==0)和src0 vld 可知是 mx 类型
                    id_srcm1_vld      = 1'b1;
                end

            // LSU
            {MAT_LSU, 4'b0000, 3'b100, 1'b?} : // mld{b/h/w/d} : 由id_elem_data_width决定元素宽度进而决定从内存load的数据量和访存方式
                begin
                    id_mat_op       = MAT_LSU_LOAD;
                    id_dstm_9_7_vld = 1'b1;
                    // id_nf_vld       = 1'b0; // 标识非整个寄存器load
                end
            {MAT_LSU, 4'b0000, 3'b101, 1'b?} : // mst{b/h/w/d}
                begin
                    id_mat_op    = MAT_LSU_STORE;
                    id_srcm2_vld = 1'b1;
                    // id_nf_vld    = 1'b0; // 标识非整个寄存器store
                end
            {MAT_LSU, 4'b0010, 3'b100, 1'b0} : // mld{1/2/4/8}m : 由nf决定需要total load的寄存器数量
                begin
                    id_mat_op       = MAT_LSU_LOAD;
                    id_dstm_9_7_vld = 1'b1;
                    id_nf_vld       = 1'b1;
                end
            {MAT_LSU, 4'b0010, 3'b101, 1'b0} : // mst{1/2/4/8}m : 由nf决定需要total store的寄存器数量
                begin
                    id_mat_op    = MAT_LSU_STORE;
                    id_srcm2_vld = 1'b1;
                    id_nf_vld    = 1'b1;
                end

            // CFG
            {MAT_CFG, 4'b?000, 3'b111, 1'b?} : // mcfgk{i} : 使用立即数或GPR由src0 vld决定
                begin
                    id_mat_op    = MAT_CFG_K;
                end
            {MAT_CFG, 4'b?001, 3'b111, 1'b?} : // mcfgm{i} : 使用立即数或GPR由src0 vld决定
                begin
                    id_mat_op    = MAT_CFG_M;
                end
            {MAT_CFG, 4'b?010, 3'b111, 1'b?} : // mcfgn{i} : 使用立即数或GPR由src0 vld决定
                begin
                    id_mat_op    = MAT_CFG_N;
                end
            {MAT_CFG, 4'b1111, 3'b111, 1'b0} : // mcfg : 使用GPR配置xmsize M/N/K三个参数
                begin
                    id_mat_op = MAT_CFG_ALL;
                end
            default : /* default */;
        endcase
    end


endmodule : ct_idu_rf_pipe8_mat_decd