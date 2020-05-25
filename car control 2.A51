JNB P3.4,BUZZER
		SJMP START
BUZZER:  CLR P1.5
		LCALL DELAY1
		SETB P1.5
		JNB P3.4,BUZZER
		SJMP START
	 
	 
INT00:	JNB P3.4,RETURN
		SETB P3.7
		CLR P1.0
		MOV P0,#11111110B
		JNB P3.2,INT00
RETURN:	RETI

	
INT01:SETB P1.5
	SETB P3.6
	CLR P1.0
	MOV P0,#11110111B
	JNB P3.3,INT01
	RETI
	
DELAY1: 	MOV R6,#10D			; R7 save data 100 in decimal
back1:	MOV TMOD, #10H		; 16-bit timer 0 mode selected
		MOV TH1, #0D8H		; high byte set to D8 in hexa
		MOV TL1, #0F0H		; low byte set to F0 in hexa
		SETB TR1			; set timer 0 to ON
L11: 	JNB TF1,L11	; stay until overflow flag timer 0 is 1
		CLR TR1			; set timer 0 run-control bit to 0
		CLR TF1			; set overflow flag timer 0 to 0
		DJNZ R6, back1		; R7 will decrement by 1 and go back to 'back' if R7 not 0
		RET					; return from subroutine

END