//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module serial_comparator_least_significant_first
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output a_less_b,
  output a_eq_b,
  output a_greater_b
);

  logic prev_a_eq_b, prev_a_less_b;

  assign a_eq_b      = prev_a_eq_b & (a == b);
  assign a_less_b    = (~ a & b) | (a == b & prev_a_less_b); // если текущие a = b то смотрим на прев, причём учитываем 0 и 1
  assign a_greater_b = (~ a_eq_b) & (~ a_less_b);

  always_ff @ (posedge clk)
    if (rst) begin
      prev_a_eq_b   <= '1;
      prev_a_less_b <= '0;
    end
    else begin
      prev_a_eq_b   <= a_eq_b;
      prev_a_less_b <= a_less_b;
    end

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_comparator_most_significant_first
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output a_less_b,
  output a_eq_b,
  output a_greater_b
);

  logic prev_a_eq_b, prev_a_greater_b;

  assign a_eq_b      = prev_a_eq_b & (a == b);
  assign a_greater_b    = ( (a & (~ b)) & (~a_less_b) ) | (prev_a_greater_b); // если хоть раз a > b, то и числа так (тк смотрим значащие)
  assign a_less_b = (~ a_eq_b) & (~ a_greater_b);

  always_ff @ (posedge clk)
    if (rst) begin
      prev_a_eq_b   <= '1;
      prev_a_greater_b <= '0;
    end
    else begin
      if (~a_less_b) begin
        prev_a_eq_b   <= a_eq_b;
        prev_a_greater_b <= a_greater_b;
      end
      else begin // если хоть раз a < b, то и числа так (тк смотрим значащие)
        prev_a_eq_b <= '0;
        prev_a_greater_b <= '0;
      end
    end
endmodule
