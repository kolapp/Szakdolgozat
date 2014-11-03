/*

List of commands:

@I
Send a null-terminated identification text to host. 
The host must send a byte to receive each character, can send ESC to abort the process.

@x <byte>
The inputs can be connected to GND or 2,5V via a 10k resistor.
Logical one in any of the lower four bits means that the corresponding channel is connected.
The fifth bit is 0 for GND, 1 for 2,5V

@t <byte>
Inverts the trigger input, if the LSB of the input is 1.

@b <byte>
Sets the number of samples in a frame. Maximum value is 128, minimum is 2, use even numbers.
THe system waits for one frame of samples before sending data to the host.

@c <byte1> <byte2> <byte3> <byte4>
Configures the ADC channel and gain for continuous sampling mode
<byte1> and <byte2> sets ADC0 and ADC1 channel and gain for even samples, while
<byte3> and <byte4> sets ADC0 and ADC1 channel and gain for odd samples

*/

#include <stdio.h>
#include "C8051F060.h"


#define LED P2_2

#define CTS P2_0
#define RTS P2_1

#define SW0 P1_1		// switch Vref or GND via 10k resistors to inputs
#define SW1 P1_2
#define SW2 P1_3
#define SW3 P1_0
#define PGACS0 P1_4		// PGA chip select
#define PGACS1 P1_5		// PGA chip select

#define TRIGINV P2_3
#define PULL P2_4		// 0: pull up to Vref, 1: pull down to GND

#define XRAM(addr) (*((unsigned char xdata *)(addr)))
#define SET_ADDRESS_HI(x) (P3=(P3 & 0xF8) | (((x)>>16) & 0x07));

unsigned char dly_cycles=225;
unsigned long sysclk=24000000;

bit handshake;						// handshaking needed
unsigned char length;
bit Master;
unsigned int  samplingfreq=500;
unsigned int  adc0data,adc1data;	// ADC0 and ADC1 data
volatile unsigned char data_counter;
volatile unsigned int  data_ptr;	// ADC and DAC pointer

// Peripheral specific initialization functions,
// Called from the Init_Device() function
void Reset_Sources_Init()
{
    WDTCN     = 0xDE;
    WDTCN     = 0xAD;
}

void Timer_Init()
{
    SFRPAGE   = TIMER01_PAGE;
    TCON      = 0x40;
    TMOD      = 0x21;
    CKCON     = 0x18;
    TH1       = 0xFF;			// F3:115200 baud, FF:1,5M, SYSCLK=24 MHz
    SFRPAGE   = TMR2_PAGE;
    TMR2CN    = 0x04;
    TMR2CF    = 0x02;
    RCAP2L    = 0x9C;
    RCAP2H    = 0xFF;			// 20000Hz sampling rate
}

void UART_Init()
{
    SFRPAGE   = UART0_PAGE;
    SCON0     = 0x50;
    SSTA0     = 0x10;
	TI0=1;
	RI0=0;
}

void SPI_Init()
{
    SFRPAGE   = SPI0_PAGE;
    SPI0CFG   = 0x40;		// SCK idle low
//    SPI0CFG   = 0x70;		// SCK idle high
    SPI0CN    = 0x01;
    SPI0CKR   = 0x01;
}

void ADC_Init(unsigned char convertmode)
{
	SFRPAGE   = ADC0_PAGE;
	ADC0CF    = 0x10;
	if (convertmode == 2) ADC0CN = 0x88;		// ext trig
	else if (convertmode == 1) ADC0CN = 0x8C;	// timer2
	else ADC0CN = 0x80;							// write to AD0BUSY
	AD0INT=0;
	SFRPAGE   = ADC1_PAGE;
	ADC1CF    = 0x10;
	if (convertmode == 2) ADC1CN = 0x88;		// ext trig
	else if (convertmode == 1) ADC1CN = 0x8C;	// timer2
	else ADC1CN = 0x82;							// write to AD0BUSY
	AD1INT=0;
}

void DAC_Init()
{
    SFRPAGE   = DAC0_PAGE;
    DAC0CN    = 0x84;
    DAC0L     = 0x00;
    DAC0H     = 0x80;
    SFRPAGE   = DAC1_PAGE;
    DAC1CN    = 0x84;		// left justified, update on write to DAC0H
    DAC1L     = 0x00;
    DAC1H     = 0x80;
}

void Voltage_Reference_Init()
{
    SFRPAGE   = ADC0_PAGE;
    REF0CN    = 0x02;	// 0x03 for internal, 0x02 for external reference
    SFRPAGE   = ADC1_PAGE;
    REF1CN    = 0x02;	// 0x03 for internal, 0x02 for external reference
    SFRPAGE   = ADC2_PAGE;
    REF2CN    = 0x02;
}

