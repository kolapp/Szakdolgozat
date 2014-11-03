;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.3.0 #8604 (May 11 2013) (MINGW32)
; This file was generated Sun Nov 02 15:32:23 2014
;--------------------------------------------------------
	.module MADAQ
	.optsdcc -mmcs51 --model-small
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _CheckSRAMs
	.globl _ADC0_irqhandler
	.globl _SendID
	.globl _SInOut
	.globl _SOut
	.globl _SIn0
	.globl _SIn
	.globl _Delay_ms
	.globl _Init_Device
	.globl _Interrupts_Init
	.globl _Oscillator_Init
	.globl _Port_IO_Init
	.globl _Voltage_Reference_Init
	.globl _EMI_Init
	.globl _DAC_Init
	.globl _ADC_Init
	.globl _SMBus_Init
	.globl _UART_Init
	.globl _Timer_Init
	.globl _Reset_Sources_Init
	.globl _P7_7
	.globl _P7_6
	.globl _P7_5
	.globl _P7_4
	.globl _P7_3
	.globl _P7_2
	.globl _P7_1
	.globl _P7_0
	.globl _DMA0HLT
	.globl _DMA0XBY
	.globl _DMA0CIE
	.globl _DMA0CI
	.globl _DMA0EOE
	.globl _DMA0EO
	.globl _CANTEST
	.globl _CANCCE
	.globl _CANDAR
	.globl _CANIF
	.globl _CANEIE
	.globl _CANSIE
	.globl _CANIE
	.globl _CANINIT
	.globl _SPIF
	.globl _WCOL
	.globl _MODF
	.globl _RXOVRN
	.globl _NSSMD1
	.globl _NSSMD0
	.globl _TXBMT
	.globl _SPIEN
	.globl _P6_7
	.globl _P6_6
	.globl _P6_5
	.globl _P6_4
	.globl _P6_3
	.globl _P6_2
	.globl _P6_1
	.globl _P6_0
	.globl _AD2EN
	.globl _AD2TM
	.globl _AD2INT
	.globl _AD2BUSY
	.globl _AD2CM1
	.globl _AD2CM0
	.globl _AD2WINT
	.globl _AD2LJST
	.globl _AD1EN
	.globl _AD1TM
	.globl _AD1INT
	.globl _AD1BUSY
	.globl _AD1CM2
	.globl _AD1CM1
	.globl _AD1CM0
	.globl _AD0EN
	.globl _AD0TM
	.globl _AD0INT
	.globl _AD0BUSY
	.globl _AD0CM1
	.globl _AD0CM0
	.globl _AD0WINT
	.globl _P5_7
	.globl _P5_6
	.globl _P5_5
	.globl _P5_4
	.globl _P5_3
	.globl _P5_2
	.globl _P5_1
	.globl _P5_0
	.globl _DMA0EN
	.globl _DMA0INT
	.globl _DMA0MD
	.globl _DMA0DE1
	.globl _DMA0DE0
	.globl _DMA0DOE
	.globl _DMA0DO1
	.globl _DMA0DO0
	.globl _CF
	.globl _CR
	.globl _CCF5
	.globl _CCF4
	.globl _CCF3
	.globl _CCF2
	.globl _CCF1
	.globl _CCF0
	.globl _CY
	.globl _AC
	.globl _F0
	.globl _RS1
	.globl _RS0
	.globl _OV
	.globl _F1
	.globl _P
	.globl _P4_7
	.globl _P4_6
	.globl _P4_5
	.globl _P4_4
	.globl _P4_3
	.globl _P4_2
	.globl _P4_1
	.globl _P4_0
	.globl _TF4
	.globl _EXF4
	.globl _EXEN4
	.globl _TR4
	.globl _CT4
	.globl _CPRL4
	.globl _TF3
	.globl _EXF3
	.globl _EXEN3
	.globl _TR3
	.globl _CT3
	.globl _CPRL3
	.globl _TF2
	.globl _EXF2
	.globl _EXEN2
	.globl _TR2
	.globl _CT2
	.globl _CPRL2
	.globl _CANBOFF
	.globl _CANEWARN
	.globl _CANEPASS
	.globl _CANRXOK
	.globl _CANTXOK
	.globl _BUSY
	.globl _ENSMB
	.globl _STA
	.globl _STO
	.globl _SI
	.globl _AA
	.globl _SMBFTE
	.globl _SMBTOE
	.globl _PT2
	.globl _PS
	.globl _PS0
	.globl _PT1
	.globl _PX1
	.globl _PT0
	.globl _PX0
	.globl _P3_7
	.globl _P3_6
	.globl _P3_5
	.globl _P3_4
	.globl _P3_3
	.globl _P3_2
	.globl _P3_1
	.globl _P3_0
	.globl _EA
	.globl _ET2
	.globl _ES
	.globl _ES0
	.globl _ET1
	.globl _EX1
	.globl _ET0
	.globl _EX0
	.globl _P2_7
	.globl _P2_6
	.globl _P2_5
	.globl _P2_4
	.globl _P2_3
	.globl _P2_2
	.globl _P2_1
	.globl _P2_0
	.globl _S1MODE
	.globl _MCE1
	.globl _REN1
	.globl _TB81
	.globl _RB81
	.globl _TI1
	.globl _RI1
	.globl _SM00
	.globl _SM10
	.globl _SM20
	.globl _REN
	.globl _REN0
	.globl _TB80
	.globl _RB80
	.globl _TI
	.globl _TI0
	.globl _RI
	.globl _RI0
	.globl _P1_7
	.globl _P1_6
	.globl _P1_5
	.globl _P1_4
	.globl _P1_3
	.globl _P1_2
	.globl _P1_1
	.globl _P1_0
	.globl _CP2EN
	.globl _CP2OUT
	.globl _CP2RIF
	.globl _CP2FIF
	.globl _CP2HYP1
	.globl _CP2HYP0
	.globl _CP2HYN1
	.globl _CP2HYN0
	.globl _CP1EN
	.globl _CP1OUT
	.globl _CP1RIF
	.globl _CP1FIF
	.globl _CP1HYP1
	.globl _CP1HYP0
	.globl _CP1HYN1
	.globl _CP1HYN0
	.globl _CP0EN
	.globl _CP0OUT
	.globl _CP0RIF
	.globl _CP0FIF
	.globl _CP0HYP1
	.globl _CP0HYP0
	.globl _CP0HYN1
	.globl _CP0HYN0
	.globl _TF1
	.globl _TR1
	.globl _TF0
	.globl _TR0
	.globl _IE1
	.globl _IT1
	.globl _IE0
	.globl _IT0
	.globl _P0_7
	.globl _P0_6
	.globl _P0_5
	.globl _P0_4
	.globl _P0_3
	.globl _P0_2
	.globl _P0_1
	.globl _P0_0
	.globl _P7
	.globl _P6
	.globl _XBR3
	.globl _XBR2
	.globl _XBR1
	.globl _XBR0
	.globl _P5
	.globl _P4
	.globl _ADC0CCF
	.globl _ADC0CPT
	.globl _FLACL
	.globl _P2MDIN
	.globl _P1MDIN
	.globl _P3MDOUT
	.globl _P2MDOUT
	.globl _P1MDOUT
	.globl _P0MDOUT
	.globl _P7MDOUT
	.globl _P6MDOUT
	.globl _P5MDOUT
	.globl _P4MDOUT
	.globl _CLKSEL
	.globl _SFRPGCN
	.globl _OSCXCN
	.globl _OSCICL
	.globl _OSCICN
	.globl _DMA0ISW
	.globl _DMA0BND
	.globl _DMA0CSH
	.globl _DMA0CSL
	.globl _DMA0CTH
	.globl _DMA0CTL
	.globl _DMA0CF
	.globl _DMA0IDT
	.globl _DMA0IPT
	.globl _DMA0DSH
	.globl _DMA0DSL
	.globl _DMA0DAH
	.globl _DMA0DAL
	.globl _DMA0CN
	.globl _CPT2MD
	.globl _CPT2CN
	.globl _ADC2CN
	.globl _REF2CN
	.globl _TMR4H
	.globl _TMR4L
	.globl _RCAP4H
	.globl _RCAP4L
	.globl _TMR4CF
	.globl _TMR4CN
	.globl _ADC2LTH
	.globl _ADC2LTL
	.globl _ADC2GTH
	.globl _ADC2GTL
	.globl _ADC2H
	.globl _ADC2L
	.globl _ADC2CF
	.globl _AMX2SL
	.globl _AMX2CF
	.globl _CPT1MD
	.globl _CPT1CN
	.globl _CAN0CN
	.globl _ADC1CN
	.globl _CAN0TST
	.globl _CAN0ADR
	.globl _CAN0DATH
	.globl _CAN0DATL
	.globl _DAC1CN
	.globl _DAC1H
	.globl _DAC1L
	.globl _REF1CN
	.globl _TMR3H
	.globl _TMR3L
	.globl _RCAP3H
	.globl _RCAP3L
	.globl _TMR3CF
	.globl _TMR3CN
	.globl _CAN0STA
	.globl _ADC1H
	.globl _ADC1L
	.globl _ADC1CF
	.globl _SBUF1
	.globl _SCON1
	.globl _CPT0MD
	.globl _CPT0CN
	.globl _PCA0CPH1
	.globl _PCA0CPL1
	.globl _PCA0CPH0
	.globl _PCA0CPL0
	.globl _PCA0H
	.globl _PCA0L
	.globl _SPI0CN
	.globl _RSTSRC
	.globl _PCA0CPH4
	.globl _PCA0CPL4
	.globl _PCA0CPH3
	.globl _PCA0CPL3
	.globl _PCA0CPH2
	.globl _PCA0CPL2
	.globl _ADC0CN
	.globl _PCA0CPH5
	.globl _PCA0CPL5
	.globl _PCA0CPM5
	.globl _PCA0CPM4
	.globl _PCA0CPM3
	.globl _PCA0CPM2
	.globl _PCA0CPM1
	.globl _PCA0CPM0
	.globl _PCA0MD
	.globl _PCA0CN
	.globl _DAC0CN
	.globl _DAC0H
	.globl _DAC0L
	.globl _REF0CN
	.globl _SMB0CR
	.globl _TH2
	.globl _TMR2H
	.globl _TL2
	.globl _TMR2L
	.globl _RCAP2H
	.globl _RCAP2L
	.globl _TMR2CF
	.globl _TMR2CN
	.globl _ADC0LTH
	.globl _ADC0LTL
	.globl _ADC0GTH
	.globl _ADC0GTL
	.globl _SMB0ADR
	.globl _SMB0DAT
	.globl _SMB0STA
	.globl _SMB0CN
	.globl _ADC0H
	.globl _ADC0L
	.globl _ADC0CF
	.globl _AMX0SL
	.globl _SADEN0
	.globl _FLSCL
	.globl _SADDR0
	.globl _EMI0CF
	.globl __XPAGE
	.globl _EMI0CN
	.globl _EMI0TC
	.globl _SPI0CKR
	.globl _SPI0DAT
	.globl _SPI0CFG
	.globl _SBUF
	.globl _SBUF0
	.globl _SCON
	.globl _SCON0
	.globl _SSTA0
	.globl _PSCTL
	.globl _CKCON
	.globl _TH1
	.globl _TH0
	.globl _TL1
	.globl _TL0
	.globl _TMOD
	.globl _TCON
	.globl _WDTCN
	.globl _EIP2
	.globl _EIP1
	.globl _B
	.globl _EIE2
	.globl _EIE1
	.globl _ACC
	.globl _PSW
	.globl _IP
	.globl _P3
	.globl _IE
	.globl _P2
	.globl _P1
	.globl _PCON
	.globl _SFRLAST
	.globl _SFRNEXT
	.globl _SFRPAGE
	.globl _DPH
	.globl _DPL
	.globl _SP
	.globl _P0
	.globl _samples
	.globl _handshake
	.globl _elemszam
	.globl _i
	.globl _samplingfreq
	.globl _sysclk
	.globl _dly_cycles
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
G$P0$0$0 == 0x0080
_P0	=	0x0080
G$SP$0$0 == 0x0081
_SP	=	0x0081
G$DPL$0$0 == 0x0082
_DPL	=	0x0082
G$DPH$0$0 == 0x0083
_DPH	=	0x0083
G$SFRPAGE$0$0 == 0x0084
_SFRPAGE	=	0x0084
G$SFRNEXT$0$0 == 0x0085
_SFRNEXT	=	0x0085
G$SFRLAST$0$0 == 0x0086
_SFRLAST	=	0x0086
G$PCON$0$0 == 0x0087
_PCON	=	0x0087
G$P1$0$0 == 0x0090
_P1	=	0x0090
G$P2$0$0 == 0x00a0
_P2	=	0x00a0
G$IE$0$0 == 0x00a8
_IE	=	0x00a8
G$P3$0$0 == 0x00b0
_P3	=	0x00b0
G$IP$0$0 == 0x00b8
_IP	=	0x00b8
G$PSW$0$0 == 0x00d0
_PSW	=	0x00d0
G$ACC$0$0 == 0x00e0
_ACC	=	0x00e0
G$EIE1$0$0 == 0x00e6
_EIE1	=	0x00e6
G$EIE2$0$0 == 0x00e7
_EIE2	=	0x00e7
G$B$0$0 == 0x00f0
_B	=	0x00f0
G$EIP1$0$0 == 0x00f6
_EIP1	=	0x00f6
G$EIP2$0$0 == 0x00f7
_EIP2	=	0x00f7
G$WDTCN$0$0 == 0x00ff
_WDTCN	=	0x00ff
G$TCON$0$0 == 0x0088
_TCON	=	0x0088
G$TMOD$0$0 == 0x0089
_TMOD	=	0x0089
G$TL0$0$0 == 0x008a
_TL0	=	0x008a
G$TL1$0$0 == 0x008b
_TL1	=	0x008b
G$TH0$0$0 == 0x008c
_TH0	=	0x008c
G$TH1$0$0 == 0x008d
_TH1	=	0x008d
G$CKCON$0$0 == 0x008e
_CKCON	=	0x008e
G$PSCTL$0$0 == 0x008f
_PSCTL	=	0x008f
G$SSTA0$0$0 == 0x0091
_SSTA0	=	0x0091
G$SCON0$0$0 == 0x0098
_SCON0	=	0x0098
G$SCON$0$0 == 0x0098
_SCON	=	0x0098
G$SBUF0$0$0 == 0x0099
_SBUF0	=	0x0099
G$SBUF$0$0 == 0x0099
_SBUF	=	0x0099
G$SPI0CFG$0$0 == 0x009a
_SPI0CFG	=	0x009a
G$SPI0DAT$0$0 == 0x009b
_SPI0DAT	=	0x009b
G$SPI0CKR$0$0 == 0x009d
_SPI0CKR	=	0x009d
G$EMI0TC$0$0 == 0x00a1
_EMI0TC	=	0x00a1
G$EMI0CN$0$0 == 0x00a2
_EMI0CN	=	0x00a2
G$_XPAGE$0$0 == 0x00a2
__XPAGE	=	0x00a2
G$EMI0CF$0$0 == 0x00a3
_EMI0CF	=	0x00a3
G$SADDR0$0$0 == 0x00a9
_SADDR0	=	0x00a9
G$FLSCL$0$0 == 0x00b7
_FLSCL	=	0x00b7
G$SADEN0$0$0 == 0x00b9
_SADEN0	=	0x00b9
G$AMX0SL$0$0 == 0x00bb
_AMX0SL	=	0x00bb
G$ADC0CF$0$0 == 0x00bc
_ADC0CF	=	0x00bc
G$ADC0L$0$0 == 0x00be
_ADC0L	=	0x00be
G$ADC0H$0$0 == 0x00bf
_ADC0H	=	0x00bf
G$SMB0CN$0$0 == 0x00c0
_SMB0CN	=	0x00c0
G$SMB0STA$0$0 == 0x00c1
_SMB0STA	=	0x00c1
G$SMB0DAT$0$0 == 0x00c2
_SMB0DAT	=	0x00c2
G$SMB0ADR$0$0 == 0x00c3
_SMB0ADR	=	0x00c3
G$ADC0GTL$0$0 == 0x00c4
_ADC0GTL	=	0x00c4
G$ADC0GTH$0$0 == 0x00c5
_ADC0GTH	=	0x00c5
G$ADC0LTL$0$0 == 0x00c6
_ADC0LTL	=	0x00c6
G$ADC0LTH$0$0 == 0x00c7
_ADC0LTH	=	0x00c7
G$TMR2CN$0$0 == 0x00c8
_TMR2CN	=	0x00c8
G$TMR2CF$0$0 == 0x00c9
_TMR2CF	=	0x00c9
G$RCAP2L$0$0 == 0x00ca
_RCAP2L	=	0x00ca
G$RCAP2H$0$0 == 0x00cb
_RCAP2H	=	0x00cb
G$TMR2L$0$0 == 0x00cc
_TMR2L	=	0x00cc
G$TL2$0$0 == 0x00cc
_TL2	=	0x00cc
G$TMR2H$0$0 == 0x00cd
_TMR2H	=	0x00cd
G$TH2$0$0 == 0x00cd
_TH2	=	0x00cd
G$SMB0CR$0$0 == 0x00cf
_SMB0CR	=	0x00cf
G$REF0CN$0$0 == 0x00d1
_REF0CN	=	0x00d1
G$DAC0L$0$0 == 0x00d2
_DAC0L	=	0x00d2
G$DAC0H$0$0 == 0x00d3
_DAC0H	=	0x00d3
G$DAC0CN$0$0 == 0x00d4
_DAC0CN	=	0x00d4
G$PCA0CN$0$0 == 0x00d8
_PCA0CN	=	0x00d8
G$PCA0MD$0$0 == 0x00d9
_PCA0MD	=	0x00d9
G$PCA0CPM0$0$0 == 0x00da
_PCA0CPM0	=	0x00da
G$PCA0CPM1$0$0 == 0x00db
_PCA0CPM1	=	0x00db
G$PCA0CPM2$0$0 == 0x00dc
_PCA0CPM2	=	0x00dc
G$PCA0CPM3$0$0 == 0x00dd
_PCA0CPM3	=	0x00dd
G$PCA0CPM4$0$0 == 0x00de
_PCA0CPM4	=	0x00de
G$PCA0CPM5$0$0 == 0x00df
_PCA0CPM5	=	0x00df
G$PCA0CPL5$0$0 == 0x00e1
_PCA0CPL5	=	0x00e1
G$PCA0CPH5$0$0 == 0x00e2
_PCA0CPH5	=	0x00e2
G$ADC0CN$0$0 == 0x00e8
_ADC0CN	=	0x00e8
G$PCA0CPL2$0$0 == 0x00e9
_PCA0CPL2	=	0x00e9
G$PCA0CPH2$0$0 == 0x00ea
_PCA0CPH2	=	0x00ea
G$PCA0CPL3$0$0 == 0x00eb
_PCA0CPL3	=	0x00eb
G$PCA0CPH3$0$0 == 0x00ec
_PCA0CPH3	=	0x00ec
G$PCA0CPL4$0$0 == 0x00ed
_PCA0CPL4	=	0x00ed
G$PCA0CPH4$0$0 == 0x00ee
_PCA0CPH4	=	0x00ee
G$RSTSRC$0$0 == 0x00ef
_RSTSRC	=	0x00ef
G$SPI0CN$0$0 == 0x00f8
_SPI0CN	=	0x00f8
G$PCA0L$0$0 == 0x00f9
_PCA0L	=	0x00f9
G$PCA0H$0$0 == 0x00fa
_PCA0H	=	0x00fa
G$PCA0CPL0$0$0 == 0x00fb
_PCA0CPL0	=	0x00fb
G$PCA0CPH0$0$0 == 0x00fc
_PCA0CPH0	=	0x00fc
G$PCA0CPL1$0$0 == 0x00fd
_PCA0CPL1	=	0x00fd
G$PCA0CPH1$0$0 == 0x00fe
_PCA0CPH1	=	0x00fe
G$CPT0CN$0$0 == 0x0088
_CPT0CN	=	0x0088
G$CPT0MD$0$0 == 0x0089
_CPT0MD	=	0x0089
G$SCON1$0$0 == 0x0098
_SCON1	=	0x0098
G$SBUF1$0$0 == 0x0099
_SBUF1	=	0x0099
G$ADC1CF$0$0 == 0x00bc
_ADC1CF	=	0x00bc
G$ADC1L$0$0 == 0x00be
_ADC1L	=	0x00be
G$ADC1H$0$0 == 0x00bf
_ADC1H	=	0x00bf
G$CAN0STA$0$0 == 0x00c0
_CAN0STA	=	0x00c0
G$TMR3CN$0$0 == 0x00c8
_TMR3CN	=	0x00c8
G$TMR3CF$0$0 == 0x00c9
_TMR3CF	=	0x00c9
G$RCAP3L$0$0 == 0x00ca
_RCAP3L	=	0x00ca
G$RCAP3H$0$0 == 0x00cb
_RCAP3H	=	0x00cb
G$TMR3L$0$0 == 0x00cc
_TMR3L	=	0x00cc
G$TMR3H$0$0 == 0x00cd
_TMR3H	=	0x00cd
G$REF1CN$0$0 == 0x00d1
_REF1CN	=	0x00d1
G$DAC1L$0$0 == 0x00d2
_DAC1L	=	0x00d2
G$DAC1H$0$0 == 0x00d3
_DAC1H	=	0x00d3
G$DAC1CN$0$0 == 0x00d4
_DAC1CN	=	0x00d4
G$CAN0DATL$0$0 == 0x00d8
_CAN0DATL	=	0x00d8
G$CAN0DATH$0$0 == 0x00d9
_CAN0DATH	=	0x00d9
G$CAN0ADR$0$0 == 0x00da
_CAN0ADR	=	0x00da
G$CAN0TST$0$0 == 0x00db
_CAN0TST	=	0x00db
G$ADC1CN$0$0 == 0x00e8
_ADC1CN	=	0x00e8
G$CAN0CN$0$0 == 0x00f8
_CAN0CN	=	0x00f8
G$CPT1CN$0$0 == 0x0088
_CPT1CN	=	0x0088
G$CPT1MD$0$0 == 0x0089
_CPT1MD	=	0x0089
G$AMX2CF$0$0 == 0x00ba
_AMX2CF	=	0x00ba
G$AMX2SL$0$0 == 0x00bb
_AMX2SL	=	0x00bb
G$ADC2CF$0$0 == 0x00bc
_ADC2CF	=	0x00bc
G$ADC2L$0$0 == 0x00be
_ADC2L	=	0x00be
G$ADC2H$0$0 == 0x00bf
_ADC2H	=	0x00bf
G$ADC2GTL$0$0 == 0x00c4
_ADC2GTL	=	0x00c4
G$ADC2GTH$0$0 == 0x00c5
_ADC2GTH	=	0x00c5
G$ADC2LTL$0$0 == 0x00c6
_ADC2LTL	=	0x00c6
G$ADC2LTH$0$0 == 0x00c7
_ADC2LTH	=	0x00c7
G$TMR4CN$0$0 == 0x00c8
_TMR4CN	=	0x00c8
G$TMR4CF$0$0 == 0x00c9
_TMR4CF	=	0x00c9
G$RCAP4L$0$0 == 0x00ca
_RCAP4L	=	0x00ca
G$RCAP4H$0$0 == 0x00cb
_RCAP4H	=	0x00cb
G$TMR4L$0$0 == 0x00cc
_TMR4L	=	0x00cc
G$TMR4H$0$0 == 0x00cd
_TMR4H	=	0x00cd
G$REF2CN$0$0 == 0x00d1
_REF2CN	=	0x00d1
G$ADC2CN$0$0 == 0x00e8
_ADC2CN	=	0x00e8
G$CPT2CN$0$0 == 0x0088
_CPT2CN	=	0x0088
G$CPT2MD$0$0 == 0x0089
_CPT2MD	=	0x0089
G$DMA0CN$0$0 == 0x00d8
_DMA0CN	=	0x00d8
G$DMA0DAL$0$0 == 0x00d9
_DMA0DAL	=	0x00d9
G$DMA0DAH$0$0 == 0x00da
_DMA0DAH	=	0x00da
G$DMA0DSL$0$0 == 0x00db
_DMA0DSL	=	0x00db
G$DMA0DSH$0$0 == 0x00dc
_DMA0DSH	=	0x00dc
G$DMA0IPT$0$0 == 0x00dd
_DMA0IPT	=	0x00dd
G$DMA0IDT$0$0 == 0x00de
_DMA0IDT	=	0x00de
G$DMA0CF$0$0 == 0x00f8
_DMA0CF	=	0x00f8
G$DMA0CTL$0$0 == 0x00f9
_DMA0CTL	=	0x00f9
G$DMA0CTH$0$0 == 0x00fa
_DMA0CTH	=	0x00fa
G$DMA0CSL$0$0 == 0x00fb
_DMA0CSL	=	0x00fb
G$DMA0CSH$0$0 == 0x00fc
_DMA0CSH	=	0x00fc
G$DMA0BND$0$0 == 0x00fd
_DMA0BND	=	0x00fd
G$DMA0ISW$0$0 == 0x00fe
_DMA0ISW	=	0x00fe
G$OSCICN$0$0 == 0x008a
_OSCICN	=	0x008a
G$OSCICL$0$0 == 0x008b
_OSCICL	=	0x008b
G$OSCXCN$0$0 == 0x008c
_OSCXCN	=	0x008c
G$SFRPGCN$0$0 == 0x0096
_SFRPGCN	=	0x0096
G$CLKSEL$0$0 == 0x0097
_CLKSEL	=	0x0097
G$P4MDOUT$0$0 == 0x009c
_P4MDOUT	=	0x009c
G$P5MDOUT$0$0 == 0x009d
_P5MDOUT	=	0x009d
G$P6MDOUT$0$0 == 0x009e
_P6MDOUT	=	0x009e
G$P7MDOUT$0$0 == 0x009f
_P7MDOUT	=	0x009f
G$P0MDOUT$0$0 == 0x00a4
_P0MDOUT	=	0x00a4
G$P1MDOUT$0$0 == 0x00a5
_P1MDOUT	=	0x00a5
G$P2MDOUT$0$0 == 0x00a6
_P2MDOUT	=	0x00a6
G$P3MDOUT$0$0 == 0x00a7
_P3MDOUT	=	0x00a7
G$P1MDIN$0$0 == 0x00ad
_P1MDIN	=	0x00ad
G$P2MDIN$0$0 == 0x00ae
_P2MDIN	=	0x00ae
G$FLACL$0$0 == 0x00b7
_FLACL	=	0x00b7
G$ADC0CPT$0$0 == 0x00ba
_ADC0CPT	=	0x00ba
G$ADC0CCF$0$0 == 0x00bb
_ADC0CCF	=	0x00bb
G$P4$0$0 == 0x00c8
_P4	=	0x00c8
G$P5$0$0 == 0x00d8
_P5	=	0x00d8
G$XBR0$0$0 == 0x00e1
_XBR0	=	0x00e1
G$XBR1$0$0 == 0x00e2
_XBR1	=	0x00e2
G$XBR2$0$0 == 0x00e3
_XBR2	=	0x00e3
G$XBR3$0$0 == 0x00e4
_XBR3	=	0x00e4
G$P6$0$0 == 0x00e8
_P6	=	0x00e8
G$P7$0$0 == 0x00f8
_P7	=	0x00f8
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
G$P0_0$0$0 == 0x0080
_P0_0	=	0x0080
G$P0_1$0$0 == 0x0081
_P0_1	=	0x0081
G$P0_2$0$0 == 0x0082
_P0_2	=	0x0082
G$P0_3$0$0 == 0x0083
_P0_3	=	0x0083
G$P0_4$0$0 == 0x0084
_P0_4	=	0x0084
G$P0_5$0$0 == 0x0085
_P0_5	=	0x0085
G$P0_6$0$0 == 0x0086
_P0_6	=	0x0086
G$P0_7$0$0 == 0x0087
_P0_7	=	0x0087
G$IT0$0$0 == 0x0088
_IT0	=	0x0088
G$IE0$0$0 == 0x0089
_IE0	=	0x0089
G$IT1$0$0 == 0x008a
_IT1	=	0x008a
G$IE1$0$0 == 0x008b
_IE1	=	0x008b
G$TR0$0$0 == 0x008c
_TR0	=	0x008c
G$TF0$0$0 == 0x008d
_TF0	=	0x008d
G$TR1$0$0 == 0x008e
_TR1	=	0x008e
G$TF1$0$0 == 0x008f
_TF1	=	0x008f
G$CP0HYN0$0$0 == 0x0088
_CP0HYN0	=	0x0088
G$CP0HYN1$0$0 == 0x0089
_CP0HYN1	=	0x0089
G$CP0HYP0$0$0 == 0x008a
_CP0HYP0	=	0x008a
G$CP0HYP1$0$0 == 0x008b
_CP0HYP1	=	0x008b
G$CP0FIF$0$0 == 0x008c
_CP0FIF	=	0x008c
G$CP0RIF$0$0 == 0x008d
_CP0RIF	=	0x008d
G$CP0OUT$0$0 == 0x008e
_CP0OUT	=	0x008e
G$CP0EN$0$0 == 0x008f
_CP0EN	=	0x008f
G$CP1HYN0$0$0 == 0x0088
_CP1HYN0	=	0x0088
G$CP1HYN1$0$0 == 0x0089
_CP1HYN1	=	0x0089
G$CP1HYP0$0$0 == 0x008a
_CP1HYP0	=	0x008a
G$CP1HYP1$0$0 == 0x008b
_CP1HYP1	=	0x008b
G$CP1FIF$0$0 == 0x008c
_CP1FIF	=	0x008c
G$CP1RIF$0$0 == 0x008d
_CP1RIF	=	0x008d
G$CP1OUT$0$0 == 0x008e
_CP1OUT	=	0x008e
G$CP1EN$0$0 == 0x008f
_CP1EN	=	0x008f
G$CP2HYN0$0$0 == 0x0088
_CP2HYN0	=	0x0088
G$CP2HYN1$0$0 == 0x0089
_CP2HYN1	=	0x0089
G$CP2HYP0$0$0 == 0x008a
_CP2HYP0	=	0x008a
G$CP2HYP1$0$0 == 0x008b
_CP2HYP1	=	0x008b
G$CP2FIF$0$0 == 0x008c
_CP2FIF	=	0x008c
G$CP2RIF$0$0 == 0x008d
_CP2RIF	=	0x008d
G$CP2OUT$0$0 == 0x008e
_CP2OUT	=	0x008e
G$CP2EN$0$0 == 0x008f
_CP2EN	=	0x008f
G$P1_0$0$0 == 0x0090
_P1_0	=	0x0090
G$P1_1$0$0 == 0x0091
_P1_1	=	0x0091
G$P1_2$0$0 == 0x0092
_P1_2	=	0x0092
G$P1_3$0$0 == 0x0093
_P1_3	=	0x0093
G$P1_4$0$0 == 0x0094
_P1_4	=	0x0094
G$P1_5$0$0 == 0x0095
_P1_5	=	0x0095
G$P1_6$0$0 == 0x0096
_P1_6	=	0x0096
G$P1_7$0$0 == 0x0097
_P1_7	=	0x0097
G$RI0$0$0 == 0x0098
_RI0	=	0x0098
G$RI$0$0 == 0x0098
_RI	=	0x0098
G$TI0$0$0 == 0x0099
_TI0	=	0x0099
G$TI$0$0 == 0x0099
_TI	=	0x0099
G$RB80$0$0 == 0x009a
_RB80	=	0x009a
G$TB80$0$0 == 0x009b
_TB80	=	0x009b
G$REN0$0$0 == 0x009c
_REN0	=	0x009c
G$REN$0$0 == 0x009c
_REN	=	0x009c
G$SM20$0$0 == 0x009d
_SM20	=	0x009d
G$SM10$0$0 == 0x009e
_SM10	=	0x009e
G$SM00$0$0 == 0x009f
_SM00	=	0x009f
G$RI1$0$0 == 0x0098
_RI1	=	0x0098
G$TI1$0$0 == 0x0099
_TI1	=	0x0099
G$RB81$0$0 == 0x009a
_RB81	=	0x009a
G$TB81$0$0 == 0x009b
_TB81	=	0x009b
G$REN1$0$0 == 0x009c
_REN1	=	0x009c
G$MCE1$0$0 == 0x009d
_MCE1	=	0x009d
G$S1MODE$0$0 == 0x009f
_S1MODE	=	0x009f
G$P2_0$0$0 == 0x00a0
_P2_0	=	0x00a0
G$P2_1$0$0 == 0x00a1
_P2_1	=	0x00a1
G$P2_2$0$0 == 0x00a2
_P2_2	=	0x00a2
G$P2_3$0$0 == 0x00a3
_P2_3	=	0x00a3
G$P2_4$0$0 == 0x00a4
_P2_4	=	0x00a4
G$P2_5$0$0 == 0x00a5
_P2_5	=	0x00a5
G$P2_6$0$0 == 0x00a6
_P2_6	=	0x00a6
G$P2_7$0$0 == 0x00a7
_P2_7	=	0x00a7
G$EX0$0$0 == 0x00a8
_EX0	=	0x00a8
G$ET0$0$0 == 0x00a9
_ET0	=	0x00a9
G$EX1$0$0 == 0x00aa
_EX1	=	0x00aa
G$ET1$0$0 == 0x00ab
_ET1	=	0x00ab
G$ES0$0$0 == 0x00ac
_ES0	=	0x00ac
G$ES$0$0 == 0x00ac
_ES	=	0x00ac
G$ET2$0$0 == 0x00ad
_ET2	=	0x00ad
G$EA$0$0 == 0x00af
_EA	=	0x00af
G$P3_0$0$0 == 0x00b0
_P3_0	=	0x00b0
G$P3_1$0$0 == 0x00b1
_P3_1	=	0x00b1
G$P3_2$0$0 == 0x00b2
_P3_2	=	0x00b2
G$P3_3$0$0 == 0x00b3
_P3_3	=	0x00b3
G$P3_4$0$0 == 0x00b4
_P3_4	=	0x00b4
G$P3_5$0$0 == 0x00b5
_P3_5	=	0x00b5
G$P3_6$0$0 == 0x00b6
_P3_6	=	0x00b6
G$P3_7$0$0 == 0x00b7
_P3_7	=	0x00b7
G$PX0$0$0 == 0x00b8
_PX0	=	0x00b8
G$PT0$0$0 == 0x00b9
_PT0	=	0x00b9
G$PX1$0$0 == 0x00ba
_PX1	=	0x00ba
G$PT1$0$0 == 0x00bb
_PT1	=	0x00bb
G$PS0$0$0 == 0x00bc
_PS0	=	0x00bc
G$PS$0$0 == 0x00bc
_PS	=	0x00bc
G$PT2$0$0 == 0x00bd
_PT2	=	0x00bd
G$SMBTOE$0$0 == 0x00c0
_SMBTOE	=	0x00c0
G$SMBFTE$0$0 == 0x00c1
_SMBFTE	=	0x00c1
G$AA$0$0 == 0x00c2
_AA	=	0x00c2
G$SI$0$0 == 0x00c3
_SI	=	0x00c3
G$STO$0$0 == 0x00c4
_STO	=	0x00c4
G$STA$0$0 == 0x00c5
_STA	=	0x00c5
G$ENSMB$0$0 == 0x00c6
_ENSMB	=	0x00c6
G$BUSY$0$0 == 0x00c7
_BUSY	=	0x00c7
G$CANTXOK$0$0 == 0x00c3
_CANTXOK	=	0x00c3
G$CANRXOK$0$0 == 0x00c4
_CANRXOK	=	0x00c4
G$CANEPASS$0$0 == 0x00c5
_CANEPASS	=	0x00c5
G$CANEWARN$0$0 == 0x00c6
_CANEWARN	=	0x00c6
G$CANBOFF$0$0 == 0x00c7
_CANBOFF	=	0x00c7
G$CPRL2$0$0 == 0x00c8
_CPRL2	=	0x00c8
G$CT2$0$0 == 0x00c9
_CT2	=	0x00c9
G$TR2$0$0 == 0x00ca
_TR2	=	0x00ca
G$EXEN2$0$0 == 0x00cb
_EXEN2	=	0x00cb
G$EXF2$0$0 == 0x00ce
_EXF2	=	0x00ce
G$TF2$0$0 == 0x00cf
_TF2	=	0x00cf
G$CPRL3$0$0 == 0x00c8
_CPRL3	=	0x00c8
G$CT3$0$0 == 0x00c9
_CT3	=	0x00c9
G$TR3$0$0 == 0x00ca
_TR3	=	0x00ca
G$EXEN3$0$0 == 0x00cb
_EXEN3	=	0x00cb
G$EXF3$0$0 == 0x00ce
_EXF3	=	0x00ce
G$TF3$0$0 == 0x00cf
_TF3	=	0x00cf
G$CPRL4$0$0 == 0x00c8
_CPRL4	=	0x00c8
G$CT4$0$0 == 0x00c9
_CT4	=	0x00c9
G$TR4$0$0 == 0x00ca
_TR4	=	0x00ca
G$EXEN4$0$0 == 0x00cb
_EXEN4	=	0x00cb
G$EXF4$0$0 == 0x00ce
_EXF4	=	0x00ce
G$TF4$0$0 == 0x00cf
_TF4	=	0x00cf
G$P4_0$0$0 == 0x00c8
_P4_0	=	0x00c8
G$P4_1$0$0 == 0x00c9
_P4_1	=	0x00c9
G$P4_2$0$0 == 0x00ca
_P4_2	=	0x00ca
G$P4_3$0$0 == 0x00cb
_P4_3	=	0x00cb
G$P4_4$0$0 == 0x00cc
_P4_4	=	0x00cc
G$P4_5$0$0 == 0x00cd
_P4_5	=	0x00cd
G$P4_6$0$0 == 0x00ce
_P4_6	=	0x00ce
G$P4_7$0$0 == 0x00cf
_P4_7	=	0x00cf
G$P$0$0 == 0x00d0
_P	=	0x00d0
G$F1$0$0 == 0x00d1
_F1	=	0x00d1
G$OV$0$0 == 0x00d2
_OV	=	0x00d2
G$RS0$0$0 == 0x00d3
_RS0	=	0x00d3
G$RS1$0$0 == 0x00d4
_RS1	=	0x00d4
G$F0$0$0 == 0x00d5
_F0	=	0x00d5
G$AC$0$0 == 0x00d6
_AC	=	0x00d6
G$CY$0$0 == 0x00d7
_CY	=	0x00d7
G$CCF0$0$0 == 0x00d8
_CCF0	=	0x00d8
G$CCF1$0$0 == 0x00d9
_CCF1	=	0x00d9
G$CCF2$0$0 == 0x00da
_CCF2	=	0x00da
G$CCF3$0$0 == 0x00db
_CCF3	=	0x00db
G$CCF4$0$0 == 0x00dc
_CCF4	=	0x00dc
G$CCF5$0$0 == 0x00dd
_CCF5	=	0x00dd
G$CR$0$0 == 0x00de
_CR	=	0x00de
G$CF$0$0 == 0x00df
_CF	=	0x00df
G$DMA0DO0$0$0 == 0x00d8
_DMA0DO0	=	0x00d8
G$DMA0DO1$0$0 == 0x00d9
_DMA0DO1	=	0x00d9
G$DMA0DOE$0$0 == 0x00da
_DMA0DOE	=	0x00da
G$DMA0DE0$0$0 == 0x00db
_DMA0DE0	=	0x00db
G$DMA0DE1$0$0 == 0x00dc
_DMA0DE1	=	0x00dc
G$DMA0MD$0$0 == 0x00dd
_DMA0MD	=	0x00dd
G$DMA0INT$0$0 == 0x00de
_DMA0INT	=	0x00de
G$DMA0EN$0$0 == 0x00df
_DMA0EN	=	0x00df
G$P5_0$0$0 == 0x00d8
_P5_0	=	0x00d8
G$P5_1$0$0 == 0x00d9
_P5_1	=	0x00d9
G$P5_2$0$0 == 0x00da
_P5_2	=	0x00da
G$P5_3$0$0 == 0x00db
_P5_3	=	0x00db
G$P5_4$0$0 == 0x00dc
_P5_4	=	0x00dc
G$P5_5$0$0 == 0x00dd
_P5_5	=	0x00dd
G$P5_6$0$0 == 0x00de
_P5_6	=	0x00de
G$P5_7$0$0 == 0x00df
_P5_7	=	0x00df
G$AD0WINT$0$0 == 0x00e9
_AD0WINT	=	0x00e9
G$AD0CM0$0$0 == 0x00ea
_AD0CM0	=	0x00ea
G$AD0CM1$0$0 == 0x00eb
_AD0CM1	=	0x00eb
G$AD0BUSY$0$0 == 0x00ec
_AD0BUSY	=	0x00ec
G$AD0INT$0$0 == 0x00ed
_AD0INT	=	0x00ed
G$AD0TM$0$0 == 0x00ee
_AD0TM	=	0x00ee
G$AD0EN$0$0 == 0x00ef
_AD0EN	=	0x00ef
G$AD1CM0$0$0 == 0x00e9
_AD1CM0	=	0x00e9
G$AD1CM1$0$0 == 0x00ea
_AD1CM1	=	0x00ea
G$AD1CM2$0$0 == 0x00eb
_AD1CM2	=	0x00eb
G$AD1BUSY$0$0 == 0x00ec
_AD1BUSY	=	0x00ec
G$AD1INT$0$0 == 0x00ed
_AD1INT	=	0x00ed
G$AD1TM$0$0 == 0x00ee
_AD1TM	=	0x00ee
G$AD1EN$0$0 == 0x00ef
_AD1EN	=	0x00ef
G$AD2LJST$0$0 == 0x00e8
_AD2LJST	=	0x00e8
G$AD2WINT$0$0 == 0x00e9
_AD2WINT	=	0x00e9
G$AD2CM0$0$0 == 0x00ea
_AD2CM0	=	0x00ea
G$AD2CM1$0$0 == 0x00eb
_AD2CM1	=	0x00eb
G$AD2BUSY$0$0 == 0x00ec
_AD2BUSY	=	0x00ec
G$AD2INT$0$0 == 0x00ed
_AD2INT	=	0x00ed
G$AD2TM$0$0 == 0x00ee
_AD2TM	=	0x00ee
G$AD2EN$0$0 == 0x00ef
_AD2EN	=	0x00ef
G$P6_0$0$0 == 0x00e8
_P6_0	=	0x00e8
G$P6_1$0$0 == 0x00e9
_P6_1	=	0x00e9
G$P6_2$0$0 == 0x00ea
_P6_2	=	0x00ea
G$P6_3$0$0 == 0x00eb
_P6_3	=	0x00eb
G$P6_4$0$0 == 0x00ec
_P6_4	=	0x00ec
G$P6_5$0$0 == 0x00ed
_P6_5	=	0x00ed
G$P6_6$0$0 == 0x00ee
_P6_6	=	0x00ee
G$P6_7$0$0 == 0x00ef
_P6_7	=	0x00ef
G$SPIEN$0$0 == 0x00f8
_SPIEN	=	0x00f8
G$TXBMT$0$0 == 0x00f9
_TXBMT	=	0x00f9
G$NSSMD0$0$0 == 0x00fa
_NSSMD0	=	0x00fa
G$NSSMD1$0$0 == 0x00fb
_NSSMD1	=	0x00fb
G$RXOVRN$0$0 == 0x00fc
_RXOVRN	=	0x00fc
G$MODF$0$0 == 0x00fd
_MODF	=	0x00fd
G$WCOL$0$0 == 0x00fe
_WCOL	=	0x00fe
G$SPIF$0$0 == 0x00ff
_SPIF	=	0x00ff
G$CANINIT$0$0 == 0x00f8
_CANINIT	=	0x00f8
G$CANIE$0$0 == 0x00f9
_CANIE	=	0x00f9
G$CANSIE$0$0 == 0x00fa
_CANSIE	=	0x00fa
G$CANEIE$0$0 == 0x00fb
_CANEIE	=	0x00fb
G$CANIF$0$0 == 0x00fc
_CANIF	=	0x00fc
G$CANDAR$0$0 == 0x00fd
_CANDAR	=	0x00fd
G$CANCCE$0$0 == 0x00fe
_CANCCE	=	0x00fe
G$CANTEST$0$0 == 0x00ff
_CANTEST	=	0x00ff
G$DMA0EO$0$0 == 0x00f8
_DMA0EO	=	0x00f8
G$DMA0EOE$0$0 == 0x00f9
_DMA0EOE	=	0x00f9
G$DMA0CI$0$0 == 0x00fa
_DMA0CI	=	0x00fa
G$DMA0CIE$0$0 == 0x00fb
_DMA0CIE	=	0x00fb
G$DMA0XBY$0$0 == 0x00fe
_DMA0XBY	=	0x00fe
G$DMA0HLT$0$0 == 0x00ff
_DMA0HLT	=	0x00ff
G$P7_0$0$0 == 0x00f8
_P7_0	=	0x00f8
G$P7_1$0$0 == 0x00f9
_P7_1	=	0x00f9
G$P7_2$0$0 == 0x00fa
_P7_2	=	0x00fa
G$P7_3$0$0 == 0x00fb
_P7_3	=	0x00fb
G$P7_4$0$0 == 0x00fc
_P7_4	=	0x00fc
G$P7_5$0$0 == 0x00fd
_P7_5	=	0x00fd
G$P7_6$0$0 == 0x00fe
_P7_6	=	0x00fe
G$P7_7$0$0 == 0x00ff
_P7_7	=	0x00ff
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	.area REG_BANK_0	(REL,OVR,DATA)
	.ds 8
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	.area DSEG    (DATA)
G$dly_cycles$0$0==.
_dly_cycles::
	.ds 1
