module SPI_Slave #(
    parameter N = 8 // Data width (default: 8-bit)
)(
    input  wire         sclk,     // Serial Clock coming from Master
    input  wire         ss_n,     // Slave Select coming from Master (Active Low)
    input  wire         mosi,     // Master Out Slave In
    input  wire [N-1:0] tx_data,  // Parallel data to send to Master
    
    output wire         miso,     // Master In Slave Out
    output reg  [N-1:0] rx_data   // Received parallel data from Master
);

    // Internal Shift Registers & Counter
    reg [N-1:0]       tx_shift;
    reg [N-1:0]       rx_shift;
    reg [$clog2(N):0] bit_count;

    // Output MSB bit continuously on MISO line
    // بنحدد اخر بيت علشان اعمل من عنده شيفت يسار 
    assign miso = tx_shift[N-1];

    // Prepare Data when Slave is Selected (Falling edge of ss_n) * لسه مرحله تجهيز الداتا 
    always @(negedge ss_n) begin
        tx_shift  <= tx_data;     // خزن الداتا الي عندي في الريجيستر علشان عمليه الشيفت 
        rx_shift  <= 0;          // مفيش داتا استقبها 
        bit_count <= 0;
    end

    //  Sample MOSI on SCLK Rising Edge (Receive from Master) عمليه القراءه للبيانات المستقبله
    //                                                           عند الحافه الصاعده 
    always @(posedge sclk) 
    begin
        if (!ss_n)  // active low 
        begin            // concatenation and in the slave mosi
            rx_shift <= {rx_shift[N-2:0], mosi}; // Shift in MOSI bit
        end
    end

    // Shift TX on SCLK Falling Edge (Transmit to Master )
    always @(negedge sclk) 
    begin
        if (!ss_n) 
        begin
            if (bit_count == N - 1) // عداد البيت وصل ل الاخر وعاوز يوقف الغمليه 
            begin
                rx_data   <= rx_shift; // Store final received byte
                                       // زي حاله done in master 
             // 151هنخليها لما العداد يصفر تحفظ اخر قيمه متخزنه في الشيفت الي في سطر 
                bit_count <= 0;
            end 
            else // غير كده لو انت في الحافه الهابطه اعمل شيفت للبيانات الي عندي وعاوز ارسلها 
            begin
                tx_shift  <= tx_shift << 1;    // Shift left for next bit 
                bit_count <= bit_count + 1'b1;  // وزود عداد البيت 
            end
        end
    end

endmodule