void Port_IO_Init()
{
    // P0.0  -  TX0 (UART0), Push-Pull,  Digital
    // P0.1  -  RX0 (UART0), Open-Drain, Digital
    // P0.2  -  SCK  (SPI0), Push-Pull,  Digital
    // P0.3  -  MISO (SPI0), Open-Drain, Digital
    // P0.4  -  MOSI (SPI0), Open-Drain, Digital
    // P0.5  -  CEX0 (PCA),  Open-Drain, Digital
    // P0.6  -  CEX1 (PCA),  Open-Drain, Digital
    // P0.7  -  CEX2 (PCA),  Push-Pull,  Digital

    // P1.0  -  Unassigned,  Push-Pull,  Digital
    // P1.1  -  Unassigned,  Push-Pull,  Digital
    // P1.2  -  Unassigned,  Push-Pull,  Digital
    // P1.3  -  Unassigned,  Push-Pull,  Digital
    // P1.4  -  Unassigned,  Push-Pull,  Digital
    // P1.5  -  Unassigned,  Push-Pull,  Digital
    // P1.6  -  Unassigned,  Open-Drain, Digital
    // P1.7  -  Unassigned,  Open-Drain, Digital

    // P2.0  -  Unassigned,  Open-Drain, Digital
    // P2.1  -  Unassigned,  Push-Pull,  Digital
    // P2.2  -  Unassigned,  Open-Drain, Digital
    // P2.3  -  Unassigned,  Push-Pull,  Digital
    // P2.4  -  Unassigned,  Push-Pull,  Digital
    // P2.5  -  Unassigned,  Open-Drain, Digital
    // P2.6  -  Unassigned,  Push-Pull,  Digital
    // P2.7  -  Unassigned,  Open-Drain, Digital

    // P3.0  -  Unassigned,  Push-Pull,  Digital
    // P3.1  -  Unassigned,  Push-Pull,  Digital
    // P3.2  -  Unassigned,  Push-Pull,  Digital
    // P3.3  -  Unassigned,  Open-Drain, Digital
    // P3.4  -  Unassigned,  Open-Drain, Digital
    // P3.5  -  Unassigned,  Open-Drain, Digital
    // P3.6  -  Unassigned,  Open-Drain, Digital
    // P3.7  -  Unassigned,  Open-Drain, Digital

    SFRPAGE   = CONFIG_PAGE;
    P0MDOUT   = 0x05;
    P1MDOUT   = 0x3F;
    P2MDOUT   = 0x5A;
    P3MDOUT   = 0x07;
    P4MDOUT   = 0xE0;
    P5MDOUT   = 0xFF;
    P6MDOUT   = 0xFF;
    P7MDOUT   = 0xFF;
    XBR0      = 0x1E;
    XBR2      = 0x40;
}

void Oscillator_Init()
{
    int i = 0;
    SFRPAGE   = CONFIG_PAGE;
    OSCXCN    = 0x67;
    for (i = 0; i < 3000; i++);  // Wait 1ms for initialization
    while ((OSCXCN & 0x80) == 0);
    CLKSEL    = 0x01;
}

void Interrupts_Init()
{
    IE        = 0x00;
    EIE1      = 0x80;
}

// Initialization function for device,
// Call Init_Device() from your main program
void Init_Device(void)
{
    Reset_Sources_Init();
    Timer_Init();
    UART_Init();
    SPI_Init();
    ADC_Init(0);
    DAC_Init();
    Voltage_Reference_Init();
    Port_IO_Init();
    Oscillator_Init();
    Interrupts_Init();
}

void SetMaster(unsigned char c)
{
	if (c)	// master
	{
		Master=1;
		SFRPAGE   = PCA0_PAGE;
		PCA0CN    = 0x00;
		PCA0CPM2  = 0x46;
		SFRPAGE   = CONFIG_PAGE;
		P0MDOUT   = 0x85;
	}
	else	// slave
	{
		Master=0;
		SFRPAGE   = PCA0_PAGE;
		PCA0CN    = 0x00;
		PCA0CPM2  = 0x00;
		SFRPAGE   = CONFIG_PAGE;
		P0MDOUT   = 0x05;
	}
}

