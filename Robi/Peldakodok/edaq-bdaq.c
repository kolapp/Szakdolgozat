/*

Szia!

Struktúrailag:

Felteszem csak sima C-t tudsz használni, így a logikailag kapcsolódó metódusok külön fájlokba helyezésénél többet struktúrailag nem biztos, hogy lehet csinálni. 

* Amit egybefüggõ résznek látok, például már a kommentek alapján is, az az Init_Device() és a felette tévõ metódusok - "Peripheral specific initialization functions".

* Aztán jönnek olyan függvények, amiket én I/O mûveleteknek vélek - SIn(), SIn0(), SOut(), SInOut() | SendId() -> ebben nem vagyok biztos, ez elég specifikusnak tûnik, konkrét üzenetet küld, nem szigorúan I/O.

* Aztán van néhány SetPGA..(), SetSamplingFreq(), Delay(), CheckSRAMs(). Ezek gondolom globálisan állítanak, ellenõriznek a program, lapka mûködésén.

* A *Sampling() metódusok gondolom különbözõ mintavételezési módszereket valósítanak meg. Ezek is egy csoportnak tûnnek.

* Van itt egy putchar(char c), ami egy az egyben hívja az SOut(char c)-t. Ennek van valami különösebb oka? Ha nincs akkor törölhetõ és helyette hasznald az SOut()-ot.

* test() végülis elfér a main mellett.

* main(): Ehhez van több dolog is.

  * Legyen egy külön main.c vagy hasonló fájlban.

  * Az Init_Device() és CheckSRAMs() hívás utn van egy kódblokk, ami értékeket állít be. Esetleg lehetnek külön metódusban.

  * A nagy if elágazást elég ronda. Én egy switch(char c) -re cserélném, és az összes branch-en belüli utasítást kiraknám külön metódusba, beszédes nevekkel, ugyanígy az I,x,b stb karaktereket konstansként értelmes névvel definiálnám. Lehet ha egy mérnök ránéz, õ tudja, hogy az ág amikor a c=='x' mit jelent, de más ránéz a kódra nem mond semmit - ok ott a komment mellette, de pl c=="S" // start sampling, ESC exits // - esetén sokkal szebb lenne egy:
    
    switch(c)
        case START_SAMPLING:
            ContSampling();
            break;
        case SWITCH_REF_VOLTAGE_AND_RESISTORS:
            switchRefVoltageAndResistors();
            break;
        ...

-- ---------------------------------------------------------------------

Érzésre:

* Az elnevezések legyenek következetesek. Általában camel case-esen (camelBack) vannak elnevezve a metódusok, de pl az init-es ek nem. Amiket az Init_Device() hív pl Timer_Init(). Meg akkor már talán mindehol vagy az elején legyen az Init vagy a végén.

* Ugyanez a Delay_ms(), ADC0_irqhandler().

* Néhol látok varázs számokat, ezeket is érdemes lehet beszédesebb nevû konstansokba rakni. Pl. 991.sor: DAC0CN    = 0x84; // Ez az érték mit takar? Talán szebb egy DAC0CN    = STHG_FANCY; - bár lehet túlzásba sem kell vinni a konstansokba kiemelést, de a switch/nagy if else ben mindképp érdemés a char-okat.

Hirtelen ennyi.

*/




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

//#define F064EK


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

#define TRIGGER P0_5

#define SW0 P1_1		// switch Vref or GND via 10k resistors to inputs
#define SW1 P1_2
#define SW2 P1_3
#define SW3 P1_0
#define PGACS0 P1_4		// PGA chip select
#define PGACS1 P1_5		// PGA chip select

#define TRIGINV P2_3
#define PULL P2_4		// 0: pull up to Vref, 1: pull down to GND

#define XRAM(addr) (*((unsigned char __xdata *)(addr)))
#define SET_ADDRESS_HI(x) (P3=(P3 & 0xF8) | (((x)>>16) & 0x07));

unsigned char dly_cycles=225;
unsigned long sysclk=24000000;

