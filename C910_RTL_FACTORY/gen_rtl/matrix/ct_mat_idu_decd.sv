module ct_mat_idu_decd (
    input  [22:0] id_inst_m_data    
);

    // matrix basic decode information
    parameter M_DATA_IR_WIDTH = 23;
    parameter M_TYPE     = 22;
    parameter M_DST_X0   = 18;
    parameter M_DST_VLD  = 17;
    parameter M_DST_REG  = 16;
    parameter M_SRC0_VLD = 11;
    parameter M_SRC0_REG = 10;
    parameter M_SRC1_VLD = 5 ;
    parameter M_SRC1_REG = 4 ;

    // matrix decode type
    parameter MAT_TYPE_WIDTH = 4;
    parameter MAT_CAL = 4'b0001;
    parameter MAT_LSU = 4'b0010;
    parameter MAT_CFG = 4'b0100;
    parameter MAT_MOV = 4'b1000;

    logic [3:0] id_inst_m_inst_type;

    assign id_inst_m_inst_type[3:0] = id_inst_m_data[M_TYPE:M_TYPE-3];

    always_comb begin : proc_matrix_inst_decode_
        case (id_inst_m_inst_type)
            MAT_CAL : begin

            end

            default : /* default */;
        endcase
    end


endmodule : ct_mat_idu_decd