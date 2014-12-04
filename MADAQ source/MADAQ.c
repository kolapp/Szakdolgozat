#include <stdio.h>
#include "C8051F060.h"
#include "typedef.h"
#include "MADAQ_config.c"

// ezek CheckSRAMs()-hoz kellenek
#define XRAM(addr) (*((unsigned char __xdata *)(addr)))

#define SAMPLES(addr) (*((unsigned char __xdata *)(addr))) // mintak [0, 255] cimen
#define INPUT_MEASURE(addr) (*((unsigned char __xdata *)(256 + addr))) // adatok [256, 511] cimen
#define OUTPUT_MEASURE(addr) (*((unsigned char __xdata *)(512 + addr))) // adatok [512, 767] cimen

#define SET_ADDRESS_HI(x) (P3=(P3 & 0xF8) | (((x)>>16) & 0x07));

#define sysclk 24500000
#define SIZE 256
#define samples(addr) (*((unsigned char __xdata *)(addr)))

#define LED P2_2
#define DEBUG_PORT P0_2 // kapcsolasi rajzon talaltam egy szabad labat...
#define DEBUG_ON

#define CTS P2_0
#define RTS P2_1

__bit evenOdd = 0; // signal-gen delay
__bit handshake; // handshaking needed
INT8U dly_cycles = 225;
INT16U samplingfreq = 500;

INT8U i = 0; 
INT8U j = 0; 
INT8U n = 0; // !!!

// jelgenerator mintai
// __xdata INT8U samples[SIZE][2];
// __xdata INT8U input_measure[SIZE][2];
// __xdata INT16U output_measure[SIZE];
INT8U num_of_samples = 0; // memoriaban 2*num_of_samples db byte van !!!

void Delay_ms(short ms) {
	short i;
	for(i=0; i<24*ms; i++)
	{
		{ /* about 1ms, 11059200/12 Hz */
			__asm
				push b
				mov b,_dly_cycles
			00001$:
				djnz b,00001$
				mov b,_dly_cycles
			00002$:
				djnz b,00002$
				pop b
			__endasm;
		}
	}
}


// Wait for a byte from serial port (UART1-FT232RL USB) 
unsigned char SIn(void) {
	unsigned char saved_sfrpage;
	unsigned char c;

	saved_sfrpage=SFRPAGE;
	SFRPAGE   = UART0_PAGE;
	while (!RI0);
	RI0=0;
	c=SBUF0;
	SFRPAGE=saved_sfrpage;
	return c;
}


// if a byte has been received, return it, otherwise return 0
unsigned char SIn0(void) {
	unsigned char saved_sfrpage;
	unsigned char c;

	saved_sfrpage=SFRPAGE;
	SFRPAGE   = UART0_PAGE;
	c=0;
	if (RI0)
	{
		RI0=0;
		c=SBUF0;
	}
	SFRPAGE=saved_sfrpage;
	return c;
}


// sends a byte over the serial port
void SOut(unsigned char a) {
	unsigned char saved_sfrpage;

	if (handshake) while (CTS); 	// if FT232 can't accept data
	saved_sfrpage=SFRPAGE;
	SFRPAGE   = UART0_PAGE;
	while (!TI0);
	TI0=0;
	SBUF0=a;
	SFRPAGE=saved_sfrpage;
}


// waits for a byte, when arrived, sends back and returns with the value
unsigned char SInOut(void) {
	unsigned char saved_sfrpage;
	unsigned char c;
	
	saved_sfrpage=SFRPAGE;
	SFRPAGE   = UART0_PAGE;
	while (!RI0);
	RI0=0;
	c=SBUF0;
	if (handshake) while (CTS); 	// if FT232 can't accept data
	while (!TI0);
	TI0=0;
	SBUF0=c;
	SFRPAGE=saved_sfrpage;
	return c;
}


void SendID() {
	unsigned char *s;

	s="MA-DAQ";
	do {
		if (SIn()==27) break;
		SOut(*s);
		if (*s) s++;
	} while (*s);

}


