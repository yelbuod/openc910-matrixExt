module ct_mat_src_oh_binary(
  input  [11:0]  x_num_oh,
  output [3:0]  x_num_binary
);

//==========================================================
//  convert 8 bits one-hot number to 3 bits binary number
//==========================================================
generate
  for(genvar j = 0; j < 4; j++) begin
    logic [11:0] temp_mask;
    for(genvar i = 0; i < 12; i++) begin
      logic [4:0] temp_i;
      assign temp_i = 4'(i);
      assign temp_mask[i] = temp_i[j];   
    end
    assign x_num_binary[j] = |(temp_mask & x_num_oh);
  end
endgenerate

// &ModuleEnd; @41
endmodule