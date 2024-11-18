//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_fsm
(
    input               clk,
    input               rst,

    input               arg_vld,
    input        [31:0] a,
    input        [31:0] b,
    input        [31:0] c,

    output logic        res_vld,
    output logic [31:0] res,

    // isqrt interface

    output logic        isqrt_x_vld,
    output logic [31:0] isqrt_x,

    input               isqrt_y_vld,
    input        [15:0] isqrt_y
);
    
    typedef enum logic[3:0] { IDLE        = 4'b0001,
                              W_C         = 4'b0010,
                              W_B_sqC     = 4'b0100,
                              W_A_sqB_sqC = 4'b1000} states;

    states state, next_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else     state <= next_state; 
    end

    always_comb begin
        next_state = state;

        isqrt_x_vld = '0;
        isqrt_x     = 'x;

        case(state)
            IDLE: begin
                isqrt_x = c; // готовим на счёт c

                if(arg_vld) begin
                    isqrt_x_vld ='1; // если всё валидно начинаем счёт c
                    next_state  = W_C;
                end
            end

            W_C: begin
                if (isqrt_y_vld) begin
                    isqrt_x     = b + isqrt_y; // готовим на счёт b + isqrt(c)
                    isqrt_x_vld = '1; // сразу начинаем счёт b + isqrt(c)
                    next_state  = W_B_sqC;
                end
            end

            W_B_sqC: begin
                if (isqrt_y_vld) begin
                    isqrt_x     = a + isqrt_y; // готовим на счёт a + isqrt(b + isqrt(c))
                    isqrt_x_vld = '1; // сразу начинаем счёт b + isqrt(c)
                    next_state  = W_A_sqB_sqC;
                end
            end

            W_A_sqB_sqC: begin
                if (isqrt_y_vld) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) res_vld <= '0;
        else     res_vld <= (state == W_A_sqB_sqC & isqrt_y_vld); // рез выставляем, если в конечном состоянии и посчиталось
    end

    always_ff @(posedge clk) begin
        if      (state == IDLE)                       res <= 0;        
        else if (isqrt_y_vld && state == W_A_sqB_sqC) res <= 32' (isqrt_y);
    end
endmodule