// EZ MIT CSINAL??
unsigned char CheckSRAMs(void) {
	unsigned char k,j;

	SFRPAGE   = EMI0_PAGE;
	EMI0CF    = 0x3F;	// external SRAM only 

	SFRPAGE=CONFIG_PAGE;
	P4_5=0;	// enable SRAM

	k=0;
	SET_ADDRESS_HI(0);
	// check if all data wires are OK
	XRAM(0xF000)=0x55;
	XRAM(0xF001)=0xAA;
	if (XRAM(0xF000)!=0x55) k=1;
	if (XRAM(0xF001)!=0xAA) k=1;
	// check if all address wires are OK
	SET_ADDRESS_HI(0);
	for (j=0; j<16; j++) XRAM(1 << j)=j;
	for (j=0; j<16; j++) if (XRAM(1 << j)!=j) k|=2;
	// check if all page address wires are OK
	for (j=0; j<3; j++)
	{
		SET_ADDRESS_HI(1<<j);
		XRAM(0xF000+j)=j;
	}
	for (j=0; j<3; j++)
	{
		SET_ADDRESS_HI(1<<j);
		if (XRAM(0xF000+j)!=j) k|=4;
	}
	return k;
}

// ============================ [ Send data to PC ] ============================ //
void Send_ADC_data() {
	INT16U i = 0;
	
	 // Disable ADC0
	SFRPAGE   = ADC0_PAGE;
	AD0EN = 0;
	
	// ez elrontja a comm-t ???
	// Disable ADC1
	SFRPAGE   = ADC1_PAGE;
	AD1EN = 0;

	// send output data to pc
	for (i=0; i<num_of_samples *2+1; i++) {
		SOut(OUTPUT_MEASURE(i));
		i++;
	}
	
	// send input data
	for (i=0; i<num_of_samples *2+1; i++) {
		SOut(INPUT_MEASURE(i));
		i++;
	}
	
}


// ============================ [ ADC 0 - output data ] ============================ //
void ADC0_irqhandler (void) __interrupt 13 {

#ifdef DEBUG_ON	
	DEBUG_PORT = 1; // ON
#endif


	AD0INT = 0;	
	// meres
	OUTPUT_MEASURE(i) = ADC0H;
	i++;
	OUTPUT_MEASURE(i) = ADC0L;
	i++;

	
#ifdef DEBUG_ON	
	DEBUG_PORT = 0; // OFF
#endif	
}


// ============================ [ ADC 1 - input data ] ============================ //
// hint: eloszor a 13-mas interrupt hivodik
void ADC1_irqhandler (void) __interrupt 15 {

#ifdef DEBUG_ON	
	DEBUG_PORT = 1; // ON
#endif


	AD1INT = 0;	
	// output_measure[i] = (ADC1H << 8) | ADC1L;
	// input_measure[i] = ADC1; // gyüjti a mintakat

	INPUT_MEASURE(j) = ADC0H;
	j++;
	INPUT_MEASURE(j) = ADC0L;
	j++;
	
	// ha osszegyult 1 periodusnyi minta
	if (j >= num_of_samples *2) {
		i = 0;
		j = 0;
		
		SFRPAGE   = ADC0_PAGE;
		AD0EN = 0; // Disable ADC0
		
		// ez elrontja a comm-t ???
		SFRPAGE   = ADC1_PAGE;
		AD1EN = 0; // Disable ADC1
	}	
	/* nem tetszik:
	__asm
			clr	c
			mov	a,_num_of_samples
			rl a					// a *= 2; 
			dec a					// a--;
			subb	a,_i	
			jc	00103$
			mov	_i,#0x00 			// i = 0; 
			mov	_j,#0x00 			// j = 0;
			mov	_SFRPAGE,#0x00 		// SFRPAGE   = ADC0_PAGE;
			clr	_AD0EN 				// AD0EN = 0; // Disable ADC0	
			mov	_SFRPAGE,#0x01 		// SFRPAGE   = ADC1_PAGE;
			clr	_AD1EN 				// AD1EN = 0; // Disable ADC1
		00103$:
	__endasm;
	*/

	
#ifdef DEBUG_ON	
	DEBUG_PORT = 0; // OFF
#endif	
}


