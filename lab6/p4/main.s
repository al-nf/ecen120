;******************** (C) Alan Fung ********************************************
; @file    main.s
; @author  Alan Fung
; @date    November 12, 2025
; @note
;*******************************************************************************


	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s 
	INCLUDE	rgb60_redact.h
	INCLUDE jstick.h
	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC		
		bl		porta_init			;initialize port A
		bl		exti3_init			;initialize exti3 interrupt
		bl		exti5_init			;initialize exti5 interrupt
		bl		spisw_init
		
		mov		r8, #30
loop	mov		r4, #60
		ldr		r0, =0x0
		bl		spi32
loop2	cmp		r4, r8
		beq		red
		ldr		r0, =0xE99042f5
		bl		spi32
		b		out
		
red		ldr		r0, =0xE9FF0000
		bl		spi32
		b		out

out		sub		r4, #1
		cmp		r4, #0
		bne		loop2
		b		loop
		
		ENDP
			
EXTI9_5_IRQHandler PROC
		EXPORT	EXTI9_5_IRQHandler	
		ldr		r2,=(EXTI_BASE+EXTI_PR1)
		ldr		r1,[r2]
		and		r1,	#0x20
		cmp 	r1, #0x20
		bne 	skip_9_5
		
		sub		r8, #1
		cmp		r8, #-1
		bne		skip
		mov		r8, #60
		
skip	ldr		r2,=(EXTI_BASE+EXTI_PR1)	;reset pending interrupt for EXTI5		
		mov		r1,#EXTI_PR1_PIF5
		str		r1,[r2]
		dsb
skip_9_5	
		bx		lr
		ENDP

EXTI3_IRQHandler PROC
		EXPORT	EXTI3_IRQHandler
		
		add		r8, #1
		cmp		r8, #61
		bne		skip3
		mov 	r8, #0
		
skip3	ldr		r2,=(EXTI_BASE+EXTI_PR1)	;reset pending interrupt for EXTI3		
		mov		r1,#EXTI_PR1_PIF3
		str		r1,[r2]
		dsb
		bx		lr
		ENDP
		
	END