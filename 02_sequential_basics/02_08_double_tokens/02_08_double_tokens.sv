//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module double_tokens
(
    input        clk,
    input        rst,
    input        a,
    output logic b,
    output logic overflow
);

    int counter_b = 0;
    int overflow_counter;
    
    always_ff @( posedge clk ) begin
        if (rst) begin
            overflow_counter <= 0;
            overflow <= '0;
        end
        else if (a == '1) overflow_counter <= overflow_counter + 1;
        if (overflow_counter > 200) overflow = '1;
    end

    always @(posedge clk) begin
        if (rst) begin
            b = '0;
            counter_b = 0;
        end
        else if ((a == '1) | (counter_b != overflow_counter * 2)) begin
            b = '1;
            counter_b += 1;
        end
        else b = '0;
    end
endmodule
