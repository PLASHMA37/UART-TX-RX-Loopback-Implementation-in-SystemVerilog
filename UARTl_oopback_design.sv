`timescale 1ns / 1ps
module uart_loopback(input logic CLK, RESET,[7:0]  TX_DIN,
  input logic TX_ENA,
  output logic TX_DONE,RX_DONE,[7:0]RX_DOUT);

  logic TX_SERIAL;
  
  uart_tx uart_tx (.CLK(CLK),.RESET(RESET),.TX_DIN(TX_DIN),.TX_ENA(TX_ENA),.TX_DONE(TX_DONE),.TX_SERIAL(TX_SERIAL));
  uart_rx uart_rx (.CLK(CLK),.RESET(RESET),.RX_SERIAL(TX_SERIAL),.RX_DOUT(RX_DOUT),.RX_DONE(RX_DONE));
endmodule

module uart_tx(input  logic CLK,RESET,[7:0]TX_DIN,
  input  logic TX_ENA,
  output logic TX_DONE,TX_SERIAL);

  typedef enum logic { S_IDLE, S_TRANSFER }statetype;
  statetype state;
  logic [3:0]bitcntr;
  logic [9:0]tx_buffer;

  always_ff @(posedge CLK) begin
    if(!RESET) begin
      state <= S_IDLE;
      TX_DONE <= 1'b0;
      TX_SERIAL <= 1'b1;
      bitcntr <= 0;
    end else begin
      case (state)
        S_IDLE: begin
         TX_SERIAL <= 1'b1;
          TX_DONE <= 1'b0;
          if (TX_ENA) begin
            state <= S_TRANSFER;
            bitcntr <= 0;
            tx_buffer <= {1'b1, TX_DIN, 1'b0};
          end
        end

        S_TRANSFER: begin
          TX_SERIAL <= tx_buffer[0];
          begin
            tx_buffer <= {1'b1, tx_buffer[9:1]};
            bitcntr <= bitcntr + 1;
            if (bitcntr == 9) begin
              TX_DONE <= 1'b1;
              state <= S_IDLE;
            end
          end
        end
      endcase
    end
  end
endmodule

module uart_rx(
  input  logic CLK, RESET, RX_SERIAL,
  output logic [7:0] RX_DOUT,
  output logic RX_DONE
);
  typedef enum logic { S_IDLE, S_RECEIVE }statetype;
  statetype state;
  logic [8:0]  rx_buffer;
  logic [3:0]  bitcntr;

  always_ff @(posedge CLK) begin
    if (!RESET) begin
      state <= S_IDLE;
      RX_DONE <= 1'b0;
      RX_DOUT <= 8'd0;
      bitcntr <= 0;
      rx_buffer <= 9'd0;
    end 
    else begin
      case (state)
        S_IDLE: begin
          RX_DONE <= 1'b0;
          if (!RX_SERIAL) begin
             begin
              state <= S_RECEIVE;
              bitcntr <= 0;
            end
          end else begin
          end
        end

        S_RECEIVE: begin
       begin
            rx_buffer <= {RX_SERIAL, rx_buffer[8:1]};
            bitcntr <= bitcntr + 1;
            if (bitcntr == 9) begin
              RX_DOUT <= rx_buffer[7:0];
              RX_DONE <= 1'b1;
              state <= S_IDLE;
            end
          end
        end
      endcase
    end
  end
endmodule
