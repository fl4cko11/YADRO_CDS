//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module serial_adder (input  clk, input  rst, input  a, input  b, output sum);
  logic carry;
  wire carry_d;

  assign { carry_d, sum } = a + b + carry;

  always_ff @ (posedge clk)
    if (rst)
      carry <= '0;
    else
      carry <= carry_d;
endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_adder_using_logic_operations_only (input  clk, input  rst, input logic  a, input logic  b, output logic sum); //побитово складываем многобитные числа
  logic carry; // сохарнённый перенос
  wire carry_d; // актуальный перенос

  assign { carry_d, sum } = {a & b, a ^ b | carry};

  always_ff @ (posedge clk)
    if (rst)
      carry <= '0;
    else
      carry <= carry_d;

endmodule
