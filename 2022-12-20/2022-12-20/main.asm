
; Hardware : two shift buttons and one 5x7 LED matrix
; create a program that move a LED from left to right in a LED matrix
; if the led is in lower row (row = 0) then the LED should be lit on the upper border and move one left or right position
; deppending on which button that is pressed. 
; if in left boarder and left button is pressed then the LED should move down and the same with right border
; else the LED should move deppending on button pressed and one row down each time.

; not tested but it should work. It is possible to change to a subrutines instead.
COLD:
	ldi r16,HIGH(RAMEND)
	out SPH,r16
	ldi r16,LOW(RAMEND)
	out SPL,r16

	call INIT_IO
MAIN:
	out PORTA,r16 ; display rows
	out PORTB,r16 ; display cols
	sbic PIND,0 ; left button pressed
	rjmp MOVE_LEFT
	sbic PIND,1 ; right button pressed
	rjmp MOVE_RIGHT 
	rjmp MAIN

JUMP_UP:
	ldi r16,$04 ; row in upper boarder
	rjmp WAIT_RELEASE

MOVE_LEFT:
	cpi r17,$01 ; if col is in left boarder
	breq JUMP_DOWN
	lsl r17 ; move left
	cpi r16,$00 ; row in lower boarder
	breq JUMP_UP
	rjmp JUMP_DOWN

MOVE_RIGHT:
	cpi r17,$40 ; if col is in the right corner
	breq JUMP_DOWN
	lsr r17 ; move right
	cpi r16,$00 ; row in lower boarder
	breq JUMP_UP

JUMP_DOWN:
	cpi r16,$00 ; row in lower boarder
	breq JUMP_UP
	dec r16
WAIT_RELEASE:
	sbic PIND,0 ; left button
	rjmp WAIT_RELEASE
	sbic PIND,1 ; right button
	rjmp WAIT_RELEASE
	rjmp MAIN

INIT_IO:
	clr r16
	out DDRD,r16 ; in : D0 = left button , D1 = right button

	ldi r16,$FF
	out DDRA, r16; out : A0 to A2 connects to A,B,C respective on 5x7 Display (row)
	out DDRB,r16 ; out : A0 to A6 connects to 1 to 7 in 5x7 Display (col)

	ldi r16,$00
	ldi r17,$01

	ret