// Wait for a byte from serial port (UART1-FT232RL USB)
unsigned char SIn(void)
{
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
unsigned char SIn0(void)
{
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
void SOut(unsigned char a)
{
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
unsigned char SInOut(void)
{
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

void SendID()
{
	unsigned char *s;

	s="EduDAQ (c) 02/05/2009 www.noise.physx.u-szeged.hu";
	do
	{
		if (SIn()==27) break;
		SOut(*s);
		if (*s) s++;
	} while (*s);
}

void SetPGA0(unsigned char c)
{
	SFRPAGE = SPI0_PAGE;
	PGACS0  = 0;
	SPIF    = 0;
	SPI0DAT = 0x2A;
	while (!SPIF);
	SPIF    = 0;
	SPI0DAT = c;
	while (!SPIF);
	PGACS0  = 1;
}

void SetPGA1(unsigned char c)
{
	SFRPAGE = SPI0_PAGE;
	PGACS1  = 0;
	SPIF    = 0;
	SPI0DAT = 0x2A;
	while (!SPIF);
	SPIF    = 0;
	SPI0DAT = c;
	while (!SPIF);
	PGACS1  = 1;
}

void SetSamplingFreq(long freq)
{
	unsigned char PCAvalue;

	if (freq<4000) freq=4000;
	if (freq>60000) freq=60000;
	PCAvalue=1000000L/freq;
	SFRPAGE   = PCA0_PAGE;
	PCA0CPH2  = 0x64;
}

void Delay_ms(short ms)
{
	short i;
	for(i=0; i<24*ms; i++)
	{
		{ /* about 1ms, 11059200/12 Hz */
			_asm
				push b
				mov b,_dly_cycles
			00001$:
				djnz b,00001$
				mov b,_dly_cycles
			00002$:
				djnz b,00002$
				pop b
			_endasm;
		}
	}
}

// this routine will measure both analog inputs using
// the current setting for averaging and gain
void Convert(unsigned char avr)
{
	char oldsfrpage;
	unsigned char i;
	unsigned long d0,d1;

	d0=0;
	d1=0;
	oldsfrpage=SFRPAGE;
	ADC_Init(0);
	SFRPAGE=ADC1_PAGE;
	AD1INT=0;
	SFRPAGE=ADC0_PAGE;
	AD0INT=0;
	for(i=0;i<avr;i++)
	{
		AD0BUSY=1;
		while (!AD0INT);
		AD0INT=0;
		d0+=(unsigned int)(ADC0H << 8)+(unsigned int)ADC0L;
		SFRPAGE=ADC1_PAGE;
		while (!AD1INT);
		AD1INT=0;
		d1+=(unsigned int)(ADC1H << 8)+(unsigned int)ADC1L;
		SFRPAGE=ADC0_PAGE;
	}
	adc0data=d0/avr;
	adc1data=d1/avr;
	SFRPAGE=oldsfrpage;
}

void ADC0_irqhandler (void) interrupt 13
{
	_asm
		mov 	dpl,_data_ptr
		mov 	dph,_data_ptr+1
		mov 	_SFRPAGE,#ADC0_PAGE
		clr		_AD0INT
		mov 	a,_ADC0L
		movx 	@dptr,a
		inc 	dptr
		mov 	a,_ADC0H
		movx 	@dptr,a
		inc 	dptr
		mov 	_SFRPAGE,#ADC1_PAGE
		mov 	a,_ADC1H
		movx 	@dptr,a
		inc 	dptr
		mov 	a,_ADC1L
		movx 	@dptr,a
		dec 	dpl
		dec 	_data_counter
		mov 	a,_data_counter
		jnz		$00040
		mov 	_SFRPAGE,#PCA0_PAGE
		clr 	_CR
		clr 	_EA
$00040:
		mov 	_SFRPAGE,#DAC0_PAGE
		orl 	dph,#0x04
		movx 	a,@dptr
		inc 	dptr
		mov 	c,acc.0
		mov 	P2.6,c
		mov 	_DAC0L,a
		movx 	a,@dptr
		inc 	dptr
		mov 	_DAC0H,a
		anl 	dph,#0x03
		mov 	_data_ptr,dpl
		mov 	_data_ptr+1,dph
	_endasm;
}

void ReceiveDACdata(void)
{
	_asm
		mov 	dph,#4
		mov 	dpl,#0
		mov 	_SFRPAGE,#UART0_PAGE
		mov 	R7,_length
$00080:
		jnb 	_RI0,$00080
		clr 	_RI0
		mov 	a,_SBUF0
		movx 	a,@dptr
		inc 	dptr
$00082:
		jnb 	_RI0,$00082
		clr 	_RI0
		mov 	a,_SBUF0
		inc 	dptr
		inc 	dptr
		movx 	a,@dptr
		inc 	dptr
		djnz 	R7,$00080
	_endasm;
}

void SamplingToSRAM(void)
{
	unsigned char i;
	xdata unsigned char *xp;

	SFRPAGE   = ADC0_PAGE;
	AD0INT=0;
	SFRPAGE   = ADC1_PAGE;
	AD1INT=0;
	LED=0;

	EA=1;
	SFRPAGE   = PCA0_PAGE;
	if (Master) CR=1;
	while (EA); // wait for end of sampling
	EA=0;

	i=length;
	xp=0;
	do
	{
		SOut(*xp);
		xp++;
		i--;
	} while (i);
	LED=1;
}

void putchar(char c)
{
	SOut(c);
}

void main()
{
	unsigned char c;

	Init_Device();

	ADC_Init(2);
	handshake=0;
	length=128;
	LED=0;
	RTS=0;

	while (1)
	{
		while (SInOut()!='@');
		c=SInOut();
		if (c=='I')
		{
			SendID();
		}
		else if (c=='K') // start process
		{
			SamplingToSRAM();
		}
		else if (c=='Y') // 
		{
			SetMaster(SInOut());
		}
		else if (c=='1') // set range, current, channel
		{
			c=SInOut();
			SetPGA0(c);
		}
		else if (c=='2') // set range, current, channel
		{
			c=SInOut();
			SetPGA1(c);
		}
		else if (c=='f') // set freq
		{
			samplingfreq = SInOut();
			samplingfreq = (samplingfreq << 8)+SInOut();
			SetSamplingFreq(samplingfreq);
		}
		else if (c=='l')
		{
			length=SInOut();
			ReceiveDACdata();
		}
	}
}
