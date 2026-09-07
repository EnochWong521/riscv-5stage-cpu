`timescale 1ns / 1ps

module if_stage(
  input logic clk, 
  input logic rst_n,
  input logic pc_src
  input logic [31:0] pc_target,
  output logic [31:0] inst_id,
  output logic [31:0] pc_id,
  output logic [31:0] pc_plus_four_id
  );

  // compute PC
  logic [31:0] pc;
  logic [31:0] pc_plus_four;
  logic [31:0] pc_next;
  
  always_comb begin
    // PC + 4
    pc_plus_four = pc + 32'd4;
    
    // multiplex between PC sources
    if (pc_src) begin
      pc_next = pc_target;
    end else begin
      pc_next = pc_plus_four;
    end
  end

  // update PC registers 
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      pc <= 32'b0;
    end else begin
      pc <= pc_next;
    end
  end

  // instruction memory
  logic [31:0] inst;
  inst_mem IMEM (
    .pc(pc),
    .inst(inst)
    );
    
  // IF/ID pipeline registers
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      inst_id <= 32'b0;
      pc_id <= 32'b0;
      pc_plus_four <= 32'b0;
    end else begin
      inst_id <= inst;
      // PC saved for computing branch/jump address
      pc_id <= pc;
      // PC + 4 saved for WB in JAL/JALR instructions
      pc_plus_four_id <= pc_plus_four;
    end
  end
endmodule;
