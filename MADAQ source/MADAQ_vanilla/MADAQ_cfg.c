/////////////////////////////////////
//  Generated Initialization File  //
/////////////////////////////////////

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
	TMOD      = 0x20;
	CKCON     = 0x10;
	TH1       = 0x98;
	SFRPAGE   = TMR2_PAGE;
	TMR2CN    = 0x04;
	TMR2CF    = 0x02;
	RCAP2L    = 0x9C;
	RCAP2H    = 0xFF;
	SFRPAGE   = TMR3_PAGE;
	TMR3CN    = 0x04;
	TMR3CF    = 0x08;
	RCAP3L    = 0xFF;
	RCAP3H    = 0xFF;
}

void UART_Init()
{
	SFRPAGE   = UART0_PAGE;
	SCON0     = 0x50;
	SSTA0     = 0x1A;
	TI0=1;
	RI0=0;
	SFRPAGE   = UART1_PAGE;
	SCON1     = 0x50;
	TI1=1;
	RI1=0;
}

void SMBus_Init()
{
	SFRPAGE   = SMB0_PAGE;
	SMB0CN    = 0x40;
	SMB0CR    = 0x91;
}

void ADC_Init(unsigned char convertmode)
{
	SFRPAGE   = ADC0_PAGE;
	ADC0CF    = 0x10;
	if (convertmode == 2) ADC0CN = 0x88;	// ext trig
	else if (convertmode == 1) ADC0CN = 0x8C;	// timer2
	else ADC0CN = 0x80;	// write to AD0BUSY
	AD0INT=0;
	SFRPAGE   = ADC1_PAGE;
	ADC1CF    = 0x10;
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
	EMI0TC    = 0x45;
}

void Voltage_Reference_Init()
{
	SFRPAGE   = ADC0_PAGE;
	REF0CN    = 0x02;
	SFRPAGE   = ADC1_PAGE;
	REF1CN    = 0x02;
	SFRPAGE   = ADC2_PAGE;
	REF2CN    = 0x02;
}

void Port_IO_Init()
{
    // P0.0  -  TX0 (UART0), Push-Pull,  Digital
    // P0.1  -  RX0 (UART0), Open-Drain, Digital
    // P0.2  -  Unassigned,  Open-Drain, Digital
    // P0.3  -  Unassigned,  Open-Drain, Digital
    // P0.4  -  Unassigned,  Open-Drain, Digital
    // P0.5  -  Unassigned,  Open-Drain, Digital
    // P0.6  -  Unassigned,  Open-Drain, Digital
    // P0.7  -  Unassigned,  Open-Drain, Digital

    // P1.0  -  Unassigned,  Open-Drain, Digital
    // P1.1  -  Unassigned,  Open-Drain, Digital
    // P1.2  -  Unassigned,  Open-Drain, Digital
    // P1.3  -  Unassigned,  Open-Drain, Digital
    // P1.4  -  Unassigned,  Push-Pull,  Digital
    // P1.5  -  Unassigned,  Push-Pull,  Digital
    // P1.6  -  Unassigned,  Open-Drain, Digital
    // P1.7  -  Unassigned,  Open-Drain, Digital

    // P2.0  -  Unassigned,  Open-Drain, Digital
    // P2.1  -  Unassigned,  Push-Pull,  Digital
    // P2.2  -  Unassigned,  Open-Drain, Digital
    // P2.3  -  Unassigned,  Push-Pull,  Digital
    // P2.4  -  Unassigned,  Push-Pull,  Digital
    // P2.5  -  Unassigned,  Push-Pull,  Digital
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
    P0MDOUT   = 0x01;
    P1MDOUT   = 0x30;
    P2MDOUT   = 0x7A;
    P3MDOUT   = 0x07;
    P4MDOUT   = 0xE0;
    P5MDOUT   = 0xFF;
    P6MDOUT   = 0xFF;
    P7MDOUT   = 0xFF;
    XBR0      = 0x04;
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
	SMBus_Init();
	ADC_Init(0);
	DAC_Init();
	EMI_Init();
	Voltage_Reference_Init();
	Port_IO_Init();
	Oscillator_Init();
	Interrupts_Init();
}