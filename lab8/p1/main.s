;******************** (C) Alan Fung, Gavin Morris ******************************
; @file    main.s
; @author  Alan Fung, Gavin Morris
; @date    December 3, 2025
; @note
;*******************************************************************************



	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s   

	INCLUDE lcd.h



	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC
		bl		lcd_init
endless	bl		lcd_clear
		
		mov		r4, #1
		ldr		r5, =word1
loop	ldrb	r0, [r5]
		add		r5, #1
		bl		let2font
		mov		r1, r4
		bl		lcd_draw
		add		r4, #1
		cmp		r4, #6
		bne		loop

		ldr		r0, =1250000
delay	subs	r0, #1
		bne		delay
		
		bl		lcd_clear
		
		mov		r4, #2
		ldr		r5, =word2
loop2	ldrb	r0, [r5]
		add		r5, #1
		bl		let2font
		mov		r1, r4
		bl		lcd_draw
		add		r4, #1
		cmp		r4, #7
		bne		loop2

		ldr		r0, =1250000
delay2	subs	r0, #1
		bne		delay2
			
		b		endless		
		ENDP
			

			
			ALIGN						
			AREA    myData, DATA, READWRITE
			
			ALIGN			
word1		dcb		'S','A','N','T','A'
word2		dcb		'C','L','A','R','A'

	END
