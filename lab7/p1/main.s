;******************** (C) Alan Fung ********************************************
; @file    main.s
; @author  Alan Fung
; @date    November 19, 2025
; @note
;*******************************************************************************



	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s   

	INCLUDE leds.h

	INCLUDE	adc.h

	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC	
		ldr		r0, =RCC_AHB2ENR_GPIOBEN	
		bl		portclock_en
		
		ldr		r0,=GPIOB_BASE
		ldr		r1,=GPIO_MODER_MODER2_0
		bl		port_bit_pushpull
		
		bl		adc_init
		
endless	bl		adc_read
		cmp		r0, #2048
		blt		led_off
		bl		red_on
		b		endless
led_off	bl		red_off
		b 		endless
			
		ENDP
			
			ALIGN						
			AREA    myData, DATA, READWRITE
			
			ALIGN			


	END
