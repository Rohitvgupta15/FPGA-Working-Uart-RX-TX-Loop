module uart_tx (
    input             i_clk,
    input             i_rst,            
    input      [15:0] i_clks_per_bit,   // 868 = 100 MHz / 115200
    input             i_tx_start,
    input      [7:0]  i_tx_byte,
    output reg        o_tx_serial = 1'b1,
    output reg        o_tx_active = 1'b0,
    output reg        o_tx_done   = 1'b0
);

    localparam IDLE    = 3'd0,
               START   = 3'd1,
               DATA    = 3'd2,
               STOP    = 3'd3,
               CLEANUP = 3'd4;

    reg [2:0]  state   = IDLE;
    reg [15:0] count   = 0;
    reg [2:0]  bit_idx = 0;
    reg [7:0]  data    = 0;

    wire bit_end = (count >= i_clks_per_bit - 1);    

    always @(posedge i_clk) begin
        if (i_rst) begin
            state       <= IDLE;
            count       <= 0;
            bit_idx     <= 0;
            data        <= 0;
            o_tx_serial <= 1'b1;
            o_tx_active <= 1'b0;
            o_tx_done   <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    o_tx_serial <= 1'b1;    
                    o_tx_done   <= 1'b0;
                    count       <= 0;
                    bit_idx     <= 0;
                    if (i_tx_start) begin
                        data        <= i_tx_byte;
                        o_tx_active <= 1'b1;
                        state       <= START;
                    end
                end

                START: begin
                    o_tx_serial <= 1'b0;
                    if (bit_end) begin
                        count <= 0;
                        state <= DATA;
                    end else begin
                        count <= count + 1;
                    end
                end

                DATA: begin
                    o_tx_serial <= data[bit_idx];
                    if (bit_end) begin
                        count   <= 0;
                        bit_idx <= bit_idx + 1;    
                        if (bit_idx == 7) begin
                            state <= STOP;
                        end
                    end else begin
                        count <= count + 1;
                    end
                end

                STOP: begin
                    o_tx_serial <= 1'b1;
                    if (bit_end) begin
                        count       <= 0;
                        o_tx_done   <= 1'b1;
                        o_tx_active <= 1'b0;
                        state       <= CLEANUP;
                    end else begin
                        count <= count + 1;
                    end
                end

                CLEANUP: begin
                    state <= IDLE;            
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule