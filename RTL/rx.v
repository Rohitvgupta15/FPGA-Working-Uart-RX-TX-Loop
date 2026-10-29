module uart_rx (
    input             i_clk,
    input             i_rst,            
    input      [15:0] i_clks_per_bit,   // 868 = 100 MHz / 115200
    input             i_rx_serial,
    output reg        o_rx_valid = 1'b0,
    output reg [7:0]  o_rx_byte  = 0
);

    localparam IDLE    = 3'd0,
               START   = 3'd1,
               DATA    = 3'd2,
               STOP    = 3'd3,
               CLEANUP = 3'd4;

    reg [2:0]  state   = IDLE;
    reg [15:0] count   = 0;
    reg [2:0]  bit_idx = 0;

    reg rx_meta = 1'b1;
    reg rx      = 1'b1;

    always @(posedge i_clk) begin
        rx_meta <= i_rx_serial;
        rx      <= rx_meta;
    end

    wire bit_end  = (count >= i_clks_per_bit - 1);         
    wire half_bit = (count == (i_clks_per_bit - 1) >> 1);   // /2

    always @(posedge i_clk) begin
        if (i_rst) begin
            state      <= IDLE;
            count      <= 0;
            bit_idx    <= 0;
            o_rx_byte  <= 0;
            o_rx_valid <= 1'b0;
        end else begin
            o_rx_valid <= 1'b0;   

            case (state)
                IDLE: begin
                    count   <= 0;
                    bit_idx <= 0;
                    if (!rx) begin
                        state <= START;      
                    end
                end

                START: begin                      
                    if (half_bit) begin
                        count <= 0;
                        if (rx) begin
                            state <= IDLE;
                        end else begin
                            state <= DATA;
                        end
                    end else begin
                        count <= count + 1;
                    end
                end

                DATA: begin                       
                    if (bit_end) begin
                        count              <= 0;
                        o_rx_byte[bit_idx] <= rx;
                        bit_idx            <= bit_idx + 1;   
                        if (bit_idx == 7) begin
                            state <= STOP;
                        end
                    end else begin
                        count <= count + 1;
                    end
                end

                STOP: begin                       
                    if (bit_end) begin
                        count      <= 0;
                        o_rx_valid <= 1'b1;
                        state      <= CLEANUP;
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