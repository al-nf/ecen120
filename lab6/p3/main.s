;******************** (C) Alan Fung, Gavin Morris ******************************
; @file    main.s
; @author  Alan Fung, Gavin Morris
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
		ldr		r5, =colors
		ldr		r6, =eoc
loop	ldr		r0, [r5]
		bl		spi32
		
		add		r5, #4
		cmp		r5, r6
		bne		skip
		ldr		r5, =colors

skip	subs	r4, #1
		bne		loop
	
		ldr		r0, =0x0
		bl 		spi32
endless	b		endless		
		ENDP			
		
		ALIGN
		AREA mydata, DATA, READONLY
colors		DCD		0xE70000FF, 0xE7FF0000, 0xE700FF00, 0xE8FFFFFF
eoc

	END
