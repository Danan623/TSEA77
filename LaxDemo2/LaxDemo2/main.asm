;
; LaxDemo2.asm
;
; Hardware : two switch buttons and 7 -segment display
; Create a program that counts from 0 to F. when left button is pressed : count up. when right button is pressed : display. else show nothing
; Rule : if left button is pressed 15 times then the display should be lit. if 15 is reached or right
; button is pressed, then the counter should be cleared (start over)
;  

COLD:
	ldi r16, HIGH(RAMEND) ; set stackpointers
	out SPH,r16
	ldi r16, LOW(RAMEND)
	out SPL,r16

	call INIT_IO
MAIN:
	out PORTA,r16 ; display data
	sbic PIND,0 ; count up
	rjmp GET_DATA
	sbic PIND,1 ; show data
	rjmp SHOW_DATA
	rjmp MAIN

GET_DATA:
	inc r20
	cpi r20,$0F ; if we reach 15, show value and clear counter
	breq SHOW_DATA
	rjmp WAIT_RELEASE

SHOW_DATA:
	mov r16,r20 ; copy the current value

CLEAR_COUNTER:
	clr r20 ; start over

WAIT_RELEASE:
	sbic PIND,0 
	rjmp WAIT_RELEASE
	sbic PIND,1
	rjmp WAIT_RELEASE
	rjmp MAIN

INIT_IO:
	clr r17
	out DDRD,r17 ; in : D0 = left button and D1 = right button
	
	ldi r18,$FF
	out DDRA,r18 ; out : A0 to A3 connect to right display A to D respective  
	
	clr r16 ; in start : show 0
	clr r20 ; the counter

	ret
