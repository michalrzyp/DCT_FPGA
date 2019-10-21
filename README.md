# DCT_FPGA
The theme of the project is a microcontroller module ready to perform DCT transforms using the UART interface. 
The prepared module consists of a stream of smaller modules.
UART_RX→FIFO→DEMUX→FIFO→DCT→FIFO→MUX→FIFO→UART_TX
