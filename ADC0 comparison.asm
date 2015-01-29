RÉGI ASM:
;	C:\Users\Hallgato\Desktop\Szakdolgozat\MADAQ source\MADAQ.c:182: output_measure[i] = (ADC0H << 8) | ADC0L; // gyüjti a mintakat
	mov	a,_i
	mov	b,#0x02
	mul	ab
	mov	r6,a
	mov	r7,b
	add	a,#_output_measure
	mov	dpl,a
	mov	a,r7
	addc	a,#(_output_measure >> 8)
	mov	dph,a
	mov	r5,_ADC0H
	mov	r4,#0x00
	mov	r2,_ADC0L
	mov	r3,#0x00
	mov	a,r2
	orl	ar4,a
	mov	a,r3
	orl	ar5,a
	mov	a,r4
	movx	@dptr,a
	mov	a,r5
	inc	dptr
	movx	@dptr,a
	C$MADAQ.c$185$1$49 ==.
	
	
ÚJ ASM SFR16-TAL:
;	output_measure[i] = ADC0; // gyüjti a mintakat
	mov	a,_i
	mov	b,#0x02
	mul	ab
	mov	r6,a
	mov	r7,b
	add	a,#_output_measure
	mov	dpl,a
	mov	a,r7
	addc	a,#(_output_measure >> 8)
	mov	dph,a
	mov	a,(_ADC0 & 0xFF)
	movx	@dptr,a
	mov	a,((_ADC0 >> 8) & 0xFF)
	inc	dptr
	movx	@dptr,a
	
XRAM OS KÖZVETLEN ELÉRÉS	
;	C:\Users\Hallgato\Desktop\Szakdolgozat\MADAQ source\MADAQ.c:213: OUTPUT_MEASURE(i) = ADC0H;
	mov	r6,_i
	mov	r7,#0x00
	mov	a,#0x02
	add	a,r7
	mov	r7,a
	mov	dpl,r6
	mov	dph,r7
	mov	a,_ADC0H
	movx	@dptr,a
	inc	_i
	
	mov	r6,_i
	mov	r7,#0x00
	mov	a,#0x02
	add	a,r7
	mov	r7,a
	mov	dpl,r6
	mov	dph,r7
	mov	a,_ADC0L
	movx	@dptr,a
	inc	_i
	
	
	
	
	
	
	
	