module ct_mat_mux_onehot #(KEY_LEN = 1, DATA_LEN = 1) (
  output logic [DATA_LEN-1:0] data_out,
  input logic [KEY_LEN-1:0] onehot_key,
  input logic [DATA_LEN-1:0] default_out,
  input logic [DATA_LEN-1:0] data_list [0:KEY_LEN-1]
);

  genvar n;

  logic [DATA_LEN-1:0] data_in_filter[0:KEY_LEN-1];
  logic [DATA_LEN-1:0] data_out_temp[0:KEY_LEN-1]/*verilator split_var*/; 
  
  generate
  for (n = 0; n < KEY_LEN; n = n + 1) begin
    assign data_in_filter[n] = onehot_key[n] ? data_list[n] : 'b0;

    if(n == 0) begin
      assign data_out_temp[n] = data_in_filter[n];
    end
    else begin
      assign data_out_temp[n] = data_out_temp[n - 1] | data_in_filter[n];
    end
  end
  endgenerate
  
  logic key_valid;
  assign key_valid = |onehot_key;
  assign data_out = key_valid ? data_out_temp[KEY_LEN - 1] : default_out;

endmodule