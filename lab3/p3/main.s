;******************** (C) Alan Fung, Gavin Morris ******************************
; @file    main.s
; @author  Alan Fung, Gavin Morris
; @date    October 15, 2025
; @note
;*******************************************************************************

	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s   
	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC
	
		; ENABLE CLOCKS
		ldr r0, =(RCC_BASE+RCC_AHB2ENR) ; load ahb2 enable register
		ldr r1, [r0]
		orr r1, r1, #0x12	; set bits 1 and 4
		str r1, [r0]
		
		; ENABLE GP OUTPUT MODE
		ldr r0, =(GPIOB_BASE+GPIO_MODER) ; load gpiob mode register
		ldr r1, [r0]
		orr r1, r1, #0x10	; set bit 4
		bic r1, r1, #0x20	; clear bit 5
		str r1, [r0]
		ldr r0, =(GPIOE_BASE+GPIO_MODER) ; load gpioe mode register
		ldr r1, [r0]
		orr r1, r1, #0x10000	; set bit 16
		bic r1, r1, #0x20000	; clear bit 17
		str r1, [r0]
		
		; TURN ON LEDS
endless	ldr r0, =(GPIOB_BASE+GPIO_ODR) ; load gpiob output data register
		ldr r1, [r0]
		orr r1, r1, #0x4	; set bit 2
		str r1, [r0]
		
		ldr r0, =(GPIOE_BASE+GPIO_ODR) ; load gpioe output data register
		ldr r1, [r0]
		bic r1, r1, #0x100	; set bit 8
		str r1, [r0]
		
		; WAIT 1 SECOND
		ldr r0, =1250000
loop	subs r0, #1
		bne loop
		
		ldr r0, =(GPIOB_BASE+GPIO_ODR) ; load gpiob output data register
		ldr r1, [r0]
		bic r1, r1, #0x4	; set bit 2
		str r1, [r0]
		ldr r0, =(GPIOE_BASE+GPIO_ODR) ; load gpioe output data register
		ldr r1, [r0]
		orr r1, r1, #0x100	; set bit 8
		str r1, [r0]
		
		; WAIT 1 SECOND
		ldr r0, =1250000
loopy	subs r0, #1
		bne loopy
		
		b	endless


		ENDP
			ALIGN					
			AREA    myData, DATA, READWRITE
			ALIGN			


	END