__bit handshake;						// handshaking needed
unsigned int  samplingfreq=500;
unsigned char adc_select=3;
unsigned int  adc0data,adc1data;			// ADC0 and ADC1 data
unsigned char ADC0ConfigEven,ADC0ConfigOdd;		// adc0 gain and channel selection for every even sample and every odd sample
unsigned char ADC1ConfigEven,ADC1ConfigOdd;
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
    TH1       = 0xFF; // F3:115200 baud, FF:1,5M, SYSCLK=24 MHz
    SFRPAGE   = TMR2_PAGE;
    TMR2CN    = 0x04;
    TMR2CF    = 0x02;
    RCAP2L    = 0x9C;
    RCAP2H    = 0xFF;	// 20000Hz sampling rate
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
    ADC0CF    = 0x00;
	if (convertmode == 2) ADC0CN = 0x88;	// ext trig
	else if (convertmode == 1) ADC0CN = 0x8C;	// timer2
	else ADC0CN = 0x80;	// write to AD0BUSY
	AD0INT=0;
    SFRPAGE   = ADC1_PAGE;
    ADC1CF    = 0x00;
	if (convertmode == 2) ADC1CN = 0x88;	// ext trig
	else if (convertmode == 1) ADC1CN = 0x8C;	// timer2
	else ADC1CN = 0x82;	// write to AD0BUSY
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

