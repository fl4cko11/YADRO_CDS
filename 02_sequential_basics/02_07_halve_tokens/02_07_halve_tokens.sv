//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module halve_tokens
(
    input  clk,
    input  rst,
    input  a,
    output logic b
);
    
    int counter_of_ones;
    logic a_reg;
    logic a_reg_reg;
    
    always_ff @( posedge clk ) begin
        if (rst) a_reg <= 0;
        else a_reg <= a;
    end

    always_comb begin
        if (a == '1) counter_of_ones = counter_of_ones + 1;
        if (rst) begin
            b = '0;
            counter_of_ones = 0;
        end
        else if ((a_reg & a) & ((counter_of_ones % 2) == 0))b = '1;
        else b = '0; 
    end
endmodule
