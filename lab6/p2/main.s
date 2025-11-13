;******************** (C) Alan Fung ********************************************
; @file    main.s
; @author  Alan Fung
; @date    November 12, 2025
; @note
;*******************************************************************************



	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s 
	INCLUDE	rgb60_redact.h
	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC
		bl		spisw_init
		
		ldr		r0, =0x0
		bl		spi32
		
		mov 	r4, #60
loop	ldr		r0, =0xE70000FF
		bl		spi32
		subs	r4, #1
		bne		loop
	
		ldr		r0, =0x0
		bl 		spi32
endless	b		endless		
		ENDP			
	END
