Universal Asynchronous Receiver/Transmitter (UART) is a protocol for exchanging serial data between devices. 
The transmitting UART converts parallel data from a CPU or microcontroller into a serial data packet containing a start bit, data bits, an optional parity bit, and stop bits, sending it bit by bit to the receiver. 
The receiving UART then reconstructs the serial signal back into parallel data.


My approach implements a UART loopback system that demonstrates serial communication functionality by connecting a transmitter and receiver within the same FPGA.

