
; 1. Write a program that reads a value from an input port and displays it on a set of 8 LED lamps. 
; The program should continuously read the input value and update the LED lamps to match the value.
; This program is uses a Hexa Keyboard but the code is easy to change to another input hardware.
; This hardware use a Dalia card that is developed at Linköping University

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
	in r16, PINA ; save the value from input pin to a register. In this case the register we use for output in MAIN

WAIT_RELEASE:
	sbic PIND,0 ; wait for button release
	rjmp WAIT_RELEASE
	rjmp MAIN

INIT_IO: 
	clr r17
	out DDRA, r17 ; port-in : A0 -> A7
	out DDRD, r17 ; port-in : D0 if we use a HEXA keyboard (the strobe to indicate button pressed needs a port -in)
	
	ldi r18,$FF 
	out DDRB, r18 ; port-out : B0 -> B7 

	ret
