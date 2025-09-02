module tb_uart_loopback;
  logic CLK;
  logic RESET;
  logic [7:0] TX_DIN;
  logic TX_ENA;
  logic TX_DONE;
  logic RX_DONE;
  logic [7:0] RX_DOUT;

  uart_loopback uart_inst (.CLK(CLK), .RESET(RESET), .TX_DIN(TX_DIN), .TX_ENA(TX_ENA), .TX_DONE(TX_DONE), .RX_DONE(RX_DONE), .RX_DOUT(RX_DOUT));

  always begin
    #5 CLK = ~CLK;
  end

  initial begin
    CLK = 0;
    RESET = 0;
    TX_DIN = 8'b00000000;
    TX_ENA = 0;
    
    #20;
    RESET = 1;

    #20;
    TX_DIN = 8'b01010101;
    TX_ENA = 1;
    #10;
    TX_ENA = 0;
    wait(TX_DONE == 1);
    wait(RX_DONE == 1);

    #20;
    TX_DIN = 8'b10100011;
    TX_ENA = 1;
    #10;
    TX_ENA = 0;
    wait(TX_DONE == 1);
    wait(RX_DONE == 1);

    #20;
    TX_DIN = 8'b11111111;
    TX_ENA = 1;
    #10;
    TX_ENA = 0;
    wait(TX_DONE == 1);
    wait(RX_DONE == 1);

    #20;
    TX_DIN = 8'b00011100;
    TX_ENA = 1;
    #10;
    TX_ENA = 0;
    wait(TX_DONE == 1);
    wait(RX_DONE == 1);

    #20;
    $finish;
  end

endmodule
