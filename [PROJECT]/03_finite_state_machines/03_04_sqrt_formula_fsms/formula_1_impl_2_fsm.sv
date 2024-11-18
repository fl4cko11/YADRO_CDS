//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_impl_2_fsm
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

    output logic        isqrt_1_x_vld,
    output logic [31:0] isqrt_1_x,

    input               isqrt_1_y_vld,
    input        [15:0] isqrt_1_y,

    output logic        isqrt_2_x_vld,
    output logic [31:0] isqrt_2_x,

    input               isqrt_2_y_vld,
    input        [15:0] isqrt_2_y
);

    typedef enum logic[2:0] { IDLE      = 3'b001,
                              W_A_AND_B = 3'b010,
                              W_C       = 3'b100} states;

    states state, next_state; 
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    always_comb begin
        next_state  = state;

        isqrt_1_x_vld = '0;
        isqrt_2_x_vld = '0;
        isqrt_1_x     = 'x;
        isqrt_2_x     = 'x; // на входы isqrt модуля FSM изначально ничего не определbk и сигнала на старт не дал

        case (state)
            IDLE: begin
                isqrt_1_x = a;
                isqrt_2_x = b; // готовим на счёт

                if (arg_vld) begin
                    isqrt_1_x_vld = 1;
                    isqrt_2_x_vld = 1; // если всё валидно, даём сигнал считать
                    next_state = W_A_AND_B;
                end
            end

            W_A_AND_B: begin
                isqrt_1_x = c; // подготавливаем на вход c

                if (isqrt_1_y_vld && isqrt_2_y_vld) begin
                    isqrt_1_x_vld = 1; // начинаем считать c, когдаisqrt модуль даст сигнал, что посичтано
                    next_state = W_C;
                end
            end

            W_C: begin
                if (isqrt_1_y_vld) next_state = IDLE;
            end
        endcase
    end

    always_ff @ (posedge clk or posedge rst) begin // отвечает за вытавление валидности результата
        if (rst)
            res_vld <= '0;
        else
            res_vld <= (state == W_C & isqrt_1_y_vld); // если посчитали c при этом в состояни ожидания c, то выводим ответ
    end

    always_ff @ (posedge clk) begin // формирует результат
        if (state == IDLE)
            res <= '0;
        else if ((isqrt_1_y_vld && isqrt_2_y_vld) && state == W_A_AND_B)
            res <= res + 32' (isqrt_1_y) + 32' (isqrt_2_y);
        else if (isqrt_1_y_vld && state == W_C)
            res <= res + 32' (isqrt_1_y);
    end
endmodule