// ASM hack-el 2.2 mikro sec
// ASM hack nelkul 3 mikrosec-ig tart
// ============================ [ TIMER 2 ] ============================ //
void TMR2_irqhandler (void) __interrupt 5 {

// #ifdef DEBUG_ON	
	// DEBUG_PORT = 1; // ON
// #endif
	
	
	TF2 = 0; // ez kell, de pontosan miert?

	// index = [0, num_of_samples * 2]	
	__asm // if (n >= num_of_samples *2) n = 0; // 127 mintaig mukodik csak !!!
			clr	c
			mov	a,_num_of_samples
			rl a					// a *= 2; 
			dec a					// a--;
			subb	a,_n
			jnc	00102$
			mov	_n,#0x00
		00102$:
	__endasm;
	
	// jel generalas mintakbol
	DAC0H = SAMPLES(n); n++;
	DAC0L = SAMPLES(n); n++;
	
	
// #ifdef DEBUG_ON	
	// DEBUG_PORT = 0; // OFF
// #endif
}


void main() {
	INT8U c; // valtozo a beolvasott byte-oknak
	
	Init_Device();	
	
	// enelkul nem jo az UART0
	SFRPAGE = UART0_PAGE;
    TI0 = 1;
    RI0 = 0;
    // SFRPAGE = UART1_PAGE; // UART1 most nem kell
    // TI1 = 1;
    // RI1 = 0;
	
	CheckSRAMs();
	
	handshake = 1; // UART-hoz kell	
	
	// flash the power LED three times to indicate booting
	for(c=0; c<3; c++) {
		LED=0;
		Delay_ms(200);
		LED=1;
		Delay_ms(200);
	}
	LED=0;
	RTS=0;

	
	while (1) {
		while (SInOut()!='@');
		c = SInOut();
		
		// system info
		if (c=='I') {
			SendID();
		}
		
		// s, mint Send
		if (c=='S') {
			Send_ADC_data();
		}
		
		// set DAC0
		else if (c=='d') {
			unsigned char a; 
			c=SInOut();	// hi
			a=SInOut();	// lo
		    SFRPAGE   = DAC0_PAGE;
		    DAC0CN    = 0x84;
			DAC0L=a;
			DAC0H=c;
		}
		
		// set DAC1
		else if (c=='D') {
			unsigned char a; 
			c=SInOut();	// hi
			a=SInOut();	// lo
		    SFRPAGE   = DAC1_PAGE;
		    DAC1CN    = 0x84;
			DAC1L=a;
			DAC1H=c;
		}
		
		// tomb fogadasa - G, mint get()
		else if (c=='G') {
		
			SFRPAGE   = TMR2_PAGE;
			TR2 = 0; // disable tmr2 (kuldeskor ne nyuljon a tombhoz)
			
			// ez nem kell ide assssszem
			// SFRPAGE   = ADC0_PAGE;
			// CLR_BIT(ADC0CN, 7); // Disable ADC0			
			// ez elrontja a comm-t
			// SFRPAGE   = ADC1_PAGE;
			// AD1EN = 0; // Disable ADC1

			// bekeri hany elemet kell beolvasni
			num_of_samples = SInOut();
			// num_of_samples = (num_of_samples << 8) + SInOut(); // interrupt gyorsitashoz 8 bites-re vettem
			
			// tomb beolvasasa
			for (i=0; i < num_of_samples; i++) {
				// who will know what happens here? not even me.
				XRAM(2*i) = SInOut(); // paros: hi
				XRAM(2*i+1) = SInOut(); // paratlan: lo
			}		
		}
		
		// set TMR2 RLD value
		else if (c=='f') {
			RCAP2H   = SInOut();	// hi
			RCAP2L   = SInOut();	// lo
		}
		
		// [g]enerate samples
		else if (c=='g') {
		    SFRPAGE   = DAC0_PAGE;
		    DAC0CN    = 0x84;
			
			SFRPAGE   = TMR2_PAGE;
			TR2 = 1; // enable tmr2
		}
		
		// measure 2 channels
		else if (c=='m') {
			// reset indexes
			i = 0; 
			j = 0;			
			// start measurement
			SFRPAGE   = ADC0_PAGE;
			SET_BIT(ADC0CN, 7); // Enable ADC0, 7=MSB			
			SFRPAGE   = ADC1_PAGE;
			SET_BIT(ADC1CN, 7); // Enable ADC1, 7=MSB
		}
	}
}