G$sysclk$0$0==.
_sysclk::
	.ds 4
G$samplingfreq$0$0==.
_samplingfreq::
	.ds 2
G$i$0$0==.
_i::
	.ds 2
G$elemszam$0$0==.
_elemszam::
	.ds 2
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
	.area	OSEG    (OVR,DATA)
	.area	OSEG    (OVR,DATA)
	.area	OSEG    (OVR,DATA)
	.area	OSEG    (OVR,DATA)
	.area	OSEG    (OVR,DATA)
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG	(DATA)
__start__stack:
	.ds	1

;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	.area ISEG    (DATA)
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	.area IABS    (ABS,DATA)
	.area IABS    (ABS,DATA)
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	.area BSEG    (BIT)
G$handshake$0$0==.
_handshake::
	.ds 1
LMADAQ.ADC0_irqhandler$sloc0$1$0==.
_ADC0_irqhandler_sloc0_1_0:
	.ds 1
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	.area PSEG    (PAG,XDATA)
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
G$samples$0$0==.
_samples::
	.ds 1024
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area XABS    (ABS,XDATA)
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
	.area XISEG   (XDATA)
	.area HOME    (CODE)
	.area GSINIT0 (CODE)
	.area GSINIT1 (CODE)
	.area GSINIT2 (CODE)
	.area GSINIT3 (CODE)
	.area GSINIT4 (CODE)
	.area GSINIT5 (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area CSEG    (CODE)
;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME    (CODE)
__interrupt_vect:
	ljmp	__sdcc_gsinit_startup
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	reti
	.ds	7
	ljmp	_ADC0_irqhandler
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME    (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area GSINIT  (CODE)
	.globl __sdcc_gsinit_startup
	.globl __sdcc_program_startup
	.globl __start__stack
	.globl __mcs51_genXINIT
	.globl __mcs51_genXRAMCLEAR
	.globl __mcs51_genRAMCLEAR
	C$MADAQ.c$18$1$49 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:18: INT8U dly_cycles = 225;
	mov	_dly_cycles,#0xE1
	C$MADAQ.c$19$1$49 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:19: INT32U sysclk = 24000000;
	mov	_sysclk,#0x00
	mov	(_sysclk + 1),#0x36
	mov	(_sysclk + 2),#0x6E
	mov	(_sysclk + 3),#0x01
	C$MADAQ.c$20$1$49 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:20: INT16U samplingfreq = 500;
	mov	_samplingfreq,#0xF4
	mov	(_samplingfreq + 1),#0x01
	C$MADAQ.c$23$1$49 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:23: INT16U i = 0;
	clr	a
	mov	_i,a
	mov	(_i + 1),a
	C$MADAQ.c$27$1$49 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:27: INT16U elemszam = 0;
	clr	a
	mov	_elemszam,a
	mov	(_elemszam + 1),a
	.area GSFINAL (CODE)
	ljmp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME    (CODE)
	.area HOME    (CODE)
__sdcc_program_startup:
	ljmp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CSEG    (CODE)
;------------------------------------------------------------
;Allocation info for local variables in function 'Reset_Sources_Init'
;------------------------------------------------------------
	G$Reset_Sources_Init$0$0 ==.
	C$MADAQ_config.c$9$0$0 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:9: void Reset_Sources_Init()
;	-----------------------------------------
;	 function Reset_Sources_Init
;	-----------------------------------------
_Reset_Sources_Init:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
	C$MADAQ_config.c$11$1$15 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:11: WDTCN     = 0xDE;
	mov	_WDTCN,#0xDE
	C$MADAQ_config.c$12$1$15 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:12: WDTCN     = 0xAD;
	mov	_WDTCN,#0xAD
	C$MADAQ_config.c$13$1$15 ==.
	XG$Reset_Sources_Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer_Init'
;------------------------------------------------------------
	G$Timer_Init$0$0 ==.
	C$MADAQ_config.c$15$1$15 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:15: void Timer_Init()
;	-----------------------------------------
;	 function Timer_Init
;	-----------------------------------------
_Timer_Init:
	C$MADAQ_config.c$17$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:17: SFRPAGE   = TIMER01_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ_config.c$18$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:18: TCON      = 0x40;
	mov	_TCON,#0x40
	C$MADAQ_config.c$19$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:19: TMOD      = 0x20;
	mov	_TMOD,#0x20
	C$MADAQ_config.c$20$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:20: CKCON     = 0x10;
	mov	_CKCON,#0x10
	C$MADAQ_config.c$21$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:21: TH1       = 0x98;
	mov	_TH1,#0x98
	C$MADAQ_config.c$22$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:22: SFRPAGE   = TMR2_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ_config.c$23$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:23: TMR2CN    = 0x04;
	mov	_TMR2CN,#0x04
	C$MADAQ_config.c$25$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:25: TMR2CF    = 0x08; // tmr2 clk = sysclk
	mov	_TMR2CF,#0x08
	C$MADAQ_config.c$28$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:28: RCAP2L    = 0x9C;
	mov	_RCAP2L,#0x9C
	C$MADAQ_config.c$29$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:29: RCAP2H    = 0xFF;
	mov	_RCAP2H,#0xFF
	C$MADAQ_config.c$30$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:30: SFRPAGE   = TMR3_PAGE;
	mov	_SFRPAGE,#0x01
	C$MADAQ_config.c$31$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:31: TMR3CN    = 0x04;
	mov	_TMR3CN,#0x04
	C$MADAQ_config.c$32$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:32: TMR3CF    = 0x08;
	mov	_TMR3CF,#0x08
	C$MADAQ_config.c$33$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:33: RCAP3L    = 0xB2;
	mov	_RCAP3L,#0xB2
	C$MADAQ_config.c$34$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:34: RCAP3H    = 0xFF;
	mov	_RCAP3H,#0xFF
	C$MADAQ_config.c$35$1$16 ==.
	XG$Timer_Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'UART_Init'
;------------------------------------------------------------
	G$UART_Init$0$0 ==.
	C$MADAQ_config.c$37$1$16 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:37: void UART_Init()
;	-----------------------------------------
;	 function UART_Init
;	-----------------------------------------
_UART_Init:
	C$MADAQ_config.c$39$1$17 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:39: SFRPAGE   = UART0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ_config.c$40$1$17 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:40: SCON0     = 0x50;
	mov	_SCON0,#0x50
	C$MADAQ_config.c$41$1$17 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:41: SSTA0     = 0x1A;
	mov	_SSTA0,#0x1A
	C$MADAQ_config.c$43$1$17 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:43: TI0=1;
	setb	_TI0
	C$MADAQ_config.c$44$1$17 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:44: RI0=0;
	clr	_RI0
	C$MADAQ_config.c$45$1$17 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:45: SFRPAGE   = UART1_PAGE;
	mov	_SFRPAGE,#0x01
	C$MADAQ_config.c$46$1$17 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:46: SCON1     = 0x50;
	mov	_SCON1,#0x50
	C$MADAQ_config.c$48$1$17 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:48: TI1=1;
	setb	_TI1
	C$MADAQ_config.c$49$1$17 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:49: RI1=0;
	clr	_RI1
	C$MADAQ_config.c$50$1$17 ==.
	XG$UART_Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'SMBus_Init'
;------------------------------------------------------------
	G$SMBus_Init$0$0 ==.
	C$MADAQ_config.c$52$1$17 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:52: void SMBus_Init()
;	-----------------------------------------
;	 function SMBus_Init
;	-----------------------------------------
_SMBus_Init:
	C$MADAQ_config.c$54$1$18 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:54: SFRPAGE   = SMB0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ_config.c$55$1$18 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:55: SMB0CN    = 0x40;
	mov	_SMB0CN,#0x40
	C$MADAQ_config.c$56$1$18 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:56: SMB0CR    = 0x91;
	mov	_SMB0CR,#0x91
	C$MADAQ_config.c$57$1$18 ==.
	XG$SMBus_Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'ADC_Init'
;------------------------------------------------------------
	G$ADC_Init$0$0 ==.
	C$MADAQ_config.c$59$1$18 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:59: void ADC_Init()
;	-----------------------------------------
;	 function ADC_Init
;	-----------------------------------------
_ADC_Init:
	C$MADAQ_config.c$61$1$19 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:61: SFRPAGE   = ADC0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ_config.c$62$1$19 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:62: ADC0CF    = 0x10;
	mov	_ADC0CF,#0x10
	C$MADAQ_config.c$63$1$19 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:63: ADC0CN    = 0x0C;
	mov	_ADC0CN,#0x0C
	C$MADAQ_config.c$64$1$19 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:64: SFRPAGE   = ADC1_PAGE;
	mov	_SFRPAGE,#0x01
	C$MADAQ_config.c$65$1$19 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:65: ADC1CF    = 0x10;
	mov	_ADC1CF,#0x10
	C$MADAQ_config.c$66$1$19 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:66: ADC1CN    = 0x8C;
	mov	_ADC1CN,#0x8C
	C$MADAQ_config.c$67$1$19 ==.
	XG$ADC_Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'DAC_Init'
;------------------------------------------------------------
	G$DAC_Init$0$0 ==.
	C$MADAQ_config.c$69$1$19 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:69: void DAC_Init()
;	-----------------------------------------
;	 function DAC_Init
;	-----------------------------------------
_DAC_Init:
	C$MADAQ_config.c$71$1$20 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:71: SFRPAGE   = DAC0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ_config.c$72$1$20 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:72: DAC0CN    = 0x84;
	mov	_DAC0CN,#0x84
	C$MADAQ_config.c$73$1$20 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:73: SFRPAGE   = DAC1_PAGE;
	mov	_SFRPAGE,#0x01
	C$MADAQ_config.c$74$1$20 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:74: DAC1CN    = 0x84;
	mov	_DAC1CN,#0x84
	C$MADAQ_config.c$75$1$20 ==.
	XG$DAC_Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'EMI_Init'
;------------------------------------------------------------
	G$EMI_Init$0$0 ==.
	C$MADAQ_config.c$77$1$20 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:77: void EMI_Init()
;	-----------------------------------------
;	 function EMI_Init
;	-----------------------------------------
_EMI_Init:
	C$MADAQ_config.c$79$1$21 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:79: SFRPAGE   = EMI0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ_config.c$80$1$21 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:80: EMI0CF    = 0x3F;
	mov	_EMI0CF,#0x3F
	C$MADAQ_config.c$81$1$21 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:81: EMI0TC    = 0x45;
	mov	_EMI0TC,#0x45
	C$MADAQ_config.c$82$1$21 ==.
	XG$EMI_Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Voltage_Reference_Init'
;------------------------------------------------------------
	G$Voltage_Reference_Init$0$0 ==.
	C$MADAQ_config.c$84$1$21 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:84: void Voltage_Reference_Init()
;	-----------------------------------------
;	 function Voltage_Reference_Init
;	-----------------------------------------
_Voltage_Reference_Init:
	C$MADAQ_config.c$86$1$22 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:86: SFRPAGE   = ADC0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ_config.c$87$1$22 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:87: REF0CN    = 0x02;
	mov	_REF0CN,#0x02
	C$MADAQ_config.c$88$1$22 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:88: SFRPAGE   = ADC1_PAGE;
	mov	_SFRPAGE,#0x01
	C$MADAQ_config.c$89$1$22 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:89: REF1CN    = 0x02;
	mov	_REF1CN,#0x02
	C$MADAQ_config.c$90$1$22 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:90: SFRPAGE   = ADC2_PAGE;
	mov	_SFRPAGE,#0x02
	C$MADAQ_config.c$91$1$22 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:91: REF2CN    = 0x02;
	mov	_REF2CN,#0x02
	C$MADAQ_config.c$92$1$22 ==.
	XG$Voltage_Reference_Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Port_IO_Init'
;------------------------------------------------------------
	G$Port_IO_Init$0$0 ==.
	C$MADAQ_config.c$94$1$22 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:94: void Port_IO_Init()
;	-----------------------------------------
;	 function Port_IO_Init
;	-----------------------------------------
_Port_IO_Init:
	C$MADAQ_config.c$132$1$23 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:132: SFRPAGE   = CONFIG_PAGE;
	mov	_SFRPAGE,#0x0F
	C$MADAQ_config.c$133$1$23 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:133: P0MDOUT   = 0x01;
	mov	_P0MDOUT,#0x01
	C$MADAQ_config.c$134$1$23 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:134: P0MDOUT = P0MDOUT | 0x04; // set P0.2 as push-pull
	orl	_P0MDOUT,#0x04
	C$MADAQ_config.c$136$1$23 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:136: P2MDOUT   = 0x7A;
	mov	_P2MDOUT,#0x7A
	C$MADAQ_config.c$137$1$23 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:137: P3MDOUT   = 0x07;
	mov	_P3MDOUT,#0x07
	C$MADAQ_config.c$138$1$23 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:138: P4MDOUT   = 0xE0;
	mov	_P4MDOUT,#0xE0
	C$MADAQ_config.c$139$1$23 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:139: P5MDOUT   = 0xFF;
	mov	_P5MDOUT,#0xFF
	C$MADAQ_config.c$140$1$23 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:140: P6MDOUT   = 0xFF;
	mov	_P6MDOUT,#0xFF
	C$MADAQ_config.c$141$1$23 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:141: P7MDOUT   = 0xFF;
	mov	_P7MDOUT,#0xFF
	C$MADAQ_config.c$142$1$23 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:142: XBR0      = 0x04;
	mov	_XBR0,#0x04
	C$MADAQ_config.c$143$1$23 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:143: XBR2      = 0x40;
	mov	_XBR2,#0x40
	C$MADAQ_config.c$144$1$23 ==.
	XG$Port_IO_Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Oscillator_Init'
;------------------------------------------------------------
;i                         Allocated to registers r6 r7 
;------------------------------------------------------------
	G$Oscillator_Init$0$0 ==.
	C$MADAQ_config.c$146$1$23 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:146: void Oscillator_Init()
;	-----------------------------------------
;	 function Oscillator_Init
;	-----------------------------------------
_Oscillator_Init:
	C$MADAQ_config.c$149$1$24 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:149: SFRPAGE   = CONFIG_PAGE;
	mov	_SFRPAGE,#0x0F
	C$MADAQ_config.c$150$1$24 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:150: OSCXCN    = 0x67;
	mov	_OSCXCN,#0x67
	C$MADAQ_config.c$151$1$24 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:151: for (i = 0; i < 3000; i++);  // Wait 1ms for initialization
	mov	r6,#0xB8
	mov	r7,#0x0B
00107$:
	dec	r6
	cjne	r6,#0xFF,00121$
	dec	r7
00121$:
	mov	a,r6
	orl	a,r7
	jnz	00107$
	C$MADAQ_config.c$152$1$24 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:152: while ((OSCXCN & 0x80) == 0);
00102$:
	mov	a,_OSCXCN
	jnb	acc.7,00102$
	C$MADAQ_config.c$153$1$24 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:153: CLKSEL    = 0x01;
	mov	_CLKSEL,#0x01
	C$MADAQ_config.c$154$1$24 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:154: OSCICN    = 0x03;
	mov	_OSCICN,#0x03
	C$MADAQ_config.c$155$1$24 ==.
	XG$Oscillator_Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Interrupts_Init'
;------------------------------------------------------------
	G$Interrupts_Init$0$0 ==.
	C$MADAQ_config.c$157$1$24 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:157: void Interrupts_Init()
;	-----------------------------------------
;	 function Interrupts_Init
;	-----------------------------------------
_Interrupts_Init:
	C$MADAQ_config.c$159$1$25 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:159: IE        = 0x80;
	mov	_IE,#0x80
	C$MADAQ_config.c$160$1$25 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:160: EIE1      = 0x80;
	mov	_EIE1,#0x80
	C$MADAQ_config.c$161$1$25 ==.
	XG$Interrupts_Init$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Init_Device'
;------------------------------------------------------------
	G$Init_Device$0$0 ==.
	C$MADAQ_config.c$165$1$25 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:165: void Init_Device(void)
;	-----------------------------------------
;	 function Init_Device
;	-----------------------------------------
_Init_Device:
	C$MADAQ_config.c$167$1$27 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:167: Reset_Sources_Init();
	lcall	_Reset_Sources_Init
	C$MADAQ_config.c$168$1$27 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:168: Timer_Init();
	lcall	_Timer_Init
	C$MADAQ_config.c$169$1$27 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:169: UART_Init();
	lcall	_UART_Init
	C$MADAQ_config.c$170$1$27 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:170: SMBus_Init();
	lcall	_SMBus_Init
	C$MADAQ_config.c$171$1$27 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:171: ADC_Init();
	lcall	_ADC_Init
	C$MADAQ_config.c$172$1$27 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:172: DAC_Init();
	lcall	_DAC_Init
	C$MADAQ_config.c$173$1$27 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:173: EMI_Init();
	lcall	_EMI_Init
	C$MADAQ_config.c$174$1$27 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:174: Voltage_Reference_Init();
	lcall	_Voltage_Reference_Init
	C$MADAQ_config.c$175$1$27 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:175: Port_IO_Init();
	lcall	_Port_IO_Init
	C$MADAQ_config.c$176$1$27 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:176: Oscillator_Init();
	lcall	_Oscillator_Init
	C$MADAQ_config.c$177$1$27 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\/MADAQ_config.c:177: Interrupts_Init();
	lcall	_Interrupts_Init
	C$MADAQ_config.c$178$1$27 ==.
	XG$Init_Device$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Delay_ms'
;------------------------------------------------------------
;ms                        Allocated to registers 
;i                         Allocated to registers r4 r5 
;------------------------------------------------------------
	G$Delay_ms$0$0 ==.
	C$MADAQ.c$30$1$27 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:30: void Delay_ms(short ms) {
;	-----------------------------------------
;	 function Delay_ms
;	-----------------------------------------
_Delay_ms:
	mov	__mulint_PARM_2,dpl
	mov	(__mulint_PARM_2 + 1),dph
	C$MADAQ.c$32$1$29 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:32: for(i=0; i<24*ms; i++)
	mov	dptr,#0x0018
	lcall	__mulint
	mov	r6,dpl
	mov	r7,dph
	mov	r4,#0x00
	mov	r5,#0x00
00103$:
	clr	c
	mov	a,r4
	subb	a,r6
	mov	a,r5
	xrl	a,#0x80
	mov	b,r7
	xrl	b,#0x80
	subb	a,b
	jnc	00105$
	C$MADAQ.c$44$3$31 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:44: __endasm;
	push b
	mov b,_dly_cycles
	   00001$:
	djnz b,00001$
	mov b,_dly_cycles
	   00002$:
	djnz b,00002$
	pop b
	C$MADAQ.c$32$1$29 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:32: for(i=0; i<24*ms; i++)
	inc	r4
	cjne	r4,#0x00,00103$
	inc	r5
	sjmp	00103$
00105$:
	C$MADAQ.c$47$1$29 ==.
	XG$Delay_ms$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'SIn'
;------------------------------------------------------------
;saved_sfrpage             Allocated to registers r7 
;c                         Allocated to registers 
;------------------------------------------------------------
	G$SIn$0$0 ==.
	C$MADAQ.c$51$1$29 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:51: unsigned char SIn(void) {
;	-----------------------------------------
;	 function SIn
;	-----------------------------------------
_SIn:
	C$MADAQ.c$55$1$33 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:55: saved_sfrpage=SFRPAGE;
	mov	r7,_SFRPAGE
	C$MADAQ.c$56$1$33 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:56: SFRPAGE   = UART0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ.c$57$1$33 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:57: while (!RI0);
00101$:
	C$MADAQ.c$58$1$33 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:58: RI0=0;
	jbc	_RI0,00112$
	sjmp	00101$
00112$:
	C$MADAQ.c$59$1$33 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:59: c=SBUF0;
	mov	dpl,_SBUF0
	C$MADAQ.c$60$1$33 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:60: SFRPAGE=saved_sfrpage;
	mov	_SFRPAGE,r7
	C$MADAQ.c$61$1$33 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:61: return c;
	C$MADAQ.c$62$1$33 ==.
	XG$SIn$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'SIn0'
;------------------------------------------------------------
;saved_sfrpage             Allocated to registers r7 
;c                         Allocated to registers r6 
;------------------------------------------------------------
	G$SIn0$0$0 ==.
	C$MADAQ.c$66$1$33 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:66: unsigned char SIn0(void) {
;	-----------------------------------------
;	 function SIn0
;	-----------------------------------------
_SIn0:
	C$MADAQ.c$70$1$35 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:70: saved_sfrpage=SFRPAGE;
	mov	r7,_SFRPAGE
	C$MADAQ.c$71$1$35 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:71: SFRPAGE   = UART0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ.c$72$1$35 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:72: c=0;
	mov	r6,#0x00
	C$MADAQ.c$73$1$35 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:73: if (RI0)
	C$MADAQ.c$75$2$36 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:75: RI0=0;
	jbc	_RI0,00108$
	sjmp	00102$
00108$:
	C$MADAQ.c$76$2$36 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:76: c=SBUF0;
	mov	r6,_SBUF0
00102$:
	C$MADAQ.c$78$1$35 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:78: SFRPAGE=saved_sfrpage;
	mov	_SFRPAGE,r7
	C$MADAQ.c$79$1$35 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:79: return c;
	mov	dpl,r6
	C$MADAQ.c$80$1$35 ==.
	XG$SIn0$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'SOut'
;------------------------------------------------------------
;a                         Allocated to registers r7 
;saved_sfrpage             Allocated to registers r6 
;------------------------------------------------------------
	G$SOut$0$0 ==.
	C$MADAQ.c$84$1$35 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:84: void SOut(unsigned char a) {
;	-----------------------------------------
;	 function SOut
;	-----------------------------------------
_SOut:
	mov	r7,dpl
	C$MADAQ.c$87$1$38 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:87: if (handshake) while (CTS); 	// if FT232 can't accept data
	jnb	_handshake,00105$
00101$:
	jb	_P2_0,00101$
00105$:
	C$MADAQ.c$88$1$38 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:88: saved_sfrpage=SFRPAGE;
	mov	r6,_SFRPAGE
	C$MADAQ.c$89$1$38 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:89: SFRPAGE   = UART0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ.c$90$1$38 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:90: while (!TI0);
00106$:
	C$MADAQ.c$91$1$38 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:91: TI0=0;
	jbc	_TI0,00122$
	sjmp	00106$
00122$:
	C$MADAQ.c$92$1$38 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:92: SBUF0=a;
	mov	_SBUF0,r7
	C$MADAQ.c$93$1$38 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:93: SFRPAGE=saved_sfrpage;
	mov	_SFRPAGE,r6
	C$MADAQ.c$94$1$38 ==.
	XG$SOut$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'SInOut'
;------------------------------------------------------------
;saved_sfrpage             Allocated to registers r7 
;c                         Allocated to registers r6 
;------------------------------------------------------------
	G$SInOut$0$0 ==.
	C$MADAQ.c$98$1$38 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:98: unsigned char SInOut(void) {
;	-----------------------------------------
;	 function SInOut
;	-----------------------------------------
_SInOut:
	C$MADAQ.c$102$1$40 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:102: saved_sfrpage=SFRPAGE;
	mov	r7,_SFRPAGE
	C$MADAQ.c$103$1$40 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:103: SFRPAGE   = UART0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ.c$104$1$40 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:104: while (!RI0);
00101$:
	C$MADAQ.c$105$1$40 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:105: RI0=0;
	jbc	_RI0,00129$
	sjmp	00101$
00129$:
	C$MADAQ.c$106$1$40 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:106: c=SBUF0;
	mov	r6,_SBUF0
	C$MADAQ.c$107$1$40 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:107: if (handshake) while (CTS); 	// if FT232 can't accept data
	jnb	_handshake,00109$
00104$:
	jb	_P2_0,00104$
	C$MADAQ.c$108$1$40 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:108: while (!TI0);
00109$:
	C$MADAQ.c$109$1$40 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:109: TI0=0;
	jbc	_TI0,00132$
	sjmp	00109$
00132$:
	C$MADAQ.c$110$1$40 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:110: SBUF0=c;
	mov	_SBUF0,r6
	C$MADAQ.c$111$1$40 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:111: SFRPAGE=saved_sfrpage;
	mov	_SFRPAGE,r7
	C$MADAQ.c$112$1$40 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:112: return c;
	mov	dpl,r6
	C$MADAQ.c$113$1$40 ==.
	XG$SInOut$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'SendID'
;------------------------------------------------------------
;s                         Allocated to registers 
;------------------------------------------------------------
	G$SendID$0$0 ==.
	C$MADAQ.c$116$1$40 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:116: void SendID() {
;	-----------------------------------------
;	 function SendID
;	-----------------------------------------
_SendID:
	C$MADAQ.c$119$1$41 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:119: s="MA-DAQ";
	mov	r5,#__str_0
	mov	r6,#(__str_0 >> 8)
	mov	r7,#0x80
	C$MADAQ.c$120$1$41 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:120: do
00105$:
	C$MADAQ.c$122$2$42 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:122: if (SIn()==27) break;
	push	ar7
	push	ar6
	push	ar5
	lcall	_SIn
	mov	r4,dpl
	pop	ar5
	pop	ar6
	pop	ar7
	cjne	r4,#0x1B,00120$
	sjmp	00108$
00120$:
	C$MADAQ.c$123$2$42 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:123: SOut(*s);
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	lcall	__gptrget
	mov	dpl,a
	push	ar7
	push	ar6
	push	ar5
	lcall	_SOut
	pop	ar5
	pop	ar6
	pop	ar7
	C$MADAQ.c$124$2$42 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:124: if (*s) s++;
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	lcall	__gptrget
	jz	00106$
	inc	r5
	cjne	r5,#0x00,00122$
	inc	r6
00122$:
00106$:
	C$MADAQ.c$125$1$41 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:125: } while (*s);
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	lcall	__gptrget
	jnz	00105$
00108$:
	C$MADAQ.c$127$1$41 ==.
	XG$SendID$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'ADC0_irqhandler'
;------------------------------------------------------------
	G$ADC0_irqhandler$0$0 ==.
	C$MADAQ.c$130$1$41 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:130: void ADC0_irqhandler (void) __interrupt 13 {
;	-----------------------------------------
;	 function ADC0_irqhandler
;	-----------------------------------------
_ADC0_irqhandler:
	push	psw
	C$MADAQ.c$131$1$44 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:131: AD0INT = 0;	
	clr	_AD0INT
	C$MADAQ.c$133$1$44 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:133: DEBUG_PORT = !DEBUG_PORT; // debug
	mov	c,_P0_2
	cpl	c
	mov  _ADC0_irqhandler_sloc0_1_0,c
	mov	_P0_2,c
	pop	psw
	C$MADAQ.c$147$1$44 ==.
	XG$ADC0_irqhandler$0$0 ==.
	reti
;	eliminated unneeded mov psw,# (no regs used in bank)
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;	eliminated unneeded push/pop acc
;------------------------------------------------------------
;Allocation info for local variables in function 'CheckSRAMs'
;------------------------------------------------------------
;k                         Allocated to registers r7 
;j                         Allocated to registers r6 
;------------------------------------------------------------
	G$CheckSRAMs$0$0 ==.
	C$MADAQ.c$156$1$44 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:156: unsigned char CheckSRAMs(void) {
;	-----------------------------------------
;	 function CheckSRAMs
;	-----------------------------------------
_CheckSRAMs:
	C$MADAQ.c$159$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:159: SFRPAGE   = EMI0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ.c$160$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:160: EMI0CF    = 0x3F;	// external SRAM only 
	mov	_EMI0CF,#0x3F
	C$MADAQ.c$162$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:162: SFRPAGE=CONFIG_PAGE;
	mov	_SFRPAGE,#0x0F
	C$MADAQ.c$163$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:163: P4_5=0;	// enable SRAM
	clr	_P4_5
	C$MADAQ.c$165$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:165: k=0;
	mov	r7,#0x00
	C$MADAQ.c$166$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:166: SET_ADDRESS_HI(0);
	anl	_P3,#0xF8
	C$MADAQ.c$168$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:168: XRAM(0xF000)=0x55;
	mov	dptr,#0xF000
	mov	a,#0x55
	movx	@dptr,a
	C$MADAQ.c$169$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:169: XRAM(0xF001)=0xAA;
	mov	dptr,#0xF001
	mov	a,#0xAA
	movx	@dptr,a
	C$MADAQ.c$170$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:170: if (XRAM(0xF000)!=0x55) k=1;
	mov	dptr,#0xF000
	movx	a,@dptr
	mov	r6,a
	cjne	r6,#0x55,00163$
	sjmp	00102$
00163$:
	mov	r7,#0x01
00102$:
	C$MADAQ.c$171$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:171: if (XRAM(0xF001)!=0xAA) k=1;
	mov	dptr,#0xF001
	movx	a,@dptr
	mov	r6,a
	cjne	r6,#0xAA,00164$
	sjmp	00104$
00164$:
	mov	r7,#0x01
00104$:
	C$MADAQ.c$173$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:173: SET_ADDRESS_HI(0);
	anl	_P3,#0xF8
	C$MADAQ.c$174$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:174: for (j=0; j<16; j++) XRAM(1 << j)=j;
	mov	r6,#0x00
00113$:
	mov	b,r6
	inc	b
	mov	r4,#0x01
	mov	r5,#0x00
	sjmp	00166$
00165$:
	mov	a,r4
	add	a,r4
	mov	r4,a
	mov	a,r5
	rlc	a
	mov	r5,a
00166$:
	djnz	b,00165$
	mov	dpl,r4
	mov	dph,r5
	mov	a,r6
	movx	@dptr,a
	inc	r6
	cjne	r6,#0x10,00167$
00167$:
	jc	00113$
	C$MADAQ.c$175$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:175: for (j=0; j<16; j++) if (XRAM(1 << j)!=j) k|=2;
	mov	r6,#0x00
00115$:
	mov	b,r6
	inc	b
	mov	r4,#0x01
	mov	r5,#0x00
	sjmp	00170$
00169$:
	mov	a,r4
	add	a,r4
	mov	r4,a
	mov	a,r5
	rlc	a
	mov	r5,a
00170$:
	djnz	b,00169$
	mov	dpl,r4
	mov	dph,r5
	movx	a,@dptr
	mov	r5,a
	cjne	a,ar6,00171$
	sjmp	00116$
00171$:
	orl	ar7,#0x02
00116$:
	inc	r6
	cjne	r6,#0x10,00172$
00172$:
	jc	00115$
	C$MADAQ.c$177$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:177: for (j=0; j<3; j++)
	mov	r6,#0x00
00117$:
	C$MADAQ.c$179$2$47 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:179: SET_ADDRESS_HI(1<<j);
	mov	a,#0xF8
	anl	a,_P3
	mov	r5,a
	mov	b,r6
	inc	b
	mov	r3,#0x01
	mov	r4,#0x00
	sjmp	00175$
00174$:
	mov	a,r3
	add	a,r3
	mov	r3,a
	mov	a,r4
	rlc	a
	mov	r4,a
00175$:
	djnz	b,00174$
	mov	a,r4
	rlc	a
	subb	a,acc
	mov	r3,a
	anl	ar3,#0x07
	clr	a
	mov	r4,a
	mov	r2,a
	mov	a,r5
	orl	ar3,a
	mov	a,r2
	orl	ar4,a
	mov	_P3,r3
	C$MADAQ.c$180$2$47 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:180: XRAM(0xF000+j)=j;
	mov	ar4,r6
	mov	r5,#0x00
	mov	a,#0xF0
	add	a,r5
	mov	r5,a
	mov	dpl,r4
	mov	dph,r5
	mov	a,r6
	movx	@dptr,a
	C$MADAQ.c$177$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:177: for (j=0; j<3; j++)
	inc	r6
	cjne	r6,#0x03,00176$
00176$:
	jc	00117$
	C$MADAQ.c$182$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:182: for (j=0; j<3; j++)
	mov	r6,#0x00
00119$:
	C$MADAQ.c$184$2$48 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:184: SET_ADDRESS_HI(1<<j);
	mov	a,#0xF8
	anl	a,_P3
	mov	r5,a
	mov	b,r6
	inc	b
	mov	r3,#0x01
	mov	r4,#0x00
	sjmp	00179$
00178$:
	mov	a,r3
	add	a,r3
	mov	r3,a
	mov	a,r4
	rlc	a
	mov	r4,a
00179$:
	djnz	b,00178$
	mov	a,r4
	rlc	a
	subb	a,acc
	mov	r3,a
	anl	ar3,#0x07
	clr	a
	mov	r4,a
	mov	r2,a
	mov	a,r5
	orl	ar3,a
	mov	a,r2
	orl	ar4,a
	mov	_P3,r3
	C$MADAQ.c$185$2$48 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:185: if (XRAM(0xF000+j)!=j) k|=4;
	mov	ar4,r6
	mov	r5,#0x00
	mov	a,#0xF0
	add	a,r5
	mov	r5,a
	mov	dpl,r4
	mov	dph,r5
	movx	a,@dptr
	mov	r5,a
	cjne	a,ar6,00180$
	sjmp	00120$
00180$:
	orl	ar7,#0x04
00120$:
	C$MADAQ.c$182$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:182: for (j=0; j<3; j++)
	inc	r6
	cjne	r6,#0x03,00181$
00181$:
	jc	00119$
	C$MADAQ.c$187$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:187: return k;
	mov	dpl,r7
	C$MADAQ.c$188$1$46 ==.
	XG$CheckSRAMs$0$0 ==.
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;c                         Allocated to registers r7 
;a                         Allocated to registers r6 
;a                         Allocated to registers r6 
;------------------------------------------------------------
	G$main$0$0 ==.
	C$MADAQ.c$191$1$46 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:191: void main() {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	C$MADAQ.c$194$1$49 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:194: Init_Device();	
	lcall	_Init_Device
	C$MADAQ.c$195$1$49 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:195: CheckSRAMs();
	lcall	_CheckSRAMs
	C$MADAQ.c$197$1$49 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:197: handshake = 1; // UART-hoz kell	
	setb	_handshake
	C$MADAQ.c$200$1$49 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:200: for(c=0; c<3; c++) {
	mov	r7,#0x00
00126$:
	C$MADAQ.c$201$2$50 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:201: LED=0;
	clr	_P2_2
	C$MADAQ.c$202$2$50 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:202: Delay_ms(200);
	mov	dptr,#0x00C8
	push	ar7
	lcall	_Delay_ms
	C$MADAQ.c$203$2$50 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:203: LED=1;
	setb	_P2_2
	C$MADAQ.c$204$2$50 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:204: Delay_ms(200);
	mov	dptr,#0x00C8
	lcall	_Delay_ms
	pop	ar7
	C$MADAQ.c$200$1$49 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:200: for(c=0; c<3; c++) {
	inc	r7
	cjne	r7,#0x03,00170$
00170$:
	jc	00126$
	C$MADAQ.c$206$1$49 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:206: LED=0;
	clr	_P2_2
	C$MADAQ.c$207$1$49 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:207: RTS=0;
	clr	_P2_1
	C$MADAQ.c$211$2$51 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:211: while (SInOut()!='@');
00102$:
	lcall	_SInOut
	mov	r7,dpl
	cjne	r7,#0x40,00102$
	C$MADAQ.c$212$2$51 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:212: c = SInOut();
	lcall	_SInOut
	mov	r7,dpl
	C$MADAQ.c$215$2$51 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:215: if (c=='I') {
	cjne	r7,#0x49,00121$
	C$MADAQ.c$216$3$52 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:216: SendID();
	lcall	_SendID
	sjmp	00102$
00121$:
	C$MADAQ.c$220$2$51 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:220: else if (c=='d') {
	cjne	r7,#0x64,00118$
	C$MADAQ.c$222$3$53 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:222: c=SInOut();	// hi
	lcall	_SInOut
	mov	r7,dpl
	C$MADAQ.c$223$3$53 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:223: a=SInOut();	// lo
	push	ar7
	lcall	_SInOut
	mov	r6,dpl
	pop	ar7
	C$MADAQ.c$224$3$53 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:224: SFRPAGE   = DAC0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ.c$225$3$53 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:225: DAC0CN    = 0x84;
	mov	_DAC0CN,#0x84
	C$MADAQ.c$226$3$53 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:226: DAC0L=a;
	mov	_DAC0L,r6
	C$MADAQ.c$227$3$53 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:227: DAC0H=c;
	mov	_DAC0H,r7
	sjmp	00102$
00118$:
	C$MADAQ.c$231$2$51 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:231: else if (c=='D') {
	cjne	r7,#0x44,00115$
	C$MADAQ.c$233$3$54 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:233: c=SInOut();	// hi
	lcall	_SInOut
	mov	r7,dpl
	C$MADAQ.c$234$3$54 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:234: a=SInOut();	// lo
	push	ar7
	lcall	_SInOut
	mov	r6,dpl
	pop	ar7
	C$MADAQ.c$235$3$54 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:235: SFRPAGE   = DAC1_PAGE;
	mov	_SFRPAGE,#0x01
	C$MADAQ.c$236$3$54 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:236: DAC1CN    = 0x84;
	mov	_DAC1CN,#0x84
	C$MADAQ.c$237$3$54 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:237: DAC1L=a;
	mov	_DAC1L,r6
	C$MADAQ.c$238$3$54 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:238: DAC1H=c;
	mov	_DAC1H,r7
	sjmp	00102$
00115$:
	C$MADAQ.c$242$2$51 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:242: else if (c=='G') {
	cjne	r7,#0x47,00180$
	sjmp	00181$
00180$:
	ljmp	00112$
00181$:
	C$MADAQ.c$243$3$55 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:243: SFRPAGE   = ADC0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ.c$244$3$55 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:244: CLR_BIT(ADC0CN, 7); // Disable ADC0
	mov	r6,_ADC0CN
	mov	a,#0x7F
	anl	a,r6
	mov	_ADC0CN,a
	C$MADAQ.c$247$3$55 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:247: elemszam = SInOut();
	lcall	_SInOut
	mov	r6,dpl
	C$MADAQ.c$248$3$55 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:248: elemszam = (elemszam << 8) + SInOut();
	mov	_elemszam,r6
	mov	(_elemszam + 1),#0x00
	mov	r5,#0x00
	push	ar6
	push	ar5
	lcall	_SInOut
	mov	r4,dpl
	pop	ar5
	pop	ar6
	mov	r3,#0x00
	mov	a,r4
	add	a,r5
	mov	_elemszam,a
	mov	a,r3
	addc	a,r6
	mov	(_elemszam + 1),a
	C$MADAQ.c$251$3$55 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:251: for (i=0; i<elemszam; i++) {
	clr	a
	mov	_i,a
	mov	(_i + 1),a
00129$:
	clr	c
	mov	a,_i
	subb	a,_elemszam
	mov	a,(_i + 1)
	subb	a,(_elemszam + 1)
	jc	00182$
	ljmp	00102$
00182$:
	C$MADAQ.c$252$4$56 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:252: samples[i] = SInOut();
	mov	a,_i
	add	a,_i
	mov	r5,a
	mov	a,(_i + 1)
	rlc	a
	mov	r6,a
	mov	a,r5
	add	a,#_samples
	mov	r5,a
	mov	a,r6
	addc	a,#(_samples >> 8)
	mov	r6,a
	push	ar6
	push	ar5
	lcall	_SInOut
	mov	r4,dpl
	pop	ar5
	pop	ar6
	mov	r3,#0x00
	mov	dpl,r5
	mov	dph,r6
	mov	a,r4
	movx	@dptr,a
	mov	a,r3
	inc	dptr
	movx	@dptr,a
	C$MADAQ.c$253$4$56 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:253: samples[i] = (samples[i] << 8) + SInOut();
	mov	a,_i
	add	a,_i
	mov	r5,a
	mov	a,(_i + 1)
	rlc	a
	mov	r6,a
	mov	a,r5
	add	a,#_samples
	mov	r5,a
	mov	a,r6
	addc	a,#(_samples >> 8)
	mov	r6,a
	mov	dpl,r5
	mov	dph,r6
	movx	a,@dptr
	mov	r3,a
	inc	dptr
	movx	a,@dptr
	mov	ar4,r3
	mov	r3,#0x00
	push	ar6
	push	ar5
	push	ar4
	push	ar3
	lcall	_SInOut
	mov	r2,dpl
	pop	ar3
	pop	ar4
	pop	ar5
	pop	ar6
	mov	ar1,r2
	mov	r2,#0x00
	mov	a,r1
	add	a,r3
	mov	r3,a
	mov	a,r2
	addc	a,r4
	mov	r4,a
	mov	dpl,r5
	mov	dph,r6
	mov	a,r3
	movx	@dptr,a
	mov	a,r4
	inc	dptr
	movx	@dptr,a
	C$MADAQ.c$251$3$55 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:251: for (i=0; i<elemszam; i++) {
	inc	_i
	clr	a
	cjne	a,_i,00183$
	inc	(_i + 1)
00183$:
	ljmp	00129$
00112$:
	C$MADAQ.c$259$2$51 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:259: else if (c=='f') {
	cjne	r7,#0x66,00109$
	C$MADAQ.c$260$3$57 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:260: RCAP2H   = SInOut();	// hi
	lcall	_SInOut
	mov	_RCAP2H,dpl
	C$MADAQ.c$261$3$57 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:261: RCAP2L   = SInOut();	// lo
	lcall	_SInOut
	mov	_RCAP2L,dpl
	ljmp	00102$
00109$:
	C$MADAQ.c$265$2$51 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:265: else if (c=='g') {		
	cjne	r7,#0x67,00186$
	sjmp	00187$
00186$:
	ljmp	00102$
00187$:
	C$MADAQ.c$266$3$58 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:266: SFRPAGE   = DAC0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ.c$267$3$58 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:267: DAC0CN    = 0x84;
	mov	_DAC0CN,#0x84
	C$MADAQ.c$269$3$58 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:269: SFRPAGE   = ADC0_PAGE;
	mov	_SFRPAGE,#0x00
	C$MADAQ.c$270$3$58 ==.
;	C:\Users\NB\Dropbox\UNI\Szakdolgozat\1030\MADAQ.c:270: SET_BIT(ADC0CN, 7); // Enable ADC0, 7=MSB
	orl	_ADC0CN,#0x80
	ljmp	00102$
	C$MADAQ.c$274$1$49 ==.
	XG$main$0$0 ==.
	ret
	.area CSEG    (CODE)
	.area CONST   (CODE)
FMADAQ$_str_0$0$0 == .
__str_0:
	.ascii "MA-DAQ"
	.db 0x00
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
