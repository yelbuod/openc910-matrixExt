module ct_mat_expand_12(
  x_num,
  x_num_expand
);

// &Ports; @25
input   [3:0]  x_num;       
output  [11:0]  x_num_expand; 

// &Regs; @26

// &Wires; @27
wire    [3:0]  x_num;       
wire    [11:0]  x_num_expand; 


//==========================================================
//       expand 3 bits number to 8 bits one-hot number
//==========================================================
assign x_num_expand[0] = (x_num[3:0] == 4'd0);
assign x_num_expand[1] = (x_num[3:0] == 4'd1);
assign x_num_expand[2] = (x_num[3:0] == 4'd2);
assign x_num_expand[3] = (x_num[3:0] == 4'd3);
assign x_num_expand[4] = (x_num[3:0] == 4'd4);
assign x_num_expand[5] = (x_num[3:0] == 4'd5);
assign x_num_expand[6] = (x_num[3:0] == 4'd6);
assign x_num_expand[7] = (x_num[3:0] == 4'd7);
assign x_num_expand[8] = (x_num[3:0] == 4'd8);
assign x_num_expand[9] = (x_num[3:0] == 4'd9);
assign x_num_expand[10] = (x_num[3:0] == 4'd10);
assign x_num_expand[11] = (x_num[3:0] == 4'd11);

// &ModuleEnd; @41
endmodule