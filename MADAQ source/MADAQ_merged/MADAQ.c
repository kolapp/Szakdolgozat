#include <stdio.h>
#include "C8051F060.h"
#include "MADAQ_cfg.c"
#include "typedef.h"

// DMA INSTRUCTIONS
#define DMA0_END_OF_OP     0x00           // End-of-Operation
#define DMA0_END_OF_OP_C   0x80           // End-of-Operation + Continue
#define DMA0_GET_ADC0      0x10           // Retrieve ADC0 Data
#define DMA0_GET_ADC1      0x20           // Retrieve ADC1 Data
#define DMA0_GET_ADC01     0x30           // Retrieve ADC0 and ADC1 Data
#define DMA0_GET_DIFF      0x40           // Retrieve Differential Data
#define DMA0_GET_DIFF1     0x60           // Retrieve Differential and ADC1 Data

#define LED P2_2

#define CTS P2_0
#define RTS P2_1

#define MUX1A0 P2_4
#define MUX1A1 P2_3
#define MUX2A0 P2_5
#define MUX2A1 P2_6
#define MUX1EN P1_4		// PGA chip select
#define MUX2EN P1_5		// PGA chip select


#define XRAM(addr) (*((unsigned char __xdata *)(addr)))
#define SET_ADDRESS_HI(x) (P3=(P3 & 0xF8) | (((x)>>16) & 0x07));

/* =====================[ 2CH AND TRANSFER FUNCTION MEASUREMENT ] ===================== */
#define SAMPLES(addr) (*((unsigned char __xdata *)(addr))) // jelgen. mintak [0, 255] cimen
#define INPUT_MEASURE(addr) (*((unsigned char __xdata *)(256 + addr))) // mert adatok [256, 511] cimen
#define OUTPUT_MEASURE(addr) (*((unsigned char __xdata *)(512 + addr))) // mert adatok [512, 767] cimen

#define FILTER_CONTROL P1_3
#define LED P2_2
#define DEBUG_PORT P0_2 // egy szabad port altalanos+debug celokra
//#define DEBUG_ON

INT8U i = 0; 
INT8U j = 0; 
INT8U n = 0;

INT8U num_of_samples = 0; // memoriaban 2*num_of_samples db byte van!
/*  =================================================================================== */

unsigned char dly_cycles=225;
unsigned long sysclk=24000000;

__bit handshake;						// handshaking needed
unsigned int  samplingfreq=500;
unsigned char adc_select=3;
unsigned int  adc0data,adc1data;			// ADC0 and ADC1 data
unsigned char ADCConfigEven,ADCConfigOdd;		// adc0 gain and channel selection for every even sample and every odd sample
unsigned char DAC0_mode;	// 0: normal mode, 1: function generator during smapling
volatile unsigned char dac_increment=1, dac_index, dac_amplitude=255, dac_offset;
volatile unsigned int  fifo_rp, fifo_wp;	// fifo write and read pointers
volatile unsigned char fifo_blocks;			// filled fifo blocks, available to read
volatile unsigned char fifo_max_blocks;		// maximum number of fifo blocks
volatile unsigned char samples_to_save;		// number of ADC samples to save into the actual fifo block
volatile unsigned char fifo_size;			// number of ADC samples (2 bytes/sample) in a fifo block
volatile unsigned char fifo_mode;			// fifo mode, continuous acquisition
volatile __bit EvenOddSample;

__xdata unsigned char fifo[16];


void ADC_Config(unsigned char convertmode)
{
	SFRPAGE   = ADC0_PAGE;
	if (convertmode == 2) ADC0CN = 0x88;	// ext trig
	else if (convertmode == 1) ADC0CN = 0x8C;	// timer2
	else ADC0CN = 0x80;	// write to AD0BUSY
	AD0INT=0;

	SFRPAGE   = ADC1_PAGE;
	if (convertmode == 2) ADC1CN = 0x88;	// ext trig
	else if (convertmode == 1) ADC1CN = 0x8C;	// timer2
	else ADC1CN = 0x82;	// write to AD0BUSY
	AD1INT=0;
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

	s="MA-DAQ (c) 23/03/2015 www.inf.u-szeged.hu/noise";
	do
	{
		if (SIn()==27) break;
		SOut(*s);
		if (*s) s++;
	} while (*s);
}

