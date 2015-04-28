/////////////////////////////////////
//  Generated Initialization File  //
/////////////////////////////////////

#include "compiler_defs.h"
#include "C8051F410_defs.h"

// Peripheral specific initialization functions,
// Called from the Init_Device() function
void PCA_Init()
{
    PCA0MD    &= ~0x40;
    PCA0MD    = 0x00;
}

void Timer_Init()
{
    TMR2CN    = 0x04;
    TMR2RLH   = 0x80;
    TMR2H     = 0x80;
}

void ADC_Init()
{
    ADC0MX    = 0x14;
    ADC0CN    = 0x83;
}

void Voltage_Reference_Init()
{
    REF0CN    = 0x18;
}

void Port_IO_Init()
{
    // P0.0  -  Unassigned,  Push-Pull,  Digital
    // P0.1  -  Unassigned,  Push-Pull,  Digital
    // P0.2  -  Unassigned,  Push-Pull,  Digital
    // P0.3  -  Unassigned,  Push-Pull,  Digital
    // P0.4  -  Unassigned,  Push-Pull,  Digital
    // P0.5  -  Unassigned,  Push-Pull,  Digital
    // P0.6  -  Unassigned,  Push-Pull,  Digital
    // P0.7  -  Unassigned,  Push-Pull,  Digital

    // P1.0  -  Unassigned,  Open-Drain, Digital
    // P1.1  -  Unassigned,  Open-Drain, Digital
    // P1.2  -  Unassigned,  Open-Drain, Digital
    // P1.3  -  Unassigned,  Open-Drain, Digital
    // P1.4  -  Unassigned,  Open-Drain, Digital
    // P1.5  -  Unassigned,  Open-Drain, Digital
    // P1.6  -  Unassigned,  Open-Drain, Digital
    // P1.7  -  Unassigned,  Open-Drain, Digital

    // P2.0  -  Unassigned,  Push-Pull,  Digital
    // P2.1  -  Unassigned,  Push-Pull,  Digital
    // P2.2  -  Unassigned,  Open-Drain, Digital
    // P2.3  -  Unassigned,  Push-Pull,  Digital
    // P2.4  -  Skipped,     Open-Drain, Analog
    // P2.5  -  Unassigned,  Open-Drain, Digital
    // P2.6  -  Unassigned,  Open-Drain, Digital
    // P2.7  -  Unassigned,  Open-Drain, Digital

    P2MDIN    = 0xEF;
    P0MDOUT   = 0xFF;
    P2MDOUT   = 0x0B;
    P2SKIP    = 0x10;
    XBR1      = 0x40;
}

void Oscillator_Init()
{
    OSCICN    = 0x84;
}

void Interrupts_Init()
{
    EIE1      = 0x08;
    IE        = 0x80;
}

// Initialization function for device,
// Call Init_Device() from your main program
void Init_Device(void)
{
    PCA_Init();
    Timer_Init();
    ADC_Init();
    Voltage_Reference_Init();
    Port_IO_Init();
    Oscillator_Init();
    Interrupts_Init();
}









#define HEATER_ON_OFF 	P2_0
#define TEMP 			P2_4
#define DATA_PORT		P0
#define GOMB1			P1_4
#define GOMB2			P1_5


volatile float temp = 0;
volatile float voltage = 0.0;
volatile __bit seged = 0;


void ACDInterruptHandler(void) __interrupt INT_ADC0_EOC {

	P2_1 = !P2_1;

	AD0INT = 0;

// /*
	// DEBUG
	DATA_PORT++;	
	HEATER_ON_OFF = !HEATER_ON_OFF;
// */

	
/*
	// 1. feladat

	voltage = (float)((ADC0 / 4095.0) * 2.25);
	temp = 25.0 * voltage - 10.0;

	if( temp < 20.0 ){
		HEATER_ON_OFF = 1;
	}
	else{
		HEATER_ON_OFF = 0;
	}
*/


/*
	// 2. feladat
	voltage = (float)((ADC0 / 4095.0) * 2.25);
	temp = 25.0 * voltage - 10.0;

	if( temp < 18.0 ){
		HEATER_ON_OFF = 0;
	}

	if( temp > 22.0 ){
		HEATER_ON_OFF = 1;
	}
*/

	
/*
	// 3. feladat, potenciometer
	if(seged == 1) {
		voltage = (float)((ADC0 / 4095.0) * 2.25);
		temp = 25.0 * voltage - 10.0;
	
		if( temp < (float)(DATA_PORT-1) ){
			HEATER_ON_OFF = 1;
		}

		if( temp > (float)(DATA_PORT+1) ){
			HEATER_ON_OFF = 0;
		}
	}
	else {
	//	DATA_PORT = (unsigned char)(ADC0 / 100);	// 3. feladat, potenciometer
	}
	
	seged = !seged;
	
	// kovetkezo meres beallitasa
	if (seged) ADC0MX = 0x14; // external input at P2_4
	else ADC0MX = 0x0E; // potenciometer
*/

}



void main(void){

	Init_Device();

	P2_1 = 0;
	P2_3 = 0;
	
	// 3. feladat, gombnyomas
	DATA_PORT = 0;

	while(1){
		if(GOMB1 == 0){
			while(GOMB1 == 0);	
			if(DATA_PORT < 40) { DATA_PORT++; }			
		}

		if(GOMB2 == 0){
			while(GOMB2 == 0);
			if(DATA_PORT > 0) { DATA_PORT--; }				
		}
	}

}