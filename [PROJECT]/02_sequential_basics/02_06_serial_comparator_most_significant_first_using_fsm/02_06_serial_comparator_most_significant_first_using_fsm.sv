//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module serial_comparator_least_significant_first_using_fsm
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output a_less_b,
  output a_eq_b,
  output a_greater_b
);

  // States
  typedef enum logic[1:0]
  {
     st_equal       = 2'b00,
     st_a_less_b    = 2'b01,
     st_a_greater_b = 2'b10
  } state_t;
  state_t state, new_state;

  // State transition logic
  always_comb begin
    new_state = state;
    case (state)
      st_equal       : if (~ a &   b) new_state = st_a_less_b;
                  else if (  a & ~ b) new_state = st_a_greater_b;
      st_a_less_b    : if (  a & ~ b) new_state = st_a_greater_b;
      st_a_greater_b : if (~ a &   b) new_state = st_a_less_b;
    endcase
  end

  // Output logic
  assign a_eq_b      = (a == b) & (state == st_equal);
  assign a_less_b    = (~ a &   b) | (a == b & state == st_a_less_b);
  assign a_greater_b = (  a & ~ b) | (a == b & state == st_a_greater_b);

  always_ff @ (posedge clk)
    if (rst)
      state <= st_equal;
    else
      state <= new_state;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------
module serial_comparator_most_significant_first_using_fsm
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output a_less_b,
  output a_eq_b,
  output a_greater_b
);

  // States
  typedef enum logic[1:0]
  {
     st_equal       = 2'b00,
     st_a_less_b    = 2'b01,
     st_a_greater_b = 2'b10
  } state_t;
  state_t state, new_state;

  // State transition logic
  always_comb begin
    new_state = state;
    case (state)
      st_equal       : if (~ a &   b) new_state = st_a_less_b;
                  else if (  a & ~ b) new_state = st_a_greater_b;
      st_a_less_b    : new_state = st_a_less_b;
      st_a_greater_b : new_state = st_a_greater_b; // один раз бит больше или меньше другого то всё число так тк смотрим значащие
    endcase
  end

  // Output logic
  assign a_eq_b      = (a == b) & (state == st_equal);
  assign a_less_b    = ((~ a & b) & (~a_greater_b)) | (state == st_a_less_b);
  assign a_greater_b = ((a & ~ b) & (~a_less_b)) | (state == st_a_greater_b);

  always_ff @ (posedge clk)
    if (rst)
      state <= st_equal;
    else
      state <= new_state;
endmodule
