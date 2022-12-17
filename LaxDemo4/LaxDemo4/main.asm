;
; LaxDemo4.asm
;
; Hardware : Hexa keyboard and 7 -segment Display
; Create a program that displays values from respective Hexa-key on the keyboard on the 7-segment display.
; Rules : only the values 0 to 9 should be displayed. Only one display on the 7 - segment should show the current value.
; If key F is pressed then toggle to the other display and show current value.

COLD:
	ldi r16,HIGH(RAMEND)
	out SPH,r16
	ldi r16,LOW(RAMEND)
	out SPL,r16

	call INIT_IO
MAIN:
	sbic PIND,4 ; check if key pressed
	rjmp READ_DATA
	rjmp MAIN

READ_DATA:
	in r22,PIND ; read input data
	andi r22,$0F

	cpi r20,$00 ; right flag
	breq RIGHT_DISPLAY
	cpi r20,$01 ; left flag
	breq LEFT_DISPLAY

RIGHT_DISPLAY:
	cpi r22,$0F ; check if F is pressed
	breq TOGGLE_LEFT
	
	call CHECK_TEN

	cpi r20,$01 ; left flag
	breq SHOW_LEFT
	cpi r20,$00 ; right flag
	breq SHOW_RIGHT 	
	
CHECK_TEN: ; check if input > 9

	mov r21,r22 ; copy input data
	com r21 ; invert the bits
	andi r21,$0F ; clear high bits 
	subi r21,$06 ; if it's A or more it will set the N flag (negative)
	brmi WAIT_RELEASE ; if negative = true
	mov r16,r22 ; else copy the input to output register (0 to 9 is valid values)

	ret

LEFT_DISPLAY:
	cpi r22,$0F ; check if F is pressed
	breq TOGGLE_RIGHT

	call CHECK_TEN

	cpi r20,$01 ; left flag
	breq SHOW_LEFT
	cpi r20,$00 ; right flag
	breq SHOW_RIGHT 	

TOGGLE_RIGHT: ; change flag and toggle output
	dec r20
	rjmp SHOW_RIGHT

TOGGLE_LEFT: ; change flag and toggle output
	inc r20

SHOW_LEFT:
	clr r22
	out PORTA,r22 ; show zero
	out PORTB,r16 ; show input to left display

	rjmp WAIT_RELEASE

SHOW_RIGHT:
	clr r22
	out PORTB,r22 ; show zero
	out PORTA,r16 ; show input to right display
	
WAIT_RELEASE:
	sbic PIND,4
	rjmp WAIT_RELEASE
	rjmp MAIN

INIT_IO:
	clr r17
	out DDRD,r17 ; in : D4 = strobe, D0 to D3 connect to pin 3,5,7,9 on Hexa 
	
	ldi r18, $FF
	out DDRA, r18 ; out : A0 to A3 connect to A to D on right display
	out DDRB,r18 ; in : B0 to B3 connect to A to D on left display
	
	clr r16 ; Start in 0
	ldi r20, $01 ; init current display

	ret
