;******************** (C) Alan Fung ********************************************
; @file    main.s
; @author  Alan Fung
; @date    October 15, 2025
; @note
;*******************************************************************************

	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s   
	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC
	
		ldr r0, =(RCC_BASE+RCC_AHB2ENR) ; load ahb2 enable register
		ldr r1, [r0]
		orr r1, r1, #0x2	; set bit 1
		str r1, [r0]
		
		ldr r0, =(GPIOB_BASE+GPIO_MODER) ; load gpiob mode register
		ldr r1, [r0]
		orr r1, r1, #0x10	; set bit 4
		bic r1, r1, #0x20	; clear bit 5
		str r1, [r0]
		
		ldr r0, =(GPIOB_BASE+GPIO_ODR) ; load gpiob output data register
		ldr r1, [r0]
		orr r1, r1, #0x4	; set bit 2
		str r1, [r0]
endless b	endless


		ENDP
			ALIGN					
			AREA    myData, DATA, READWRITE
			ALIGN			


	END
