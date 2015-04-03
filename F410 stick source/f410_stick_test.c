#include "common/C8051F410.h"
#include "common/typedef.h"
#include "common/uart.c"
#include "f410_stick_cfg.c"

#define DLY_CYCLES 225

#define L1 P2_0
#define L2 P2_1
#define L3 P0_6
#define L4 P0_7


INT8U i, c = 0;
INT8U light[] = {0x08, 0x04, 0x02, 0x01, 0x02, 0x04};

void Delay_ms(short ms) {
	short i;
	for(i=0; i<24*ms; i++)
	{
		{ /* about 1ms, 11059200/12 Hz */
			__asm
				push b
				mov b, DLY_CYCLES
			00001$:
				djnz b,00001$
				mov b, DLY_CYCLES
			00002$:
				djnz b,00002$
				pop b
			__endasm;
		}
	}
}

void SendID() {
	unsigned char *s;

	s="victory";
	do
	{
		SOut(*s);
		if (*s) s++;
	} while (*s);
}


void main(void){
	unsigned char c;

	Init_Device();
	
	// init
	for (i=0; i<6; i++) {
		c = light[i];
		L1 = c & 0x01;
		L2 = c & 0x02;
		L3 = c & 0x04;
		L4 = c & 0x08;			
		Delay_ms(50);
	}
	
	// UART init
	TI = 1;
	RI = 0;
	
	// config + enable digital input
	P2MDOUT = 0xFF; // P2_0 - P2_7 as open drain
	P1MDOUT = 0xF8; // P1_3 - P1_7 as open drain
	P2 = 0;
	P1 &= 0x07;
	
	while(1) {
		while (SInOut()!='@');
		c=SInOut();
		if (c=='I')
		{
			SendID();
		}
/* ============[ HIL SIMULATION, HOUSE HEATING ] ========= */
		else if (c=='a') {
			SOut(P1);
			SOut(P2);
		}
/* =============================================================== */
	}

}