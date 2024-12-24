module ct_idu_is_miq(
  miq_aiq_create0_entry,
  miq_aiq_create1_entry,
  miq_ctrl_1_left_updt,
  miq_ctrl_empty,
  miq_ctrl_full,
  miq_ctrl_full_updt,
  miq_ctrl_full_updt_clk_en,
  miq_dp_issue_entry,
  miq_dp_issue_read_data,
  miq_top_miq_entry_cnt,
  miq_xx_gateclk_issue_en,
  miq_xx_issue_en,
  cp0_idu_icg_en,
  cp0_idu_iq_bypass_disable,
  cp0_yy_clk_en,
  cpurst_b,
  ctrl_miq_create0_dp_en,
  ctrl_miq_create0_en,
  ctrl_miq_create0_gateclk_en,
  ctrl_miq_create1_dp_en,
  ctrl_miq_create1_en,
  ctrl_miq_create1_gateclk_en,
  ctrl_miq_rf_lch_fail_vld,
  ctrl_miq_rf_pipe0_alu_reg_fwd_vld,
  ctrl_miq_rf_pipe1_alu_reg_fwd_vld,
  ctrl_miq_rf_pop_vld,
  ctrl_xx_rf_pipe0_preg_lch_vld_dupx,
  ctrl_xx_rf_pipe1_preg_lch_vld_dupx,
  dp_miq_bypass_data,
  dp_miq_create0_data,
  dp_miq_create1_data,
  dp_miq_create_src0_rdy_for_bypass,
  dp_miq_create_src1_rdy_for_bypass,
  dp_miq_rf_lch_entry,
  dp_miq_rf_rdy_clr,
  dp_xx_rf_pipe0_dst_preg_dupx,
  dp_xx_rf_pipe1_dst_preg_dupx,
  forever_cpuclk,
  iu_idu_div_inst_vld,
  iu_idu_div_preg_dupx,
  iu_idu_ex2_pipe0_wb_preg_dupx,
  iu_idu_ex2_pipe0_wb_preg_vld_dupx,
  iu_idu_ex2_pipe1_mult_inst_vld_dupx,
  iu_idu_ex2_pipe1_preg_dupx,
  iu_idu_ex2_pipe1_wb_preg_dupx,
  iu_idu_ex2_pipe1_wb_preg_vld_dupx,
  lsu_idu_ag_pipe3_load_inst_vld,
  lsu_idu_ag_pipe3_preg_dupx,
  lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx,
  lsu_idu_dc_pipe3_load_inst_vld_dupx,
  lsu_idu_dc_pipe3_preg_dupx,
  lsu_idu_wb_pipe3_wb_preg_dupx,
  lsu_idu_wb_pipe3_wb_preg_vld_dupx,
  pad_yy_icg_scan_en,
  rtu_idu_flush_fe,
  rtu_idu_flush_is,
  rtu_yy_xx_flush,
  vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx,
  vfpu_idu_ex1_pipe6_preg_dupx,
  vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx,
  vfpu_idu_ex1_pipe7_preg_dupx
);

// &Ports; @28
input            cp0_idu_icg_en;                         
input            cp0_idu_iq_bypass_disable;              
input            cp0_yy_clk_en;                          
input            cpurst_b;                               
input            ctrl_miq_create0_dp_en;                 
input            ctrl_miq_create0_en;                    
input            ctrl_miq_create0_gateclk_en;            
input            ctrl_miq_create1_dp_en;                 
input            ctrl_miq_create1_en;                    
input            ctrl_miq_create1_gateclk_en;            
input            ctrl_miq_rf_lch_fail_vld;               
input   [23 :0]  ctrl_miq_rf_pipe0_alu_reg_fwd_vld;      
input   [23 :0]  ctrl_miq_rf_pipe1_alu_reg_fwd_vld;      
input            ctrl_miq_rf_pop_vld;                    
input            ctrl_xx_rf_pipe0_preg_lch_vld_dupx;     
input            ctrl_xx_rf_pipe1_preg_lch_vld_dupx;     
input   [72 :0]  dp_miq_bypass_data;                     
input   [72 :0]  dp_miq_create0_data;                    
input   [72 :0]  dp_miq_create1_data;                    
input            dp_miq_create_src0_rdy_for_bypass;      
input            dp_miq_create_src1_rdy_for_bypass;      
input   [11 :0]  dp_miq_rf_lch_entry;                    
input   [1  :0]  dp_miq_rf_rdy_clr;                      
input   [6  :0]  dp_xx_rf_pipe0_dst_preg_dupx;           
input   [6  :0]  dp_xx_rf_pipe1_dst_preg_dupx;           
input            forever_cpuclk;                         
input            iu_idu_div_inst_vld;                    
input   [6  :0]  iu_idu_div_preg_dupx;                   
input   [6  :0]  iu_idu_ex2_pipe0_wb_preg_dupx;          
input            iu_idu_ex2_pipe0_wb_preg_vld_dupx;      
input            iu_idu_ex2_pipe1_mult_inst_vld_dupx;    
input   [6  :0]  iu_idu_ex2_pipe1_preg_dupx;             
input   [6  :0]  iu_idu_ex2_pipe1_wb_preg_dupx;          
input            iu_idu_ex2_pipe1_wb_preg_vld_dupx;      
input            lsu_idu_ag_pipe3_load_inst_vld;         
input   [6  :0]  lsu_idu_ag_pipe3_preg_dupx;             
input            lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx; 
input            lsu_idu_dc_pipe3_load_inst_vld_dupx;    
input   [6  :0]  lsu_idu_dc_pipe3_preg_dupx;             
input   [6  :0]  lsu_idu_wb_pipe3_wb_preg_dupx;          
input            lsu_idu_wb_pipe3_wb_preg_vld_dupx;      
input            pad_yy_icg_scan_en;                     
input            rtu_idu_flush_fe;                       
input            rtu_idu_flush_is;                       
input            rtu_yy_xx_flush;                        
input            vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx;  
input   [6  :0]  vfpu_idu_ex1_pipe6_preg_dupx;           
input            vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx;  
input   [6  :0]  vfpu_idu_ex1_pipe7_preg_dupx;           
output  [11 :0]  miq_aiq_create0_entry;                  
output  [11 :0]  miq_aiq_create1_entry;                  
output           miq_ctrl_1_left_updt;                   
output           miq_ctrl_empty;                         
output           miq_ctrl_full;                          
output           miq_ctrl_full_updt;                     
output           miq_ctrl_full_updt_clk_en;              
output  [11 :0]  miq_dp_issue_entry;                     
output  [72 :0]  miq_dp_issue_read_data;                 
output  [3  :0]  miq_top_miq_entry_cnt;                  
output           miq_xx_gateclk_issue_en;                
output           miq_xx_issue_en;                        

reg [ 10:0] miq_entry0_create_agevec ;
reg [ 72:0] miq_entry0_create_data   ;
reg         miq_entry0_create_frz    ;
reg [ 10:0] miq_entry10_create_agevec;
reg [ 72:0] miq_entry10_create_data  ;
reg         miq_entry10_create_frz   ;
reg [ 10:0] miq_entry11_create_agevec;
reg [ 72:0] miq_entry11_create_data  ;
reg         miq_entry11_create_frz   ;
reg [ 10:0] miq_entry1_create_agevec ;
reg [ 72:0] miq_entry1_create_data   ;
reg         miq_entry1_create_frz    ;
reg [ 10:0] miq_entry2_create_agevec ;
reg [ 72:0] miq_entry2_create_data   ;
reg         miq_entry2_create_frz    ;
reg [ 10:0] miq_entry3_create_agevec ;
reg [ 72:0] miq_entry3_create_data   ;
reg         miq_entry3_create_frz    ;
reg [ 10:0] miq_entry4_create_agevec ;
reg [ 72:0] miq_entry4_create_data   ;
reg         miq_entry4_create_frz    ;
reg [ 10:0] miq_entry5_create_agevec ;
reg [ 72:0] miq_entry5_create_data   ;
reg         miq_entry5_create_frz    ;
reg [ 10:0] miq_entry6_create_agevec ;
reg [ 72:0] miq_entry6_create_data   ;
reg         miq_entry6_create_frz    ;
reg [ 10:0] miq_entry7_create_agevec ;
reg [ 72:0] miq_entry7_create_data   ;
reg         miq_entry7_create_frz    ;
reg [ 10:0] miq_entry8_create_agevec ;
reg [ 72:0] miq_entry8_create_data   ;
reg         miq_entry8_create_frz    ;
reg [ 10:0] miq_entry9_create_agevec ;
reg [ 72:0] miq_entry9_create_data   ;
reg         miq_entry9_create_frz    ;
reg [  3:0] miq_entry_cnt            ;
reg [ 11:0] miq_entry_create0_in     ;
reg [ 11:0] miq_entry_create1_in     ;
reg [ 72:0] miq_entry_read_data      ;

wire    [11 :0]  miq_aiq_create0_entry;                  
wire    [11 :0]  miq_aiq_create1_entry;                  
wire             miq_bypass_dp_en;                       
wire             miq_bypass_en;                          
wire             miq_bypass_gateclk_en;                  
wire             miq_create0_rdy_bypass;                 
wire             miq_create0_rdy_bypass_dp;              
wire             miq_create0_rdy_bypass_gateclk;         
wire             miq_create_bypass_empty;                
wire             miq_ctrl_1_left_updt;                   
wire             miq_ctrl_empty;                         
wire             miq_ctrl_full;                          
wire             miq_ctrl_full_updt;                     
wire             miq_ctrl_full_updt_clk_en;              
wire    [11 :0]  miq_dp_issue_entry;                     
wire    [72 :0]  miq_dp_issue_read_data;                 
wire    [10 :0]  miq_entry0_agevec;                      
wire    [1  :0]  miq_entry0_alu0_reg_fwd_vld;            
wire    [1  :0]  miq_entry0_alu1_reg_fwd_vld;            
wire             miq_entry0_create_dp_en;                
wire             miq_entry0_create_en;                   
wire             miq_entry0_create_gateclk_en;           
wire             miq_entry0_frz_clr;                     
wire             miq_entry0_issue_en;                    
wire             miq_entry0_pop_cur_entry;               
wire    [10 :0]  miq_entry0_pop_other_entry;             
wire             miq_entry0_rdy;                         
wire    [72 :0]  miq_entry0_read_data;                   
wire             miq_entry0_vld;                         
wire             miq_entry0_vld_with_frz;                
wire    [10 :0]  miq_entry10_agevec;                     
wire    [1  :0]  miq_entry10_alu0_reg_fwd_vld;           
wire    [1  :0]  miq_entry10_alu1_reg_fwd_vld;           
wire             miq_entry10_create_dp_en;               
wire             miq_entry10_create_en;                  
wire             miq_entry10_create_gateclk_en;          
wire             miq_entry10_frz_clr;                    
wire             miq_entry10_issue_en;                   
wire             miq_entry10_pop_cur_entry;              
wire    [10 :0]  miq_entry10_pop_other_entry;            
wire             miq_entry10_rdy;                        
wire    [72 :0]  miq_entry10_read_data;                  
wire             miq_entry10_vld;                        
wire             miq_entry10_vld_with_frz;               
wire    [10 :0]  miq_entry11_agevec;                     
wire    [1  :0]  miq_entry11_alu0_reg_fwd_vld;           
wire    [1  :0]  miq_entry11_alu1_reg_fwd_vld;           
wire             miq_entry11_create_dp_en;               
wire             miq_entry11_create_en;                  
wire             miq_entry11_create_gateclk_en;          
wire             miq_entry11_frz_clr;                    
wire             miq_entry11_issue_en;                   
wire             miq_entry11_pop_cur_entry;              
wire    [10 :0]  miq_entry11_pop_other_entry;            
wire             miq_entry11_rdy;                        
wire    [72 :0]  miq_entry11_read_data;                  
wire             miq_entry11_vld;                        
wire             miq_entry11_vld_with_frz;               
wire    [10 :0]  miq_entry1_agevec;                      
wire    [1  :0]  miq_entry1_alu0_reg_fwd_vld;            
wire    [1  :0]  miq_entry1_alu1_reg_fwd_vld;            
wire             miq_entry1_create_dp_en;                
wire             miq_entry1_create_en;                   
wire             miq_entry1_create_gateclk_en;           
wire             miq_entry1_frz_clr;                     
wire             miq_entry1_issue_en;                    
wire             miq_entry1_pop_cur_entry;               
wire    [10 :0]  miq_entry1_pop_other_entry;             
wire             miq_entry1_rdy;                         
wire    [72 :0]  miq_entry1_read_data;                   
wire             miq_entry1_vld;                         
wire             miq_entry1_vld_with_frz;                
wire    [10 :0]  miq_entry2_agevec;                      
wire    [1  :0]  miq_entry2_alu0_reg_fwd_vld;            
wire    [1  :0]  miq_entry2_alu1_reg_fwd_vld;            
wire             miq_entry2_create_dp_en;                
wire             miq_entry2_create_en;                   
wire             miq_entry2_create_gateclk_en;           
wire             miq_entry2_frz_clr;                     
wire             miq_entry2_issue_en;                    
wire             miq_entry2_pop_cur_entry;               
wire    [10 :0]  miq_entry2_pop_other_entry;             
wire             miq_entry2_rdy;                         
wire    [72 :0]  miq_entry2_read_data;                   
wire             miq_entry2_vld;                         
wire             miq_entry2_vld_with_frz;                
wire    [10 :0]  miq_entry3_agevec;                      
wire    [1  :0]  miq_entry3_alu0_reg_fwd_vld;            
wire    [1  :0]  miq_entry3_alu1_reg_fwd_vld;            
wire             miq_entry3_create_dp_en;                
wire             miq_entry3_create_en;                   
wire             miq_entry3_create_gateclk_en;           
wire             miq_entry3_frz_clr;                     
wire             miq_entry3_issue_en;                    
wire             miq_entry3_pop_cur_entry;               
wire    [10 :0]  miq_entry3_pop_other_entry;             
wire             miq_entry3_rdy;                         
wire    [72 :0]  miq_entry3_read_data;                   
wire             miq_entry3_vld;                         
wire             miq_entry3_vld_with_frz;                
wire    [10 :0]  miq_entry4_agevec;                      
wire    [1  :0]  miq_entry4_alu0_reg_fwd_vld;            
wire    [1  :0]  miq_entry4_alu1_reg_fwd_vld;            
wire             miq_entry4_create_dp_en;                
wire             miq_entry4_create_en;                   
wire             miq_entry4_create_gateclk_en;           
wire             miq_entry4_frz_clr;                     
wire             miq_entry4_issue_en;                    
wire             miq_entry4_pop_cur_entry;               
wire    [10 :0]  miq_entry4_pop_other_entry;             
wire             miq_entry4_rdy;                         
wire    [72 :0]  miq_entry4_read_data;                   
wire             miq_entry4_vld;                         
wire             miq_entry4_vld_with_frz;                
wire    [10 :0]  miq_entry5_agevec;                      
wire    [1  :0]  miq_entry5_alu0_reg_fwd_vld;            
wire    [1  :0]  miq_entry5_alu1_reg_fwd_vld;            
wire             miq_entry5_create_dp_en;                
wire             miq_entry5_create_en;                   
wire             miq_entry5_create_gateclk_en;           
wire             miq_entry5_frz_clr;                     
wire             miq_entry5_issue_en;                    
wire             miq_entry5_pop_cur_entry;               
wire    [10 :0]  miq_entry5_pop_other_entry;             
wire             miq_entry5_rdy;                         
wire    [72 :0]  miq_entry5_read_data;                   
wire             miq_entry5_vld;                         
wire             miq_entry5_vld_with_frz;                
wire    [10 :0]  miq_entry6_agevec;                      
wire    [1  :0]  miq_entry6_alu0_reg_fwd_vld;            
wire    [1  :0]  miq_entry6_alu1_reg_fwd_vld;            
wire             miq_entry6_create_dp_en;                
wire             miq_entry6_create_en;                   
wire             miq_entry6_create_gateclk_en;           
wire             miq_entry6_frz_clr;                     
wire             miq_entry6_issue_en;                    
wire             miq_entry6_pop_cur_entry;               
wire    [10 :0]  miq_entry6_pop_other_entry;             
wire             miq_entry6_rdy;                         
wire    [72 :0]  miq_entry6_read_data;                   
wire             miq_entry6_vld;                         
wire             miq_entry6_vld_with_frz;                
wire    [10 :0]  miq_entry7_agevec;                      
wire    [1  :0]  miq_entry7_alu0_reg_fwd_vld;            
wire    [1  :0]  miq_entry7_alu1_reg_fwd_vld;            
wire             miq_entry7_create_dp_en;                
wire             miq_entry7_create_en;                   
wire             miq_entry7_create_gateclk_en;           
wire             miq_entry7_frz_clr;                     
wire             miq_entry7_issue_en;                    
wire             miq_entry7_pop_cur_entry;               
wire    [10 :0]  miq_entry7_pop_other_entry;             
wire             miq_entry7_rdy;                         
wire    [72 :0]  miq_entry7_read_data;                   
wire             miq_entry7_vld;                         
wire             miq_entry7_vld_with_frz;                
wire    [10 :0]  miq_entry8_agevec;                      
wire    [1  :0]  miq_entry8_alu0_reg_fwd_vld;            
wire    [1  :0]  miq_entry8_alu1_reg_fwd_vld;            
wire             miq_entry8_create_dp_en;                
wire             miq_entry8_create_en;                   
wire             miq_entry8_create_gateclk_en;           
wire             miq_entry8_frz_clr;                     
wire             miq_entry8_issue_en;                    
wire             miq_entry8_pop_cur_entry;               
wire    [10 :0]  miq_entry8_pop_other_entry;             
wire             miq_entry8_rdy;                         
wire    [72 :0]  miq_entry8_read_data;                   
wire             miq_entry8_vld;                         
wire             miq_entry8_vld_with_frz;                
wire    [10 :0]  miq_entry9_agevec;                      
wire    [1  :0]  miq_entry9_alu0_reg_fwd_vld;            
wire    [1  :0]  miq_entry9_alu1_reg_fwd_vld;            
wire             miq_entry9_create_dp_en;                
wire             miq_entry9_create_en;                   
wire             miq_entry9_create_gateclk_en;           
wire             miq_entry9_frz_clr;                     
wire             miq_entry9_issue_en;                    
wire             miq_entry9_pop_cur_entry;               
wire    [10 :0]  miq_entry9_pop_other_entry;             
wire             miq_entry9_rdy;                         
wire    [72 :0]  miq_entry9_read_data;                   
wire             miq_entry9_vld;                         
wire             miq_entry9_vld_with_frz;                
wire    [3  :0]  miq_entry_cnt_create;                   
wire             miq_entry_cnt_create_0;                 
wire             miq_entry_cnt_create_1;                 
wire             miq_entry_cnt_create_2;                 
wire             miq_entry_cnt_pop_0;                    
wire             miq_entry_cnt_pop_1;                    
wire    [3  :0]  miq_entry_cnt_updt_val;                 
wire             miq_entry_cnt_updt_vld;                 
wire    [11 :0]  miq_entry_create0_agevec;               
wire    [11 :0]  miq_entry_create1_agevec;               
wire    [11 :0]  miq_entry_create_dp_en;                 
wire    [11 :0]  miq_entry_create_en;                    
wire    [11 :0]  miq_entry_create_gateclk_en;            
wire    [11 :0]  miq_entry_create_sel;                   
wire    [11 :0]  miq_entry_issue_en;                     
wire    [11 :0]  miq_entry_ready;                        
wire    [11 :0]  miq_entry_vld;                          
wire    [11 :0]  miq_older_entry_ready;                  
wire    [3  :0]  miq_top_miq_entry_cnt;                  
wire             miq_xx_gateclk_issue_en;                
wire             miq_xx_issue_en;                        
wire             cnt_clk;                                
wire             cnt_clk_en;                             
wire             cp0_idu_icg_en;                         
wire             cp0_idu_iq_bypass_disable;              
wire             cp0_yy_clk_en;                          
wire             cpurst_b;                               
wire             ctrl_miq_create0_dp_en;                 
wire             ctrl_miq_create0_en;                    
wire             ctrl_miq_create0_gateclk_en;            
wire             ctrl_miq_create1_dp_en;                 
wire             ctrl_miq_create1_en;                    
wire             ctrl_miq_create1_gateclk_en;            
wire             ctrl_miq_rf_lch_fail_vld;               
wire    [23 :0]  ctrl_miq_rf_pipe0_alu_reg_fwd_vld;      
wire    [23 :0]  ctrl_miq_rf_pipe1_alu_reg_fwd_vld;      
wire             ctrl_miq_rf_pop_vld;                    
wire             ctrl_xx_rf_pipe0_preg_lch_vld_dupx;     
wire             ctrl_xx_rf_pipe1_preg_lch_vld_dupx;     
wire    [72 :0]  dp_miq_bypass_data;                     
wire    [72 :0]  dp_miq_create0_data;                    
wire    [72 :0]  dp_miq_create1_data;                    
wire             dp_miq_create_src0_rdy_for_bypass;      
wire             dp_miq_create_src1_rdy_for_bypass;      
wire    [11 :0]  dp_miq_rf_lch_entry;                    
wire    [1  :0]  dp_miq_rf_rdy_clr;                      
wire    [6  :0]  dp_xx_rf_pipe0_dst_preg_dupx;           
wire    [6  :0]  dp_xx_rf_pipe1_dst_preg_dupx;           
wire             forever_cpuclk;                         
wire             iu_idu_div_inst_vld;                    
wire    [6  :0]  iu_idu_div_preg_dupx;                   
wire    [6  :0]  iu_idu_ex2_pipe0_wb_preg_dupx;          
wire             iu_idu_ex2_pipe0_wb_preg_vld_dupx;      
wire             iu_idu_ex2_pipe1_mult_inst_vld_dupx;    
wire    [6  :0]  iu_idu_ex2_pipe1_preg_dupx;             
wire    [6  :0]  iu_idu_ex2_pipe1_wb_preg_dupx;          
wire             iu_idu_ex2_pipe1_wb_preg_vld_dupx;      
wire             lsu_idu_ag_pipe3_load_inst_vld;         
wire    [6  :0]  lsu_idu_ag_pipe3_preg_dupx;             
wire             lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx; 
wire             lsu_idu_dc_pipe3_load_inst_vld_dupx;    
wire    [6  :0]  lsu_idu_dc_pipe3_preg_dupx;             
wire    [6  :0]  lsu_idu_wb_pipe3_wb_preg_dupx;          
wire             lsu_idu_wb_pipe3_wb_preg_vld_dupx;      
wire             pad_yy_icg_scan_en;                     
wire             rtu_idu_flush_fe;                       
wire             rtu_idu_flush_is;                       
wire             rtu_yy_xx_flush;                        
wire             vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx;  
wire    [6  :0]  vfpu_idu_ex1_pipe6_preg_dupx;           
wire             vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx;  
wire    [6  :0]  vfpu_idu_ex1_pipe7_preg_dupx;           


