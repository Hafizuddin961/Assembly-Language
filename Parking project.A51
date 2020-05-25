		ORG 0000H
		LJMP START
		ORG 0003H
		LJMP INT00
		ORG 0013H
		LJMP INT01

		 
		ORG 0030h 
START: 	MOV IE, #85h       ;enable global and external interrupts 
		SETB IT0       ;negative-edge triggered  
		SETB IT1 
		MOV DPTR,#1000H
		MOV R0,#01D
		MOV R1,#01D
	
DISP:	SETB P1.1   			;2nd 7-segment turn OFF
		CLR P1.2				;3rd 7-segment turn ON
		MOV A,R0   				;Acc now is R4
		MOVC A,@A+DPTR   		;Acc is point at address depend on R4 at origin 1000H
		MOV P0,A    			;Acc value transfer to 7-segment
		LCALL DELAY   
		
		
		SETB P1.2    			;3rd 7-segment turn OFF	
		CLR P1.1				;2nd 7-segment turn ON
		MOV A,R1    			;Acc now is R4
		MOVC A,@A+DPTR    		;Acc is point at address depend on R5 at origin 1000H
		MOV P0,A 				;Acc value transfer to 7-segment
		LCALL DELAY
		
		CJNE R1,#03D,DISP		;if not exceed 20 jump back DISP
		SJMP FULL				;if exceed 20 jump to full
		
FULL:	MOV R0,#01D				;full parking condition
		MOV R1,#03D
		MOV P2,#00H
		LJMP DISP
		
INT00:	CJNE R1,#03D,INCRE		;car enter parking
		SJMP BUZZER				;buzzer ON if car still want to enter while parking full
INCRE:	INC R0					;increase 1 parking
		CJNE R0,#11D,RETURN		;if less than 9 or 19 
		INC R1					;if more than 9 or 19 increase 2nd digit
		MOV R0,#01D
		CJNE R1,#03D,RETURN			
BUZZER:	SETB P1.1
		SETB P1.2
		CLR P1.5
		LCALL DELAY1
		SETB P1.5
RETURN:	RETI

INT01: 	MOV P2,#0FFH			;car leave parking
		DEC R0
		CJNE R0,#00D,RETURN1
		DEC R1
		MOV R0,#10D
		CJNE R1,#00D,RETURN1
		MOV R1,#01D
		MOV R0,#01D
RETURN1:RETI
		


DELAY: 	MOV R7,#1D			
back:	MOV TMOD, #01H		
		MOV TH0, #0D8H		
		MOV TL0, #0F0H		
		SETB TCON.4			
L1: 	JNB TCON.5,L1		
		CLR TCON.4			
		CLR TCON.5			
		DJNZ R7, back		
		RET					

DELAY1: 	MOV R6,#10D			
back1:	MOV TMOD, #10H		
		MOV TH1, #0D8H		
		MOV TL1, #0F0H		
		SETB TR1			
L11: 	JNB TF1,L11	
		CLR TR1			
		CLR TF1			
		DJNZ R6, back1		
		RET					
		
		ORG 1000H   
		DB 11000000B  		;display '0'
		DB 11000000B  		;display '0' 
		DB 11111001B   		;display '1'
		DB 10100100B   		;display '2'
		DB 10110000B    	;display '3'
		DB 10011001B    	;display '4'
		DB 10010010B    	;display '5'
		DB 10000010B    	;display '6'
		DB 11111000B    	;display '7'
		DB 10000000B    	;display '8'
		DB 10010000B    	;display '9'
		END	
