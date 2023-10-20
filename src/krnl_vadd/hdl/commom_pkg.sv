`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/19 15:03:58
// Design Name: 
// Module Name: commom_pkg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


package common_pkg;
  parameter MAX_SIM_BYTS = 2048; // In simulation tasks how big is the logic register for putting / getting data
  
  // Compare bytes and print if they do not match
  task compare_and_print(input logic [MAX_SIM_BYTS*8-1:0] data, expected);
    logic start_print;
    start_print = 0;
    if (data == expected) begin
      $display("%m %t INFO: Data matched", $time);
    end else begin
      $write("exp: 0x");
      for (int i = MAX_SIM_BYTS-1; i >= 0; i--) begin
        if (expected[i*8 +: 8] != 0) start_print = 1;
        if (start_print) $write("%x", expected[i*8 +: 8]);
      end
      start_print = 0;
      $write("\nwas: 0x");
      for (int i = MAX_SIM_BYTS-1; i >= 0; i--) begin
        if (data[i*8 +: 8] != 0) start_print = 1;
        if (start_print) $write("%x", data[i*8 +: 8]);
      end
      $write("\n");
      $fatal(1, "%m %t ERROR: data did not match", $time);
    end
  endtask
  
  // Return a random vector
  function [MAX_SIM_BYTS*8-1:0] random_vector(input integer unsigned in_len);
    random_vector = 0;
    for (int i = 0; i < in_len; i++)
      random_vector[i*8 +:8] = $random();
  endfunction
  
  // Parse a string which is a file path and remove the file name (so return the directory)
  function string get_file_dir(input string str);
    int npos = 0;
    for (int i = 0; i < str.len(); i++)
      if (str[i] == "/")
        npos = i;
    return str.substr(0,npos-1);
  endfunction
  
endpackage