void SetSamplingFreq(long freq)
{
	unsigned int tmr2value;

	tmr2value=65536-(sysclk/12)/freq;
	SFRPAGE  = TMR2_PAGE;
	RCAP2L   = tmr2value;
	RCAP2H   = tmr2value >> 8;
}

void Delay_ms(short ms)
{
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
	ADC_Config(0);
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

/*
void ADC0_irqhandler (void) __interrupt 13
{
	__asm
		clr		_AD0INT
		cpl		_EvenOddSample
		mov 	a,_ADCConfigOdd
		jb		_EvenOddSample,L1
		mov 	a,_ADCConfigEven
L1:		anl 	_P2,#0x87
		orl 	_P2,a
		mov 	dpl,_fifo_wp
		mov 	dph,_fifo_wp+1
		mov 	a,_adc_select
		anl 	a,#1
		jz		$00005
		mov 	_SFRPAGE,#ADC1_PAGE
		mov 	a,_ADC1H
		movx 	@dptr,a
		inc 	dptr
		mov 	a,_ADC1L
		movx 	@dptr,a
		inc 	dptr
		dec 	_samples_to_save
$00005:	mov 	a,_adc_select
		anl 	a,#2
		jz		$00006
		mov 	_SFRPAGE,#ADC0_PAGE
		mov 	a,_ADC0H
		movx 	@dptr,a
		inc 	dptr
		mov 	a,_ADC0L
		movx 	@dptr,a
		inc 	dptr
		dec 	_samples_to_save
$00006:	mov 	_fifo_wp,dpl
		mov 	_fifo_wp+1,dph
		mov 	a,_fifo_mode
		jz		$00030
		mov 	a,_samples_to_save
		jnz		$00040
		inc 	_fifo_blocks
$00010:	mov 	_samples_to_save,_fifo_size
$00020:	ajmp	$00040	
$00030:	mov 	a,_fifo_wp+1	// non fifo mode
		clr 	c
		subb 	a,_fifo_max_blocks
		jc		$00040
		clr 	_EA
$00040:	mov		a,_DAC0_mode
		jz 		$00050
		mov 	dptr,#_sinetable
		mov 	a,_dac_index
		add 	a,_dac_increment
		mov 	_dac_index,a
		movc 	a,@a+dptr
		mov 	_SFRPAGE,#DAC1_PAGE
		mov 	b,_dac_amplitude
		mul		ab
		mov 	a,b
		add 	a,_dac_offset
		mov 	_DAC1H,a
$00050:	nop
	__endasm;
}
*/

unsigned char CheckSRAMs(void)
{
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

void ContSampling(void)
{
	unsigned char rec_chr,i;

//	Delay_ms(500);

	rec_chr=0;
	dac_index=0;
	if (DAC0_mode)
	{
		SFRPAGE   = DAC0_PAGE;
		DAC0CN    = 0x9C;		// left justified, update on Timer2 overflow
	}
	SFRPAGE   = TMR2_PAGE;
	TMR2CN    = 0x00;
	ADC_Config(1);
	SFRPAGE   = ADC0_PAGE;
	AD0INT=0;
	SFRPAGE   = ADC1_PAGE;
	AD1INT=0;
	fifo_wp=fifo_rp=0;
	samples_to_save=fifo_size;
	fifo_blocks=0;
	fifo_max_blocks=0;
	fifo_mode=1;
	EvenOddSample=0;
	P2 = (P2 & 0x87) | ADCConfigEven;	// select ADC channels

	SFRPAGE=CONFIG_PAGE;
	P4_5=0;	// enable SRAM
	LED=0;
	EA=1;
	SFRPAGE   = TMR2_PAGE;
	TMR2CN    = 0x04;
	do
	{
		while (!fifo_blocks);
		for(i=0; i<fifo_size; i++)
		{
			SOut(fifo[fifo_rp++]);
			SOut(fifo[fifo_rp++]);
		}
		fifo_blocks--;
	} while (SIn0()!=27);
	SFRPAGE=CONFIG_PAGE;
	P4_5=1;	// disable SRAM
	EA=0;
	SFRPAGE   = TMR2_PAGE;
	TMR2CN    = 0x00;
	SFRPAGE   = DAC0_PAGE;
	DAC0CN    = 0x84;
	LED=1;
}

void SamplingToSRAM(unsigned char blocks)
{
	unsigned char rec_chr,i;

	rec_chr=0;
	dac_index=0;
	if (DAC0_mode)
	{
		SFRPAGE   = DAC0_PAGE;
		DAC0CN    = 0x9C;		// left justified, update on Timer2 overflow
	}
	SFRPAGE   = TMR2_PAGE;
	TMR2CN    = 0x00;
	ADC_Config(1);
	SFRPAGE   = ADC0_PAGE;
	AD0INT=0;
	SFRPAGE   = ADC1_PAGE;
	AD1INT=0;
	fifo_wp=fifo_rp=0;
	samples_to_save=fifo_size;
	fifo_blocks=0;
	fifo_max_blocks=blocks;
	fifo_mode=0;
	dac_index=0;
	LED=0;

    SFRPAGE   = TMR4_PAGE;
    TMR4CN    = 0x04;
    TMR4CF    = 0x08;

	SFRPAGE=CONFIG_PAGE;
	P4_5=0;	// enable SRAM
	EA=1;
	SFRPAGE   = TMR2_PAGE;
	TMR2CN    = 0x04;
	while (EA); // wait for end of sampling

	do
	{
		rec_chr=SIn();
		for(i=0; i<fifo_size; i++)
		{
			SOut(fifo[fifo_rp++]);
			SOut(fifo[fifo_rp++]);
		}
	} while ( (rec_chr!=27) && (fifo_rp<fifo_wp) );

	SFRPAGE=CONFIG_PAGE;
	P4_5=1;	// disable SRAM
	EA=0;
	SFRPAGE   = TMR2_PAGE;
	TMR2CN    = 0x00;
	LED=1;
	SFRPAGE   = DAC0_PAGE;
	DAC0CN    = 0x84;
}

void HiSpeedSampling(unsigned int samples) 	// uses DMA
{
	unsigned char rec_chr;
	unsigned int i;

	LED=0;

	rec_chr=0;
	SFRPAGE   = TMR2_PAGE;
	TMR2CN    = 0x00;

    SFRPAGE   = ADC0_PAGE;
    ADC0CF    = 0x10;
	ADC0CN = 0x4C;	// timer2
	AD0INT=0;
    SFRPAGE   = ADC1_PAGE;
    ADC1CF    = 0x10;
	ADC1CN = 0x4C;	// timer2
	AD1INT=0;


	SFRPAGE=CONFIG_PAGE;
	P4_5=0;	// enable SRAM

	SFRPAGE   = TMR2_PAGE;
	TMR2CN    = 0x04;

	SFRPAGE = DMA0_PAGE;        // Switch to DMA0 Page
	DMA0CN = 0x00;    		  	// Disable DMA interface
	DMA0DAL = 0;            	// Starting Point for XRAM addressing
	DMA0DAH = 0;            	// Starting Point for XRAM addressing
	DMA0CTL = samples;          // Get NUM_SAMPLES samples
	DMA0CTH = samples>>8;       // Get NUM_SAMPLES samples
	DMA0IPT = 0x00;             // Start writing at location 0
	// Push instructions onto stack in order they will be executed
	DMA0IDT = adc_select<<4; 	// DMA0_GET_ADC0;            // DMA to move ADC0 data.
	DMA0IDT = DMA0_END_OF_OP;

	DMA0BND = 0x00;             // Begin instruction executions at address 0
	DMA0CN = 0xA0;              // Mode 1 Operations, Begin Executing DMA Ops
                                // (which will start ADC0)
	SFRPAGE = DMA0_PAGE;      	// Switch to DMA0 Page
	while ((!(DMA0CN & 0x40)) && (SIn0()!=27));  // Wait for DMA to obtain and move ADC samples
	LED=1;
	i=0;
	do
	{
		if (adc_select==3)
		{
			SOut(XRAM(4*i));
			SOut(XRAM(4*i+1));
			SOut(XRAM(4*i+2));
			SOut(XRAM(4*i+3));
		}
		else
		{
			SOut(XRAM(2*i));
			SOut(XRAM(2*i+1));
		}
		i++;
	} while (i<samples);

	SFRPAGE=CONFIG_PAGE;
	P4_5=1;	// disable SRAM
	EA=0;
	SFRPAGE   = TMR2_PAGE;
	TMR2CN    = 0x00;
	LED=1;
}

void putchar(char c)
{
	SOut(c);
}

void test(void)
{
	unsigned char c;

	c=128-4;
    SFRPAGE   = DAC0_PAGE;
	DAC0H=128-4;
    SFRPAGE   = DAC1_PAGE;
	DAC1H=128-8;
	while (1)
	{
		P0_5=!P0_5;
//		SetPGA0(0x00);
		Delay_ms(10);
		Convert(1); // get channel and convert
		adc1data-=32768;
		printf("%8d",adc1data);
//		SetPGA0(0x01);
		Delay_ms(10);
		Convert(1); // get channel and convert
		adc1data-=32768;
		printf("%8d",adc1data);
//		SetPGA1(0x00);
		Delay_ms(10);
		Convert(1); // get channel and convert
		adc0data-=32768;
		printf("%8d",adc0data);
//		SetPGA1(0x01);
		Delay_ms(10);
		Convert(1); // get channel and convert
		adc0data-=32768;
		printf("%8d\n\r",adc0data);
	}
}

/* =====================[ 2CH AND TRANSFER FUNCTION MEASUREMENT ] ===================== */
void Send_ADC_data() {
	INT8U i = 0;
	
	// ADC alljon meg kuldes alatt
	SFRPAGE   = TMR2_PAGE;
	TR2 = 0; // Disable TMR2
	// legkozelebb 0V-rol induljon a DAC: 
	SFRPAGE = DAC1_PAGE;
	DAC1H = 0x80;
	DAC1L = 0;
	
	// send input data to pc
	for (i=0; i<num_of_samples *2/*+1*/; i++) {
		SOut(INPUT_MEASURE(i)); // HI
		i++;
		SOut(INPUT_MEASURE(i)); // LO
	}
	
	// send output data to pc
	for (i=0; i<num_of_samples *2/*+1*/; i++) {
		SOut(OUTPUT_MEASURE(i)); // HI
		i++;
		SOut(OUTPUT_MEASURE(i)); // LO
	}	
}


void ADC0_irqhandler (void) __interrupt 13 {

#ifdef DEBUG_ON	
	DEBUG_PORT = 1; // ON
#endif


	AD0INT = 0;	
	
	// COMPILE ERROR ERROR - wtf
	// if (samples_to_save != 0) {;}
	
	// index ellenorzes
	__asm
		// if (n >= num_of_samples *2) n = 0; // csak 127 mintaig jo!
		clr	c
		mov	a,_num_of_samples
		rl a					// a *= 2; 
		dec a					// a--;
		subb	a,_n
		jnc	ELSE
		mov	_n, #0x00
		ELSE:
	__endasm;
	
	// ------ CSATORNA #1 MERES ------ 
	__asm
		// SFRPAGE = ADC1_PAGE;
		// i = n; j = n; // kezdoindex beallitas
		// INPUT_MEASURE(i) = ADC1H; i++;
		// INPUT_MEASURE(i) = ADC1L; i++;
		mov	_SFRPAGE,#0x01
		mov dpl,_n
		mov dph,#0x01	// dptr: 0x0100-tol 0x01FF-ig
		mov a,_ADC1H
		movx @dptr,a
		inc dpl
		mov a,_ADC1L
		movx @dptr,a
	__endasm;	
	
	// ------ CSATORNA #2 MERES ------ 
	__asm
		// SFRPAGE = ADC0_PAGE;
		// OUTPUT_MEASURE(j) = ADC0H; j++;
		// OUTPUT_MEASURE(j) = ADC0L; j++;	
		mov	_SFRPAGE,#0x00
		mov dpl,_n
		mov dph,#0x02	// dptr: 0x0200-tol 0x02FF-ig
		mov a,_ADC0H
		movx @dptr,a
		inc dpl
		mov a,_ADC0L
		movx @dptr,a
	__endasm;
	
	// ------ JEL-GENERALAS ------ 
	__asm 
		// jel generalas mintakbol
		// DAC0H = SAMPLES(n); n++;
		// DAC0L = SAMPLES(n); n++;
		mov	_SFRPAGE,#0x01 // DAC1_PAGE
		mov	dpl,_n
		mov	dph,#0x00
		movx	a,@dptr
		mov	_DAC1H,a
		inc dpl
		movx	a,@dptr
		mov	_DAC1L,a
		inc	_n
		inc	_n
	__endasm;
	
	
#ifdef DEBUG_ON	
	DEBUG_PORT = 0; // OFF
#endif	
}
/*  =================================================================================== */

void main()
{
	unsigned char c;

	Init_Device();
	
	// UART init
	SFRPAGE   = UART0_PAGE;
	TI0=1;
	RI0=0;
	SFRPAGE   = UART1_PAGE;
	TI1=1;
	RI1=0;

	CheckSRAMs();

	adc_select=3;
	ADCConfigEven=ADCConfigOdd=0;		// adc0 gain and channel selection for every even sample and every odd sample
	DAC0_mode=0;
	handshake=1;
	dac_increment=1;
	dac_amplitude=255;
	dac_offset=0;
	fifo_size=128;	// default number of samples in a block

//fifo_size=4;	// default number of samples in a block
//SetSamplingFreq(100);

	for(c=0; c<3; c++)	// flash the power LED three times to indicate booting
	{
		LED=0;	Delay_ms(200);
		LED=1;	Delay_ms(200);
	}
	LED=0;


	RTS=0;

	MUX1EN = 1;
	MUX2EN = 1;

	while (1)
	{
		while (SInOut()!='@');
		c=SInOut();
		if (c=='I')
		{
			SendID();
		}
/* ============[ 2CH AND TRANSFER FUNCTION MEASUREMENT ] ========= */
		else if (c=='S') {
			Send_ADC_data();
		}
		
		// tomb feltoltese mintakkal - G, mint get()
		else if (c=='G') {	
			SFRPAGE   = TMR2_PAGE;
			TR2 = 0; // Disable TMR2 (kuldeskor ne nyuljon a tombhoz)
			
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
		
		// set TMR2 RLD value - f, mint freq
		else if (c=='f') {
			RCAP2H   = SInOut();	// hi
			RCAP2L   = SInOut(); // lo
		}
		
		// generate sample signal
		else if (c=='g') {
			// teszt
			Init_Device();
		    SFRPAGE   = DAC1_PAGE;
		    DAC1CN    = 0x84;
			
			SFRPAGE   = TMR2_PAGE;
			TR2 = 1; // Enable TMR2
			
			SFRPAGE   = ADC0_PAGE;
			AD0EN = 1; // Enable ADC0	
			SFRPAGE   = ADC1_PAGE;
			AD1EN = 1; // Enable ADC1
		}
		
		else if (c=='C') {
			// 0 = fs < 1200 Hz
			// 1 = fs > 1200 Hz			
			FILTER_CONTROL = SInOut() & 1;
		}
		
		// teszt: mert jel generalasa (ellenorzes)
		else if (c=='t') {		
			// ADC alljon meg kuldes alatt
			SFRPAGE   = TMR2_PAGE;
			TR2 = 0; // Disable TMR2			
			for (i=0; i<num_of_samples *2+2; i++) {
				SAMPLES(i) = INPUT_MEASURE(i);
				i++;
				SAMPLES(i) = INPUT_MEASURE(i);
			}			
			// ADC alljon meg kuldes alatt
			SFRPAGE   = TMR2_PAGE;
			TR2 = 1; 
		}
/* =============================================================== */
		else if (c=='x')	// switch reference voltage and resistors
		{
		}
		// else if (c=='t')	// set trigger polarity
		// {
		// }
		else if (c=='b')	// set fifo block size (number of samples in a block
		{
			fifo_size=SInOut();
		}
		else if (c=='c')	// configure continuous sampling mode
		{
			c=SInOut();
			ADCConfigEven = ((c & 1) << 4) | ((c & 2) << 2);
			c=SInOut();
			ADCConfigEven =  ((c & 1) << 5) | ((c & 2) << 5);
			c=SInOut();
			ADCConfigOdd = ((c & 1) << 4) | ((c & 2) << 2);
			c=SInOut();
			ADCConfigOdd =  ((c & 1) << 5) | ((c & 2) << 5);
		}
		// else if (c=='S') // start sampling, ESC exits
		// {
			// ContSampling();
		// }
		else if (c=='s') // start sampling, ESC exits
		{
			unsigned long n;

			n = SInOut();
			n = (n << 8)+SInOut();
			n = (n << 8)+SInOut();
			SetSamplingFreq(n);
			n = SInOut();
			n = (n << 8)+SInOut();
			HiSpeedSampling(n);
		}
		else if (c=='A') // select ADCs
		{
			adc_select = SInOut() & 3;
		}
		else if (c=='1') // set channel
		{
			c=SInOut();
			MUX1A0 = c & 1;
			MUX1A1 = c & 2;
		}
		else if (c=='2') // setchannel
		{
			c=SInOut();
			MUX2A0 = c & 1;
			MUX2A1 = c & 2;
		}
		else if (c=='M') // measure channels
		{
			c=SInOut();
			if (c<1) c=1;
			Convert(c); // make a single conversion and send data to PC
			SOut(adc1data >> 8);	// channel 0 or 1
			SOut(adc1data);
			SOut(adc0data >> 8);	// channel 2 or 3
			SOut(adc0data);
		}
		// else if (c=='f') // set freq
		// {
			// samplingfreq = SInOut();
			// samplingfreq = (samplingfreq << 8)+SInOut();
			// SetSamplingFreq(samplingfreq);
		// }
		else if (c=='P') // set port __bits
		{
			P1 = (P1 & 0xF0) | (SInOut() & 0x0F);
		}
		else if (c=='Q') // set port __bits
		{
			SOut(P1 & 0x0F);
		}
		else if (c=='d') // set DAC0
		{
			unsigned char a; 
			c=SInOut();	// hi
			a=SInOut();	// lo
		    SFRPAGE   = DAC0_PAGE;
		    DAC0CN    = 0x84;
			DAC0L=a;
			DAC0H=c;
		}
		else if (c=='D') // set DAC1
		{
			unsigned char a; 
			c=SInOut();	// hi
			a=SInOut();	// lo
		    SFRPAGE   = DAC1_PAGE;
		    DAC1CN    = 0x84;
			DAC1L=a;
			DAC1H=c;
		}
		else if (c=='L') // set DAC parameters
		{
			dac_increment = SInOut();
			dac_amplitude = SInOut();
			dac_offset = SInOut();
		}
		else if (c=='w') // DAC0 wavegenerator off
		{
			DAC0_mode=0;
		}
		else if (c=='W') // DAC0 wavegenerator on
		{
			DAC0_mode=1;
		}
	}
}

unsigned char __code sinetable[] =
{
	 128, 131, 134, 137, 140, 144, 147, 150, 153, 156, 159, 162, 165, 168, 171, 174,
	 177, 179, 182, 185, 188, 191, 193, 196, 199, 201, 204, 206, 209, 211, 213, 216,
	 218, 220, 222, 224, 226, 228, 230, 232, 234, 235, 237, 239, 240, 241, 243, 244,
	 245, 246, 248, 249, 250, 250, 251, 252, 253, 253, 254, 254, 254, 255, 255, 255,
	 255, 255, 255, 255, 254, 254, 254, 253, 253, 252, 251, 250, 250, 249, 248, 246,
	 245, 244, 243, 241, 240, 239, 237, 235, 234, 232, 230, 228, 226, 224, 222, 220,
	 218, 216, 213, 211, 209, 206, 204, 201, 199, 196, 193, 191, 188, 185, 182, 179,
	 177, 174, 171, 168, 165, 162, 159, 156, 153, 150, 147, 144, 140, 137, 134, 131,
	 128, 125, 122, 119, 116, 112, 109, 106, 103, 100,  97,  94,  91,  88,  85,  82,
	  79,  77,  74,  71,  68,  65,  63,  60,  57,  55,  52,  50,  47,  45,  43,  40,
	  38,  36,  34,  32,  30,  28,  26,  24,  22,  21,  19,  17,  16,  15,  13,  12,
	  11,  10,   8,   7,   6,   6,   5,   4,   3,   3,   2,   2,   2,   1,   1,   1,
	   1,   1,   1,   1,   2,   2,   2,   3,   3,   4,   5,   6,   6,   7,   8,  10,
	  11,  12,  13,  15,  16,  17,  19,  21,  22,  24,  26,  28,  30,  32,  34,  36,
	  38,  40,  43,  45,  47,  50,  52,  55,  57,  60,  63,  65,  68,  71,  74,  77,
	  79,  82,  85,  88,  91,  94,  97, 100, 103, 106, 109, 112, 116, 119, 122, 125
};
