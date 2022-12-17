;
; LaxDemo5.asm
;
;	Hardware : Hexa keyboard and LED display
;	Create a program when a key is pushed on Hexa keyboard the curresponding binary sequence should be shown on the LED display
;	Rule : the LED 0 to 3 and LED 4 to 7 should show the same sequence when a key is pressed. ex. press key 4 -> [0100 | 0100]
;	if key 0 is pressed then the right most (LED 0 to 3) should be inverted but the left most should stay the same
;    ex. key 0 is pressed -> [0100 | 1011]

COLD:
	ldi r16,HIGH(RAMEND)
	out SPH,r16
	ldi r16, LOW(RAMEND)
	out SPL,r16

	CALL INIT_IO

MAIN:
	sbic PIND,4 ; check if key pressed
	rjmp READ_DATA
	rjmp MAIN

READ_DATA:
	in r16,PIND ; read input from key
	andi r16,$0F ; clear high bits
	cpi r16,$00 ; check if 0
	breq TOGGLE

	mov r20,r16 ; if not 0 copy input value
	cpi r19,$00 ; check flag (normal)
	breq SHOW_NORMAL
	rjmp SHOW_INVERT ; else inverted bits

TOGGLE:
	cpi r19,$01 ; if in invert mode -> change flag
	breq SHOW_NORMAL

INVERT_RIGHT:
	inc r19 ; set flag to "invert mode"

SHOW_INVERT:
	mov r21,r20 ; copy value (this will prevent the bits to toggle back and forth)
	com r21 ; invert bits
	andi r21,$0F ; clear high bits (not really necesarry, pin A4 and A7 not connected)
	out PORTA,r21 ; led 0 to 3
	out PORTB,r20 ; led 4 to 7
	rjmp WAIT_RELEASE

SHOW_NORMAL:
	clr r19 ; set flag to "normal mode"
	out PORTA,r20 ; LED 0 to 3
	out PORTB,r20 ; LED 4 to 7

WAIT_RELEASE:
	sbic PIND,4
	rjmp WAIT_RELEASE
	rjmp MAIN

INIT_IO:
	clr r17
	out DDRD,r17 ; in : D0 to D3 connects to 3,5,7,9 on Hexa, D4 = strobe

	ldi r18,$FF
	out DDRA,r18 ; out : A0 to A3 connects to pin 0 to pin 3 on LED (right)
	out DDRB,r18 ; out : B0 to B3 connects to pin 4 to pin 7 on LED (left)

	clr r19 ; "flag" to check normal or invert mode. normal = 0 invert = 1 

	ret
