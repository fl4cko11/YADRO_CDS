//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module round_robin_arbiter_with_2_requests
(
    input        clk,
    input        rst,
    input  [1:0] requests,
    output logic [1:0] grants
);

    logic prev_opened; // 0 = opened for 1st, 1 = opened for 2nd

    always_ff @( posedge clk ) begin
        if (rst) prev_opened <= '1; // default open for 1st req first
        else if (requests[0] == '1 & requests[1] == '0) prev_opened <= '0;
        else if (requests[0] == '0 & requests[1] == '1) prev_opened <= '1;
        else if (requests[0] == '1 & requests[1] == '1) prev_opened <= prev_opened + 1;
    end


    always @(requests) begin
        if (rst) begin
            grants[0] = 'x;
            grants[1] = 'x;
        end
        if (requests[0] == '1 & requests[1] == '0) begin
            grants[0] = '1;
            grants[1] = '0;
        end
        else if (requests[0] == '0 & requests[1] == '1) begin
            grants[0] = '0;
            grants[1] = '1;
        end
        else if (requests[0] == '1 & requests[1] == '1) begin
            if (prev_opened == '0) begin
                grants[0] = '0;
                grants[1] = '1;
            end
            else begin
                grants[0] = '1;
                grants[1] = '0;
            end
        end
        else if (requests[0] == '0 & requests[1] == '0) begin
            grants[0] = '0;
            grants[1] = '0;
        end
    end
endmodule
