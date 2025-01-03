module ct_mat_exu_config_unit (
  /* common */
  input         cpurst_b                       ,
  input         forever_cpuclk                 ,
  /* from rf issue to CFG unit*/
  input         idu_mat_rf_cfg_sel             ,
  input         idu_mat_rf_cfg_gateclk_sel     ,
  input  [ 4:0] idu_mat_rf_pipe8_cfg_meta      ,
  input  [63:0] idu_mat_rf_pipe8_cfg_src0      ,
  /* output to LSU/ALU unit */
  output [15:0] x_sizeK                        ,
  output [ 7:0] x_sizeM                        ,
  output [ 7:0] x_sizeN                        ,
  /* write back to main pipeline GPR */
  output [63:0] mat_idu_ex1_cfg_wb_data        ,
  /* sync xmsize csr to main pipeline */
  output [63:0] mat_idu_ex1_cfg_sync_xmsize_csr
);

  parameter MAT_CFG_OP_TYPE_WIDTH = 4      ;
  parameter MAT_CFG_K             = 4'b0001;
  parameter MAT_CFG_M             = 4'b0010;
  parameter MAT_CFG_N             = 4'b0100;
  parameter MAT_CFG_ALL           = 4'b1000;

  parameter MAT_CFG_DATA_WIDTH    = 4;
  parameter MAT_CFG_OP            = 3; // 3:0

  parameter SIZE_K_WIDTH = 16;
  parameter SIZE_M_WIDTH = 8;
  parameter SIZE_N_WIDTH = 8;

  wire [ 3:0] mat_cfg_op   ;
  wire [63:0] mat_cfg_src0 ;
  wire        mat_cfg_sizeK;
  wire        mat_cfg_sizeM;
  wire        mat_cfg_sizeN;
  wire        mat_cfg_all  ;
  wire        sizeK_wen    ;
  wire        sizeM_wen    ;
  wire        sizeN_wen    ;
  wire [15:0] sizeK_wdata  ;
  wire [ 7:0] sizeM_wdata  ;
  wire [ 7:0] sizeN_wdata  ;

  reg [15:0] sizeK;
  reg [ 7:0] sizeM;
  reg [ 7:0] sizeN;
  
  wire [63:0] xmsize;

  /* --------------------------------------------------------------------- */
  /* ------------------------------ Matrix Cfg---------------------------- */
  /* --------------------------------------------------------------------- */
  assign mat_cfg_op[3:0]    = idu_mat_rf_pipe8_cfg_meta[MAT_CFG_OP:MAT_CFG_OP-3];
  assign mat_cfg_src0[63:0] = idu_mat_rf_pipe8_cfg_src0[63:0];
  
  assign mat_cfg_sizeK = mat_cfg_op[0];
  assign mat_cfg_sizeM = mat_cfg_op[1];
  assign mat_cfg_sizeN = mat_cfg_op[2];
  assign mat_cfg_all   = mat_cfg_op[3];

  assign sizeK_wen = mat_cfg_sizeK || mat_cfg_all; // MAT_CFG_K or MAT_CFG_ALL
  assign sizeM_wen = mat_cfg_sizeM || mat_cfg_all; // MAT_CFG_M or MAT_CFG_ALL
  assign sizeN_wen = mat_cfg_sizeN || mat_cfg_all; // MAT_CFG_N or MAT_CFG_ALL

  assign sizeK_wdata[15:0] =  
      ({SIZE_K_WIDTH{mat_cfg_sizeK}} & mat_cfg_src0[15:0])
    | ({SIZE_K_WIDTH{mat_cfg_all}}   & mat_cfg_src0[31:16]);

  assign sizeM_wdata[7:0] = 
      ({SIZE_M_WIDTH{mat_cfg_sizeM}} & mat_cfg_src0[7:0])
    | ({SIZE_M_WIDTH{mat_cfg_all}}   & mat_cfg_src0[7:0]);

  assign sizeN_wdata[7:0] = 
      ({SIZE_N_WIDTH{mat_cfg_sizeN}} & mat_cfg_src0[7:0]) 
    | ({SIZE_N_WIDTH{mat_cfg_all}}   & mat_cfg_src0[15:8]);    

  // TODO : gate clk
  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_configure_sizeK
    if(!cpurst_b) begin
      sizeK[SIZE_K_WIDTH-1:0] <= {SIZE_K_WIDTH{1'b0}};
    end 
    else if(sizeK_wen) begin
      sizeK[SIZE_K_WIDTH-1:0] <= sizeK_wdata[SIZE_K_WIDTH-1:0];
    end
  end

  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_configure_sizeM
    if(!cpurst_b) begin
      sizeM[SIZE_M_WIDTH-1:0] <= {SIZE_M_WIDTH{1'b0}};
    end 
    else if(sizeM_wen) begin
      sizeM[SIZE_M_WIDTH-1:0] <= sizeM_wdata[SIZE_M_WIDTH-1:0];
    end
  end

  always_ff @(posedge forever_cpuclk or negedge cpurst_b) begin : proc_configure_sizeN
    if(!cpurst_b) begin
      sizeN[SIZE_N_WIDTH-1:0] <= {SIZE_N_WIDTH{1'b0}};
    end 
    else if(sizeN_wen) begin
      sizeN[SIZE_N_WIDTH-1:0] <= sizeN_wdata[SIZE_N_WIDTH-1:0];
    end
  end

  assign x_sizeK[15:0] = sizeK[15:0];
  assign x_sizeM[ 7:0] = sizeM[ 7:0];
  assign x_sizeN[ 7:0] = sizeN[ 7:0];

  assign xmsize[63:0] = {32'd0, sizeK[15:0], sizeN[7:0], sizeM[7:0]};

  assign mat_idu_ex1_cfg_wb_data[63:0] = xmsize[63:0];
  assign mat_idu_ex1_cfg_sync_xmsize_csr[63:0] = xmsize[63:0];

endmodule : ct_mat_exu_config_unit