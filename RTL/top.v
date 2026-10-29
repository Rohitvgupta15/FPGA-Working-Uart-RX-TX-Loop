module top_aes (
    input        clock,      
    input        reset,      
    input        rx,         // USB-UART, PC -> FPGA
    output       tx,         // USB-UART, FPGA -> PC
    output [7:0] led,        
    output       heartbeat   
);

    localparam [15:0] CLKS_PER_BIT = 16'd868;   // 100 MHz / 115200

    reg [1:0] rst_sync = 2'b11;

    always @(posedge clock) begin
        rst_sync <= {rst_sync[0], reset};
    end

    wire rst = rst_sync[1];

    wire       rx_valid;
    wire       tx_active;
    wire       tx_done;
    wire [7:0] rx_byte;

    reg        tx_start = 1'b0;
    reg  [7:0] tx_byte  = 8'd0;
    reg        pending  = 1'b0;    
    
    //--------------------------------------------------
    // UART Receiver
    //--------------------------------------------------
    uart_rx u_rx (
        .i_clk          (clock),
        .i_rst          (rst),
        .i_clks_per_bit (CLKS_PER_BIT),
        .i_rx_serial    (rx),
        .o_rx_valid     (rx_valid),
        .o_rx_byte      (rx_byte)
    );

    //--------------------------------------------------
    // UART Transmitter 
    //--------------------------------------------------
    uart_tx u_tx (
        .i_clk          (clock),
        .i_rst          (rst),
        .i_clks_per_bit (CLKS_PER_BIT),
        .i_tx_start     (tx_start),
        .i_tx_byte      (tx_byte),
        .o_tx_serial    (tx),
        .o_tx_active    (tx_active),
        .o_tx_done      (tx_done)
    );

    always @(posedge clock) begin
        if (rst) begin
            tx_start <= 1'b0;
            tx_byte  <= 8'd0;
            pending  <= 1'b0;
        end else begin
            tx_start <= 1'b0;
            if (rx_valid) begin
                tx_byte <= rx_byte;                
                pending <= 1'b1;
            end else if (pending && !tx_active && !tx_done && !tx_start) begin
                tx_start <= 1'b1;
                pending  <= 1'b0;
            end
        end
    end

    assign led = rx_byte;
    
    //--------------------------------------------------
    // Heartbeat LED (simple divider)
    //--------------------------------------------------
    reg [25:0] hb_cnt = 0;
    
    always @(posedge clock) begin
        if (rst) begin
            hb_cnt <= 0;
        end else begin
            hb_cnt <= hb_cnt + 1;
        end
    end

    assign heartbeat = hb_cnt[25];

endmodule