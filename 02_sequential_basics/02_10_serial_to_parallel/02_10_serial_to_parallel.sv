//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);

    int counter_of_bits;
    logic [width - 1 : 0] parallel_data_collector;

    always @(posedge clk) begin
        if (rst) begin
            counter_of_bits = 0;
            parallel_valid = 'x;
            parallel_data = 'x;
            parallel_data_collector = 0;
        end
        if (serial_valid) begin
            counter_of_bits += 1;
            if (counter_of_bits <= width) begin
                $display("bits catched: %d", counter_of_bits);
                $display("data input %b", serial_data);
                parallel_data_collector[counter_of_bits - 1] = serial_data;
                $display("par data col: %o", parallel_data_collector);
            end
            if (counter_of_bits == width) begin
                $display("");
                $display("SHOWING FINAL DATA...");
                parallel_valid = 1;
                parallel_data = parallel_data_collector;
                $display("parallel data: %o", parallel_data);
                parallel_data_collector = 0;
            end
        end
    end
endmodule
