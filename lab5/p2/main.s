;******************** (C) Alan Fung ********************************************
; @file    main.s
; @author  Alan Fung
; @date    November 5, 2025
; @note
;*******************************************************************************



	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s   
	INCLUDE jstick.h
	INCLUDE leds.h
	
	

	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC
		ldr		r0,=RCC_AHB2ENR_GPIOBEN	
		bl		portclock_en				; enable port B clock
		
		ldr		r0,=RCC_AHB2ENR_GPIOEEN	
		bl		portclock_en				; enable port E clock

		ldr		r0,=GPIOB_BASE
		ldr		r1,=GPIO_MODER_MODER2_0
		bl		port_bit_pushpull			;set port b.2 to push pull
		
		ldr		r0,=GPIOE_BASE
		ldr		r1,=GPIO_MODER_MODER8_0
		bl		port_bit_pushpull			;set port e.8 to push pull
		
		bl		porta_init			;initialize port A for this program
		bl		exti5_init			;initialize exti0 interrupt
		bl		exti3_init			;initialize exti3 interrupt
		

endless	b		endless		
		ENDP
			
			
EXTI9_5_IRQHandler PROC
		EXPORT	EXTI9_5_IRQHandler	
		ldr		r2,=(EXTI_BASE+EXTI_PR1)
		ldr		r1,[r2]
		and		r1,	#0x20
		cmp 	r1, #0x20
		bne 	skip
		
		push	{lr}
		bl		green_tog
		pop		x`{lr}
		
		ldr		r2,=(EXTI_BASE+EXTI_PR1)	;reset pending interrupt for EXTI5		
		mov		r1,#EXTI_PR1_PIF5
		str		r1,[r2]
		dsb
skip	bx		lr
		ENDP

EXTI3_IRQHandler PROC
		EXPORT	EXTI3_IRQHandler
		push	{lr}
		bl		red_tog
		pop		{lr}
		ldr		r2,=(EXTI_BASE+EXTI_PR1)	;reset pending interrupt for EXTI3		
		mov		r1,#EXTI_PR1_PIF3
		str		r1,[r2]
		dsb
		bx		lr
		ENDP
			
			
			
			
			ALIGN						
			AREA    myData, DATA, READWRITE
			
			ALIGN			
	

	END
