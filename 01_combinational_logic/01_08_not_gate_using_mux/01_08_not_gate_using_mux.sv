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

module not_gate_using_mux
(
    input  i,
    output o
);

  localparam logic ch1 = 1'b1;
  localparam logic ch2 = 1'b0;
  
  mux mux(.d0(ch1), .d1(ch2), .sel(i), .y(o));

endmodule
