`include "../include/util.svh"
`include "02_01_edge_and_pulse_detection.sv"

module testbench;

  logic clk;

  initial begin
    clk = '0;
    forever
      #500 clk = ~clk; // генерируем такты
  end

  logic rst;

  initial begin
    rst <= 'x;             // Устанавливаем rst в неопределенное состояние ('x)
    repeat (2) @ (posedge clk); // Ждем два фронта тактового сигнала clk
    rst <= '1;            // Устанавливаем rst в логическую единицу
    repeat (2) @ (posedge clk); // Ждем еще два фронта clk
    rst <= '0;            // Устанавливаем rst в логический ноль
  end

  logic a, pd_detected, ocpd_detected;

  posedge_detector         pd   (.detected(pd_detected),   .clk(clk), .rst(rst), .a(a));
  one_cycle_pulse_detector ocpd (.detected(ocpd_detected), .clk(clk), .rst(rst), .a(a));

  localparam n = 16;

  // Sequence of input values
  localparam [n - 1:0] seq_a                = 16'b1000111001000100;

  // Expected sequence of correct output values
  localparam [n - 1:0] seq_posedge          = 16'b1000001001000100; // ожидаемый для детектора полож фронта
  localparam [n - 1:0] seq_one_cycle_pulse  = 16'b0000000100010000; // ожидаемый для детектора одного пульса

  initial begin
    int if_fail = 0; // Локальная переменная для отслеживания ошибок

    `ifdef __ICARUS__
      // Uncomment the following line
      // to generate a VCD file and analyze it using GTKwave or Surfer
      $dumpvars;
    `endif

    @ (negedge rst);

    for (int i = 0; i < n; i++) begin
      a <= seq_a[i];

      @ (posedge clk); // синхронизируем процесс
      
      if (pd_detected !== seq_posedge[i] || ocpd_detected !== seq_one_cycle_pulse[i]) begin
        $display("FAIL %s", `__FILE__);
        $display("++ INPUT    => {%s, %s}", `PB(seq_a), `PB(seq_one_cycle_pulse));
        $display("++ TEST     => {%s, %s, %s}", `PD(i), `PB(ocpd_detected), `PB(seq_one_cycle_pulse[i]));
        if_fail = 1; // Устанавливаем флаг ошибки
      end
    end

    if (if_fail == 0) begin
      $display("PASS %s", `__FILE__); // Печатаем PASS, если не было ошибок
    end

    $finish;
  end

endmodule
