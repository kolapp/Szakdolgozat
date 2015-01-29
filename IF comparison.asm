; num_of_samples = UINT16
;	C:\Users\Hallgato\Desktop\Szakdolgozat\MADAQ source\MADAQ.c:244: if (n >= num_of_samples * 2) n = 0;
	mov	a,_num_of_samples
	add	a,_num_of_samples
	mov	r6,a
	mov	a,(_num_of_samples + 1)
	rlc	a
	mov	r7,a
	mov	r4,_n
	mov	r5,#0x00
	clr	c
	mov	a,r4
	subb	a,r6
	mov	a,r5
	subb	a,r7
	jc	00102$
	mov	_n,#0x00
00102$:


; num_of_samples = UINT8
;	C:\Users\Hallgato\Desktop\Szakdolgozat\MADAQ source\MADAQ.c:244: if (n >= num_of_samples * 2) n = 0;
	mov	a,_num_of_samples
	mov	b,#0x02
	mul	ab
	mov	r6,a
	mov	r7,b
	mov	r4,_n
	mov	r5,#0x00
	clr	c
	mov	a,r4
	subb	a,r6
	mov	a,r5
	xrl	a,#0x80
	mov	b,r7
	xrl	b,#0x80
	subb	a,b
	jc	00102$
	mov	_n,#0x00
00102$:



; sajat kod
;	C:\Users\Hallgato\Desktop\Szakdolgozat\MADAQ source\MADAQ.c: if (n >= num_of_samples *2) n = 0;	
	clr	c
	mov	a,_num_of_samples
	rl a					// a *= 2; 
	dec a					// a--;
	subb	a,_n
	jnc	00102$
	mov	_n,#0x00
00102$:


		
		
		
		