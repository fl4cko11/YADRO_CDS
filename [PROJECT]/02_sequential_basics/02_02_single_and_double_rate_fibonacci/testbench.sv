`include "../include/util.svh"
`include "02_02_single_and_double_rate_fibonacci.sv"

module testbench;

  logic clk;

  initial begin
    clk = 0;
    forever
      # 500 clk = ~ clk;
  end

  logic rst;

  initial begin
    rst <= 'x;
    repeat (2) @ (posedge clk);
    rst <= '1;
    repeat (2) @ (posedge clk);
    rst <= '0;
  end

  logic [15:0] f1_num, f2_num, f2_num2;

  fibonacci   f1 (.num (f1_num), .*);
  fibonacci_2 f2 (.num (f2_num), .num2 (f2_num2), .*);

  localparam n = 10;

  logic [15:0] fifo1 [$], fifo2 [$];

  integer round = 1;

  initial begin
    int if_fail = 0;
    
    `ifdef __ICARUS__
      // Uncomment the following line
      // to generate a VCD file and analyze it using GTKwave or Surfer

      $dumpvars;
    `endif

    @ (negedge rst);
    while (fifo1.size () < n) begin
      @ (posedge clk);

      fifo1.push_back (f1_num);
      fifo2.push_back (f2_num);
      fifo2.push_back (f2_num2);
    end

    while (fifo1.size () > 0 && fifo2.size () > 0) begin
      logic [15:0] expected, actual;

      expected = fifo1.pop_front ();
      actual = fifo2.pop_front ();

      if (expected !== actual)
      begin
        $display("FAIL %s", `__FILE__);
        $display("++ TEST     => {%s, %s, %s}", `PD(round), `PD(expected), `PD(actual));
        if_fail = 1;
      end
      round += 1;
    end

    if (if_fail == 0) begin
      $display("PASS %s", `__FILE__); // Печатаем PASS, если не было ошибок
    end
    $finish;
  end

endmodule
