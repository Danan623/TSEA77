
; 1. Write a program that reads a value from an input port and displays it on a set of 4 LED lamps.
; Hardware : Hexa keyboard and LED
; RULE: The program should continuously read the input value and update the LED lamps to match the value.

COLD:
    ldi r16,HIGH(RAMEND) ; set stackpointers
	out SPH,r16
	ldi r16,LOW(RAMEND)
	out SPL,r16

	clr r16 ; clear the register so the LED(s) start turned off

	call INIT_IO
	
MAIN:
	out PORTB, r16 ; show the current LED setting
	sbic PIND,0 ; scip next command if the button is not pressed
	rjmp CHANGE_VALUE
	rjmp MAIN

CHANGE_VALUE:
	in r16, PINA ; save the value from input pin to a register. In this case the same register we use for output in MAIN

WAIT_RELEASE:
	sbic PIND,0 ; wait for button release
	rjmp WAIT_RELEASE
	rjmp MAIN

INIT_IO: 
	clr r17
	out DDRA, r17 ; in : A0 to A3 connect to 3,5,7,9 on Hexa
	out DDRD, r17 ; in : D0 = strobe (Hexa keyboard)
	
	ldi r18,$FF 
	out DDRB, r18 ; out : B0 to B3 connect to pin 0 to pin 3 on LED 

	ret
