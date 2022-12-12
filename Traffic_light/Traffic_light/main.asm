; 2. Write a program that implements a simple traffic light controller.
; The program should have three LED lamps that represent the red, yellow, and green lights of a traffic light. 
; The program should cycle through the three colors according to the standard traffic light sequence (red, red+yellow, green, yellow, red, etc.).

; I will use the hardware available at the University (all LED lamps are red) but this can be simulated in a lot of ways
; I will use two "switch" buttons in this problem.
; Left button will make the traffic light go from green -> yellow -> red (or right most LED -> middle -> left)
; And the right button will go from red -> red + yellow -> green

COLD:
    ldi r16,HIGH(RAMEND) ; set stackpointers
	out SPH,r16
	ldi r16,LOW(RAMEND)
	out SPL,r16

	ldi r16,$01 ; set the start setting to be "green", the right most LED

	call INIT_IO
	
MAIN:
	out PORTB, r16 ; show the current LED setting
	sbic PIND,0 ; scip next command if the button is not pressed (left button)
	rjmp MOVE_LEFT
	sbic PIND,1 ; scip next command if the button is not pressed (right button)
	rjmp MOVE_RIGHT
	rjmp MAIN

MOVE_LEFT:
	cpi r16,$04 ; the we are at the red lamp and can't go more left. sets Z-flag if true
	breq WAIT_RELEASE
	cpi r16,$06 ; if we don't want the traffic light to shift from red + yellow -> red
	breq WAIT_RELEASE
	lsl r16 ; else move to left
	rjmp WAIT_RELEASE

MOVE_RIGHT:
	cpi r16,$01 ; then we are at the right most position (green LED)
	breq WAIT_RELEASE
	cpi r16,$02 ; we don't want the traffic light to go from yellow -> green. but just red + yellow -> green
	breq WAIT_RELEASE
	cpi r16,$04 ; red light
	breq RED_YELLOW
	ldi r16,$01 ; else change to green

WAIT_RELEASE:
	sbic PIND,0 ; wait for button release left
	rjmp WAIT_RELEASE
	sbic PIND,1 ; wait for button release right
	rjmp WAIT_RELEASE
	rjmp MAIN

RED_YELLOW:
	ldi r16,$06
	rjmp WAIT_RELEASE

INIT_IO: 
	clr r17
	out DDRD, r17 ; port-in : D0 = left button, D1 = right button
	
	ldi r18,$FF 
	out DDRB, r18 ; port-out : B0 -> B2 (green -> yellow -> red)

	ret