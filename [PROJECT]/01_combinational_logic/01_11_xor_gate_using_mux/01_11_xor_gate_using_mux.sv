//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux
(
  input  d0, d1,
  input  sel,
  output y
);

  assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module xor_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  //a xor b = (a*~b) + (~a*b)
  localparam logic ch1 = 1'b0;
  localparam logic ch2 = 1'b1;
  logic inv_a;
  logic inv_b;
  logic temp_in_for_mux_and_1;
  logic temp_in_for_mux_and_2;
  logic in_for_mux_or_1;
  logic in_for_mux_or_2;
  logic temp_in_for_add;

  mux mux_inv_a(.d0(ch2), .d1(ch1), .sel(a), .y(inv_a));
  mux mux_inv_b(.d0(ch2), .d1(ch1), .sel(b), .y(inv_b));

  mux mux_for_and1(.d0(ch1), .d1(ch2), .sel(a), .y(temp_in_for_mux_and_1));
  mux mux_and1(.d0(ch1), .d1(temp_in_for_mux_and_1), .sel(inv_b), .y(in_for_mux_or_1));
  mux mux_for_and2(.d0(ch1), .d1(ch2), .sel(inv_a), .y(temp_in_for_mux_and_2));
  mux mux_and2(.d0(ch1), .d1(temp_in_for_mux_and_2), .sel(b), .y(in_for_mux_or_2));  

  mux mux_for_add(.d0(ch1), .d1(ch2), .sel(in_for_mux_or_1), .y(temp_in_for_add));
  mux mux_add(.d0(temp_in_for_add), .d1(ch2), .sel(in_for_mux_or_2), .y(o));

endmodule
