ORG 0000H
SJMP START
ORG 0003H
SJMP INT00
ORG 0013H
SJMP INT01


ORG 0030h 
START: 	MOV IE, #85h       ;enable global and external interrupts 
		SETB IT0       ;negative-edge triggered AT TCON
		SETB IT1 
		MOV DPTR,#1000H
		MOV R1,#2D

		MOV P2,#00000000D
		SJMP START
		
INT00:	CLR P1.3
		MOV R1,#5D
		CLR P1.3				;2nd 7-segment turn ON
		MOV A,R1    			;Acc now is R4
		MOVC A,@A+DPTR    		;Acc is point at address depend on R5 at origin 1000H
		MOV P0,A 				;Acc value transfer to 7-segment
		MOV P2,#00000001D
		LCALL DELAY	
		
		
		DEC R1
		MOV A,R1    			;Acc now is R4
		MOVC A,@A+DPTR    		;Acc is point at address depend on R5 at origin 1000H
		MOV P0,A 				;Acc value transfer to 7-segment
		MOV P2,#00000001D
		LCALL DELAY
		
		DEC R1
		MOV A,R1    			;Acc now is R4
		MOVC A,@A+DPTR    		;Acc is point at address depend on R5 at origin 1000H
		MOV P0,A 				;Acc value transfer to 7-segment
		MOV P2,#00000001D
		LCALL DELAY
		
		DEC R1
		MOV A,R1    			;Acc now is R4
		MOVC A,@A+DPTR    		;Acc is point at address depend on R5 at origin 1000H
		MOV P0,A 				;Acc value transfer to 7-segment
		MOV P2,#00000001D
		LCALL DELAY
		
		DEC R1
		MOV A,R1    			;Acc now is R4
		MOVC A,@A+DPTR    		;Acc is point at address depend on R5 at origin 1000H
		MOV P0,A 				;Acc value transfer to 7-segment
		MOV P2,#00000001D
		LCALL DELAY
		
		DEC R1
		MOV A,R1    			;Acc now is R4
		MOVC A,@A+DPTR    		;Acc is point at address depend on R5 at origin 1000H
		MOV P0,A 				;Acc value transfer to 7-segment
		RETI

INT01: 	MOV P2,#00000001D
		LCALL DELAY1
		MOV P2,#00000000D
		LCALL DELAY1
		DJNZ R1,INT01
		RETI

DELAY: 	MOV R7,#100D			;2.5S
back:	MOV TMOD, #01H		
		MOV TH0, #0D8H		
		MOV TL0, #0F0H		
		SETB TCON.4			
L1: 	JNB TCON.5,L1		
		CLR TCON.4			
		CLR TCON.5			
		DJNZ R7, back		
		RET	
		
DELAY1: 	MOV R6,#5D		;50MS	
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