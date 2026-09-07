`timescale 1ns / 1ps

module inst_mem(
  input logic [31:0] pc,
  output logic [31:0] inst
  );

  logic [31:0] imem [0:255];
  
  initial begin
    $readmemh("program.hex", imem);
  end

  assign inst = imem[pc[9:2]];

endmodule;