parameter MIQ_WIDTH             = 73;

//==========================================================
//            Branch Issue Queue Create Control
//==========================================================
//-------------------gated cell instance--------------------
assign cnt_clk_en = (miq_entry_cnt[3:0] != 4'b0)
                    || ctrl_miq_create0_gateclk_en
                    || ctrl_miq_create1_gateclk_en;
// &Instance("gated_clk_cell", "x_cnt_gated_clk"); @41
gated_clk_cell  x_cnt_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (cnt_clk           ),
  .external_en        (1'b0              ),
  .global_en          (cp0_yy_clk_en     ),
  .local_en           (cnt_clk_en        ),
  .module_en          (cp0_idu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in      (forever_cpuclk), @42
//          .external_en (1'b0), @43
//          .global_en   (cp0_yy_clk_en), @44
//          .module_en   (cp0_idu_icg_en), @45
//          .local_en    (cnt_clk_en), @46
//          .clk_out     (cnt_clk)); @47

assign miq_ctrl_full_updt_clk_en = cnt_clk_en;

//--------------------miq entry counter--------------------
//if create, add entry counter
assign miq_entry_cnt_create[3:0]   = {3'b0,ctrl_miq_create0_en}
                                     + {3'b0,ctrl_miq_create1_en};
//update valid and value
assign miq_entry_cnt_updt_vld      = ctrl_miq_create0_en
                                     || ctrl_miq_rf_pop_vld;
assign miq_entry_cnt_updt_val[3:0] = miq_entry_cnt[3:0]
                                     + miq_entry_cnt_create[3:0]
                                     - {3'b0,ctrl_miq_rf_pop_vld};
//implement entry counter
always @(posedge cnt_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    miq_entry_cnt[3:0] <= 4'b0;
  //after flush fe/is, the rf may wrongly pop before rtu_yy_xx_flush
  //need flush also when rtu_yy_xx_flush
  else if(rtu_idu_flush_fe || rtu_idu_flush_is || rtu_yy_xx_flush)
    miq_entry_cnt[3:0] <= 4'b0;
  else if(miq_entry_cnt_updt_vld)
    miq_entry_cnt[3:0] <= miq_entry_cnt_updt_val[3:0];
  else
    miq_entry_cnt[3:0] <= miq_entry_cnt[3:0];
end

assign miq_ctrl_full                    = (miq_entry_cnt[3:0] == 4'd12);

assign miq_top_miq_entry_cnt[3:0]       = miq_entry_cnt[3:0];

//---------------------miq entry full-----------------------
assign miq_entry_cnt_create_2 =  ctrl_miq_create1_en;
assign miq_entry_cnt_create_1 =  ctrl_miq_create0_en && !ctrl_miq_create1_en;
assign miq_entry_cnt_create_0 = !ctrl_miq_create0_en;

assign miq_entry_cnt_pop_1    =  ctrl_miq_rf_pop_vld;
assign miq_entry_cnt_pop_0    = !ctrl_miq_rf_pop_vld;

assign miq_ctrl_full_updt     = (miq_entry_cnt[3:0] == 4'd10)
                                && miq_entry_cnt_create_2
                                && miq_entry_cnt_pop_0
                             || (miq_entry_cnt[3:0] == 4'd11)
                                && miq_entry_cnt_create_1
                                && miq_entry_cnt_pop_0
                             || (miq_entry_cnt[3:0] == 4'd12)
                                && miq_entry_cnt_create_0
                                && miq_entry_cnt_pop_0;

assign miq_ctrl_1_left_updt   = (miq_entry_cnt[3:0] == 4'd9)
                                && miq_entry_cnt_create_2
                                && miq_entry_cnt_pop_0
                             || (miq_entry_cnt[3:0] == 4'd10)
                                && miq_entry_cnt_create_1
                                && miq_entry_cnt_pop_0
                             || (miq_entry_cnt[3:0] == 4'd10)
                                && miq_entry_cnt_create_2
                                && miq_entry_cnt_pop_1
                             || (miq_entry_cnt[3:0] == 4'd11)
                                && miq_entry_cnt_create_0
                                && miq_entry_cnt_pop_0
                             || (miq_entry_cnt[3:0] == 4'd11)
                                && miq_entry_cnt_create_1
                                && miq_entry_cnt_pop_1
                             || (miq_entry_cnt[3:0] == 4'd12)
                                && miq_entry_cnt_create_0
                                && miq_entry_cnt_pop_1;

//assign miq_full_entry_cnt_updt_val[3:0] = (miq_entry_cnt_updt_vld)
//                                           ? miq_entry_cnt_updt_val[3:0]
//                                           : miq_entry_cnt[3:0];
//
//assign miq_ctrl_full_updt   = (miq_full_entry_cnt_updt_val[3:0] == 4'd12);
//assign miq_ctrl_1_left_updt = (miq_full_entry_cnt_updt_val[3:0] == 4'd11);

//---------------------create bypass------------------------
//if create instruction is ready, it may bypass from issue queue
assign miq_create0_rdy_bypass    = ctrl_miq_create0_en
                                   && !cp0_idu_iq_bypass_disable
                                   && dp_miq_create_src0_rdy_for_bypass
                                   && dp_miq_create_src1_rdy_for_bypass;
//data path bypass signal, with timing optmized
assign miq_create0_rdy_bypass_dp = ctrl_miq_create0_dp_en
                                   && !cp0_idu_iq_bypass_disable
                                   && dp_miq_create_src0_rdy_for_bypass
                                   && dp_miq_create_src1_rdy_for_bypass;
//data path bypass signal, with timing optmized
assign miq_create0_rdy_bypass_gateclk = ctrl_miq_create0_gateclk_en
                                        && dp_miq_create_src0_rdy_for_bypass
                                        && dp_miq_create_src1_rdy_for_bypass;
//issue queue entry create control
assign miq_entry_vld[0]          = miq_entry0_vld;
assign miq_entry_vld[1]          = miq_entry1_vld;
assign miq_entry_vld[2]          = miq_entry2_vld;
assign miq_entry_vld[3]          = miq_entry3_vld;
assign miq_entry_vld[4]          = miq_entry4_vld;
assign miq_entry_vld[5]          = miq_entry5_vld;
assign miq_entry_vld[6]          = miq_entry6_vld;
assign miq_entry_vld[7]          = miq_entry7_vld;
assign miq_entry_vld[8]          = miq_entry8_vld;
assign miq_entry_vld[9]          = miq_entry9_vld;
assign miq_entry_vld[10]         = miq_entry10_vld;
assign miq_entry_vld[11]         = miq_entry11_vld;

assign miq_create_bypass_empty   = !(miq_entry0_vld_with_frz // x_vld_with_frz = vld && !frz; 实际表示表项有效且未冻结
                                     || miq_entry1_vld_with_frz // 表示如果IQ存在任一有效且未发射的表项, 
                                     || miq_entry2_vld_with_frz //  则不会考虑创建并旁路直接issue(create bypass)
                                     || miq_entry3_vld_with_frz
                                     || miq_entry4_vld_with_frz
                                     || miq_entry5_vld_with_frz
                                     || miq_entry6_vld_with_frz
                                     || miq_entry7_vld_with_frz
                                     || miq_entry8_vld_with_frz
                                     || miq_entry9_vld_with_frz
                                     || miq_entry10_vld_with_frz
                                     || miq_entry11_vld_with_frz);

assign miq_ctrl_empty            = !(|miq_entry_vld[11:0]);

//create0 priority is from entry 0 to 11
// &CombBeg; @169
always @( miq_entry3_vld
       or miq_entry10_vld
       or miq_entry8_vld
       or miq_entry9_vld
       or miq_entry1_vld
       or miq_entry4_vld
       or miq_entry7_vld
       or miq_entry11_vld
       or miq_entry0_vld
       or miq_entry2_vld
       or miq_entry6_vld
       or miq_entry5_vld)
begin
  if(!miq_entry0_vld)
    miq_entry_create0_in[11:0] = 12'b0000_0000_0001;
  else if(!miq_entry1_vld)
    miq_entry_create0_in[11:0] = 12'b0000_0000_0010;
  else if(!miq_entry2_vld)
    miq_entry_create0_in[11:0] = 12'b0000_0000_0100;
  else if(!miq_entry3_vld)
    miq_entry_create0_in[11:0] = 12'b0000_0000_1000;
  else if(!miq_entry4_vld)
    miq_entry_create0_in[11:0] = 12'b0000_0001_0000;
  else if(!miq_entry5_vld)
    miq_entry_create0_in[11:0] = 12'b0000_0010_0000;
  else if(!miq_entry6_vld)
    miq_entry_create0_in[11:0] = 12'b0000_0100_0000;
  else if(!miq_entry7_vld)
    miq_entry_create0_in[11:0] = 12'b0000_1000_0000;
  else if(!miq_entry8_vld)
    miq_entry_create0_in[11:0] = 12'b0001_0000_0000;
  else if(!miq_entry9_vld)
    miq_entry_create0_in[11:0] = 12'b0010_0000_0000;
  else if(!miq_entry10_vld)
    miq_entry_create0_in[11:0] = 12'b0100_0000_0000;
  else if(!miq_entry11_vld)
    miq_entry_create0_in[11:0] = 12'b1000_0000_0000;
  else
    miq_entry_create0_in[11:0] = 12'b0000_0000_0000;
// &CombEnd; @196
end
//create1 priority is from entry 11 to 0
// &CombBeg; @198
always @( miq_entry3_vld
       or miq_entry10_vld
       or miq_entry9_vld
       or miq_entry8_vld
       or miq_entry1_vld
       or miq_entry11_vld
       or miq_entry7_vld
       or miq_entry4_vld
       or miq_entry0_vld
       or miq_entry2_vld
       or miq_entry5_vld
       or miq_entry6_vld)
begin
  if(!miq_entry11_vld)
    miq_entry_create1_in[11:0] = 12'b1000_0000_0000;
  else if(!miq_entry10_vld)
    miq_entry_create1_in[11:0] = 12'b0100_0000_0000;
  else if(!miq_entry9_vld)
    miq_entry_create1_in[11:0] = 12'b0010_0000_0000;
  else if(!miq_entry8_vld)
    miq_entry_create1_in[11:0] = 12'b0001_0000_0000;
  else if(!miq_entry7_vld)
    miq_entry_create1_in[11:0] = 12'b0000_1000_0000;
  else if(!miq_entry6_vld)
    miq_entry_create1_in[11:0] = 12'b0000_0100_0000;
  else if(!miq_entry5_vld)
    miq_entry_create1_in[11:0] = 12'b0000_0010_0000;
  else if(!miq_entry4_vld)
    miq_entry_create1_in[11:0] = 12'b0000_0001_0000;
  else if(!miq_entry3_vld)
    miq_entry_create1_in[11:0] = 12'b0000_0000_1000;
  else if(!miq_entry2_vld)
    miq_entry_create1_in[11:0] = 12'b0000_0000_0100;
  else if(!miq_entry1_vld)
    miq_entry_create1_in[11:0] = 12'b0000_0000_0010;
  else if(!miq_entry0_vld)
    miq_entry_create1_in[11:0] = 12'b0000_0000_0001;
  else
    miq_entry_create1_in[11:0] = 12'b0000_0000_0000;
// &CombEnd; @225
end

assign miq_aiq_create0_entry[11:0] = miq_entry_create0_in[11:0];
assign miq_aiq_create1_entry[11:0] = miq_entry_create1_in[11:0];

assign miq_bypass_en            = miq_create_bypass_empty
                                  && miq_create0_rdy_bypass;

assign miq_entry_create_en[11:0] =
       {12{ctrl_miq_create0_en}} & miq_entry_create0_in[11:0]
     | {12{ctrl_miq_create1_en}} & miq_entry_create1_in[11:0];

assign miq_entry0_create_en  = miq_entry_create_en[0];
assign miq_entry1_create_en  = miq_entry_create_en[1];
assign miq_entry2_create_en  = miq_entry_create_en[2];
assign miq_entry3_create_en  = miq_entry_create_en[3];
assign miq_entry4_create_en  = miq_entry_create_en[4];
assign miq_entry5_create_en  = miq_entry_create_en[5];
assign miq_entry6_create_en  = miq_entry_create_en[6];
assign miq_entry7_create_en  = miq_entry_create_en[7];
assign miq_entry8_create_en  = miq_entry_create_en[8];
assign miq_entry9_create_en  = miq_entry_create_en[9];
assign miq_entry10_create_en = miq_entry_create_en[10];
assign miq_entry11_create_en = miq_entry_create_en[11];

assign miq_bypass_dp_en      = miq_create_bypass_empty
                                && miq_create0_rdy_bypass_dp;
assign miq_bypass_gateclk_en = miq_create_bypass_empty
                                && miq_create0_rdy_bypass_gateclk;

//issue queue entry create data path control
assign miq_entry_create_dp_en[11:0] =
       {12{ctrl_miq_create0_dp_en}} & miq_entry_create0_in[11:0]
     | {12{ctrl_miq_create1_dp_en}} & miq_entry_create1_in[11:0];

assign miq_entry0_create_dp_en  = miq_entry_create_dp_en[0];
assign miq_entry1_create_dp_en  = miq_entry_create_dp_en[1];
assign miq_entry2_create_dp_en  = miq_entry_create_dp_en[2];
assign miq_entry3_create_dp_en  = miq_entry_create_dp_en[3];
assign miq_entry4_create_dp_en  = miq_entry_create_dp_en[4];
assign miq_entry5_create_dp_en  = miq_entry_create_dp_en[5];
assign miq_entry6_create_dp_en  = miq_entry_create_dp_en[6];
assign miq_entry7_create_dp_en  = miq_entry_create_dp_en[7];
assign miq_entry8_create_dp_en  = miq_entry_create_dp_en[8];
assign miq_entry9_create_dp_en  = miq_entry_create_dp_en[9];
assign miq_entry10_create_dp_en = miq_entry_create_dp_en[10];
assign miq_entry11_create_dp_en = miq_entry_create_dp_en[11];

//issue queue entry create gateclk control
//ignore bypass signal for timing optimization
assign miq_entry_create_gateclk_en[11:0] =
       {12{ctrl_miq_create0_gateclk_en}} & miq_entry_create0_in[11:0]
     | {12{ctrl_miq_create1_gateclk_en}} & miq_entry_create1_in[11:0];

assign miq_entry0_create_gateclk_en  = miq_entry_create_gateclk_en[0];
assign miq_entry1_create_gateclk_en  = miq_entry_create_gateclk_en[1];
assign miq_entry2_create_gateclk_en  = miq_entry_create_gateclk_en[2];
assign miq_entry3_create_gateclk_en  = miq_entry_create_gateclk_en[3];
assign miq_entry4_create_gateclk_en  = miq_entry_create_gateclk_en[4];
assign miq_entry5_create_gateclk_en  = miq_entry_create_gateclk_en[5];
assign miq_entry6_create_gateclk_en  = miq_entry_create_gateclk_en[6];
assign miq_entry7_create_gateclk_en  = miq_entry_create_gateclk_en[7];
assign miq_entry8_create_gateclk_en  = miq_entry_create_gateclk_en[8];
assign miq_entry9_create_gateclk_en  = miq_entry_create_gateclk_en[9];
assign miq_entry10_create_gateclk_en = miq_entry_create_gateclk_en[10];
assign miq_entry11_create_gateclk_en = miq_entry_create_gateclk_en[11];

//miq create entry should consider pop signal and create0
assign miq_entry_create0_agevec[11:0] = miq_entry_vld[11:0]
                                        & ~({12{ctrl_miq_rf_pop_vld}}
                                           & dp_miq_rf_lch_entry[11:0]);

assign miq_entry_create1_agevec[11:0] = miq_entry_vld[11:0]
                                        & ~({12{ctrl_miq_rf_pop_vld}}
                                           & dp_miq_rf_lch_entry[11:0])
                                        | miq_entry_create0_in[11:0];

//create 0/1 select:
//entry 0~5 use ~miq_entry_create0_in for better timing
//entry 6~12 use miq_entry_create1_in for better timing
//miq_entry_create0/1_in cannot be both 1,
//if both 0, do not create
assign miq_entry_create_sel[11:6] = {6{ctrl_miq_create1_dp_en}} // 目的是平衡驱动, 是0则用create0驱动, 是1则用create1驱动,
                                     & miq_entry_create1_in[11:6]; // 而实际创建队列的表项则会通过使能信号进一步选通.
assign miq_entry_create_sel[5:0]  = ~({6{ctrl_miq_create0_dp_en}}
                                      & miq_entry_create0_in[5:0]);

//----------------entry0 flop create signals----------------
// &CombBeg; @313
always @( miq_entry_create_sel[0]
       or miq_bypass_dp_en
       or miq_entry_create1_agevec[11:1]
       or dp_miq_create1_data[72:0]
       or dp_miq_create0_data[72:0]
       or miq_entry_create0_agevec[11:1])
begin
  if(!miq_entry_create_sel[0]) begin
    miq_entry0_create_frz          = miq_bypass_dp_en;
    miq_entry0_create_agevec[10:0] = miq_entry_create0_agevec[11:1];
    miq_entry0_create_data[MIQ_WIDTH-1:0] =
       dp_miq_create0_data[MIQ_WIDTH-1:0];
  end
  else begin
    miq_entry0_create_frz          = 1'b0;
    miq_entry0_create_agevec[10:0] = miq_entry_create1_agevec[11:1];
    miq_entry0_create_data[MIQ_WIDTH-1:0] =
       dp_miq_create1_data[MIQ_WIDTH-1:0];
  end
// &CombEnd; @326
end

//----------------entry1 flop create signals----------------
// &CombBeg; @329
always @( miq_bypass_dp_en
       or dp_miq_create1_data[72:0]
       or miq_entry_create1_agevec[0]
       or dp_miq_create0_data[72:0]
       or miq_entry_create0_agevec[11:2]
       or miq_entry_create1_agevec[11:2]
       or miq_entry_create0_agevec[0]
       or miq_entry_create_sel[1])
begin
  if(!miq_entry_create_sel[1]) begin
    miq_entry1_create_frz          = miq_bypass_dp_en;
    miq_entry1_create_agevec[10:0] = {miq_entry_create0_agevec[11:2],
                                       miq_entry_create0_agevec[0]};
    miq_entry1_create_data[MIQ_WIDTH-1:0] =
       dp_miq_create0_data[MIQ_WIDTH-1:0];
  end
  else begin
    miq_entry1_create_frz          = 1'b0;
    miq_entry1_create_agevec[10:0] = {miq_entry_create1_agevec[11:2],
                                       miq_entry_create1_agevec[0]};
    miq_entry1_create_data[MIQ_WIDTH-1:0] = 
       dp_miq_create1_data[MIQ_WIDTH-1:0];
  end
// &CombEnd; @344
end

//----------------entry2 flop create signals----------------
// &CombBeg; @347
always @( miq_entry_create1_agevec[1:0]
       or miq_bypass_dp_en
       or miq_entry_create1_agevec[11:3]
       or dp_miq_create1_data[72:0]
       or dp_miq_create0_data[72:0]
       or miq_entry_create0_agevec[11:3]
       or miq_entry_create0_agevec[1:0]
       or miq_entry_create_sel[2])
begin
  if(!miq_entry_create_sel[2]) begin
    miq_entry2_create_frz          = miq_bypass_dp_en;
    miq_entry2_create_agevec[10:0] = {miq_entry_create0_agevec[11:3],
                                       miq_entry_create0_agevec[1:0]};
    miq_entry2_create_data[MIQ_WIDTH-1:0] =
       dp_miq_create0_data[MIQ_WIDTH-1:0];
  end
  else begin
    miq_entry2_create_frz          = 1'b0;
    miq_entry2_create_agevec[10:0] = {miq_entry_create1_agevec[11:3],
                                       miq_entry_create1_agevec[1:0]};
    miq_entry2_create_data[MIQ_WIDTH-1:0] = 
       dp_miq_create1_data[MIQ_WIDTH-1:0];
  end
// &CombEnd; @362
end

//----------------entry3 flop create signals----------------
// &CombBeg; @365
always @( miq_bypass_dp_en
       or miq_entry_create0_agevec[11:4]
       or miq_entry_create1_agevec[11:4]
       or dp_miq_create1_data[72:0]
       or dp_miq_create0_data[72:0]
       or miq_entry_create0_agevec[2:0]
       or miq_entry_create1_agevec[2:0]
       or miq_entry_create_sel[3])
begin
  if(!miq_entry_create_sel[3]) begin
    miq_entry3_create_frz          = miq_bypass_dp_en;
    miq_entry3_create_agevec[10:0] = {miq_entry_create0_agevec[11:4],
                                       miq_entry_create0_agevec[2:0]};
    miq_entry3_create_data[MIQ_WIDTH-1:0] =
       dp_miq_create0_data[MIQ_WIDTH-1:0];
  end
  else begin
    miq_entry3_create_frz          = 1'b0;
    miq_entry3_create_agevec[10:0] = {miq_entry_create1_agevec[11:4],
                                       miq_entry_create1_agevec[2:0]};
    miq_entry3_create_data[MIQ_WIDTH-1:0] = 
       dp_miq_create1_data[MIQ_WIDTH-1:0];
  end
// &CombEnd; @380
end

//----------------entry4 flop create signals----------------
// &CombBeg; @383
always @( miq_bypass_dp_en
       or dp_miq_create1_data[72:0]
       or dp_miq_create0_data[72:0]
       or miq_entry_create0_agevec[11:5]
       or miq_entry_create_sel[4]
       or miq_entry_create1_agevec[11:5]
       or miq_entry_create0_agevec[3:0]
       or miq_entry_create1_agevec[3:0])
begin
  if(!miq_entry_create_sel[4]) begin
    miq_entry4_create_frz          = miq_bypass_dp_en;
    miq_entry4_create_agevec[10:0] = {miq_entry_create0_agevec[11:5],
                                       miq_entry_create0_agevec[3:0]};
    miq_entry4_create_data[MIQ_WIDTH-1:0] =
       dp_miq_create0_data[MIQ_WIDTH-1:0];
  end
  else begin
    miq_entry4_create_frz          = 1'b0;
    miq_entry4_create_agevec[10:0] = {miq_entry_create1_agevec[11:5],
                                       miq_entry_create1_agevec[3:0]};
    miq_entry4_create_data[MIQ_WIDTH-1:0] = 
       dp_miq_create1_data[MIQ_WIDTH-1:0];
  end
// &CombEnd; @398
end

//----------------entry5 flop create signals----------------
// &CombBeg; @401
always @( miq_bypass_dp_en
       or dp_miq_create1_data[72:0]
       or dp_miq_create0_data[72:0]
       or miq_entry_create1_agevec[4:0]
       or miq_entry_create0_agevec[4:0]
       or miq_entry_create_sel[5]
       or miq_entry_create0_agevec[11:6]
       or miq_entry_create1_agevec[11:6])
begin
  if(!miq_entry_create_sel[5]) begin
    miq_entry5_create_frz          = miq_bypass_dp_en;
    miq_entry5_create_agevec[10:0] = {miq_entry_create0_agevec[11:6],
                                       miq_entry_create0_agevec[4:0]};
    miq_entry5_create_data[MIQ_WIDTH-1:0] =
       dp_miq_create0_data[MIQ_WIDTH-1:0];
  end
  else begin
    miq_entry5_create_frz          = 1'b0;
    miq_entry5_create_agevec[10:0] = {miq_entry_create1_agevec[11:6],
                                       miq_entry_create1_agevec[4:0]};
    miq_entry5_create_data[MIQ_WIDTH-1:0] = 
       dp_miq_create1_data[MIQ_WIDTH-1:0];
  end
// &CombEnd; @416
end

//----------------entry6 flop create signals----------------
// &CombBeg; @419
always @( miq_bypass_dp_en
       or miq_entry_create0_agevec[5:0]
       or miq_entry_create0_agevec[11:7]
       or miq_entry_create_sel[6]
       or miq_entry_create1_agevec[5:0]
       or dp_miq_create1_data[72:0]
       or dp_miq_create0_data[72:0]
       or miq_entry_create1_agevec[11:7])
begin
  if(!miq_entry_create_sel[6]) begin
    miq_entry6_create_frz          = miq_bypass_dp_en;
    miq_entry6_create_agevec[10:0] = {miq_entry_create0_agevec[11:7],
                                       miq_entry_create0_agevec[5:0]};
    miq_entry6_create_data[MIQ_WIDTH-1:0] =
       dp_miq_create0_data[MIQ_WIDTH-1:0];
  end
  else begin
    miq_entry6_create_frz          = 1'b0;
    miq_entry6_create_agevec[10:0] = {miq_entry_create1_agevec[11:7],
                                       miq_entry_create1_agevec[5:0]};
    miq_entry6_create_data[MIQ_WIDTH-1:0] = 
       dp_miq_create1_data[MIQ_WIDTH-1:0];
  end
// &CombEnd; @434
end

//----------------entry7 flop create signals----------------
// &CombBeg; @437
always @( miq_bypass_dp_en
       or miq_entry_create_sel[7]
       or dp_miq_create1_data[72:0]
       or dp_miq_create0_data[72:0]
       or miq_entry_create0_agevec[6:0]
       or miq_entry_create0_agevec[11:8]
       or miq_entry_create1_agevec[11:8]
       or miq_entry_create1_agevec[6:0])
begin
  if(!miq_entry_create_sel[7]) begin
    miq_entry7_create_frz          = miq_bypass_dp_en;
    miq_entry7_create_agevec[10:0] = {miq_entry_create0_agevec[11:8],
                                       miq_entry_create0_agevec[6:0]};
    miq_entry7_create_data[MIQ_WIDTH-1:0] =
       dp_miq_create0_data[MIQ_WIDTH-1:0];
  end
  else begin
    miq_entry7_create_frz          = 1'b0;
    miq_entry7_create_agevec[10:0] = {miq_entry_create1_agevec[11:8],
                                       miq_entry_create1_agevec[6:0]};
    miq_entry7_create_data[MIQ_WIDTH-1:0] = 
       dp_miq_create1_data[MIQ_WIDTH-1:0];
  end
// &CombEnd; @452
end

//----------------entry8 flop create signals----------------
// &CombBeg; @455
always @( miq_entry_create1_agevec[7:0]
       or miq_bypass_dp_en
       or miq_entry_create1_agevec[11:9]
       or miq_entry_create0_agevec[11:9]
       or dp_miq_create1_data[72:0]
       or dp_miq_create0_data[72:0]
       or miq_entry_create_sel[8]
       or miq_entry_create0_agevec[7:0])
begin
  if(!miq_entry_create_sel[8]) begin
    miq_entry8_create_frz          = miq_bypass_dp_en;
    miq_entry8_create_agevec[10:0] = {miq_entry_create0_agevec[11:9],
                                       miq_entry_create0_agevec[7:0]};
    miq_entry8_create_data[MIQ_WIDTH-1:0] =
       dp_miq_create0_data[MIQ_WIDTH-1:0];
  end
  else begin
    miq_entry8_create_frz          = 1'b0;
    miq_entry8_create_agevec[10:0] = {miq_entry_create1_agevec[11:9],
                                       miq_entry_create1_agevec[7:0]};
    miq_entry8_create_data[MIQ_WIDTH-1:0] = 
       dp_miq_create1_data[MIQ_WIDTH-1:0];
  end
// &CombEnd; @470
end

//----------------entry9 flop create signals----------------
// &CombBeg; @473
always @( miq_bypass_dp_en
       or dp_miq_create1_data[72:0]
       or miq_entry_create1_agevec[8:0]
       or dp_miq_create0_data[72:0]
       or miq_entry_create0_agevec[8:0]
       or miq_entry_create1_agevec[11:10]
       or miq_entry_create_sel[9]
       or miq_entry_create0_agevec[11:10])
begin
  if(!miq_entry_create_sel[9]) begin
    miq_entry9_create_frz          = miq_bypass_dp_en;
    miq_entry9_create_agevec[10:0] = {miq_entry_create0_agevec[11:10],
                                       miq_entry_create0_agevec[8:0]};
    miq_entry9_create_data[MIQ_WIDTH-1:0] =
       dp_miq_create0_data[MIQ_WIDTH-1:0];
  end
  else begin
    miq_entry9_create_frz          = 1'b0;
    miq_entry9_create_agevec[10:0] = {miq_entry_create1_agevec[11:10],
                                       miq_entry_create1_agevec[8:0]};
    miq_entry9_create_data[MIQ_WIDTH-1:0] = 
       dp_miq_create1_data[MIQ_WIDTH-1:0];
  end
// &CombEnd; @488
end

//---------------entry10 flop create signals----------------
// &CombBeg; @491
always @( miq_bypass_dp_en
       or miq_entry_create1_agevec[11]
       or dp_miq_create1_data[72:0]
       or miq_entry_create1_agevec[9:0]
       or dp_miq_create0_data[72:0]
       or miq_entry_create0_agevec[9:0]
       or miq_entry_create0_agevec[11]
       or miq_entry_create_sel[10])
begin
  if(!miq_entry_create_sel[10]) begin
    miq_entry10_create_frz          = miq_bypass_dp_en;
    miq_entry10_create_agevec[10:0] = {miq_entry_create0_agevec[11],
                                        miq_entry_create0_agevec[9:0]};
    miq_entry10_create_data[MIQ_WIDTH-1:0] =
        dp_miq_create0_data[MIQ_WIDTH-1:0];
  end
  else begin
    miq_entry10_create_frz          = 1'b0;
    miq_entry10_create_agevec[10:0] = {miq_entry_create1_agevec[11],
                                        miq_entry_create1_agevec[9:0]};
    miq_entry10_create_data[MIQ_WIDTH-1:0] = 
        dp_miq_create1_data[MIQ_WIDTH-1:0];
  end
// &CombEnd; @506
end

//---------------entry11 flop create signals----------------
// &CombBeg; @509
always @( miq_bypass_dp_en
       or dp_miq_create1_data[72:0]
       or dp_miq_create0_data[72:0]
       or miq_entry_create_sel[11]
       or miq_entry_create0_agevec[10:0]
       or miq_entry_create1_agevec[10:0])
begin
  if(!miq_entry_create_sel[11]) begin
    miq_entry11_create_frz          = miq_bypass_dp_en;
    miq_entry11_create_agevec[10:0] = miq_entry_create0_agevec[10:0];
    miq_entry11_create_data[MIQ_WIDTH-1:0] =
        dp_miq_create0_data[MIQ_WIDTH-1:0];
  end
  else begin
    miq_entry11_create_frz          = 1'b0;
    miq_entry11_create_agevec[10:0] = miq_entry_create1_agevec[10:0];
    miq_entry11_create_data[MIQ_WIDTH-1:0] = 
        dp_miq_create1_data[MIQ_WIDTH-1:0];
  end
// &CombEnd; @522
end

//==========================================================
//             Branch Issue Queue Issue Control
//==========================================================
//----------------Pipe0 Launch Ready Signals----------------
assign miq_entry0_alu0_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe0_alu_reg_fwd_vld[1:0];
assign miq_entry1_alu0_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe0_alu_reg_fwd_vld[3:2];
assign miq_entry2_alu0_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe0_alu_reg_fwd_vld[5:4];
assign miq_entry3_alu0_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe0_alu_reg_fwd_vld[7:6];
assign miq_entry4_alu0_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe0_alu_reg_fwd_vld[9:8];
assign miq_entry5_alu0_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe0_alu_reg_fwd_vld[11:10];
assign miq_entry6_alu0_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe0_alu_reg_fwd_vld[13:12];
assign miq_entry7_alu0_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe0_alu_reg_fwd_vld[15:14];
assign miq_entry8_alu0_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe0_alu_reg_fwd_vld[17:16];
assign miq_entry9_alu0_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe0_alu_reg_fwd_vld[19:18];
assign miq_entry10_alu0_reg_fwd_vld[1:0] = ctrl_miq_rf_pipe0_alu_reg_fwd_vld[21:20];
assign miq_entry11_alu0_reg_fwd_vld[1:0] = ctrl_miq_rf_pipe0_alu_reg_fwd_vld[23:22];

assign miq_entry0_alu1_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe1_alu_reg_fwd_vld[1:0];
assign miq_entry1_alu1_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe1_alu_reg_fwd_vld[3:2];
assign miq_entry2_alu1_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe1_alu_reg_fwd_vld[5:4];
assign miq_entry3_alu1_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe1_alu_reg_fwd_vld[7:6];
assign miq_entry4_alu1_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe1_alu_reg_fwd_vld[9:8];
assign miq_entry5_alu1_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe1_alu_reg_fwd_vld[11:10];
assign miq_entry6_alu1_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe1_alu_reg_fwd_vld[13:12];
assign miq_entry7_alu1_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe1_alu_reg_fwd_vld[15:14];
assign miq_entry8_alu1_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe1_alu_reg_fwd_vld[17:16];
assign miq_entry9_alu1_reg_fwd_vld[1:0]  = ctrl_miq_rf_pipe1_alu_reg_fwd_vld[19:18];
assign miq_entry10_alu1_reg_fwd_vld[1:0] = ctrl_miq_rf_pipe1_alu_reg_fwd_vld[21:20];
assign miq_entry11_alu1_reg_fwd_vld[1:0] = ctrl_miq_rf_pipe1_alu_reg_fwd_vld[23:22];

//-------------------issue enable signals-------------------
assign miq_entry_ready[0]      = miq_entry0_rdy;
assign miq_entry_ready[1]      = miq_entry1_rdy;
assign miq_entry_ready[2]      = miq_entry2_rdy;
assign miq_entry_ready[3]      = miq_entry3_rdy;
assign miq_entry_ready[4]      = miq_entry4_rdy;
assign miq_entry_ready[5]      = miq_entry5_rdy;
assign miq_entry_ready[6]      = miq_entry6_rdy;
assign miq_entry_ready[7]      = miq_entry7_rdy;
assign miq_entry_ready[8]      = miq_entry8_rdy;
assign miq_entry_ready[9]      = miq_entry9_rdy;
assign miq_entry_ready[10]     = miq_entry10_rdy;
assign miq_entry_ready[11]     = miq_entry11_rdy;
//if there is any entry ready or bypass enable, issue enable
assign miq_xx_issue_en         = |{miq_bypass_en,
                                   miq_entry_ready[11:0]};
//gate clock issue enable with timing optimization
assign miq_xx_gateclk_issue_en = miq_bypass_gateclk_en
                                 || miq_entry0_vld_with_frz
                                 || miq_entry1_vld_with_frz
                                 || miq_entry2_vld_with_frz
                                 || miq_entry3_vld_with_frz
                                 || miq_entry4_vld_with_frz
                                 || miq_entry5_vld_with_frz
                                 || miq_entry6_vld_with_frz
                                 || miq_entry7_vld_with_frz
                                 || miq_entry8_vld_with_frz
                                 || miq_entry9_vld_with_frz
                                 || miq_entry10_vld_with_frz
                                 || miq_entry11_vld_with_frz;
//first find older ready entry
assign miq_older_entry_ready[0]  = |(miq_entry0_agevec[10:0]
                                     & miq_entry_ready[11:1]);
assign miq_older_entry_ready[1]  = |(miq_entry1_agevec[10:0]
                                     & {miq_entry_ready[11:2],
                                        miq_entry_ready[0]});
assign miq_older_entry_ready[2]  = |(miq_entry2_agevec[10:0]
                                     & {miq_entry_ready[11:3],
                                        miq_entry_ready[1:0]});
assign miq_older_entry_ready[3]  = |(miq_entry3_agevec[10:0]
                                     & {miq_entry_ready[11:4],
                                        miq_entry_ready[2:0]});
assign miq_older_entry_ready[4]  = |(miq_entry4_agevec[10:0]
                                     & {miq_entry_ready[11:5],
                                        miq_entry_ready[3:0]});
assign miq_older_entry_ready[5]  = |(miq_entry5_agevec[10:0]
                                     & {miq_entry_ready[11:6],
                                        miq_entry_ready[4:0]});
assign miq_older_entry_ready[6]  = |(miq_entry6_agevec[10:0]
                                     & {miq_entry_ready[11:7],
                                        miq_entry_ready[5:0]});
assign miq_older_entry_ready[7]  = |(miq_entry7_agevec[10:0]
                                     & {miq_entry_ready[11:8],
                                        miq_entry_ready[6:0]});
assign miq_older_entry_ready[8]  = |(miq_entry8_agevec[10:0]
                                     & {miq_entry_ready[11:9],
                                        miq_entry_ready[7:0]});
assign miq_older_entry_ready[9]  = |(miq_entry9_agevec[10:0]
                                     & {miq_entry_ready[11:10],
                                        miq_entry_ready[8:0]});
assign miq_older_entry_ready[10] = |(miq_entry10_agevec[10:0]
                                     & {miq_entry_ready[11],
                                        miq_entry_ready[9:0]});
assign miq_older_entry_ready[11] = |(miq_entry11_agevec[10:0]
                                     & miq_entry_ready[10:0]);

//------------------entry issue enable signals--------------
//not ready if older ready exists
assign miq_entry_issue_en[11:0]  = miq_entry_ready[11:0]
                                   & ~miq_older_entry_ready[11:0];
//rename for entries
assign miq_entry0_issue_en      = miq_entry_issue_en[0];
assign miq_entry1_issue_en      = miq_entry_issue_en[1];
assign miq_entry2_issue_en      = miq_entry_issue_en[2];
assign miq_entry3_issue_en      = miq_entry_issue_en[3];
assign miq_entry4_issue_en      = miq_entry_issue_en[4];
assign miq_entry5_issue_en      = miq_entry_issue_en[5];
assign miq_entry6_issue_en      = miq_entry_issue_en[6];
assign miq_entry7_issue_en      = miq_entry_issue_en[7];
assign miq_entry8_issue_en      = miq_entry_issue_en[8];
assign miq_entry9_issue_en      = miq_entry_issue_en[9];
assign miq_entry10_issue_en     = miq_entry_issue_en[10];
assign miq_entry11_issue_en     = miq_entry_issue_en[11];

//-----------------issue entry indiction--------------------
assign miq_dp_issue_entry[11:0] = (miq_create_bypass_empty)
                                  ? miq_entry_create0_in[11:0]
                                  : miq_entry_issue_en[11:0];

//-----------------issue data path selection----------------
//issue data path will select oldest ready entry in issue queue
//if no instruction valid, the data path will always select bypass 
//data path
// &CombBeg; @647
always @( miq_entry3_read_data[72:0]
       or miq_entry2_read_data[72:0]
       or miq_entry7_read_data[72:0]
       or miq_entry11_read_data[72:0]
       or miq_entry10_read_data[72:0]
       or miq_entry5_read_data[72:0]
       or miq_entry_issue_en[11:0]
       or miq_entry4_read_data[72:0]
       or miq_entry0_read_data[72:0]
       or miq_entry1_read_data[72:0]
       or miq_entry6_read_data[72:0]
       or miq_entry8_read_data[72:0]
       or miq_entry9_read_data[72:0])
begin
  case (miq_entry_issue_en[11:0])
    12'h001: miq_entry_read_data[MIQ_WIDTH-1:0] =
               miq_entry0_read_data[MIQ_WIDTH-1:0];
    12'h002: miq_entry_read_data[MIQ_WIDTH-1:0] =
               miq_entry1_read_data[MIQ_WIDTH-1:0];
    12'h004: miq_entry_read_data[MIQ_WIDTH-1:0] =
               miq_entry2_read_data[MIQ_WIDTH-1:0];
    12'h008: miq_entry_read_data[MIQ_WIDTH-1:0] =
               miq_entry3_read_data[MIQ_WIDTH-1:0];
    12'h010: miq_entry_read_data[MIQ_WIDTH-1:0] =
               miq_entry4_read_data[MIQ_WIDTH-1:0];
    12'h020: miq_entry_read_data[MIQ_WIDTH-1:0] =
               miq_entry5_read_data[MIQ_WIDTH-1:0];
    12'h040: miq_entry_read_data[MIQ_WIDTH-1:0] =
               miq_entry6_read_data[MIQ_WIDTH-1:0];
    12'h080: miq_entry_read_data[MIQ_WIDTH-1:0] =
               miq_entry7_read_data[MIQ_WIDTH-1:0];
    12'h100: miq_entry_read_data[MIQ_WIDTH-1:0] =
               miq_entry8_read_data[MIQ_WIDTH-1:0];
    12'h200: miq_entry_read_data[MIQ_WIDTH-1:0] =
               miq_entry9_read_data[MIQ_WIDTH-1:0];
    12'h400: miq_entry_read_data[MIQ_WIDTH-1:0] =
               miq_entry10_read_data[MIQ_WIDTH-1:0];
    12'h800: miq_entry_read_data[MIQ_WIDTH-1:0] =
               miq_entry11_read_data[MIQ_WIDTH-1:0];
    default: miq_entry_read_data[MIQ_WIDTH-1:0] =
                                    {MIQ_WIDTH{1'bx}};
  endcase
// &CombEnd; @676
end

//if no entry valid, select bypass path
assign miq_dp_issue_read_data[MIQ_WIDTH-1:0] = 
         (miq_create_bypass_empty)
         ? dp_miq_bypass_data[MIQ_WIDTH-1:0]
         : miq_entry_read_data[MIQ_WIDTH-1:0];

//==========================================================
//            Branch Issue Queue Launch Control
//==========================================================
//-------------------entry pop enable signals---------------
//pop when rf launch pass
assign {miq_entry0_pop_other_entry[10:0],
        miq_entry0_pop_cur_entry}          = dp_miq_rf_lch_entry[11:0];
assign {miq_entry1_pop_other_entry[10:1],  
        miq_entry1_pop_cur_entry,
        miq_entry1_pop_other_entry[0]}     = dp_miq_rf_lch_entry[11:0];
assign {miq_entry2_pop_other_entry[10:2],  
        miq_entry2_pop_cur_entry,
        miq_entry2_pop_other_entry[1:0]}   = dp_miq_rf_lch_entry[11:0];
assign {miq_entry3_pop_other_entry[10:3],  
        miq_entry3_pop_cur_entry,
        miq_entry3_pop_other_entry[2:0]}   = dp_miq_rf_lch_entry[11:0];
assign {miq_entry4_pop_other_entry[10:4],  
        miq_entry4_pop_cur_entry,
        miq_entry4_pop_other_entry[3:0]}   = dp_miq_rf_lch_entry[11:0];
assign {miq_entry5_pop_other_entry[10:5],  
        miq_entry5_pop_cur_entry,
        miq_entry5_pop_other_entry[4:0]}   = dp_miq_rf_lch_entry[11:0];
assign {miq_entry6_pop_other_entry[10:6],  
        miq_entry6_pop_cur_entry,
        miq_entry6_pop_other_entry[5:0]}   = dp_miq_rf_lch_entry[11:0];
assign {miq_entry7_pop_other_entry[10:7],  
        miq_entry7_pop_cur_entry,
        miq_entry7_pop_other_entry[6:0]}   = dp_miq_rf_lch_entry[11:0];
assign {miq_entry8_pop_other_entry[10:8],  
        miq_entry8_pop_cur_entry,
        miq_entry8_pop_other_entry[7:0]}   = dp_miq_rf_lch_entry[11:0];
assign {miq_entry9_pop_other_entry[10:9],  
        miq_entry9_pop_cur_entry,
        miq_entry9_pop_other_entry[8:0]}   = dp_miq_rf_lch_entry[11:0];
assign {miq_entry10_pop_other_entry[10],
        miq_entry10_pop_cur_entry,
        miq_entry10_pop_other_entry[9:0]}  = dp_miq_rf_lch_entry[11:0];
assign {miq_entry11_pop_cur_entry,
        miq_entry11_pop_other_entry[10:0]} = dp_miq_rf_lch_entry[11:0];

//-------------------entry spec fail signals---------------
//clear freeze and source rdy when launch fail
assign miq_entry0_frz_clr      = ctrl_miq_rf_lch_fail_vld
                                 && dp_miq_rf_lch_entry[0];
assign miq_entry1_frz_clr      = ctrl_miq_rf_lch_fail_vld
                                 && dp_miq_rf_lch_entry[1];
assign miq_entry2_frz_clr      = ctrl_miq_rf_lch_fail_vld 
                                 && dp_miq_rf_lch_entry[2];
assign miq_entry3_frz_clr      = ctrl_miq_rf_lch_fail_vld 
                                 && dp_miq_rf_lch_entry[3];
assign miq_entry4_frz_clr      = ctrl_miq_rf_lch_fail_vld 
                                 && dp_miq_rf_lch_entry[4];
assign miq_entry5_frz_clr      = ctrl_miq_rf_lch_fail_vld 
                                 && dp_miq_rf_lch_entry[5];
assign miq_entry6_frz_clr      = ctrl_miq_rf_lch_fail_vld 
                                 && dp_miq_rf_lch_entry[6];
assign miq_entry7_frz_clr      = ctrl_miq_rf_lch_fail_vld 
                                 && dp_miq_rf_lch_entry[7];
assign miq_entry8_frz_clr      = ctrl_miq_rf_lch_fail_vld 
                                 && dp_miq_rf_lch_entry[8];
assign miq_entry9_frz_clr      = ctrl_miq_rf_lch_fail_vld 
                                 && dp_miq_rf_lch_entry[9];
assign miq_entry10_frz_clr     = ctrl_miq_rf_lch_fail_vld 
                                 && dp_miq_rf_lch_entry[10];
assign miq_entry11_frz_clr     = ctrl_miq_rf_lch_fail_vld 
                                 && dp_miq_rf_lch_entry[11];

//==========================================================
//             Branch Issue Queue Entry Instance
//==========================================================
// &ConnRule(s/^x_/miq_entry0_/); @754
// &Instance("ct_idu_is_miq_entry", "x_ct_idu_is_miq_entry0"); @755
ct_idu_is_miq_entry  x_ct_idu_is_miq_entry0 (
  .cp0_idu_icg_en                          (cp0_idu_icg_en                         ),
  .cp0_yy_clk_en                           (cp0_yy_clk_en                          ),
  .cpurst_b                                (cpurst_b                               ),
  .ctrl_miq_rf_pop_vld                     (ctrl_miq_rf_pop_vld                    ),
  .ctrl_xx_rf_pipe0_preg_lch_vld_dupx      (ctrl_xx_rf_pipe0_preg_lch_vld_dupx     ),
  .ctrl_xx_rf_pipe1_preg_lch_vld_dupx      (ctrl_xx_rf_pipe1_preg_lch_vld_dupx     ),
  .dp_miq_rf_rdy_clr                       (dp_miq_rf_rdy_clr                      ),
  .dp_xx_rf_pipe0_dst_preg_dupx            (dp_xx_rf_pipe0_dst_preg_dupx           ),
  .dp_xx_rf_pipe1_dst_preg_dupx            (dp_xx_rf_pipe1_dst_preg_dupx           ),
  .forever_cpuclk                          (forever_cpuclk                         ),
  .iu_idu_div_inst_vld                     (iu_idu_div_inst_vld                    ),
  .iu_idu_div_preg_dupx                    (iu_idu_div_preg_dupx                   ),
  .iu_idu_ex2_pipe0_wb_preg_dupx           (iu_idu_ex2_pipe0_wb_preg_dupx          ),
  .iu_idu_ex2_pipe0_wb_preg_vld_dupx       (iu_idu_ex2_pipe0_wb_preg_vld_dupx      ),
  .iu_idu_ex2_pipe1_mult_inst_vld_dupx     (iu_idu_ex2_pipe1_mult_inst_vld_dupx    ),
  .iu_idu_ex2_pipe1_preg_dupx              (iu_idu_ex2_pipe1_preg_dupx             ),
  .iu_idu_ex2_pipe1_wb_preg_dupx           (iu_idu_ex2_pipe1_wb_preg_dupx          ),
  .iu_idu_ex2_pipe1_wb_preg_vld_dupx       (iu_idu_ex2_pipe1_wb_preg_vld_dupx      ),
  .lsu_idu_ag_pipe3_load_inst_vld          (lsu_idu_ag_pipe3_load_inst_vld         ),
  .lsu_idu_ag_pipe3_preg_dupx              (lsu_idu_ag_pipe3_preg_dupx             ),
  .lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx (lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx),
  .lsu_idu_dc_pipe3_load_inst_vld_dupx     (lsu_idu_dc_pipe3_load_inst_vld_dupx    ),
  .lsu_idu_dc_pipe3_preg_dupx              (lsu_idu_dc_pipe3_preg_dupx             ),
  .lsu_idu_wb_pipe3_wb_preg_dupx           (lsu_idu_wb_pipe3_wb_preg_dupx          ),
  .lsu_idu_wb_pipe3_wb_preg_vld_dupx       (lsu_idu_wb_pipe3_wb_preg_vld_dupx      ),
  .pad_yy_icg_scan_en                      (pad_yy_icg_scan_en                     ),
  .rtu_idu_flush_fe                        (rtu_idu_flush_fe                       ),
  .rtu_idu_flush_is                        (rtu_idu_flush_is                       ),
  .vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe6_preg_dupx            (vfpu_idu_ex1_pipe6_preg_dupx           ),
  .vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe7_preg_dupx            (vfpu_idu_ex1_pipe7_preg_dupx           ),
  .x_agevec                                (miq_entry0_agevec                      ),
  .x_alu0_reg_fwd_vld                      (miq_entry0_alu0_reg_fwd_vld            ),
  .x_alu1_reg_fwd_vld                      (miq_entry0_alu1_reg_fwd_vld            ),
  .x_create_agevec                         (miq_entry0_create_agevec               ),
  .x_create_data                           (miq_entry0_create_data                 ),
  .x_create_dp_en                          (miq_entry0_create_dp_en                ),
  .x_create_en                             (miq_entry0_create_en                   ),
  .x_create_frz                            (miq_entry0_create_frz                  ),
  .x_create_gateclk_en                     (miq_entry0_create_gateclk_en           ),
  .x_frz_clr                               (miq_entry0_frz_clr                     ),
  .x_issue_en                              (miq_entry0_issue_en                    ),
  .x_pop_cur_entry                         (miq_entry0_pop_cur_entry               ),
  .x_pop_other_entry                       (miq_entry0_pop_other_entry             ),
  .x_rdy                                   (miq_entry0_rdy                         ),
  .x_read_data                             (miq_entry0_read_data                   ),
  .x_vld                                   (miq_entry0_vld                         ),
  .x_vld_with_frz                          (miq_entry0_vld_with_frz                )
);


// &ConnRule(s/^x_/miq_entry1_/); @757
// &Instance("ct_idu_is_miq_entry", "x_ct_idu_is_miq_entry1"); @758
ct_idu_is_miq_entry  x_ct_idu_is_miq_entry1 (
  .cp0_idu_icg_en                          (cp0_idu_icg_en                         ),
  .cp0_yy_clk_en                           (cp0_yy_clk_en                          ),
  .cpurst_b                                (cpurst_b                               ),
  .ctrl_miq_rf_pop_vld                     (ctrl_miq_rf_pop_vld                    ),
  .ctrl_xx_rf_pipe0_preg_lch_vld_dupx      (ctrl_xx_rf_pipe0_preg_lch_vld_dupx     ),
  .ctrl_xx_rf_pipe1_preg_lch_vld_dupx      (ctrl_xx_rf_pipe1_preg_lch_vld_dupx     ),
  .dp_miq_rf_rdy_clr                       (dp_miq_rf_rdy_clr                      ),
  .dp_xx_rf_pipe0_dst_preg_dupx            (dp_xx_rf_pipe0_dst_preg_dupx           ),
  .dp_xx_rf_pipe1_dst_preg_dupx            (dp_xx_rf_pipe1_dst_preg_dupx           ),
  .forever_cpuclk                          (forever_cpuclk                         ),
  .iu_idu_div_inst_vld                     (iu_idu_div_inst_vld                    ),
  .iu_idu_div_preg_dupx                    (iu_idu_div_preg_dupx                   ),
  .iu_idu_ex2_pipe0_wb_preg_dupx           (iu_idu_ex2_pipe0_wb_preg_dupx          ),
  .iu_idu_ex2_pipe0_wb_preg_vld_dupx       (iu_idu_ex2_pipe0_wb_preg_vld_dupx      ),
  .iu_idu_ex2_pipe1_mult_inst_vld_dupx     (iu_idu_ex2_pipe1_mult_inst_vld_dupx    ),
  .iu_idu_ex2_pipe1_preg_dupx              (iu_idu_ex2_pipe1_preg_dupx             ),
  .iu_idu_ex2_pipe1_wb_preg_dupx           (iu_idu_ex2_pipe1_wb_preg_dupx          ),
  .iu_idu_ex2_pipe1_wb_preg_vld_dupx       (iu_idu_ex2_pipe1_wb_preg_vld_dupx      ),
  .lsu_idu_ag_pipe3_load_inst_vld          (lsu_idu_ag_pipe3_load_inst_vld         ),
  .lsu_idu_ag_pipe3_preg_dupx              (lsu_idu_ag_pipe3_preg_dupx             ),
  .lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx (lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx),
  .lsu_idu_dc_pipe3_load_inst_vld_dupx     (lsu_idu_dc_pipe3_load_inst_vld_dupx    ),
  .lsu_idu_dc_pipe3_preg_dupx              (lsu_idu_dc_pipe3_preg_dupx             ),
  .lsu_idu_wb_pipe3_wb_preg_dupx           (lsu_idu_wb_pipe3_wb_preg_dupx          ),
  .lsu_idu_wb_pipe3_wb_preg_vld_dupx       (lsu_idu_wb_pipe3_wb_preg_vld_dupx      ),
  .pad_yy_icg_scan_en                      (pad_yy_icg_scan_en                     ),
  .rtu_idu_flush_fe                        (rtu_idu_flush_fe                       ),
  .rtu_idu_flush_is                        (rtu_idu_flush_is                       ),
  .vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe6_preg_dupx            (vfpu_idu_ex1_pipe6_preg_dupx           ),
  .vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe7_preg_dupx            (vfpu_idu_ex1_pipe7_preg_dupx           ),
  .x_agevec                                (miq_entry1_agevec                      ),
  .x_alu0_reg_fwd_vld                      (miq_entry1_alu0_reg_fwd_vld            ),
  .x_alu1_reg_fwd_vld                      (miq_entry1_alu1_reg_fwd_vld            ),
  .x_create_agevec                         (miq_entry1_create_agevec               ),
  .x_create_data                           (miq_entry1_create_data                 ),
  .x_create_dp_en                          (miq_entry1_create_dp_en                ),
  .x_create_en                             (miq_entry1_create_en                   ),
  .x_create_frz                            (miq_entry1_create_frz                  ),
  .x_create_gateclk_en                     (miq_entry1_create_gateclk_en           ),
  .x_frz_clr                               (miq_entry1_frz_clr                     ),
  .x_issue_en                              (miq_entry1_issue_en                    ),
  .x_pop_cur_entry                         (miq_entry1_pop_cur_entry               ),
  .x_pop_other_entry                       (miq_entry1_pop_other_entry             ),
  .x_rdy                                   (miq_entry1_rdy                         ),
  .x_read_data                             (miq_entry1_read_data                   ),
  .x_vld                                   (miq_entry1_vld                         ),
  .x_vld_with_frz                          (miq_entry1_vld_with_frz                )
);


// &ConnRule(s/^x_/miq_entry2_/); @760
// &Instance("ct_idu_is_miq_entry", "x_ct_idu_is_miq_entry2"); @761
ct_idu_is_miq_entry  x_ct_idu_is_miq_entry2 (
  .cp0_idu_icg_en                          (cp0_idu_icg_en                         ),
  .cp0_yy_clk_en                           (cp0_yy_clk_en                          ),
  .cpurst_b                                (cpurst_b                               ),
  .ctrl_miq_rf_pop_vld                     (ctrl_miq_rf_pop_vld                    ),
  .ctrl_xx_rf_pipe0_preg_lch_vld_dupx      (ctrl_xx_rf_pipe0_preg_lch_vld_dupx     ),
  .ctrl_xx_rf_pipe1_preg_lch_vld_dupx      (ctrl_xx_rf_pipe1_preg_lch_vld_dupx     ),
  .dp_miq_rf_rdy_clr                       (dp_miq_rf_rdy_clr                      ),
  .dp_xx_rf_pipe0_dst_preg_dupx            (dp_xx_rf_pipe0_dst_preg_dupx           ),
  .dp_xx_rf_pipe1_dst_preg_dupx            (dp_xx_rf_pipe1_dst_preg_dupx           ),
  .forever_cpuclk                          (forever_cpuclk                         ),
  .iu_idu_div_inst_vld                     (iu_idu_div_inst_vld                    ),
  .iu_idu_div_preg_dupx                    (iu_idu_div_preg_dupx                   ),
  .iu_idu_ex2_pipe0_wb_preg_dupx           (iu_idu_ex2_pipe0_wb_preg_dupx          ),
  .iu_idu_ex2_pipe0_wb_preg_vld_dupx       (iu_idu_ex2_pipe0_wb_preg_vld_dupx      ),
  .iu_idu_ex2_pipe1_mult_inst_vld_dupx     (iu_idu_ex2_pipe1_mult_inst_vld_dupx    ),
  .iu_idu_ex2_pipe1_preg_dupx              (iu_idu_ex2_pipe1_preg_dupx             ),
  .iu_idu_ex2_pipe1_wb_preg_dupx           (iu_idu_ex2_pipe1_wb_preg_dupx          ),
  .iu_idu_ex2_pipe1_wb_preg_vld_dupx       (iu_idu_ex2_pipe1_wb_preg_vld_dupx      ),
  .lsu_idu_ag_pipe3_load_inst_vld          (lsu_idu_ag_pipe3_load_inst_vld         ),
  .lsu_idu_ag_pipe3_preg_dupx              (lsu_idu_ag_pipe3_preg_dupx             ),
  .lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx (lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx),
  .lsu_idu_dc_pipe3_load_inst_vld_dupx     (lsu_idu_dc_pipe3_load_inst_vld_dupx    ),
  .lsu_idu_dc_pipe3_preg_dupx              (lsu_idu_dc_pipe3_preg_dupx             ),
  .lsu_idu_wb_pipe3_wb_preg_dupx           (lsu_idu_wb_pipe3_wb_preg_dupx          ),
  .lsu_idu_wb_pipe3_wb_preg_vld_dupx       (lsu_idu_wb_pipe3_wb_preg_vld_dupx      ),
  .pad_yy_icg_scan_en                      (pad_yy_icg_scan_en                     ),
  .rtu_idu_flush_fe                        (rtu_idu_flush_fe                       ),
  .rtu_idu_flush_is                        (rtu_idu_flush_is                       ),
  .vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe6_preg_dupx            (vfpu_idu_ex1_pipe6_preg_dupx           ),
  .vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe7_preg_dupx            (vfpu_idu_ex1_pipe7_preg_dupx           ),
  .x_agevec                                (miq_entry2_agevec                      ),
  .x_alu0_reg_fwd_vld                      (miq_entry2_alu0_reg_fwd_vld            ),
  .x_alu1_reg_fwd_vld                      (miq_entry2_alu1_reg_fwd_vld            ),
  .x_create_agevec                         (miq_entry2_create_agevec               ),
  .x_create_data                           (miq_entry2_create_data                 ),
  .x_create_dp_en                          (miq_entry2_create_dp_en                ),
  .x_create_en                             (miq_entry2_create_en                   ),
  .x_create_frz                            (miq_entry2_create_frz                  ),
  .x_create_gateclk_en                     (miq_entry2_create_gateclk_en           ),
  .x_frz_clr                               (miq_entry2_frz_clr                     ),
  .x_issue_en                              (miq_entry2_issue_en                    ),
  .x_pop_cur_entry                         (miq_entry2_pop_cur_entry               ),
  .x_pop_other_entry                       (miq_entry2_pop_other_entry             ),
  .x_rdy                                   (miq_entry2_rdy                         ),
  .x_read_data                             (miq_entry2_read_data                   ),
  .x_vld                                   (miq_entry2_vld                         ),
  .x_vld_with_frz                          (miq_entry2_vld_with_frz                )
);


// &ConnRule(s/^x_/miq_entry3_/); @763
// &Instance("ct_idu_is_miq_entry", "x_ct_idu_is_miq_entry3"); @764
ct_idu_is_miq_entry  x_ct_idu_is_miq_entry3 (
  .cp0_idu_icg_en                          (cp0_idu_icg_en                         ),
  .cp0_yy_clk_en                           (cp0_yy_clk_en                          ),
  .cpurst_b                                (cpurst_b                               ),
  .ctrl_miq_rf_pop_vld                     (ctrl_miq_rf_pop_vld                    ),
  .ctrl_xx_rf_pipe0_preg_lch_vld_dupx      (ctrl_xx_rf_pipe0_preg_lch_vld_dupx     ),
  .ctrl_xx_rf_pipe1_preg_lch_vld_dupx      (ctrl_xx_rf_pipe1_preg_lch_vld_dupx     ),
  .dp_miq_rf_rdy_clr                       (dp_miq_rf_rdy_clr                      ),
  .dp_xx_rf_pipe0_dst_preg_dupx            (dp_xx_rf_pipe0_dst_preg_dupx           ),
  .dp_xx_rf_pipe1_dst_preg_dupx            (dp_xx_rf_pipe1_dst_preg_dupx           ),
  .forever_cpuclk                          (forever_cpuclk                         ),
  .iu_idu_div_inst_vld                     (iu_idu_div_inst_vld                    ),
  .iu_idu_div_preg_dupx                    (iu_idu_div_preg_dupx                   ),
  .iu_idu_ex2_pipe0_wb_preg_dupx           (iu_idu_ex2_pipe0_wb_preg_dupx          ),
  .iu_idu_ex2_pipe0_wb_preg_vld_dupx       (iu_idu_ex2_pipe0_wb_preg_vld_dupx      ),
  .iu_idu_ex2_pipe1_mult_inst_vld_dupx     (iu_idu_ex2_pipe1_mult_inst_vld_dupx    ),
  .iu_idu_ex2_pipe1_preg_dupx              (iu_idu_ex2_pipe1_preg_dupx             ),
  .iu_idu_ex2_pipe1_wb_preg_dupx           (iu_idu_ex2_pipe1_wb_preg_dupx          ),
  .iu_idu_ex2_pipe1_wb_preg_vld_dupx       (iu_idu_ex2_pipe1_wb_preg_vld_dupx      ),
  .lsu_idu_ag_pipe3_load_inst_vld          (lsu_idu_ag_pipe3_load_inst_vld         ),
  .lsu_idu_ag_pipe3_preg_dupx              (lsu_idu_ag_pipe3_preg_dupx             ),
  .lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx (lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx),
  .lsu_idu_dc_pipe3_load_inst_vld_dupx     (lsu_idu_dc_pipe3_load_inst_vld_dupx    ),
  .lsu_idu_dc_pipe3_preg_dupx              (lsu_idu_dc_pipe3_preg_dupx             ),
  .lsu_idu_wb_pipe3_wb_preg_dupx           (lsu_idu_wb_pipe3_wb_preg_dupx          ),
  .lsu_idu_wb_pipe3_wb_preg_vld_dupx       (lsu_idu_wb_pipe3_wb_preg_vld_dupx      ),
  .pad_yy_icg_scan_en                      (pad_yy_icg_scan_en                     ),
  .rtu_idu_flush_fe                        (rtu_idu_flush_fe                       ),
  .rtu_idu_flush_is                        (rtu_idu_flush_is                       ),
  .vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe6_preg_dupx            (vfpu_idu_ex1_pipe6_preg_dupx           ),
  .vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe7_preg_dupx            (vfpu_idu_ex1_pipe7_preg_dupx           ),
  .x_agevec                                (miq_entry3_agevec                      ),
  .x_alu0_reg_fwd_vld                      (miq_entry3_alu0_reg_fwd_vld            ),
  .x_alu1_reg_fwd_vld                      (miq_entry3_alu1_reg_fwd_vld            ),
  .x_create_agevec                         (miq_entry3_create_agevec               ),
  .x_create_data                           (miq_entry3_create_data                 ),
  .x_create_dp_en                          (miq_entry3_create_dp_en                ),
  .x_create_en                             (miq_entry3_create_en                   ),
  .x_create_frz                            (miq_entry3_create_frz                  ),
  .x_create_gateclk_en                     (miq_entry3_create_gateclk_en           ),
  .x_frz_clr                               (miq_entry3_frz_clr                     ),
  .x_issue_en                              (miq_entry3_issue_en                    ),
  .x_pop_cur_entry                         (miq_entry3_pop_cur_entry               ),
  .x_pop_other_entry                       (miq_entry3_pop_other_entry             ),
  .x_rdy                                   (miq_entry3_rdy                         ),
  .x_read_data                             (miq_entry3_read_data                   ),
  .x_vld                                   (miq_entry3_vld                         ),
  .x_vld_with_frz                          (miq_entry3_vld_with_frz                )
);


// &ConnRule(s/^x_/miq_entry4_/); @766
// &Instance("ct_idu_is_miq_entry", "x_ct_idu_is_miq_entry4"); @767
ct_idu_is_miq_entry  x_ct_idu_is_miq_entry4 (
  .cp0_idu_icg_en                          (cp0_idu_icg_en                         ),
  .cp0_yy_clk_en                           (cp0_yy_clk_en                          ),
  .cpurst_b                                (cpurst_b                               ),
  .ctrl_miq_rf_pop_vld                     (ctrl_miq_rf_pop_vld                    ),
  .ctrl_xx_rf_pipe0_preg_lch_vld_dupx      (ctrl_xx_rf_pipe0_preg_lch_vld_dupx     ),
  .ctrl_xx_rf_pipe1_preg_lch_vld_dupx      (ctrl_xx_rf_pipe1_preg_lch_vld_dupx     ),
  .dp_miq_rf_rdy_clr                       (dp_miq_rf_rdy_clr                      ),
  .dp_xx_rf_pipe0_dst_preg_dupx            (dp_xx_rf_pipe0_dst_preg_dupx           ),
  .dp_xx_rf_pipe1_dst_preg_dupx            (dp_xx_rf_pipe1_dst_preg_dupx           ),
  .forever_cpuclk                          (forever_cpuclk                         ),
  .iu_idu_div_inst_vld                     (iu_idu_div_inst_vld                    ),
  .iu_idu_div_preg_dupx                    (iu_idu_div_preg_dupx                   ),
  .iu_idu_ex2_pipe0_wb_preg_dupx           (iu_idu_ex2_pipe0_wb_preg_dupx          ),
  .iu_idu_ex2_pipe0_wb_preg_vld_dupx       (iu_idu_ex2_pipe0_wb_preg_vld_dupx      ),
  .iu_idu_ex2_pipe1_mult_inst_vld_dupx     (iu_idu_ex2_pipe1_mult_inst_vld_dupx    ),
  .iu_idu_ex2_pipe1_preg_dupx              (iu_idu_ex2_pipe1_preg_dupx             ),
  .iu_idu_ex2_pipe1_wb_preg_dupx           (iu_idu_ex2_pipe1_wb_preg_dupx          ),
  .iu_idu_ex2_pipe1_wb_preg_vld_dupx       (iu_idu_ex2_pipe1_wb_preg_vld_dupx      ),
  .lsu_idu_ag_pipe3_load_inst_vld          (lsu_idu_ag_pipe3_load_inst_vld         ),
  .lsu_idu_ag_pipe3_preg_dupx              (lsu_idu_ag_pipe3_preg_dupx             ),
  .lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx (lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx),
  .lsu_idu_dc_pipe3_load_inst_vld_dupx     (lsu_idu_dc_pipe3_load_inst_vld_dupx    ),
  .lsu_idu_dc_pipe3_preg_dupx              (lsu_idu_dc_pipe3_preg_dupx             ),
  .lsu_idu_wb_pipe3_wb_preg_dupx           (lsu_idu_wb_pipe3_wb_preg_dupx          ),
  .lsu_idu_wb_pipe3_wb_preg_vld_dupx       (lsu_idu_wb_pipe3_wb_preg_vld_dupx      ),
  .pad_yy_icg_scan_en                      (pad_yy_icg_scan_en                     ),
  .rtu_idu_flush_fe                        (rtu_idu_flush_fe                       ),
  .rtu_idu_flush_is                        (rtu_idu_flush_is                       ),
  .vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe6_preg_dupx            (vfpu_idu_ex1_pipe6_preg_dupx           ),
  .vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe7_preg_dupx            (vfpu_idu_ex1_pipe7_preg_dupx           ),
  .x_agevec                                (miq_entry4_agevec                      ),
  .x_alu0_reg_fwd_vld                      (miq_entry4_alu0_reg_fwd_vld            ),
  .x_alu1_reg_fwd_vld                      (miq_entry4_alu1_reg_fwd_vld            ),
  .x_create_agevec                         (miq_entry4_create_agevec               ),
  .x_create_data                           (miq_entry4_create_data                 ),
  .x_create_dp_en                          (miq_entry4_create_dp_en                ),
  .x_create_en                             (miq_entry4_create_en                   ),
  .x_create_frz                            (miq_entry4_create_frz                  ),
  .x_create_gateclk_en                     (miq_entry4_create_gateclk_en           ),
  .x_frz_clr                               (miq_entry4_frz_clr                     ),
  .x_issue_en                              (miq_entry4_issue_en                    ),
  .x_pop_cur_entry                         (miq_entry4_pop_cur_entry               ),
  .x_pop_other_entry                       (miq_entry4_pop_other_entry             ),
  .x_rdy                                   (miq_entry4_rdy                         ),
  .x_read_data                             (miq_entry4_read_data                   ),
  .x_vld                                   (miq_entry4_vld                         ),
  .x_vld_with_frz                          (miq_entry4_vld_with_frz                )
);


// &ConnRule(s/^x_/miq_entry5_/); @769
// &Instance("ct_idu_is_miq_entry", "x_ct_idu_is_miq_entry5"); @770
ct_idu_is_miq_entry  x_ct_idu_is_miq_entry5 (
  .cp0_idu_icg_en                          (cp0_idu_icg_en                         ),
  .cp0_yy_clk_en                           (cp0_yy_clk_en                          ),
  .cpurst_b                                (cpurst_b                               ),
  .ctrl_miq_rf_pop_vld                     (ctrl_miq_rf_pop_vld                    ),
  .ctrl_xx_rf_pipe0_preg_lch_vld_dupx      (ctrl_xx_rf_pipe0_preg_lch_vld_dupx     ),
  .ctrl_xx_rf_pipe1_preg_lch_vld_dupx      (ctrl_xx_rf_pipe1_preg_lch_vld_dupx     ),
  .dp_miq_rf_rdy_clr                       (dp_miq_rf_rdy_clr                      ),
  .dp_xx_rf_pipe0_dst_preg_dupx            (dp_xx_rf_pipe0_dst_preg_dupx           ),
  .dp_xx_rf_pipe1_dst_preg_dupx            (dp_xx_rf_pipe1_dst_preg_dupx           ),
  .forever_cpuclk                          (forever_cpuclk                         ),
  .iu_idu_div_inst_vld                     (iu_idu_div_inst_vld                    ),
  .iu_idu_div_preg_dupx                    (iu_idu_div_preg_dupx                   ),
  .iu_idu_ex2_pipe0_wb_preg_dupx           (iu_idu_ex2_pipe0_wb_preg_dupx          ),
  .iu_idu_ex2_pipe0_wb_preg_vld_dupx       (iu_idu_ex2_pipe0_wb_preg_vld_dupx      ),
  .iu_idu_ex2_pipe1_mult_inst_vld_dupx     (iu_idu_ex2_pipe1_mult_inst_vld_dupx    ),
  .iu_idu_ex2_pipe1_preg_dupx              (iu_idu_ex2_pipe1_preg_dupx             ),
  .iu_idu_ex2_pipe1_wb_preg_dupx           (iu_idu_ex2_pipe1_wb_preg_dupx          ),
  .iu_idu_ex2_pipe1_wb_preg_vld_dupx       (iu_idu_ex2_pipe1_wb_preg_vld_dupx      ),
  .lsu_idu_ag_pipe3_load_inst_vld          (lsu_idu_ag_pipe3_load_inst_vld         ),
  .lsu_idu_ag_pipe3_preg_dupx              (lsu_idu_ag_pipe3_preg_dupx             ),
  .lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx (lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx),
  .lsu_idu_dc_pipe3_load_inst_vld_dupx     (lsu_idu_dc_pipe3_load_inst_vld_dupx    ),
  .lsu_idu_dc_pipe3_preg_dupx              (lsu_idu_dc_pipe3_preg_dupx             ),
  .lsu_idu_wb_pipe3_wb_preg_dupx           (lsu_idu_wb_pipe3_wb_preg_dupx          ),
  .lsu_idu_wb_pipe3_wb_preg_vld_dupx       (lsu_idu_wb_pipe3_wb_preg_vld_dupx      ),
  .pad_yy_icg_scan_en                      (pad_yy_icg_scan_en                     ),
  .rtu_idu_flush_fe                        (rtu_idu_flush_fe                       ),
  .rtu_idu_flush_is                        (rtu_idu_flush_is                       ),
  .vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe6_preg_dupx            (vfpu_idu_ex1_pipe6_preg_dupx           ),
  .vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe7_preg_dupx            (vfpu_idu_ex1_pipe7_preg_dupx           ),
  .x_agevec                                (miq_entry5_agevec                      ),
  .x_alu0_reg_fwd_vld                      (miq_entry5_alu0_reg_fwd_vld            ),
  .x_alu1_reg_fwd_vld                      (miq_entry5_alu1_reg_fwd_vld            ),
  .x_create_agevec                         (miq_entry5_create_agevec               ),
  .x_create_data                           (miq_entry5_create_data                 ),
  .x_create_dp_en                          (miq_entry5_create_dp_en                ),
  .x_create_en                             (miq_entry5_create_en                   ),
  .x_create_frz                            (miq_entry5_create_frz                  ),
  .x_create_gateclk_en                     (miq_entry5_create_gateclk_en           ),
  .x_frz_clr                               (miq_entry5_frz_clr                     ),
  .x_issue_en                              (miq_entry5_issue_en                    ),
  .x_pop_cur_entry                         (miq_entry5_pop_cur_entry               ),
  .x_pop_other_entry                       (miq_entry5_pop_other_entry             ),
  .x_rdy                                   (miq_entry5_rdy                         ),
  .x_read_data                             (miq_entry5_read_data                   ),
  .x_vld                                   (miq_entry5_vld                         ),
  .x_vld_with_frz                          (miq_entry5_vld_with_frz                )
);


// &ConnRule(s/^x_/miq_entry6_/); @772
// &Instance("ct_idu_is_miq_entry", "x_ct_idu_is_miq_entry6"); @773
ct_idu_is_miq_entry  x_ct_idu_is_miq_entry6 (
  .cp0_idu_icg_en                          (cp0_idu_icg_en                         ),
  .cp0_yy_clk_en                           (cp0_yy_clk_en                          ),
  .cpurst_b                                (cpurst_b                               ),
  .ctrl_miq_rf_pop_vld                     (ctrl_miq_rf_pop_vld                    ),
  .ctrl_xx_rf_pipe0_preg_lch_vld_dupx      (ctrl_xx_rf_pipe0_preg_lch_vld_dupx     ),
  .ctrl_xx_rf_pipe1_preg_lch_vld_dupx      (ctrl_xx_rf_pipe1_preg_lch_vld_dupx     ),
  .dp_miq_rf_rdy_clr                       (dp_miq_rf_rdy_clr                      ),
  .dp_xx_rf_pipe0_dst_preg_dupx            (dp_xx_rf_pipe0_dst_preg_dupx           ),
  .dp_xx_rf_pipe1_dst_preg_dupx            (dp_xx_rf_pipe1_dst_preg_dupx           ),
  .forever_cpuclk                          (forever_cpuclk                         ),
  .iu_idu_div_inst_vld                     (iu_idu_div_inst_vld                    ),
  .iu_idu_div_preg_dupx                    (iu_idu_div_preg_dupx                   ),
  .iu_idu_ex2_pipe0_wb_preg_dupx           (iu_idu_ex2_pipe0_wb_preg_dupx          ),
  .iu_idu_ex2_pipe0_wb_preg_vld_dupx       (iu_idu_ex2_pipe0_wb_preg_vld_dupx      ),
  .iu_idu_ex2_pipe1_mult_inst_vld_dupx     (iu_idu_ex2_pipe1_mult_inst_vld_dupx    ),
  .iu_idu_ex2_pipe1_preg_dupx              (iu_idu_ex2_pipe1_preg_dupx             ),
  .iu_idu_ex2_pipe1_wb_preg_dupx           (iu_idu_ex2_pipe1_wb_preg_dupx          ),
  .iu_idu_ex2_pipe1_wb_preg_vld_dupx       (iu_idu_ex2_pipe1_wb_preg_vld_dupx      ),
  .lsu_idu_ag_pipe3_load_inst_vld          (lsu_idu_ag_pipe3_load_inst_vld         ),
  .lsu_idu_ag_pipe3_preg_dupx              (lsu_idu_ag_pipe3_preg_dupx             ),
  .lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx (lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx),
  .lsu_idu_dc_pipe3_load_inst_vld_dupx     (lsu_idu_dc_pipe3_load_inst_vld_dupx    ),
  .lsu_idu_dc_pipe3_preg_dupx              (lsu_idu_dc_pipe3_preg_dupx             ),
  .lsu_idu_wb_pipe3_wb_preg_dupx           (lsu_idu_wb_pipe3_wb_preg_dupx          ),
  .lsu_idu_wb_pipe3_wb_preg_vld_dupx       (lsu_idu_wb_pipe3_wb_preg_vld_dupx      ),
  .pad_yy_icg_scan_en                      (pad_yy_icg_scan_en                     ),
  .rtu_idu_flush_fe                        (rtu_idu_flush_fe                       ),
  .rtu_idu_flush_is                        (rtu_idu_flush_is                       ),
  .vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe6_preg_dupx            (vfpu_idu_ex1_pipe6_preg_dupx           ),
  .vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe7_preg_dupx            (vfpu_idu_ex1_pipe7_preg_dupx           ),
  .x_agevec                                (miq_entry6_agevec                      ),
  .x_alu0_reg_fwd_vld                      (miq_entry6_alu0_reg_fwd_vld            ),
  .x_alu1_reg_fwd_vld                      (miq_entry6_alu1_reg_fwd_vld            ),
  .x_create_agevec                         (miq_entry6_create_agevec               ),
  .x_create_data                           (miq_entry6_create_data                 ),
  .x_create_dp_en                          (miq_entry6_create_dp_en                ),
  .x_create_en                             (miq_entry6_create_en                   ),
  .x_create_frz                            (miq_entry6_create_frz                  ),
  .x_create_gateclk_en                     (miq_entry6_create_gateclk_en           ),
  .x_frz_clr                               (miq_entry6_frz_clr                     ),
  .x_issue_en                              (miq_entry6_issue_en                    ),
  .x_pop_cur_entry                         (miq_entry6_pop_cur_entry               ),
  .x_pop_other_entry                       (miq_entry6_pop_other_entry             ),
  .x_rdy                                   (miq_entry6_rdy                         ),
  .x_read_data                             (miq_entry6_read_data                   ),
  .x_vld                                   (miq_entry6_vld                         ),
  .x_vld_with_frz                          (miq_entry6_vld_with_frz                )
);


// &ConnRule(s/^x_/miq_entry7_/); @775
// &Instance("ct_idu_is_miq_entry", "x_ct_idu_is_miq_entry7"); @776
ct_idu_is_miq_entry  x_ct_idu_is_miq_entry7 (
  .cp0_idu_icg_en                          (cp0_idu_icg_en                         ),
  .cp0_yy_clk_en                           (cp0_yy_clk_en                          ),
  .cpurst_b                                (cpurst_b                               ),
  .ctrl_miq_rf_pop_vld                     (ctrl_miq_rf_pop_vld                    ),
  .ctrl_xx_rf_pipe0_preg_lch_vld_dupx      (ctrl_xx_rf_pipe0_preg_lch_vld_dupx     ),
  .ctrl_xx_rf_pipe1_preg_lch_vld_dupx      (ctrl_xx_rf_pipe1_preg_lch_vld_dupx     ),
  .dp_miq_rf_rdy_clr                       (dp_miq_rf_rdy_clr                      ),
  .dp_xx_rf_pipe0_dst_preg_dupx            (dp_xx_rf_pipe0_dst_preg_dupx           ),
  .dp_xx_rf_pipe1_dst_preg_dupx            (dp_xx_rf_pipe1_dst_preg_dupx           ),
  .forever_cpuclk                          (forever_cpuclk                         ),
  .iu_idu_div_inst_vld                     (iu_idu_div_inst_vld                    ),
  .iu_idu_div_preg_dupx                    (iu_idu_div_preg_dupx                   ),
  .iu_idu_ex2_pipe0_wb_preg_dupx           (iu_idu_ex2_pipe0_wb_preg_dupx          ),
  .iu_idu_ex2_pipe0_wb_preg_vld_dupx       (iu_idu_ex2_pipe0_wb_preg_vld_dupx      ),
  .iu_idu_ex2_pipe1_mult_inst_vld_dupx     (iu_idu_ex2_pipe1_mult_inst_vld_dupx    ),
  .iu_idu_ex2_pipe1_preg_dupx              (iu_idu_ex2_pipe1_preg_dupx             ),
  .iu_idu_ex2_pipe1_wb_preg_dupx           (iu_idu_ex2_pipe1_wb_preg_dupx          ),
  .iu_idu_ex2_pipe1_wb_preg_vld_dupx       (iu_idu_ex2_pipe1_wb_preg_vld_dupx      ),
  .lsu_idu_ag_pipe3_load_inst_vld          (lsu_idu_ag_pipe3_load_inst_vld         ),
  .lsu_idu_ag_pipe3_preg_dupx              (lsu_idu_ag_pipe3_preg_dupx             ),
  .lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx (lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx),
  .lsu_idu_dc_pipe3_load_inst_vld_dupx     (lsu_idu_dc_pipe3_load_inst_vld_dupx    ),
  .lsu_idu_dc_pipe3_preg_dupx              (lsu_idu_dc_pipe3_preg_dupx             ),
  .lsu_idu_wb_pipe3_wb_preg_dupx           (lsu_idu_wb_pipe3_wb_preg_dupx          ),
  .lsu_idu_wb_pipe3_wb_preg_vld_dupx       (lsu_idu_wb_pipe3_wb_preg_vld_dupx      ),
  .pad_yy_icg_scan_en                      (pad_yy_icg_scan_en                     ),
  .rtu_idu_flush_fe                        (rtu_idu_flush_fe                       ),
  .rtu_idu_flush_is                        (rtu_idu_flush_is                       ),
  .vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe6_preg_dupx            (vfpu_idu_ex1_pipe6_preg_dupx           ),
  .vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe7_preg_dupx            (vfpu_idu_ex1_pipe7_preg_dupx           ),
  .x_agevec                                (miq_entry7_agevec                      ),
  .x_alu0_reg_fwd_vld                      (miq_entry7_alu0_reg_fwd_vld            ),
  .x_alu1_reg_fwd_vld                      (miq_entry7_alu1_reg_fwd_vld            ),
  .x_create_agevec                         (miq_entry7_create_agevec               ),
  .x_create_data                           (miq_entry7_create_data                 ),
  .x_create_dp_en                          (miq_entry7_create_dp_en                ),
  .x_create_en                             (miq_entry7_create_en                   ),
  .x_create_frz                            (miq_entry7_create_frz                  ),
  .x_create_gateclk_en                     (miq_entry7_create_gateclk_en           ),
  .x_frz_clr                               (miq_entry7_frz_clr                     ),
  .x_issue_en                              (miq_entry7_issue_en                    ),
  .x_pop_cur_entry                         (miq_entry7_pop_cur_entry               ),
  .x_pop_other_entry                       (miq_entry7_pop_other_entry             ),
  .x_rdy                                   (miq_entry7_rdy                         ),
  .x_read_data                             (miq_entry7_read_data                   ),
  .x_vld                                   (miq_entry7_vld                         ),
  .x_vld_with_frz                          (miq_entry7_vld_with_frz                )
);


// &ConnRule(s/^x_/miq_entry8_/); @778
// &Instance("ct_idu_is_miq_entry", "x_ct_idu_is_miq_entry8"); @779
ct_idu_is_miq_entry  x_ct_idu_is_miq_entry8 (
  .cp0_idu_icg_en                          (cp0_idu_icg_en                         ),
  .cp0_yy_clk_en                           (cp0_yy_clk_en                          ),
  .cpurst_b                                (cpurst_b                               ),
  .ctrl_miq_rf_pop_vld                     (ctrl_miq_rf_pop_vld                    ),
  .ctrl_xx_rf_pipe0_preg_lch_vld_dupx      (ctrl_xx_rf_pipe0_preg_lch_vld_dupx     ),
  .ctrl_xx_rf_pipe1_preg_lch_vld_dupx      (ctrl_xx_rf_pipe1_preg_lch_vld_dupx     ),
  .dp_miq_rf_rdy_clr                       (dp_miq_rf_rdy_clr                      ),
  .dp_xx_rf_pipe0_dst_preg_dupx            (dp_xx_rf_pipe0_dst_preg_dupx           ),
  .dp_xx_rf_pipe1_dst_preg_dupx            (dp_xx_rf_pipe1_dst_preg_dupx           ),
  .forever_cpuclk                          (forever_cpuclk                         ),
  .iu_idu_div_inst_vld                     (iu_idu_div_inst_vld                    ),
  .iu_idu_div_preg_dupx                    (iu_idu_div_preg_dupx                   ),
  .iu_idu_ex2_pipe0_wb_preg_dupx           (iu_idu_ex2_pipe0_wb_preg_dupx          ),
  .iu_idu_ex2_pipe0_wb_preg_vld_dupx       (iu_idu_ex2_pipe0_wb_preg_vld_dupx      ),
  .iu_idu_ex2_pipe1_mult_inst_vld_dupx     (iu_idu_ex2_pipe1_mult_inst_vld_dupx    ),
  .iu_idu_ex2_pipe1_preg_dupx              (iu_idu_ex2_pipe1_preg_dupx             ),
  .iu_idu_ex2_pipe1_wb_preg_dupx           (iu_idu_ex2_pipe1_wb_preg_dupx          ),
  .iu_idu_ex2_pipe1_wb_preg_vld_dupx       (iu_idu_ex2_pipe1_wb_preg_vld_dupx      ),
  .lsu_idu_ag_pipe3_load_inst_vld          (lsu_idu_ag_pipe3_load_inst_vld         ),
  .lsu_idu_ag_pipe3_preg_dupx              (lsu_idu_ag_pipe3_preg_dupx             ),
  .lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx (lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx),
  .lsu_idu_dc_pipe3_load_inst_vld_dupx     (lsu_idu_dc_pipe3_load_inst_vld_dupx    ),
  .lsu_idu_dc_pipe3_preg_dupx              (lsu_idu_dc_pipe3_preg_dupx             ),
  .lsu_idu_wb_pipe3_wb_preg_dupx           (lsu_idu_wb_pipe3_wb_preg_dupx          ),
  .lsu_idu_wb_pipe3_wb_preg_vld_dupx       (lsu_idu_wb_pipe3_wb_preg_vld_dupx      ),
  .pad_yy_icg_scan_en                      (pad_yy_icg_scan_en                     ),
  .rtu_idu_flush_fe                        (rtu_idu_flush_fe                       ),
  .rtu_idu_flush_is                        (rtu_idu_flush_is                       ),
  .vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe6_preg_dupx            (vfpu_idu_ex1_pipe6_preg_dupx           ),
  .vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe7_preg_dupx            (vfpu_idu_ex1_pipe7_preg_dupx           ),
  .x_agevec                                (miq_entry8_agevec                      ),
  .x_alu0_reg_fwd_vld                      (miq_entry8_alu0_reg_fwd_vld            ),
  .x_alu1_reg_fwd_vld                      (miq_entry8_alu1_reg_fwd_vld            ),
  .x_create_agevec                         (miq_entry8_create_agevec               ),
  .x_create_data                           (miq_entry8_create_data                 ),
  .x_create_dp_en                          (miq_entry8_create_dp_en                ),
  .x_create_en                             (miq_entry8_create_en                   ),
  .x_create_frz                            (miq_entry8_create_frz                  ),
  .x_create_gateclk_en                     (miq_entry8_create_gateclk_en           ),
  .x_frz_clr                               (miq_entry8_frz_clr                     ),
  .x_issue_en                              (miq_entry8_issue_en                    ),
  .x_pop_cur_entry                         (miq_entry8_pop_cur_entry               ),
  .x_pop_other_entry                       (miq_entry8_pop_other_entry             ),
  .x_rdy                                   (miq_entry8_rdy                         ),
  .x_read_data                             (miq_entry8_read_data                   ),
  .x_vld                                   (miq_entry8_vld                         ),
  .x_vld_with_frz                          (miq_entry8_vld_with_frz                )
);


ct_idu_is_miq_entry  x_ct_idu_is_miq_entry9 (
  .cp0_idu_icg_en                          (cp0_idu_icg_en                         ),
  .cp0_yy_clk_en                           (cp0_yy_clk_en                          ),
  .cpurst_b                                (cpurst_b                               ),
  .ctrl_miq_rf_pop_vld                     (ctrl_miq_rf_pop_vld                    ),
  .ctrl_xx_rf_pipe0_preg_lch_vld_dupx      (ctrl_xx_rf_pipe0_preg_lch_vld_dupx     ),
  .ctrl_xx_rf_pipe1_preg_lch_vld_dupx      (ctrl_xx_rf_pipe1_preg_lch_vld_dupx     ),
  .dp_miq_rf_rdy_clr                       (dp_miq_rf_rdy_clr                      ),
  .dp_xx_rf_pipe0_dst_preg_dupx            (dp_xx_rf_pipe0_dst_preg_dupx           ),
  .dp_xx_rf_pipe1_dst_preg_dupx            (dp_xx_rf_pipe1_dst_preg_dupx           ),
  .forever_cpuclk                          (forever_cpuclk                         ),
  .iu_idu_div_inst_vld                     (iu_idu_div_inst_vld                    ),
  .iu_idu_div_preg_dupx                    (iu_idu_div_preg_dupx                   ),
  .iu_idu_ex2_pipe0_wb_preg_dupx           (iu_idu_ex2_pipe0_wb_preg_dupx          ),
  .iu_idu_ex2_pipe0_wb_preg_vld_dupx       (iu_idu_ex2_pipe0_wb_preg_vld_dupx      ),
  .iu_idu_ex2_pipe1_mult_inst_vld_dupx     (iu_idu_ex2_pipe1_mult_inst_vld_dupx    ),
  .iu_idu_ex2_pipe1_preg_dupx              (iu_idu_ex2_pipe1_preg_dupx             ),
  .iu_idu_ex2_pipe1_wb_preg_dupx           (iu_idu_ex2_pipe1_wb_preg_dupx          ),
  .iu_idu_ex2_pipe1_wb_preg_vld_dupx       (iu_idu_ex2_pipe1_wb_preg_vld_dupx      ),
  .lsu_idu_ag_pipe3_load_inst_vld          (lsu_idu_ag_pipe3_load_inst_vld         ),
  .lsu_idu_ag_pipe3_preg_dupx              (lsu_idu_ag_pipe3_preg_dupx             ),
  .lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx (lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx),
  .lsu_idu_dc_pipe3_load_inst_vld_dupx     (lsu_idu_dc_pipe3_load_inst_vld_dupx    ),
  .lsu_idu_dc_pipe3_preg_dupx              (lsu_idu_dc_pipe3_preg_dupx             ),
  .lsu_idu_wb_pipe3_wb_preg_dupx           (lsu_idu_wb_pipe3_wb_preg_dupx          ),
  .lsu_idu_wb_pipe3_wb_preg_vld_dupx       (lsu_idu_wb_pipe3_wb_preg_vld_dupx      ),
  .pad_yy_icg_scan_en                      (pad_yy_icg_scan_en                     ),
  .rtu_idu_flush_fe                        (rtu_idu_flush_fe                       ),
  .rtu_idu_flush_is                        (rtu_idu_flush_is                       ),
  .vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe6_preg_dupx            (vfpu_idu_ex1_pipe6_preg_dupx           ),
  .vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe7_preg_dupx            (vfpu_idu_ex1_pipe7_preg_dupx           ),
  .x_agevec                                (miq_entry9_agevec                      ),
  .x_alu0_reg_fwd_vld                      (miq_entry9_alu0_reg_fwd_vld            ),
  .x_alu1_reg_fwd_vld                      (miq_entry9_alu1_reg_fwd_vld            ),
  .x_create_agevec                         (miq_entry9_create_agevec               ),
  .x_create_data                           (miq_entry9_create_data                 ),
  .x_create_dp_en                          (miq_entry9_create_dp_en                ),
  .x_create_en                             (miq_entry9_create_en                   ),
  .x_create_frz                            (miq_entry9_create_frz                  ),
  .x_create_gateclk_en                     (miq_entry9_create_gateclk_en           ),
  .x_frz_clr                               (miq_entry9_frz_clr                     ),
  .x_issue_en                              (miq_entry9_issue_en                    ),
  .x_pop_cur_entry                         (miq_entry9_pop_cur_entry               ),
  .x_pop_other_entry                       (miq_entry9_pop_other_entry             ),
  .x_rdy                                   (miq_entry9_rdy                         ),
  .x_read_data                             (miq_entry9_read_data                   ),
  .x_vld                                   (miq_entry9_vld                         ),
  .x_vld_with_frz                          (miq_entry9_vld_with_frz                )
);


// &ConnRule(s/^x_/miq_entry10_/); @784
// &Instance("ct_idu_is_miq_entry", "x_ct_idu_is_miq_entry10"); @785
ct_idu_is_miq_entry  x_ct_idu_is_miq_entry10 (
  .cp0_idu_icg_en                          (cp0_idu_icg_en                         ),
  .cp0_yy_clk_en                           (cp0_yy_clk_en                          ),
  .cpurst_b                                (cpurst_b                               ),
  .ctrl_miq_rf_pop_vld                     (ctrl_miq_rf_pop_vld                    ),
  .ctrl_xx_rf_pipe0_preg_lch_vld_dupx      (ctrl_xx_rf_pipe0_preg_lch_vld_dupx     ),
  .ctrl_xx_rf_pipe1_preg_lch_vld_dupx      (ctrl_xx_rf_pipe1_preg_lch_vld_dupx     ),
  .dp_miq_rf_rdy_clr                       (dp_miq_rf_rdy_clr                      ),
  .dp_xx_rf_pipe0_dst_preg_dupx            (dp_xx_rf_pipe0_dst_preg_dupx           ),
  .dp_xx_rf_pipe1_dst_preg_dupx            (dp_xx_rf_pipe1_dst_preg_dupx           ),
  .forever_cpuclk                          (forever_cpuclk                         ),
  .iu_idu_div_inst_vld                     (iu_idu_div_inst_vld                    ),
  .iu_idu_div_preg_dupx                    (iu_idu_div_preg_dupx                   ),
  .iu_idu_ex2_pipe0_wb_preg_dupx           (iu_idu_ex2_pipe0_wb_preg_dupx          ),
  .iu_idu_ex2_pipe0_wb_preg_vld_dupx       (iu_idu_ex2_pipe0_wb_preg_vld_dupx      ),
  .iu_idu_ex2_pipe1_mult_inst_vld_dupx     (iu_idu_ex2_pipe1_mult_inst_vld_dupx    ),
  .iu_idu_ex2_pipe1_preg_dupx              (iu_idu_ex2_pipe1_preg_dupx             ),
  .iu_idu_ex2_pipe1_wb_preg_dupx           (iu_idu_ex2_pipe1_wb_preg_dupx          ),
  .iu_idu_ex2_pipe1_wb_preg_vld_dupx       (iu_idu_ex2_pipe1_wb_preg_vld_dupx      ),
  .lsu_idu_ag_pipe3_load_inst_vld          (lsu_idu_ag_pipe3_load_inst_vld         ),
  .lsu_idu_ag_pipe3_preg_dupx              (lsu_idu_ag_pipe3_preg_dupx             ),
  .lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx (lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx),
  .lsu_idu_dc_pipe3_load_inst_vld_dupx     (lsu_idu_dc_pipe3_load_inst_vld_dupx    ),
  .lsu_idu_dc_pipe3_preg_dupx              (lsu_idu_dc_pipe3_preg_dupx             ),
  .lsu_idu_wb_pipe3_wb_preg_dupx           (lsu_idu_wb_pipe3_wb_preg_dupx          ),
  .lsu_idu_wb_pipe3_wb_preg_vld_dupx       (lsu_idu_wb_pipe3_wb_preg_vld_dupx      ),
  .pad_yy_icg_scan_en                      (pad_yy_icg_scan_en                     ),
  .rtu_idu_flush_fe                        (rtu_idu_flush_fe                       ),
  .rtu_idu_flush_is                        (rtu_idu_flush_is                       ),
  .vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe6_preg_dupx            (vfpu_idu_ex1_pipe6_preg_dupx           ),
  .vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe7_preg_dupx            (vfpu_idu_ex1_pipe7_preg_dupx           ),
  .x_agevec                                (miq_entry10_agevec                     ),
  .x_alu0_reg_fwd_vld                      (miq_entry10_alu0_reg_fwd_vld           ),
  .x_alu1_reg_fwd_vld                      (miq_entry10_alu1_reg_fwd_vld           ),
  .x_create_agevec                         (miq_entry10_create_agevec              ),
  .x_create_data                           (miq_entry10_create_data                ),
  .x_create_dp_en                          (miq_entry10_create_dp_en               ),
  .x_create_en                             (miq_entry10_create_en                  ),
  .x_create_frz                            (miq_entry10_create_frz                 ),
  .x_create_gateclk_en                     (miq_entry10_create_gateclk_en          ),
  .x_frz_clr                               (miq_entry10_frz_clr                    ),
  .x_issue_en                              (miq_entry10_issue_en                   ),
  .x_pop_cur_entry                         (miq_entry10_pop_cur_entry              ),
  .x_pop_other_entry                       (miq_entry10_pop_other_entry            ),
  .x_rdy                                   (miq_entry10_rdy                        ),
  .x_read_data                             (miq_entry10_read_data                  ),
  .x_vld                                   (miq_entry10_vld                        ),
  .x_vld_with_frz                          (miq_entry10_vld_with_frz               )
);


// &ConnRule(s/^x_/miq_entry11_/); @787
// &Instance("ct_idu_is_miq_entry", "x_ct_idu_is_miq_entry11"); @788
ct_idu_is_miq_entry  x_ct_idu_is_miq_entry11 (
  .cp0_idu_icg_en                          (cp0_idu_icg_en                         ),
  .cp0_yy_clk_en                           (cp0_yy_clk_en                          ),
  .cpurst_b                                (cpurst_b                               ),
  .ctrl_miq_rf_pop_vld                     (ctrl_miq_rf_pop_vld                    ),
  .ctrl_xx_rf_pipe0_preg_lch_vld_dupx      (ctrl_xx_rf_pipe0_preg_lch_vld_dupx     ),
  .ctrl_xx_rf_pipe1_preg_lch_vld_dupx      (ctrl_xx_rf_pipe1_preg_lch_vld_dupx     ),
  .dp_miq_rf_rdy_clr                       (dp_miq_rf_rdy_clr                      ),
  .dp_xx_rf_pipe0_dst_preg_dupx            (dp_xx_rf_pipe0_dst_preg_dupx           ),
  .dp_xx_rf_pipe1_dst_preg_dupx            (dp_xx_rf_pipe1_dst_preg_dupx           ),
  .forever_cpuclk                          (forever_cpuclk                         ),
  .iu_idu_div_inst_vld                     (iu_idu_div_inst_vld                    ),
  .iu_idu_div_preg_dupx                    (iu_idu_div_preg_dupx                   ),
  .iu_idu_ex2_pipe0_wb_preg_dupx           (iu_idu_ex2_pipe0_wb_preg_dupx          ),
  .iu_idu_ex2_pipe0_wb_preg_vld_dupx       (iu_idu_ex2_pipe0_wb_preg_vld_dupx      ),
  .iu_idu_ex2_pipe1_mult_inst_vld_dupx     (iu_idu_ex2_pipe1_mult_inst_vld_dupx    ),
  .iu_idu_ex2_pipe1_preg_dupx              (iu_idu_ex2_pipe1_preg_dupx             ),
  .iu_idu_ex2_pipe1_wb_preg_dupx           (iu_idu_ex2_pipe1_wb_preg_dupx          ),
  .iu_idu_ex2_pipe1_wb_preg_vld_dupx       (iu_idu_ex2_pipe1_wb_preg_vld_dupx      ),
  .lsu_idu_ag_pipe3_load_inst_vld          (lsu_idu_ag_pipe3_load_inst_vld         ),
  .lsu_idu_ag_pipe3_preg_dupx              (lsu_idu_ag_pipe3_preg_dupx             ),
  .lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx (lsu_idu_dc_pipe3_load_fwd_inst_vld_dupx),
  .lsu_idu_dc_pipe3_load_inst_vld_dupx     (lsu_idu_dc_pipe3_load_inst_vld_dupx    ),
  .lsu_idu_dc_pipe3_preg_dupx              (lsu_idu_dc_pipe3_preg_dupx             ),
  .lsu_idu_wb_pipe3_wb_preg_dupx           (lsu_idu_wb_pipe3_wb_preg_dupx          ),
  .lsu_idu_wb_pipe3_wb_preg_vld_dupx       (lsu_idu_wb_pipe3_wb_preg_vld_dupx      ),
  .pad_yy_icg_scan_en                      (pad_yy_icg_scan_en                     ),
  .rtu_idu_flush_fe                        (rtu_idu_flush_fe                       ),
  .rtu_idu_flush_is                        (rtu_idu_flush_is                       ),
  .vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe6_preg_dupx            (vfpu_idu_ex1_pipe6_preg_dupx           ),
  .vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx   (vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx  ),
  .vfpu_idu_ex1_pipe7_preg_dupx            (vfpu_idu_ex1_pipe7_preg_dupx           ),
  .x_agevec                                (miq_entry11_agevec                     ),
  .x_alu0_reg_fwd_vld                      (miq_entry11_alu0_reg_fwd_vld           ),
  .x_alu1_reg_fwd_vld                      (miq_entry11_alu1_reg_fwd_vld           ),
  .x_create_agevec                         (miq_entry11_create_agevec              ),
  .x_create_data                           (miq_entry11_create_data                ),
  .x_create_dp_en                          (miq_entry11_create_dp_en               ),
  .x_create_en                             (miq_entry11_create_en                  ),
  .x_create_frz                            (miq_entry11_create_frz                 ),
  .x_create_gateclk_en                     (miq_entry11_create_gateclk_en          ),
  .x_frz_clr                               (miq_entry11_frz_clr                    ),
  .x_issue_en                              (miq_entry11_issue_en                   ),
  .x_pop_cur_entry                         (miq_entry11_pop_cur_entry              ),
  .x_pop_other_entry                       (miq_entry11_pop_other_entry            ),
  .x_rdy                                   (miq_entry11_rdy                        ),
  .x_read_data                             (miq_entry11_read_data                  ),
  .x_vld                                   (miq_entry11_vld                        ),
  .x_vld_with_frz                          (miq_entry11_vld_with_frz               )
);


// &ModuleEnd; @790
endmodule
