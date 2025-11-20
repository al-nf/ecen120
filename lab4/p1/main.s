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
		ldr r4, =nums
		ldr r5, =eom
		mov r3, #0
		
loop	ldr r6, [r4]
		push {r6}
		add r4, r4, #4
		cmp r4, r5
		bne loop
		
		bl sum

		add sp, sp, #40
		
endless b	endless
		ENDP
			
sum		PROC
		mov r0, #0
		mov r2, sp
		
s_loop	pop {r1}
		add r0, r0, r1
		add r3, r3, #1
		cmp r3, #10
		bne s_loop
		
		mov sp, r2
		bx lr
		ENDP
								
	ALIGN			

nums	DCD	1,2,3,4,5,6,7,8,9,10
eom

	END
