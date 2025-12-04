;******************** (C) Alan Fung, Gavin Morris ******************************
; @file    main.s
; @author  Alan Fung, Gavin Morris
; @date    December 3, 2025
; @note
;*******************************************************************************



	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s   
	INCLUDE jstick.h
	INCLUDE timer.h
	INCLUDE lcd.h



	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC
		bl		tim2_init
		bl		porta_init
		bl		exti0_init
		bl		exti1_init
		bl		lcd_init
		mov		r4, #0 ; stop if 1
		mov		r5, #0 ; hundredths
		mov		r6, #0 ; seconds
		mov		r7, #0 ; minutes
		
		
endless b		endless		
		ENDP

EXTI0_IRQHandler PROC
		EXPORT	EXTI0_IRQHandler
		
		mvn		r4, r4
		and		r4, #1
		
		ldr		r2,=(EXTI_BASE+EXTI_PR1)	;reset pending interrupt for EXTI0		
		mov		r1,#EXTI_PR1_PIF0
		str		r1,[r2]
		dsb
		bx		lr
		ENDP
			
EXTI1_IRQHandler PROC
		EXPORT	EXTI1_IRQHandler
			
		mov		r5, #0 ; hundredths
		mov		r6, #0 ; seconds
		mov		r7, #0 ; minutes
		
		ldr		r2,=(EXTI_BASE+EXTI_PR1)	;reset pending interrupt for EXTI0		
		mov		r1,#EXTI_PR1_PIF1
		str		r1,[r2]
	
		dsb
		bx		lr
		ENDP
			
			
TIM2_IRQHandler PROC
		EXPORT	TIM2_IRQHandler
		push	{lr}
		
		cmp		r4, #1
		beq		done
		
		add		r5, #7
		cmp		r5, #100
		bge		sec
		b		done
		
sec		add 	r6, #1
		sub		r5, #100
		cmp		r6, #60
		beq		min
		b		done

min		add		r7, #1
		mov		r6, #0
		cmp		r7, #60
		beq		hr
		b		done
		
hr		mov		r7, #0
		
		mov		r8, r5
mod0	cmp		r5, #9
		blt		done4
		sub		r8, #9
		b		mod0
		
done4	cmp		r8, #0
		bne		skip

done	bl		lcd_clear
		mov		r10, #1
	
		mov		r8, #10			;minutes
		udiv	r9, r7, r8
		mov		r0, r9
		mov		r1, #0
		bl		int2font
		mov		r1, r10
		bl		lcd_draw
		
		add		r10, #1
		mov		r8, r7
mod		cmp		r8, #10
		blt		done1
		sub		r8, #10
		b		mod
done1	mov		r0, r8
		mov		r1, #1
		bl		int2font
		mov		r1, r10
		bl		lcd_draw
		
		add		r10, #1
		mov		r8, #10			;seconds
		udiv	r9, r6, r8
		mov		r0, r9
		mov		r1, #0
		bl		int2font
		mov		r1, r10
		bl		lcd_draw
		
		add		r10, #1
		mov		r8, r6
mod1	cmp		r8, #10
		blt		done2
		sub		r8, #10
		b		mod1
done2	mov		r0, r8
		mov		r1, #2
		bl		int2font
		mov		r1, r10
		bl		lcd_draw


		add		r10, #1
		mov		r8, #10			;hundreths
		udiv	r9, r5, r8
		mov		r0, r9
		mov		r1, #0
		bl		int2font
		mov		r1, r10
		bl		lcd_draw
		
		add		r10, #1
		mov		r8, r5
mod2	cmp		r8, #10
		blt		done3
		sub		r8, #10
		b		mod2
done3	mov		r0, r8
		mov		r1, #0
		bl		int2font
		mov		r1, r10
		bl		lcd_draw
	
		
skip	ldr		r2,=(TIM2_BASE+TIM_SR)	;reset pending interrupt for TIM2		
		mov		r1,#~TIM_SR_UIF
		str		r1,[r2]
		dsb
		
		pop		{lr}
		bx		lr
		ENDP

			ALIGN						
			AREA    myData, DATA, READWRITE
			
			ALIGN	
				


	END
