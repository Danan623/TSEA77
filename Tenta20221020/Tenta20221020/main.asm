;
;Uses HEXA-Keyboard (keys 0 to F) the numbers 0 to 7 and LED lamps 0 to 7. If a number is pressed on the Keyboard, the corresponding lamp should light up and remain lit.
;for example. press 0,3,4,6 and these LED lights should light up. If a number is pressed again (of the lights that are already on), the corresponding one must go out while the others remain on.  

COLD:
	ldi r16,HIGH(RAMEND)
	out SPH,r16
	ldi r16,LOW(RAMEND)
	out SPL,r16

	call INIT_IO
	
MAIN:
	out PORTB,r16
	mov r18,r16 ; copy current output
	sbic PIND,0 ; key pressed
	jmp CHECK_OUTPUT
	jmp MAIN

CHECK_OUTPUT:
	in r19,PINA ; read input
	ldi r17,$01 ; "check value" register : checks position
	jmp MOVE_LED

CHANGE_OUTPUT:
	and r18,r17 ; if result = r17 -> invert bits
	cp r18,r17
	breq TOGGLE
	add r16,r17
	jmp WAIT_RELEASE

MOVE_LED:
	cpi r19,0 ; count down to zero : ex input = 7 => 7,6,5,..,0 
	breq CHANGE_OUTPUT
	dec r19
	lsl r17
	jmp MOVE_LED

WAIT_RELEASE:
	sbic PIND,0
	jmp WAIT_RELEASE
	jmp MAIN
TOGGLE:
	sub r16,r17
	jmp WAIT_RELEASE

INIT_IO:
	ldi r16,$FF
	out DDRB,r16 ; out : B0 to B7 connect to LED pin(s)
	clr r16
	out DDRA,r16 ; in : A0 to A2 connect to Hexa pin(s)
	out DDRD,r16; D0 = strobe

	
	ret
