module SPI_Top_level #(
    parameter N = 8,          // Data width
    parameter CLK_DIV = 2     // Clock division factor
)
(
    input  wire         clk,             
    input  wire         rst_n,           // Active Low Reset
    input  wire         start,           // Start Transfer Trigger
    input  wire [N-1:0] master_tx_data,  // Data from Master to Slave
    input  wire [N-1:0] slave_tx_data,   // Data from Slave to Master
    
    output wire [N-1:0] master_rx_data,  // Data received by Master
    output wire [N-1:0] slave_rx_data,   // Data received by Slave
    output wire         done            
);

    // Internal Interconnect Wires (The SPI Bus)
    wire sclk;
    wire ss_n;
    wire mosi;
    wire miso;

    // Master Module Instantiation
    SPI_Master #(
        .N(N),
        .CLK_DIV(CLK_DIV)
    ) 
    master_inst
    (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (start),
        .tx_data (master_tx_data), //*******
        .miso    (miso),
        .sclk    (sclk),
        .ss_n    (ss_n),
        .mosi    (mosi),
        .rx_data (master_rx_data), //**********
        .done    (done)
    );

    // Slave Module Instantiation
    SPI_Slave #(
        .N(N)
    ) 
    slave_inst
    (
        .sclk    (sclk),
        .ss_n    (ss_n),
        .mosi    (mosi),
        .tx_data (slave_tx_data),//*******
        .miso    (miso),
        .rx_data (slave_rx_data) //*********
    );

endmodule
