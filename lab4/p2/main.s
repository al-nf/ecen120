;******************** (C) Alan Fung ********************************************
; @file    main.s
; @author  Alan Fung
; @date    October 22, 2025
; @note
;*******************************************************************************

			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC
		mov r0, #9
		bl 	fib
endless	b endless
		ENDP


fib		PROC
		push {r4, r5, lr}
		cmp r0, #1
		ble fib_b
		
		mov r4, r0
		
		
		; F(n-1)
		sub r0, r4, #1
		bl fib
		mov r5, r0
		
		; F(n-2)
		sub r0, r4, #2 
		bl fib
		add r0, r5
		
fib_b   pop {r4, r5, lr}
		bx lr
		

		ENDP
								
	ALIGN			


	END
