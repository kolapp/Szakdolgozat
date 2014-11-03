#include <stdio.h>
#include "C8051F060.h"
#include "typedef.h"
#include "MADAQ_config.c"

// ezek CheckSRAMs()-hoz kellenek
#define XRAM(addr) (*((unsigned char __xdata *)(addr)))
#define SET_ADDRESS_HI(x) (P3=(P3 & 0xF8) | (((x)>>16) & 0x07));

#define LED P2_2
#define DEBUG_PORT P0_2 // kapcsolasi rajzon talaltam egy szabad labat...


#define CTS P2_0
#define RTS P2_1

__bit handshake; // handshaking needed
INT8U dly_cycles = 225;
INT32U sysclk = 24000000;
INT16U samplingfreq = 500;


INT16U i = 0;

// jelgenerator mintai
__xdata INT16U samples[512];
INT16U elemszam = 0;


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
	do
	{
		if (SIn()==27) break;
		SOut(*s);
		if (*s) s++;
	} while (*s);

}


void ADC0_irqhandler (void) __interrupt 13 {
	AD0INT = 0;	
	
	DEBUG_PORT = !DEBUG_PORT; // debug
/*
	DEBUG_PORT = 1; // debug
	
	// jel generalas mintakbol
	DAC0L = samples[i];
	DAC0H = samples[i] >> 8;	
	
	// index noveles [0, elemszam]
	i++;
	if (i >= elemszam) i = 0;
	
	DEBUG_PORT = 0; // debug
*/
}

/*
void TMR2_irqhandler (void) __interrupt 5 {
	LED = !LED;
}
*/

// EZ MIT CSINAL???????????????????????????????????????????????????????????????????????????????????????????
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


void main() {
	INT8U c; // valtozo a beolvasott byte-oknak
	
	Init_Device();	
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
		
		// tomb fogadas - G, mint get()
		else if (c=='G') {
			SFRPAGE   = ADC0_PAGE;
			CLR_BIT(ADC0CN, 7); // Disable ADC0

			// bekeri hany elemet kell beolvasni
			elemszam = SInOut();
			elemszam = (elemszam << 8) + SInOut();
			
			// tomb beolvasasa
			for (i=0; i<elemszam; i++) {
				samples[i] = SInOut();
				samples[i] = (samples[i] << 8) + SInOut();

			}			
		}
		
		// set TMR2 RLD value
		else if (c=='f') {
			RCAP2H   = SInOut();	// hi
			RCAP2L   = SInOut();	// lo
		}
		
		// tomb [g]eneralas
		else if (c=='g') {		
		    SFRPAGE   = DAC0_PAGE;
		    DAC0CN    = 0x84;
			
			SFRPAGE   = ADC0_PAGE;
			SET_BIT(ADC0CN, 7); // Enable ADC0, 7=MSB
		}
		
	}
}