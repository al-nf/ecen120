;******************** (C) Alan Fung ********************************************
; @file    main.s
; @author  Alan Fung
; @date    November 19, 2025
; @note
;*******************************************************************************

	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s   
	INCLUDE timer.h
	INCLUDE leds.h
	INCLUDE	dac.h
	IMPORT	sintbl	
	IMPORT	sawtbl		
	
sample_freq	equ	20000		;20KHz sampling rate
sample_per	equ	1000000/sample_freq			
test_freq	equ	600
	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC
		ldr		r0,=test_freq	
		bl		calc_phaseinc		;compute the phase increment value (phaseinc)
		ldr		r2,=phaseinc
		str		r0,[r2]				;store the phase increment value in memory
		
		bl		dac_init			;initialize dac
		bl		tim2_init			;initialize timer interrupt
		ldr		r0,=sample_per		;set output rate to 20KHz
		bl		tim2_freq



endless	b		endless		
		ENDP
			
			
TIM2_IRQHandler PROC
		EXPORT	TIM2_IRQHandler
		push	{lr}
		ldr		r0,=phase			;get a pointer to the current phase
		ldr		r1,=sintbl			;Get pointer to waveform table
		bl		get_tblval
		bl		dac_set
		ldr		r1,=phaseinc		;load phase increment
		ldr		r0,=phase			;reload last phase value
		bl		update_phase
		pop		{lr}
		ldr		r2,=(TIM2_BASE+TIM_SR)	;reset pending interrupt for TIM2		
		mov		r1,#~TIM_SR_UIF
		str		r1,[r2]
		dsb
		bx		lr
		ENDP
			
calc_phaseinc	PROC
		ldr		r1, =sample_freq
		ldr		r2, =16
		ldr		r3, =1024
		mul		r0, r0, r2
		mul		r0, r0, r3
		udiv	r0, r0, r1

		bx		lr
		ENDP

update_phase	PROC
		ldr		r2, [r0]
		ldr		r1, [r1]
		add		r2, r1
		cmp		r2, #16384
		blt		skip
		sub		r2, #16384
skip	str		r2, [r0]

		bx		lr
		ENDP
		
get_tblval		PROC
		ldr		r0, [r0]
		ldr		r2, =16
		udiv	r0, r0, r2
		ldr		r2, =2
		mul		r0, r0, r2 
		add		r1, r0
		ldrh	r0, [r1]
		
		bx		lr
		ENDP
			
			
			ALIGN						
			AREA    myData, DATA, READWRITE
			
			ALIGN			
phase		dcd		0					;maintain in 16ths.
phaseinc	dcd		160	

	END
