;******************** (C) Alan Fung, Gavin Morris ******************************
; @file    main.s
; @author  Alan Fung, Gavin Morris
; @date    November 5, 2025
; @note
;*******************************************************************************

	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s   
	INCLUDE timer.h
	INCLUDE leds.h
	
	

	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC
		ldr		r0,=RCC_AHB2ENR_GPIOBEN	
		bl		portclock_en				; enable port B clock


		ldr		r0,=GPIOB_BASE
		ldr		r1,=GPIO_MODER_MODER2_0
		bl		port_bit_pushpull			;set port b.2 to push pull
		
		bl		tim2_init			;initialize exti3 interrupt
		
	
		

endless	b		endless		
		ENDP
			
			
TIM2_IRQHandler PROC
		EXPORT	TIM2_IRQHandler
		push	{lr}
		bl		red_tog
		pop		{lr}
		ldr		r2,=(TIM2_BASE+TIM_SR)	;reset pending interrupt for TIM2		
		mov		r1,#~TIM_SR_UIF
		str		r1,[r2]
		dsb
		bx		lr
		ENDP
			
			
			
			
			ALIGN						
			AREA    myData, DATA, READWRITE
			
			ALIGN			
	

	END
