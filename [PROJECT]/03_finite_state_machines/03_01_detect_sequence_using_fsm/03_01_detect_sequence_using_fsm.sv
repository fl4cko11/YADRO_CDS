//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module detect_4_bit_sequence_using_fsm
(
  input  clk,
  input  rst,
  input  a,
  output detected
);

  // Detection of the "1010" sequence

  // States (F — First, S — Second)
  enum logic[2:0]
  {
     IDLE = 3'b000,
     F1   = 3'b001,
     F0   = 3'b010,
     S1   = 3'b011,
     S0   = 3'b100
  }
  state, new_state;

  // State transition logic
  always_comb
  begin
    new_state = state;

    // This lint warning is bogus because we assign the default value above
    // verilator lint_off CASEINCOMPLETE

    case (state)
      IDLE: if (  a) new_state = F1;
      F1:   if (~ a) new_state = F0;
      F0:   if (  a) new_state = S1;
            else     new_state = IDLE;
      S1:   if (~ a) new_state = S0;
            else     new_state = F1;
      S0:   if (  a) new_state = S1;
            else     new_state = IDLE;
    endcase

    // verilator lint_on CASEINCOMPLETE

  end

  // Output logic (depends only on the current state)
  assign detected = (state == S0);

  // State update
  always_ff @ (posedge clk)
    if (rst)
      state <= IDLE;
    else
      state <= new_state;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module detect_6_bit_sequence_using_fsm(input  clk, input  rst, input  a, output logic detected);

  typedef enum logic[6:0] { NOTHING =       7'b0000001,
                            CATCHED_1 =     7'b0000010,
                            CATCHED_11 =    7'b0000100,
                            CATCHED_110 =   7'b0001000,
                            CATCHED_1100 =  7'b0010000,
                            CATCHED_11001 = 7'b0100000,
                            FINAL =         7'b1000000 } states;
  
  states state, next_state;

  always_ff @( posedge clk or posedge rst ) begin
    if (rst) state <= NOTHING;
    else     state <= next_state;
  end

  always_comb begin
    case (state)
      NOTHING: begin
        if (~a) next_state = NOTHING;
        else    next_state = CATCHED_1;
      end
      CATCHED_1: begin
        if (~a) next_state = NOTHING;
        else    next_state = CATCHED_11;
      end
      CATCHED_11: begin
        if (~a) next_state = CATCHED_110;
        else    next_state = CATCHED_11;
      end
      CATCHED_110: begin
        if (~a) next_state = CATCHED_1100;
        else    next_state = CATCHED_1;
      end
      CATCHED_1100: begin
        if (~a) next_state = NOTHING;
        else    next_state = CATCHED_11001;
      end
      CATCHED_11001: begin
        if (~a) next_state = NOTHING;
        else    next_state = FINAL;
      end
      FINAL: begin
        if (~a) next_state = CATCHED_110;
        else    next_state = CATCHED_1;
      end
    endcase
  end

  always_comb begin
    if (state == FINAL) detected = 1;
    else                detected = 0;
  end

endmodule
