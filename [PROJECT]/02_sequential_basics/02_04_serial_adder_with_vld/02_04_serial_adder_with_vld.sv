//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_adder_with_vld
(
  input  clk,
  input  rst,
  input  vld, // active = > sum
  input  a,
  input  b,
  input  last, // active and vld active => sum and reset
  output logic sum
);

  logic carry; // сохарнённый перенос
  wire carry_d; // актуальный перенос

  assign carry_d = a & b;

  always_comb begin
    if (vld) begin
      sum = a ^ b | carry;
    end
  end

  always_ff @ (posedge clk)
    if (rst || (last && vld)) begin
      carry <= '0;
      sum <= '0;
    end
    else carry <= carry_d;
endmodule