void EMI_Init()
{
    SFRPAGE   = EMI0_PAGE;
    EMI0CF    = 0x3F;
    //EMI0TC    = 0x41; // still working
	EMI0TC    = 0x40; // fast enough
	//EMI0TC    = 0x59; // wery slow :)
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
    // P0.4  -  MOSI (SPI0), Push-Pull,  Digital
    // P0.5  -  Unassigned,  Open-Drain, Digital
    // P0.6  -  Unassigned,  Open-Drain, Digital
    // P0.7  -  Unassigned,  Open-Drain, Digital

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
    // P2.6  -  Unassigned,  Open-Drain, Digital
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
    P0MDOUT   = 0x15;
    P1MDOUT   = 0x3F;
    P2MDOUT   = 0x1A;
    P3MDOUT   = 0x07;
    P4MDOUT   = 0xE0;
    P5MDOUT   = 0xFF;
    P6MDOUT   = 0xFF;
    P7MDOUT   = 0xFF;
    XBR0      = 0x06;
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
    EMI_Init();
    Voltage_Reference_Init();
    Port_IO_Init();
    Oscillator_Init();
    Interrupts_Init();
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

	s="B-DAQ 0.1 (c) 2012 www.inf.u-szeged.hu/noise";
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
	unsigned int tmr2value;

	tmr2value=65536-(sysclk/12)/freq;
	//tmr2value=65534;
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

void ADC0_irqhandler (void) __interrupt 13
{
	__asm
		clr		_AD0INT
		cpl		_EvenOddSample
		mov 	_SFRPAGE,#SPI0_PAGE
		clr 	_P1_4
		clr 	_SPIF
		mov 	_SPI0DAT,#0x2A
		mov 	a,_ADC0ConfigOdd
		jb		_EvenOddSample,L1
		mov 	a,_ADC0ConfigEven
L1:		jnb 	_SPIF,L1
		clr 	_SPIF
		mov 	_SPI0DAT,a
L2:		jnb 	_SPIF,L2
		clr 	_SPIF
		setb 	_P1_4
		clr 	_P1_5
		clr 	_SPIF
		mov 	_SPI0DAT,#0x2A
		mov 	a,_ADC1ConfigOdd
		jb		_EvenOddSample,L3
		mov 	a,_ADC1ConfigEven
L3:		jnb 	_SPIF,L3
		clr 	_SPIF
		mov 	_SPI0DAT,a
L4:		jnb 	_SPIF,L4
		setb 	_P1_5
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
	ADC_Init(1);
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
	SetPGA0(ADC0ConfigEven);
	SetPGA1(ADC1ConfigEven);

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
	ADC_Init(1);
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
    ADC0CF    = 0x00;
	ADC0CN = 0x0C;	// timer2
	AD0INT=0;
    SFRPAGE   = ADC1_PAGE;
    ADC1CF    = 0x00;
	ADC1CN = 0x0C;	// timer2
	//ADC1CN = 0;
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

void TriggeredSpeedSampling(unsigned int samples) 	// uses DMA
{
	unsigned char rec_chr;
	unsigned int i;

	LED=0;

	rec_chr=0;
	SFRPAGE   = TMR2_PAGE;
	TMR2CN    = 0x00;

    SFRPAGE   = ADC0_PAGE;
    ADC0CF    = 0x00;
	ADC0CN = 0x0C;	// timer2
	AD0INT=0;
    SFRPAGE   = ADC1_PAGE;
    ADC1CF    = 0x00;
	ADC1CN = 0x0C;	// timer2
	//ADC1CN = 0;
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
	//DMA0IDT = DMA0_GET_ADC0;
	DMA0IDT = DMA0_END_OF_OP;

	DMA0BND = 0x00;             // Begin instruction executions at address 0
	
	// Wait for trigger

		SFRPAGE   = UART0_PAGE; // using UART
		while (TRIGGER)		// wait for signal going low
		{
			if (RI0)
			{
				if (SBUF0==27 || SBUF0=='t') break; // waiting interrupted
			}
		}
		while (!TRIGGER) // wait for rising edge
		{
			if (RI0)
			{
				if (SBUF0==27 || SBUF0=='t') break; // waiting interrupted
			}
		}
		// not clearing the buffer, can be use as signal later
	
	
	
	SFRPAGE = DMA0_PAGE;        // Switch to DMA0 Page
	DMA0CN = 0xA0;              // Mode 1 Operations, Begin Executing DMA Ops
                                // (which will start ADC0)
	//SFRPAGE = DMA0_PAGE;      	// Switch to DMA0 Page
	//while ((!(DMA0CN & 0x40)) && (SIn0()!=27));  // Wait for DMA to obtain and move ADC samples
	while (!(DMA0CN & 0x40));  // Wait for DMA to obtain and move ADC samples
	
	
	
	
	LED=1;
	i=0;
	// note: will send a data even if ESC arriverd
	SIn0(); // just clear the buffer in any case
	do
	{
		//SFRPAGE = UART0_PAGE; // using UART
		//if (SBUF0==27)
		//	break; // sometime an esc arriverd
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
		SetPGA0(0x00);
		Delay_ms(10);
		Convert(1); // get channel and convert
		adc1data-=32768;
		printf("%8d",adc1data);
		SetPGA0(0x01);
		Delay_ms(10);
		Convert(1); // get channel and convert
		adc1data-=32768;
		printf("%8d",adc1data);
		SetPGA1(0x00);
		Delay_ms(10);
		Convert(1); // get channel and convert
		adc0data-=32768;
		printf("%8d",adc0data);
		SetPGA1(0x01);
		Delay_ms(10);
		Convert(1); // get channel and convert
		adc0data-=32768;
		printf("%8d\n\r",adc0data);
	}
}

void main()
{
	unsigned char c;

	Init_Device();

	CheckSRAMs();

	LED=0;
	adc_select=3;
	ADC0ConfigEven=ADC0ConfigOdd=0;		// adc0 gain and channel selection for every even sample and every odd sample
	ADC1ConfigEven=ADC1ConfigOdd=0;
	DAC0_mode=0;
	handshake=1;
	dac_increment=1;
	dac_amplitude=255;
	dac_offset=0;
	fifo_size=128;	// default number of samples in a block

	RTS=0;

	while (1)
	{
		while (SInOut()!='@');
		c=SInOut();
		if (c=='I')
		{
			SendID();
		}
		else if (c=='x')	// switch reference voltage and resistors
		{
			c=SInOut();
			SW0 = !(c&1);	// 1: 10k resistor connected to input, 0: input floating
			SW1 = !(c&2);
			SW2 = !(c&4);
			SW3 = !(c&8);
			PULL = !(c&16);	// 1: pull up to Vref, 0: pull down to GND
		}
		else if (c=='t')	// set trigger polarity
		{
			c=SInOut();
			TRIGINV = c&1;
		}
		else if (c=='b')	// set fifo block size (number of samples in a block
		{
			fifo_size=SInOut();
		}
		else if (c=='c')	// configure continuous sampling mode
		{
			ADC0ConfigEven=SInOut();
			ADC1ConfigEven=SInOut();
			ADC0ConfigOdd=SInOut();
			ADC1ConfigOdd=SInOut();
		}
		else if (c=='S') // start sampling, ESC exits
		{
			ContSampling();
		}
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
//			SamplingToSRAM(SInOut());
		}
		else if (c=='T') // start triggered sampling, ESC exits, t: force trigger
		{
			unsigned long n;

			n = SInOut();
			n = (n << 8)+SInOut();
			n = (n << 8)+SInOut();
			SetSamplingFreq(n);
			n = SInOut();
			n = (n << 8)+SInOut();
			//HiSpeedSampling(n);
			TriggeredSpeedSampling(n);
		}
		else if (c=='A') // select ADCs
		{
			adc_select = SInOut() & 3;
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
		else if (c=='f') // set freq
		{
			samplingfreq = SInOut();
			samplingfreq = (samplingfreq << 8)+SInOut();
			SetSamplingFreq(samplingfreq);
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
			DAC0L=a;
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
		else if (c=='W') // DAC0 wavegenerator off
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
