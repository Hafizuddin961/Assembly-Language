		ORG 00H 
		SJMP START
		ORG 0003H
		LJMP INT00


		 
		ORG 0030h 
START: 	MOV IE, #81h       ;enable global and external interrupts 
		CLR IT0       ;negative-edge triggered  
		MOV DPTR,#1000H
		MOV R5,#00H
		MOV R4,#00H

MAIN:	SETB P1.1   			;2nd 7-segment turn OFF
		CLR P1.2				;3rd 7-segment turn ON
		MOV A,R4   				;Acc now is R4
		MOVC A,@A+DPTR   		;Acc is point at address depend on R4 at origin 1000H
		MOV P0,A    			;Acc value transfer to 7-segment
		LCALL DELAY   
		
		SETB P1.2    			;3rd 7-segment turn OFF	
		CLR P1.1				;2nd 7-segment turn ON
		MOV A,R5    			;Acc now is R4
		MOVC A,@A+DPTR    		;Acc is point at address depend on R5 at origin 1000H
		MOV P0,A 				;Acc value transfer to 7-segment
		LCALL DELAY 
		SETB P1.1
		
		SJMP START
		
INT00:	MOV R5,#00000000B 
		MOV R4,#00000000B   
		MOV R6,#11111111B

DISP:   MOV R3,#00001010B 
								

NOM:   	JNB P3.3,NOM
		MOV P2,#0FFH
		SETB P1.1   			;2nd 7-segment turn OFF
		CLR P1.2				;3rd 7-segment turn ON
		MOV A,R4   				;Acc now is R4
		MOVC A,@A+DPTR   		;Acc is point at address depend on R4 at origin 1000H
		MOV P0,A    			;Acc value transfer to 7-segment
		LCALL DELAY   
		
		SETB P1.2    			;3rd 7-segment turn OFF	
		CLR P1.1				;2nd 7-segment turn ON
		MOV A,R5    			;Acc now is R4
		MOVC A,@A+DPTR    		;Acc is point at address depend on R5 at origin 1000H
		MOV P0,A 				;Acc value transfer to 7-segment
		LCALL DELAY
		SETB P1.1
		
		JNB P3.2,RETURN
		JNB P3.3,STOP
		  
		DJNZ R6,NOM  			;jump to NOM if R6 not 0 while decrease R6 by 1
		MOV R6,#11111111B      	;set back R6 to 11111111B 
		
		JNB P3.2,RETURN
		JNB P3.3,STOP

		INC R4    
		DJNZ R3, NOM      		;jump to NOM if R3 not 0 while decrease R3 by 1		
		INC R5      
		MOV R4,#00000000B   	;set back R4 00000000B
		
		JNB P3.2,RETURN
		JNB P3.3,STOP
		   
		CJNE R5,#00000110B,DISP 	;compare with R5 and jump to DISP if not equal
		
RETURN:	RETI

		
STOP: 	MOV P2,#00H
		JNB P3.3,STOP
BUZZER:	CLR P1.5
		LCALL DELAY1
		SETB P1.5
STOP1:	SETB P1.1   			;2nd 7-segment turn OFF
		CLR P1.2				;3rd 7-segment turn ON
		MOV A,R4   				;Acc now is R4
		MOVC A,@A+DPTR   		;Acc is point at address depend on R4 at origin 1000H
		MOV P0,A    			;Acc value transfer to 7-segment
		LCALL DELAY   
		
		SETB P1.2    			;3rd 7-segment turn OFF	
		CLR P1.1				;2nd 7-segment turn ON
		MOV A,R5    			;Acc now is R4
		MOVC A,@A+DPTR    		;Acc is point at address depend on R5 at origin 1000H
		MOV P0,A 				;Acc value transfer to 7-segment
		LCALL DELAY
		JB P3.3,STOP1
		SJMP NOM
		
	

DELAY: 	MOV R7,#1D			; R7 save data 1 in decimal
back:	MOV TMOD, #01H		; 16-bit timer 0 mode selected
		MOV TH0, #0FCH		; high byte set to D8 in hexa
		MOV TL0, #018H		; low byte set to F0 in hexa
		SETB TCON.4			; set timer 0 to ON
L1: 	JNB TCON.5,L1		; stay until overflow flag timer 0 is 1
		CLR TCON.4			; set timer 0 run-control bit to 0
		CLR TCON.5			; set overflow flag timer 0 to 0
		DJNZ R7, back		; R7 will decrement by 1 and go back to 'back' if R7 not 0
		RET					; return from subroutine
		
		
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