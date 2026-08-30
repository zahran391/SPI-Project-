module SPI_Master #(
    parameter N = 8,          // Data width (default: 8-bit)
    parameter CLK_DIV = 2     // Clock division factor
)(
    input  wire         clk,      // System clock
    input  wire         rst_n,    // Active-low asynchronous reset
    input  wire         start,    // Start transaction signal
    input  wire [N-1:0] tx_data,  // Parallel data to transmit
    input  wire         miso,     // Master In Slave Out
    
    output reg          sclk,     // Serial clock output
    output reg          ss_n,     // Slave select (active low)
    output wire         mosi,     // Master Out Slave In
    output reg  [N-1:0] rx_data,  // Received parallel data
    output reg          done      // Transaction finished flag
);

    // FSM States Definition (3 States)
    localparam IDLE     = 2'b00;
    localparam TRANSFER = 2'b01;
    localparam DONE     = 2'b10;

    reg [1:0] state;

    // Internal Registers
    reg [7:0]         clk_counter; // Clock divider counter
    reg [N-1:0]       tx_shift;    // TX Shift Register
    reg [N-1:0]       rx_shift;    // RX Shift Register
    reg [$clog2(N):0] bit_count;   // Bit counter

    // MSB First Data Output  *Most Significant Bit* transimit operation 
    assign mosi = tx_shift[N-1]; // بنحدد اخر بيت علشان اعمل من عنده شيفت يسار 

    // Master FSM & Operations Logic
    always @(posedge clk or negedge rst_n) 
    begin
        if (~rst_n) begin
            state       <= IDLE;
            sclk        <= 1'b0;
            ss_n        <= 1'b1; //active low 
            done        <= 1'b0;
            clk_counter <= 8'd0;
            bit_count   <= 0;
            tx_shift    <= 0;
            rx_shift    <= 0;
            rx_data     <= 0;
        end 
        else begin
            case (state)

                // Block 4 (FSM State 1): IDLE State
                IDLE: begin
                    ss_n        <= 1'b1; // OFF
                    done        <= 1'b0;
                    sclk        <= 1'b0;
                    clk_counter <= 8'd0;
                    bit_count   <= 0;

                    if (start) // اشاره التشغيل وبدايه النقل للداتا 
                    begin
                        tx_shift <= tx_data; // Load TX Data
                        rx_shift <= 0;
                        ss_n     <= 1'b0;    // Assert Slave Select
                        state    <= TRANSFER;
                    end
                end

                // Block 1, 2, 3: TRANSFER State (SCLK Gen + Counting + Shifting)
                TRANSFER: begin
                    ss_n <= 1'b0; //on

                    // Block 1: Clock Divider
                    if (clk_counter == CLK_DIV - 1) //اقل من المقسم بواحد صفر و اعمل كلوك 
                    begin
                        clk_counter <= 8'd0;
                        sclk        <= ~sclk; // Toggle SCLK // like clk = ~clk
                        // الشيفت للبيانات المستقبله  يشتغل فقط عند الحافه الصاعده 
                        // Sample MISO on SCLK Rising Edge (0 -> 1)
                        if (sclk == 1'b0) 
                        begin           //concatination recive in master on line miso
                            rx_shift <= {rx_shift[N-2:0], miso}; // shift left for recive data 
                        end 
                        // Shift TX & Count on SCLK Falling Edge (1 -> 0)
                        else begin
                            if (bit_count == N - 1) //لو وصل لعدد البييت المحدد خلاص كده النقل انتهى 
                            begin
                                state <= DONE;
                            end 
                            else begin
                                tx_shift  <= tx_shift << 1; //shift left on faling sclk for transimate data 
                                bit_count <= bit_count + 1'b1; // ويزود العداد 
                            end
                        end
                    end 
                    else 
                    begin
                        clk_counter <= clk_counter + 1'b1;
                    end
                end

                // Block 4 (FSM State 3): DONE State
                DONE: begin
                    ss_n    <= 1'b1;     // Deactive-assert Slave Select
                    sclk    <= 1'b0;
                    done    <= 1'b1;     // Raise Done Flag
                    rx_data <= rx_shift; // Store received data that master ricevid to output it 
                    state   <= IDLE;     // بعد كده يرجع للحاله الاولى 
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule