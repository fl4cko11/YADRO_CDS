//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module serial_divisibility_by_3_using_fsm
(
  input  clk,
  input  rst,
  input  new_bit,
  output div_by_3
);

  // States
  enum logic[1:0]
  {
     mod_0 = 2'b00,
     mod_1 = 2'b01,
     mod_2 = 2'b10
  }
  state, new_state;

  // State transition logic
  always_comb
  begin
    new_state = state;

    // This lint warning is bogus because we assign the default value above
    // verilator lint_off CASEINCOMPLETE

    case (state)
      mod_0 : if(new_bit) new_state = mod_1;
              else        new_state = mod_0;
      mod_1 : if(new_bit) new_state = mod_0;
              else        new_state = mod_2;
      mod_2 : if(new_bit) new_state = mod_2;
              else        new_state = mod_1;
    endcase

    // verilator lint_on CASEINCOMPLETE

  end

  // Output logic
  assign div_by_3 = state == mod_0;

  // State update
  always_ff @ (posedge clk)
    if (rst)
      state <= mod_0;
    else
      state <= new_state;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_divisibility_by_5_using_fsm
(
  input  clk,
  input  rst,
  input  new_bit,
  output logic div_by_5
);

  typedef enum logic [4:0] {MOD_0 = 5'b00001,
                            MOD_1 = 5'b00010,
                            MOD_2 = 5'b00100,
                            MOD_3 = 5'b01000,
                            MOD_4 = 5'b10000} states;
  
  states state, next_state;

  always_ff @( posedge clk or posedge rst ) begin
    if (rst) state <= MOD_0;
    else     state <=next_state;
  end

  always_comb begin
    case (state)
      MOD_0: begin
        if (~new_bit) next_state = MOD_0;
        else          next_state = MOD_1;
      end
      MOD_1: begin
        if (~new_bit) next_state = MOD_2;
        else          next_state = MOD_3;
      end
      MOD_2: begin
        if (~new_bit) next_state = MOD_4;
        else          next_state = MOD_0;
      end
      MOD_3: begin
        if (~new_bit) next_state = MOD_1;
        else          next_state = MOD_2;
      end
      MOD_4: begin
        if (~new_bit) next_state = MOD_3;
        else          next_state = MOD_4;
      end
    endcase
  end

  always_comb begin
    if (state == MOD_0) div_by_5 = 1;
    else                div_by_5 = 0; 
  end
endmodule
