;
; LaxDemo1.asm
;
; Hardware : Hexa keyboard and 7-segment display
; create a program when key 0 to 9 is pressed - the number should be displayed on the 7 - segment display
; Rules : it's only the numbers 0 to 9 that should be shown. If key > 9 then the left display should show 1
; if you press key (hexa) F then it should look like | [1]--[5] |


COLD:

	ldi r16,HIGH(RAMEND) ; set stackpointers
	out SPH,r16
	ldi r16,LOW(RAMEND)
	out SPL,r16

	call INIT_IO

MAIN:
	out PORTA, r16 ; display current data
	sbic PIND,0 ; wait for key pressed
	rjmp READ_DATA
	rjmp MAIN

READ_DATA:
	in r16,PINB ; read new data from keyboard
	mov r19,r16 ; copy value to be checked
	mov r20,r16 ; copy the value to use later

	com r19 ; toggle the bits (invert)
	andi r19,$0F ; clear high bit
	subi r19,$06 ; if the value is negative then we know r16 > 9. the Flag for negative is set

	brmi CHANGE_OUTPUT
	rjmp WAIT_RELEASE

CHANGE_OUTPUT:
	subi r20,$0A ; "remove" the ten
	ldi r16,$10 ; load with one high bit
	add r16,r20 ; add 0 to 5

WAIT_RELEASE:
	sbic PIND,0 ; wait for button release 
	rjmp WAIT_RELEASE
	rjmp MAIN
		
INIT_IO:

	clr r17
	out DDRD,r17 ; in : D0 = strobe connect to pin2
	out DDRB,r17 ; in : B0 to B3 connect to pin 3,5,7,9 respective

	ldi r18,$FF
	out DDRA, r18 ; out : A0 to A3 connect to A to D on right display and A4 to A7 connect to left display

	ret
