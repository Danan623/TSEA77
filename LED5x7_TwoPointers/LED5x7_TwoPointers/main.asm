

;	Move a LED lamp in a 5x7 LED matrix (5 rows x 7 coloumns)
; 
;	If a LED lamp is located in a 5x7 LED matrix, and it is currently in the rightmost position (column 7), 
;	moving one step to the right (column 8) will cause the LED to start at the leftmost position (column 1) and move down one row (row y-1). 
;	The opposite will happen if the LED is in the leftmost position (column 1) and you try to move it left (column 0)
;	in this case, the LED will start at column 7 and move up one row (row y+1).

;	If the LED is in the upper or lower corner and you move one step up or down,
;	respectively, the LED will jump to the right edge of the row at the bottom or top, respectively.
;	this will use a 5x7 LED matrix, two switch buttons and a Dalia card developed at Linköping University
;

COLD:

	ldi r16,HIGH(RAMEND) ; set stackpointers
	out SPH,r16
	ldi r16,LOW(RAMEND)
	out SPL,r16

	ldi XL,LOW($100) ; row start address $0100 (SRAM)
	ldi XH,HIGH($100)
	ldi YL,LOW($107) ; col start address $0107 (SRAM)
	ldi YL,HIGH($107)
	ldi r16,$01

	call INIT_SRAM	; call subrutines
	call INIT_IO	

MAIN:

	ld r16,X
	out PORTB,r16
	ld r16,Y
	out PORTA,r16

	sbic PIND,0 ;	wait for left button pressed
	rjmp READ_POSITION:
	sbic PIND,1 ;	wait for right button pressed
	rjmp READ_POSITION:
	rjmp MAIN

READ_POSITION:
	
	sbic PIND,0 ; step left if set
	rjmp CHECK_POSITION
	sbic PIND,1 ; step right if set
	rjmp CHECK_POSITION


CHECK_POSITION:
	
	cpi r16,$07 ; right most col
	sbic PIND,1 ; scip over if cleared ---------- kan fungera men måste testa på hårdvara
	breq MOVE_DOWN ; row + 1
	cpi r16,$01 ; left most col
	sbic PIND,0 ; scip over if cleared ---------- kan fungera men måste testa på hårdvara
	breq MOVE_UP; row - 1
	

MOVE_LEFT: ; ------------------------------fixa left
	
	jmp WAIT_RELEASE_L

MOVE_RIGHT: ; ------------------------------fixa right

	jmp WAIT_RELEASE_R
MOVE_UP:

MOVE_DOWN:

WAIT_RELEASE_L:

	sbic PIND,0
	jmp WAIT_RELEASE_L
	jmp MAIN

WAIT_RELEASE_R:

	sbic PIND,1
	jmp WAIT_RELEASE_R
	jmp MAIN

INIT_SRAM:

	st X+,r16
	cpi r16,$40
	breq CLEARREG
	lsl r16
	jmp INIT_SRAM

CLEARREG:

	clr r16 
	
SET_YPOINTER:

	st Y+,r16
	cpi r16,4
	breq CLEARPOINTER
	inc r16
	jmp SET_YPOINTER

CLEARPOINTER:

	clr 16
	clr XL; set to start adress - the led in the lower left corner - x0
	clr YL; ; set to start adress - the led in the lower left corner -y0
	ret

INIT_IO:

	ldi r17,$FF
	out DDRA,r16 ;	out : A0 -> A2 on Dalia. msb (A0) connects to msb at 5x7 matrix (A).. A1 -> B, A2 -> C. A,B,C = rows 0 -> 5 (binary)
	out DDRB,r16 ;	out : B1 -> B7 on Dalia -> 1 - 7 on 5x7 matrix
	
	clr r18
	out DDRD,r16 ; in:  D0 = button left and D1 = button right

	ret
