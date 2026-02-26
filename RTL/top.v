module top_aes (
    input        clock,
    input        reset,
    input        transmit,   // optional / future use
    input        rx,          // UART RX from PC
    input  [7:0] in,          // optional / future use
    output       tx,          // UART TX to PC
    output [7:0] led,
    output       heartbeat
);

    //--------------------------------------------------
    // Internal signals
    //--------------------------------------------------
    wire        dv;            // RX data valid
    wire [7:0]  rx_data;       // RX byte

    reg         tx_data_valid;
    reg  [7:0]  tx_byte;

    wire        active;
    wire        done;

    //--------------------------------------------------
    // UART Receiver
    //--------------------------------------------------
    uart_rx RX (
        .i_Clock(clock),
        .i_Clocks_per_Bit(16'd868),   // 100 MHz / 115200
        .i_Reset(reset),
        .i_Rx_Serial(rx),
        .o_Rx_DV(dv),
        .o_Rx_Byte(rx_data)
    );

    //--------------------------------------------------
    // UART Transmitter (to PC)
    //--------------------------------------------------
    uart_tx TX_PC (
        .i_Clock(clock),
        .i_Clocks_per_Bit(16'd868),
        .i_Tx_DV(tx_data_valid),
        .i_Reset(reset),
        .i_Tx_Byte(tx_byte),
        .o_Tx_Serial(tx),
        .o_Tx_Active(active),
        .o_Tx_Done(done)
    );

    //--------------------------------------------------
    // RX → TX control (echo received data)
    //--------------------------------------------------
    always @(posedge clock) begin
        if (reset) begin
            tx_data_valid <= 1'b0;
            tx_byte       <= 8'd0;
        end else begin
            tx_data_valid <= 1'b0;

            if (dv) begin
                tx_byte       <= rx_data;   // AES can go here
                tx_data_valid <= 1'b1;
            end
        end
    end

    //--------------------------------------------------
    // LED Debug (show received byte)
    //--------------------------------------------------
    assign led = rx_data;

    //--------------------------------------------------
    // Heartbeat LED (simple divider)
    //--------------------------------------------------
    reg [25:0] hb_cnt;
    always @(posedge clock) begin
        if (reset)
            hb_cnt <= 0;
        else
            hb_cnt <= hb_cnt + 1;
    end

    assign heartbeat = hb_cnt[25];

endmodule
