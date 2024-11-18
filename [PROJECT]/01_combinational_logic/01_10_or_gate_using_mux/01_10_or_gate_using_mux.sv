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

module or_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  localparam logic ch1 = 1'b0;
  localparam logic ch2 = 1'b1;
  logic in_for_mux_2;

  mux mux1(.d0(ch1), .d1(ch2), .sel(a), .y(in_for_mux_2));
  mux mux2(.d0(in_for_mux_2), .d1(ch2), .sel(b), .y(o));

endmodule
