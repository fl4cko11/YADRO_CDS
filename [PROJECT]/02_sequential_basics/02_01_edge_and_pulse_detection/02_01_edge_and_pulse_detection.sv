//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module posedge_detector (input clk, rst, a, output detected); // детектирует любые изменения a с 0 на 1

  logic a_r;

  always_ff @ (posedge clk)
    if (rst)
      a_r <= '0;
    else
      a_r <= a;

  assign detected = ~ a_r && a; // 1 только если произошло изменение a с 0 на 1 за два такта

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module one_cycle_pulse_detector (input clk, rst, a, output logic detected);
  logic a_reg;
  logic a_reg_reg;

  always_ff @(posedge clk) begin
    if (rst) a_reg_reg <= '0;
    else a_reg_reg <= a_reg;
  end

  always_ff @(posedge clk) begin
    if (rst) a_reg <= '0;
    else a_reg <= a;
  end

  always @(posedge clk) begin
    if (rst) detected <= '0;
    else if (~a & a_reg & ~a_reg_reg) detected <= '1;
    else detected <= '0;
  end
endmodule
