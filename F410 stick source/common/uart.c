// Wait for a byte from serial port (UART1-FT232RL USB) 
unsigned char SIn(void) {
	unsigned char c;
	while (!RI);
	RI=0;
	c=SBUF;
	return c;
}

// if a byte has been received, return it, otherwise return 0
unsigned char SIn0(void) {
	unsigned char c;

	c=0;
	if (RI)
	{
		RI=0;
		c=SBUF;
	}
	return c;
}

// sends a byte over the serial port
void SOut(unsigned char a) {
	while (!TI);
	TI=0;
	SBUF=a;
}

// waits for a byte, when arrived, sends back and returns with the value
unsigned char SInOut(void) {
	unsigned char c;

	while (!RI);
	RI=0;
	c=SBUF;
	while (!TI);
	TI=0;
	SBUF=c;
	return c;
}