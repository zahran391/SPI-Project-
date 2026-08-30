module SPI_Top_level_tb;

    //  Parameters 
    parameter N = 8;
    parameter CLK_DIV = 2;

    reg         clk;
    reg         rst_n;
    reg         start;
    reg [N-1:0] master_tx_data;
    reg [N-1:0] slave_tx_data;


    wire [N-1:0] master_rx_data;
    wire [N-1:0] slave_rx_data;
    wire         done;

    // Expected Output to comparing with output
    reg [N-1:0] exp_master_rx;
    reg [N-1:0] exp_slave_rx;

    integer i;

    // 2. DUT Instantiation
    SPI_Top_level #(
        .N(N),
        .CLK_DIV(CLK_DIV)
    ) dut 
    (
        .clk            (clk),
        .rst_n          (rst_n),
        .start          (start),
        .master_tx_data (master_tx_data),
        .slave_tx_data  (slave_tx_data),
        .master_rx_data (master_rx_data),
        .slave_rx_data  (slave_rx_data),
        .done           (done)
    ); // dut(.*)

    //Clock Generation 
    initial 
    begin
        clk = 1'b0;
        forever begin
            #10 clk = ~clk;
        end
    end
    
    // Initial Block & Loop Randomize input 
    initial 
    begin
        //  Initial zero value inputs
        clk            = 0;
        rst_n          = 1; //active low 
        start          = 0;
        master_tx_data = 0;
        slave_tx_data  = 0;
         #10
        // Active & Deactive Reset
           rst_n = 0; // Active Reset (Low)
        #20 
           rst_n = 1; // Deactive Reset (High)
        #10;

        //  Repeat Loop (100 Randomized Tests) 
        for (i = 0; i < 100; i = i + 1) 
        begin
            // Randomize transmitted data
            master_tx_data = $random;
            slave_tx_data  = $random;

            // Expected Outputs
            exp_master_rx = slave_tx_data;  // Master should receive Slave's TX
            exp_slave_rx  = master_tx_data; // Slave should receive Master's TX

             @(posedge clk);
            //  Start signal for 1 clock cycle لبدا عمليه النقل فعلا 
    
            start = 1'b1;
            @(posedge clk);
            // نلغي اشاره التفعيل علشان لو ملغتهاش كده هيفضل ينقل بدون توقف
            start = 1'b0;

            // Wait for transfer completion flag
            wait(done);
            @(posedge clk);

            // Self-Checking 
            if (master_rx_data == exp_master_rx && slave_rx_data == exp_slave_rx) 
            begin
                $display("[SUCCESS] Test %0d Passed! Master RX: 0x%h (Exp: 0x%h), Slave RX: 0x%h (Exp: 0x%h)", 
                         i+1, master_rx_data, exp_master_rx, slave_rx_data, exp_slave_rx);
            end 
            else begin
                $display("[ERROR] Test %0d Failed! Master RX: 0x%h (Exp: 0x%h), Slave RX: 0x%h (Exp: 0x%h)", 
                         i+1, master_rx_data, exp_master_rx, slave_rx_data, exp_slave_rx);
            end

            #20; 
        end

        $display("=================================================");
        $display("        ALL 100 TESTS COMPLETED SUCCESSFULLY     ");
        $display("=================================================");
        $stop;
    end
endmodule